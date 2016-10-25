# Some Useful LLVM Tools

The most important LLVM tools for use with this article are as follows:

|Name        |Function    |Reads      |Writes |Arguments
|`clang`   |C Compiler  |`.c`     |`.ll`|`-c -emit-llvm -S`
|`clang++` |C++ Compiler|`.cpp`   |`.ll`|`-c -emit-llvm -S`
|`llvm-dis`|Disassembler|`.bc`    |`.ll`|
|`opt`     |Optimizer   |`.bc/.ll`|same   |
|`llc`     |IR Compiler |`.ll`    |`.s` |

While you are playing around with generating or writing LLVM IR, you may want to add the option `-fsanitize=undefined` to
Clang/Clang++ insofar you use either of those.  This option makes Clang/Clang++ insert run-time checks in places where it would
normally output an `ud2` instruction.  This will likely save you some trouble if you happen to generate undefined LLVM IR.
Please notice that this option only works for C and C++ compiles.


