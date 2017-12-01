*************************************
Interoperating with a Runtime Library
*************************************

It is common to provide a set of run-time support functions that are
written in another language than LLVM IR and it is trivially easy to
interface to such a run-time library. The use of ``malloc`` and ``free``
in the examples in this document are examples of such use of externally
defined run-time functions.

The advantages of a custom, non-IR run-time library function is that it
can be optimized by hand to provide the best possible performance under
certain criteria. Also a custom non-IR run-time library function can
make explicit use of native instructions that are foreign to the LLVM
infrastructure.

The advantages of IR run-time library functions is that they can be run
through the optimizer and thereby also be inlined automatically.
