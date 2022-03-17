Unions
======

Unions are getting more and more rare as the years have shown that they
are quite dangerous to use; especially the C variant that does not have
a selector field to indicate which of the union's variants are valid.
Some may still have a legacy reason to use unions. In fact, LLVM does
not support unions at all:

.. code-block:: cpp

    union Foo
    {
        int a;
        char *b;
        double c;
    };

    Foo Union;

Becomes this when run through clang++:

.. code-block:: llvm

    %union.Foo = type { double }
    @Union = %union.Foo { 0.0 }

What happened here? Where did the other union members go? The answer is
that in LLVM there are no unions; there are only structs
that can be cast into whichever type the front-end want to cast the
struct into. So to access the above union from LLVM IR, you'd use the
``bitcast`` instruction to cast a pointer to the "union" into whatever
pointer you'd want it to be:

.. code-block:: llvm

    %1 = bitcast %union.Foo* @Union to i32*
    store i32 1, i32* %1
    %2 = bitcast %union.Foo* @Union to i8**
    store i8* null, i8** %2

This may seem strange, but the truth is that a union is nothing more than a
piece of memory that is being accessed using different implicit pointer casts.
There is no type-safety when dealing with unions.

If you want to support unions in your front-end language, you should
simply allocate the total size of the union (i.e. the size of the
largest member) and then generate code to reinterpret the allocated
memory as needed.

The cleanest approach might be to simply allocate a range of bytes
(``i8``), possibly with alignment padding at the end, and then cast
whenever you access the structure. That way you'd be sure you did
everything properly all the time.


Tagged Unions
-------------

When dealing with unions in C, one typically adds another field that signals
the content of the union, since accidently interpreting the bytes of a
``double`` as a ``char*``, can have disastrous consequences.

Many modern programming languages feature type-safe tagged unions. Rust has
``enum`` types, that can optionally contain values. C++ has the ``variant``
type since C++17. 

Consider the following short rust program, that defines an ``enum`` type that
can hold three different primitive types.

.. literalinclude:: listings/rust_enum.rs
   :language: rust

``rustc`` generates something similar to the following LLVM IR to
initialize the ``Foo`` variables. 

.. code-block:: llvm

   ; basic type definition   
   %Foo = type { i8, [8 x i8] }
   ; Variants of Foo
   %Foo_ABool = type { i8, i8 }       ; tagged with 0
   %Foo_AInteger = type { i8, i32 }   ; tagged with 1
   %Foo_ADouble = type { i8, double } ; tagged with 2
    
   ; allocate the first Foo
   %x = alloca %Foo
   ; pointer to the first element of type i8 (the tag)
   %0 = getelementptr inbounds %Foo, %Foo* %x, i32 0, i32 0
   ; set tag to '1'
   store i8 1, i8* %0
   ; bitcast Foo to the right Foo variant
   %1 = bitcast %Foo* %x to %Foo_AInteger*
   ; store the constant '42'
   %2 = getelementptr inbounds %Foo_AInteger, %Foo_AInteger* %1, i32 0, i32 1
   store i32 42, i32* %2
   
   ; allocate and initialize the second Foo
   %y = alloca %Foo
   %3 = getelementptr inbounds %Foo, %Foo* %y, i32 0, i32 0
   ; this time the tag is '2'
   store i8 2, i8* %3
   ; cast to variant and store double constant
   %4 = bitcast %Foo* %y to %Foo_ADouble*
   %5 = getelementptr inbounds %Foo_ADouble, %Foo_ADouble* %4, i32 0, i32 1
   store double 1.337000e+03, double* %5


To check whether the given ``Foo`` object is a certain variant, the tag must be
retrieved and compared to the desired value.

.. code-block:: llvm

   %9 = getelementptr inbounds %Foo, %Foo* %x, i32 0, i32 0
   %10 = load i8, i8* %9
   ; check if tag is '0', which identifies the variant Foo_ABool
   %11 = icmp i8 %10, 0
   br i1 %11, label %bb1, label %bb2

   bb1:
     ; cast to variant
     %12 = bitcast %Foo* %x to %Foo_ABool*
     ; retrieve boolean
     %13 = getelementptr inbounds %Foo_ABool, %Foo_ABool* %12, i32 0, i32 1
     %14 = load i8, i8* %13, 
     %15 = trunc i8 %14 to i1
     ; <...>
