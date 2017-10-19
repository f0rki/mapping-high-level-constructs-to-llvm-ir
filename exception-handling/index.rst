Exception Handling
==================

Exceptions can be implemented in one of three ways:

-  The simple way, by using a propagated return value.
-  The bulky way, by using ``setjmp`` and ``longjmp``.
-  The efficient way, by using a zero-cost exception ABI.

Please notice that many compiler developers with respect for themselves
won't accept the first method as a proper way of handling exceptions.
However, it is unbeatable in terms of simplicity and can likely help
people to understand that implementing exceptions does not need to be
very difficult.

The second method is used by some production compilers, but it has large
overhead both in terms of code bloat and the cost of a ``try-catch``
statement (because all CPU registers are saved using ``setjmp`` whenever
a ``try`` statement is encountered).

The third method is very advanced but in return does not add any cost to
execution paths where no exceptions are being thrown. This method is the
de-facto "right" way of implementing exceptions, whether you like it or
not. LLVM directly supports this kind of exception handling.

In the three sections below, we'll be using this sample and transform
it:

.. literalinclude:: listings/exception_example.cpp
    :language: c++


.. toctree::
   :hidden:
   
   exception-handling-by-propagated-return-value
   setjmp+longjmp-exception-handling
   zero-cost-exception-handling
   resources
