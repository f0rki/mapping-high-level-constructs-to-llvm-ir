Global Variables
----------------

Global variables are trivial to implement in LLVM IR:

.. code-block:: cpp

    int variable = 21;

    int main()
    {
        variable = variable * 2;
        return variable;
    }

Becomes:

.. code-block:: llvm

    @variable = global i32 21

    define i32 @main() {
        %1 = load i32, ptr @variable  ; load the global variable
        %2 = mul i32 %1, 2
        store i32 %2, ptr @variable   ; store instruction to write to global variable
        ret i32 %2
    }




Globals are prefixed with the ``@`` character. You can see that also 
functions, such as ``main``, are also global variables in LLVM.
Please notice that LLVM views global variables as pointers; so you must
explicitly dereference the global variable using the ``load`` instruction 
when accessing its value, likewise you must explicitly store the value of 
a global variable using the ``store`` instruction. In that regard LLVM IR 
is closer to Assembly than C.
