Global Variables
----------------

Global varibles are trivial to implement in LLVM IR:

.. code-block:: cpp

    int variable = 14;

    int main()
    {
        return variable;
    }

Becomes:

.. code-block:: llvm

    @variable = global i32 14

    define i32 @main() nounwind {
        %1 = load i32* @variable
        ret i32 %1
    }

Please notice that LLVM views global variables as pointers; so you must
explicitly dereference the global variable using the

``load`` instruction when accessing its value, likewise you must
explicitly store the value of a global variable using the ``store``
instruction.
