Lambda Functions
----------------

In C++, a lambda function is an anonymous function with the added spice that it may freely refer to
the local variables (including argument variables) in the containing function. Lambdas are
implemented just like Pascal's nested functions, except the compiler is responsible for generating
an internal name for the lambda function. There are a few different ways of implementing lambda
functions (see `Wikipedia on Nested Functions <https://en.wikipedia.org/wiki/Nested_function>`__ for
more information). The more generalized concept behind this are function closures, i.e., functions
defined within other functions that can also escape the context of the current functions (again
refer to `Wikipedia on Closure <https://en.wikipedia.org/wiki/Closure_(computer_programming)>`__). 

Closures are common in many modern high-level programming languages, and especially so in functional
programming languages. However, first we take a closer look at how one could implement C++'s lambda
functions.

.. literalinclude:: listings/lambda_func_0.cpp
   :language: c++

Here the "problem" is that the lambda function references a local
variable of the caller, namely ``a``, even though the lambda function is
a function of its own. This can be solved easily by passing the local
variable in as an implicit argument to the lambda function:


.. literalinclude:: listings/lambda_func_0_cleaned.ll
   :language: llvm

Alternatively, if the lambda function uses more than a few variables, you can wrap them up in a
structure which you pass in a pointer to the lambda function. You will notice that this is actually
the default behavior of clang.

.. literalinclude:: listings/lambda_func_1.cpp
   :language: c++

Becomes:

.. literalinclude:: listings/lambda_func_1_cleaned.ll
   :language: llvm

There are a couple of possible variations over this approach:

-  You could pass all implicit captures as explicit arguments to the function.
-  You could pass all implicit captures as explicit arguments in the structure.
-  You could pass in a pointer to the frame of the caller and let the
   lambda function extract the arguments and locals from the input
   frame.
