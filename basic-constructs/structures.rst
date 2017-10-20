Structures
==========

LLVM IR already includes the concept of structures so there isn't much to do:

.. code-block:: cpp

    struct Foo
    {
      size_t x;
      double y;
    };

It is only a matter of discarding the actual field names and then index with
numerals starting from zero:

.. code-block:: llvm

    %Foo = type { 
        i64,       ; index 0 = x
        double     ; index 1 = y
    }


Nested Structures
-----------------

Nested structures are also straightforward. They compose in exactly the same
way as a C/C++ ``struct``.

.. code-block:: cpp
    
    struct FooBar 
    {
        Foo x;
        char* c;
        Foo* y;
    }

.. code-block:: llvm

    %FooBar = type {
        %Foo,         ; index 0 = x
        i8*,          ; index 1 = c
        %Foo*         ; index 2 = y
    }

    
Incomplete Structure Types
--------------------------

Incomplete types are very useful for hiding the details of what fields a
given structure has. A well-designed C interface can be made so that no
details of the structure are revealed to the client, so that the client
cannot inspect or modify private members inside the structure:

.. code-block:: cpp

    void Bar(struct Foo *);

Becomes:

.. code-block:: llvm

    %Foo = type opaque
    declare void @Bar(%Foo)



Accessing a Structure Member
----------------------------

As already told, structure members are referenced by index rather than
by name in LLVM IR. And at no point do you need to, or should you,
compute the offset of a given structure member yourself. The
``getelementptr`` (short GEP) instruction is available to compute a pointer to any
structure member with no overhead (the ``getelementptr`` instruction is
typically coascaled into the actual ``load`` or ``store`` instruction).
The ``getelementptr`` instruction even has it's own article over at the docs
[#llvm-gep-doc]_. You can also find more information in the language reference
manual [#llvm-gep-langref]_.

So let's assume we have the following C++ struct:

.. code-block:: cpp

    struct Foo
    {
        int a;
        char *b;
        double c;
    };

This maps pretty straight forward to the following LLVM type. The GEP indices
are in the comments beside the subtypes.

.. code-block:: llvm

    %Foo = type {
        i32,        ; 0: a
        i8*,        ; 1: b
        double      ; 2: c
    }


Now we allocate the object on the stack and access the member ``b``, which is
at index 1 and has type ``char*`` in C++.

.. code-block:: cpp

    Foo foo;
    char **bptr = &foo.b;

First the object is allocated with the ``alloca`` instruction on the stack. To
access the ``b`` member, the GEP instruction is used to compute a pointer to
the memory location.

.. code-block:: llvm

    %foo = alloca %Foo
    ; char **bptr = &foo.b
    %1 = getelementptr %Foo, %Foo* %foo, i32 0, i32 1


Now let's see what happens if we create an array of ``Foo`` objects. Consider
the following C++ snippet:

.. code-block:: cpp

    Foo bar[100];
    bar[17].c = 0.0;


It will translate to roughly something like the following LLVM IR. First a
pointer to 100 ``Foo`` objects is allocated. Then the GEP instruction is used
to retrieve the second element of the 17th entry in the array. This is done
within one GEP instruction:

.. code-block:: llvm

    ; Foo bar[100]
    %bar = alloca %Foo, i32 100
    ; bar[17].c = 0.0
    %2 = getelementptr %Foo, %Foo* %bar, i32 17, i32 2
    store double 0.0, double* %2 


Note that newer versions of ``clang`` will produce code that directly uses the
built-in support for Array types [#llvm-array-langref]_. This explicitly
associates the length of an array with the allocated object. GEP instructions
can also have more than two indices to compute addresses deep inside nested
objects.

.. code-block:: llvm

   %bar = alloca [100 x %Foo]
   %p = getelementptr [100 x %Foo], [100 x %Foo]* %bar, i64 0, i64 17, i32 2
   store double 0.000000e+00, double* %p, align 8


It is highly recommended to read the LLVM docs about the GEP instruction very
thouroughly (see [#llvm-gep-doc]_ [#llvm-gep-langref]_).

.. [#llvm-gep-doc] `The Often Misunderstood GEP Instruction <http://llvm.org/docs/GetElementPtr.html>`_
.. [#llvm-gep-langref] `LangRef: getelementptr Instruction <http://llvm.org/docs/LangRef.html#getelementptr-instruction>`_
.. [#llvm-array-langref] `LangRef: Array type <http://llvm.org/docs/LangRef.html#array-type>`_
