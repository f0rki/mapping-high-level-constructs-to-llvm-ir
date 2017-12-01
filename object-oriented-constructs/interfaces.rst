Interfaces
----------

An interface is nothing more than a base class with no data members,
where all the methods are pure virtual (i.e. has no body).

As such, we've already described how to convert an interface to LLVM IR
- it is done precisely the same way that you convert a virtual member
function to LLVM IR.
