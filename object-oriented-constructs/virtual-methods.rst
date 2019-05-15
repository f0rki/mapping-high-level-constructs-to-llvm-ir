Virtual Methods
---------------

A virtual method is no more than a compiler-controlled function pointer.
Each virtual method is recorded in the ``vtable``, which is a structure
of all the function pointers needed by a given class:

.. code-block:: cpp

    class Foo
    {
    public:
        virtual int GetLengthTimesTwo() const
        {
            return _length * 2;
        }

        void SetLength(size_t value)
        {
            _length = value;
        }

    private:
        int _length;
    };

    int main()
    {
        Foo foo;
        foo.SetLength(4);
        return foo.GetLengthTimesTwo();
    }

This becomes:

.. code-block:: llvm

    %Foo_vtable_type = type { i32(%Foo*)* }

    %Foo = type { %Foo_vtable_type*, i32 }

    define i32 @Foo_GetLengthTimesTwo(%Foo* %this) nounwind {
        %1 = getelementptr %Foo, %Foo* %this, i32 0, i32 1
        %2 = load i32, i32* %1
        %3 = mul i32 %2, 2
        ret i32 %3
    }

    @Foo_vtable_data = global %Foo_vtable_type {
        i32(%Foo*)* @Foo_GetLengthTimesTwo
    }

    define void @Foo_Create_Default(%Foo* %this) nounwind {
        %1 = getelementptr %Foo, %Foo* %this, i32 0, i32 0
        store %Foo_vtable_type* @Foo_vtable_data, %Foo_vtable_type** %1
        %2 = getelementptr %Foo, %Foo* %this, i32 0, i32 1
        store i32 0, i32* %2
        ret void
    }

    define void @Foo_SetLength(%Foo* %this, i32 %value) nounwind {
        %1 = getelementptr %Foo, %Foo* %this, i32 0, i32 1
        store i32 %value, i32* %1
        ret void
    }

    define i32 @main(i32 %argc, i8** %argv) nounwind {
        %foo = alloca %Foo
        call void @Foo_Create_Default(%Foo* %foo)
        call void @Foo_SetLength(%Foo* %foo, i32 4)
        %1 = getelementptr %Foo, %Foo* %foo, i32 0, i32 0
        %2 = load %Foo_vtable_type*, %Foo_vtable_type** %1
        %3 = getelementptr %Foo_vtable_type, %Foo_vtable_type* %2, i32 0, i32 0
        %4 = load i32(%Foo*)*, i32(%Foo*)** %3
        %5 = call i32 %4(%Foo* %foo)
        ret i32 %5
    }

Please notice that some C++ compilers store ``_vtable`` at a negative
offset into the structure so that things like
``memset(this, 0, sizeof(*this))`` work, even though such commands
should always be avoided in an OOP context.
