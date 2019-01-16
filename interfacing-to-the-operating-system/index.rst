********************************
Interfacing to Operating Systems
********************************

I'll divide this chapter into two sections:

-  How to Interface to POSIX Operating Systems.
-  How to Interface to the Windows Operating System.

Interface to POSIX Operating Systems
====================================

On POSIX, the presence of the C run-time library is an unavoidable fact
for which reason it makes a lot of sense to directly call such C
run-time functions.

Sample POSIX "Hello World" Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On POSIX, it is really very easy to create the ``Hello world`` program:

.. code-block:: llvm

    declare i32 @puts(i8* nocapture) nounwind

    @.hello = private unnamed_addr constant [13 x i8] c"hello world\0A\00"

    define i32 @main(i32 %argc, i8** %argv) {
        %1 = getelementptr [13 x i8], [13 x i8]* @.hello, i32 0, i32 0
        call i32 @puts(i8* %1)
        ret i32 0
    }

How to Interface to the Windows Operating System
================================================

On Windows, the C run-time library is mostly considered of relevance to
the C and C++ languages only, so you have a plethora (thousands) of
standard system interfaces that any client application may use.

Sample Windows "Hello World" Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``Hello world`` on Windows is nowhere as straightforward as on POSIX:

.. literalinclude:: listings/windows.ll
    :language: llvm
