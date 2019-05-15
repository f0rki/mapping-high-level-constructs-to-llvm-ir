The New Operator
----------------

The ``new`` operator is generally nothing more than a type-safe version
of the C ``malloc`` function - in some implementations of C++, they may
even be called interchangeably without causing unseen or unwanted
side-effects.

The Instance New Operator
~~~~~~~~~~~~~~~~~~~~~~~~~

All calls of the form ``new X`` are mapped into:

.. code-block:: llvm

    declare i8* @malloc(i32) nounwind

    %X = type { i8 }

    define void @X_Create_Default(%X* %this) nounwind {
        %1 = getelementptr %X, %X* %this, i32 0, i32 0
        store i8 0, i8* %1
        ret void
    }

    define void @main() nounwind {
        %1 = call i8* @malloc(i32 1)
        %2 = bitcast i8* %1 to %X*
        call void @X_Create_Default(%X* %2)
        ret void
    }

Calls of the form ``new X(Y, Z)`` are the same, except ``Y`` and ``Z``
are passed into the constructor as arguments.

The Array New Operator
~~~~~~~~~~~~~~~~~~~~~~

New operations involving arrays are equally simple. The code
``new X[100]`` is mapped into a loop that initializes each array element
in turn:

.. code-block:: llvm

    declare i8* @malloc(i32) nounwind

    %X = type { i32 }

    define void @X_Create_Default(%X* %this) nounwind {
        %1 = getelementptr %X, %X* %this, i32 0, i32 0
        store i32 0, i32* %1
        ret void
    }

    define void @main() nounwind {
        %n = alloca i32                  ; %n = ptr to the number of elements in the array
        store i32 100, i32* %n

        %i = alloca i32                  ; %i = ptr to the loop index into the array
        store i32 0, i32* %i

        %1 = load i32, i32* %n           ; %1 = *%n
        %2 = mul i32 %1, 4               ; %2 = %1 * sizeof(X)
        %3 = call i8* @malloc(i32 %2)    ; %3 = malloc(100 * sizeof(X))
        %4 = bitcast i8* %3 to %X*       ; %4 = (X*) %3
        br label %.loop_head

    .loop_head:                         ; for (; %i < %n; %i++)
        %5 = load i32, i32* %i
        %6 = load i32, i32* %n
        %7 = icmp slt i32 %5, %6
        br i1 %7, label %.loop_body, label %.loop_tail

    .loop_body:
        %8 = getelementptr %X, %X* %4, i32 %5
        call void @X_Create_Default(%X* %8)

        %9 = add i32 %5, 1
        store i32 %9, i32* %i

        br label %.loop_head

    .loop_tail:
        ret void
    }
