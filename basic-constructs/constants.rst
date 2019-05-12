Constants
=========

There are two different kinds of constants:

-  Constants that do *not* occupy allocated memory.
-  Constants that *do* occupy allocated memory.

The former are always expanded inline by the compiler as there is no
LLVM IR equivalent of those. In other words, the compiler simply inserts
the constant value wherever it is being used in a computation:

.. code-block:: llvm

    %1 = add i32 %0, 17     ; 17 is an inlined constant

Constants that do occupy memory are defined using the ``constant``
keyword:

.. code-block:: llvm

    @hello = internal constant [6 x i8] c"hello\00"
    %struct = type { i32, i8 }
    @struct_constant = internal constant %struct { i32 16, i8 4 }

Such a constant is really a global variable whose visibility can be limited
with ``private`` or ``internal`` so that it is invisible outside the current
module.

Constant Expressions
--------------------

An example for constant expressions are ``sizeof``-style computations.
Even though the compiler ought to know the exact size of everything in
use (for statically checked languages), it can at times be convenient to
ask LLVM to figure out the size of a structure for you. This is done
with the following little snippet of code:

.. code-block:: llvm

    %Struct = type { i8, i32, i8* }
    @Struct_size = constant i32 ptrtoint (%Struct* getelementptr (%Struct, %Struct* null, i32 1) to i32)

``@Struct_size`` will now contain the size of the structure ``%Struct``.
The trick is to compute the offset of the second element

in the zero-based array starting at ``null`` and that way get the size
of the structure.
