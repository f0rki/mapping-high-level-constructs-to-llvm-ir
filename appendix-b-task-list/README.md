# Appendix B: Task List


This chapter serves as an informal task list and is to be updated as new
to-do items are completed:

- How to enable debug information?  (Line and Function, Variable)
- How to interface with a garbage collector? (link to existing docs)
- How to express a custom calling convention? (link to existing docs)
- Representing constructors, destructors, finalization
- How to examine the stack at runtime?  How to modify it?  (i.e. reflection, interjection)
- Representing subtyping checks (with full alias info), TBAA, struct-path TBAA.
- How to exploit inlining (external, vs within LLVM)?
- How to express array bounds checks for best optimization?
- How to express null pointer checks?
- How to express domain specific optimizations?  (i.e. lock elision, or matrix math simplification) (link to existing docs)
- How to optimize call dispatch or field access in dynamic languages? (ref new patchpoint intrinsics for inline call caching and field access caching)



