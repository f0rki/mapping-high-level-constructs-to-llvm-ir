Setjmp/Longjmp Exception Handling
---------------------------------

The basic idea behind the ``setjmp`` and ``longjmp`` exception handling
scheme is that you save the CPU state whenever you encounter a ``try``
keyword and then do a ``longjmp`` whenever you throw an exception. If
there are few ``try`` blocks in the program, as is typically the case,
the cost of this method is not as high as it might seem. However, often
there are implicit exception handlers due to the need to release local
resources such as class instances allocated on the stack and then the
cost can become quite high.

``setjmp``/``longjmp`` exception handling is often abbreviated ``SjLj``
for ``SetJmp``/``LongJmp``.

Here is an example implementation of this kind of exception handling:

.. literalinclude:: listings/setjmp_longjmp.ll
   :language: llvm

Note that this example has been developed for a 32-bit architecture and passes
a pointer to an exception instance instead of an error code as the second
parameter of ``longjmp``. This trick abuses the fact that the `int` type has
the same size as pointer types on 32-bit. This is not the case on 64-bit and as
such, this example doesn't work on 64-bit architectures.
