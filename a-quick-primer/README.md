# A Quick Primer

Here are a few things that you should know before reading this document:

- LLVM IR is not machine code, but sort of the step just above assembly.
- LLVM IR is highly typed so expect to be told when you do something wrong.
- LLVM IR does not differentiate between signed and unsigned integers.
- LLVM IR assumes two's complement signed integers so that say `trunc` works equally well on signed and unsigned integers.
- Global symbols begin with an at sign (@).
- Local symbols begin with a percent symbol (%).
- All symbols must be declared or defined.
- Don't worry that the LLVM IR at times can seem somewhat lengthy when it comes to expressing something; the optimizer will ensure the output is well optimized and you'll often see two or three LLVM IR instructions be coalesced into a single machine code instruction.
- If in doubt, consult the Language Reference. If there is a conflict between the Language Reference and this document, this document is wrong!
- All LLVM IR examples are presented without a data layout and without a target triple.  You need to add those yourself, if you want to actually build and run the samples.  Get them from Clang for your platform.


