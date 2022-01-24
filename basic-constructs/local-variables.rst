Local Variables
---------------

There are two kinds of local variables in LLVM:

-  Temporary variables/Registers
-  Stack-allocated local variables.

The former is created by introducing a new symbol for the variable:

.. code-block:: llvm

    %reg = add i32 4, 2

The latter is created by allocating the variable on the stack:

.. code-block:: llvm

    %stack = alloca i32


Nearly every instruction returns a value, that is usually assigned to a
temporary variable. Because of the SSA form of the LLVM IR, a temporary
variable can only be assigned once. The following code snippet would produce an
error:

.. code-block:: llvm

    %tmp = add i32 4, 2
    %tmp = add i32 4, 1  ; Error here

To conform to SSA you will often see something like this:

.. code-block:: llvm

    %tmp.0 = add i32 4, 2
    %tmp.1 = add i32 4, 1  ; fine now

Which can be further shortened to:

.. code-block:: llvm

    %0 = add i32 4, 2
    %1 = add i32 4, 1 


The number of such local variables is basically unbounded. Because a real
machine does have a rather limited number of registers the compiler backend
might need to put some of these temporaries on the stack. 

Please notice that ``alloca`` yields a pointer to the allocated type. As is
generally the case in LLVM, you must explicitly use a ``load`` or ``store``
instruction to read or write the value respectively.

The use of ``alloca`` allows for a neat trick that can simplify your
code generator in some cases. The trick is to explicitly allocate all
mutable variables, including arguments, on the stack, initialize them
with the appropriate initial value and then operate on the stack as if
that was your end goal. The trick is to run the "memory to register
promotion" pass on your code as part of the optimization phase. This
will make LLVM store as many of the stack variables in registers as it
possibly can. That way you don't have to ensure that the generated
program is in SSA form but can generate code without having to worry
about this aspect of the code generation.

This trick is also described in the chapter on `Mutable Variables in
Kaleidoscope <https://www.llvm.org/docs/tutorial/MyFirstLanguageFrontend/LangImpl07.html#mutable-variables-in-kaleidoscope>`__,
in the tutorial on the `LLVM website <https://www.llvm.org>`__.
