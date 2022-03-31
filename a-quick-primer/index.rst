**************
A Quick Primer
**************

Here are a few things that you should know before reading this document:

- LLVM IR is not machine code, but sort of the step just above assembly. So
  some things look more like a high-level language (like functions and the
  strong typing). Other looks more like low-level assembly (e.g. branching,
  basic-blocks).
- LLVM IR is strongly typed so expect to be told when you do something wrong.
- LLVM IR does not differentiate between signed and unsigned integers.
- LLVM IR assumes two's complement signed integers so that say ``trunc`` works
  equally well on signed and unsigned integers.
- Global symbols begin with an at sign (``@``).
- Local symbols begin with a percent symbol (``%``).
- All symbols must be declared or defined.
- Don't worry that the LLVM IR at times can seem somewhat lengthy when it comes
  to expressing something; the optimizer will ensure the output is well
  optimized and you'll often see two or three LLVM IR instructions be coalesced
  into a single machine code instruction.
- If in doubt, consult the Language Reference [#langref]_. If there is a
  conflict between the Language Reference and this document, this document is
  wrong! Please file an issue on github then.
- All LLVM IR examples are presented without a data layout and without a target
  triple. You can assume it's usually x86 or x86_64. 
- The original version of this document was written a while ago, therefore some
  of the snippets of LLVM IR might not compile anymore with the most recent
  LLVM/clang version. Please file a bug report at github if you encounter such
  a case.

Some Useful LLVM Tools
----------------------

The most important LLVM tools for use with this article are as follows:

+----------------+----------------+---------------+-----------+---------------------+
| Name           | Function       | Reads         | Writes    | Arguments           |
+================+================+===============+===========+=====================+
| ``clang``      | C Compiler     | ``.c``        | ``.ll``   | ``-emit-llvm -S``   |
+----------------+----------------+---------------+-----------+---------------------+
| ``clang++``    | C++ Compiler   | ``.cpp``      | ``.ll``   | ``-emit-llvm -S``   |
+----------------+----------------+---------------+-----------+---------------------+
| ``opt``        | Optimizer      | ``.bc/.ll``   | ``.bc``   |                     |
+----------------+----------------+---------------+-----------+---------------------+
| ``llvm-dis``   | Disassembler   | ``.bc``       | ``.ll``   |                     |
+----------------+----------------+---------------+-----------+---------------------+
| ``llc``        | IR Compiler    | ``.ll``       | ``.s``    |                     |
+----------------+----------------+---------------+-----------+---------------------+

While you are playing around with generating or writing LLVM IR, you may
want to add the option ``-fsanitize=undefined`` to Clang/Clang++ insofar
you use either of those. This option makes Clang/Clang++ insert run-time
checks in places where it would normally output an ``ud2`` instruction.
This will likely save you some trouble if you happen to generate
undefined LLVM IR. Please notice that this option only works for C and
C++ compilers.

Note that you can use ``.ll`` or ``.bc`` files as input files for
``clang(++)`` and compile full executables from bitcode files.


.. [#langref] http://llvm.org/docs/LangRef.html 
