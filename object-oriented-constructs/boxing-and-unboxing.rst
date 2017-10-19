Boxing and Unboxing
-------------------

Boxing is the process of converting a non-object primitive value into an
object. It is as easy as it sounds. You create a wrapper class which you
instantiate and initialize with the non-object value:

Unboxing is the reverse of boxing: You downgrade a full object to a mere
scalar value by retrieving the boxed value from the box object.

It is important to notice that changes to the boxed value does not
affect the original value and vice verse. The code below illustrates
both steps:

.. code-block:: llvm

    @Boxee = global i32 17

    %Integer = type { i32 }

    define void @Integer_Create(%Integer* %this, i32 %value) nounwind {
        ; you might set up a vtable and associated virtual methods here
        %1 = getelementptr %Integer* %this, i32 0, i32 0
        store i32 %value, i32* %1
        ret void
    }

    define i32 @Integer_GetValue(%Integer* %this) nounwind {
        %1 = getelementptr %Integer* %this, i32 0, i32 0
        %2 = load i32* %1
        ret i32 %2
    }

    define i32 @main() nounwind {
        ; box @Boxee in an instance of %Integer
        %1 = load i32* @Boxee
        %2 = alloca %Integer
        call void @Integer_Create(%Integer* %2, i32 %1)

        ; unbox @Boxee from an instance of %Integer
        %3 = call i32 @Integer_GetValue(%Integer* %2)

        ret i32 0
    }
