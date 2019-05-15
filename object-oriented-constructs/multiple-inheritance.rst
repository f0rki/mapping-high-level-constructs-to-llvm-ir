Multiple Inheritance
--------------------

Multiple inheritance is not that difficult, either, it is merely a
question of laying out the multiply inherited "structures" in order
inside each derived class.

.. code-block:: cpp

    class BaseA
    {
    public:
        void SetA(int value)
        {
            _a = value;
        }

    private:
        int _a;
    };

    class BaseB: public BaseA
    {
    public:
        void SetB(int value)
        {
            SetA(value);
            _b = value;
        }

    private:
        int _b;
    };

    class Derived:
        public BaseA,
        public BaseB
    {
    public:
        void SetC(int value)
        {
            SetB(value);
            _c = value;
        }

    private:
        int _c;
    };

This is equivalent to the following LLVM IR:

.. code-block:: llvm

    %BaseA = type {
        i32         ; '_a' from BaseA
    }

    define void @BaseA_SetA(%BaseA* %this, i32 %value) nounwind {
        %1 = getelementptr %BaseA, %BaseA* %this, i32 0, i32 0
        store i32 %value, i32* %1
        ret void
    }

    %BaseB = type {
        i32,        ; '_a' from BaseA
        i32         ; '_b' from BaseB
    }

    define void @BaseB_SetB(%BaseB* %this, i32 %value) nounwind {
        %1 = bitcast %BaseB* %this to %BaseA*
        call void @BaseA_SetA(%BaseA* %1, i32 %value)
        %2 = getelementptr %BaseB, %BaseB* %this, i32 0, i32 1
        store i32 %value, i32* %2
        ret void
    }

    %Derived = type {
        i32,        ; '_a' from BaseA
        i32,        ; '_b' from BaseB
        i32         ; '_c' from Derived
    }

    define void @Derived_SetC(%Derived* %this, i32 %value) nounwind {
        %1 = bitcast %Derived* %this to %BaseB*
        call void @BaseB_SetB(%BaseB* %1, i32 %value)
        %2 = getelementptr %Derived, %Derived* %this, i32 0, i32 2
        store i32 %value, i32* %2
        ret void
    }

And the compiler then supplies the needed type casts and pointer
arithmentic whenever ``baseB`` is being referenced as an instance

of ``BaseB``. Please notice that all it takes is a ``bitcast`` from one
class to another as well as an adjustment of the last argument to
``getelementptr``.
