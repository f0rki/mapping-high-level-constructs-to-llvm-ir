Structures
==========

LLVM IR already includes the concept of structures so there isn't much to do:

.. code-block:: cpp

    struct Foo
    {
      size_t _length;
    };

It is only a matter of discarding the actual field names and then index with
numerals starting from zero:

.. code-block:: llvm

    %Foo = type { i32 }


Nested Structures
-----------------

Nested structures are also straightforward:

.. code-block:: llvm

    %Object = type {
        %Object*,      ; 0: above; the parent pointer
        i32            ; 1: value; the value of the node
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
``getelementptr`` instruction is available to compute a pointer to any
structure member with no overhead (the ``getelementptr`` instruction is
typically coascaled into the actual ``load`` or ``store`` instruction).

The C++ code below illustrates various things you might want to do:

.. code-block:: cpp

    struct Foo
    {
        int a;
        char *b;
        double c;
    };

    int main(void)
    {
        Foo foo;
        char **bptr = &foo.b;

        Foo bar[100];
        bar[17].c = 0.0;

        return 0;
    }

Becomes:

.. code-block:: llvm

    %Foo = type {
        i32,        ; 0: a
        i8*,        ; 1: b
        double      ; 2: c
    }

    define i32 @main() nounwind {
        ; Foo foo
        %foo = alloca %Foo
        ; char **bptr = &foo.b
        %1 = getelementptr %Foo* %foo, i32 0, i32 1

        ; Foo bar[100]
        %bar = alloca %Foo, i32 100
        ; bar[17].c = 0.0
        %2 = getelementptr %Foo* %bar, i32 17, i32 2
        store double 0.0, double* %2

        ret i32 0
    }
