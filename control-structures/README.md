# Mapping Control Structures to LLVM IR

Similar to low-level assembly languages, LLVM's IR consists of sequences of
instructions, that are executed sequentially. The instructions are grouped
together to form *basic blocks*. Each basic block terminates with an
instruction that changes the control flow of the program.
