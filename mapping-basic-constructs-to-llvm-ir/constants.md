## Constants


There are two different kinds of constants:

- Constants that do *not* occupy allocated memory.
- Constants that *do* occupy allocated memory.

The former are always expanded inline by the compiler as there is no LLVM IR equivalent of those.  In other words, the compiler
simply inserts the constant value wherever it is being used in a computation:

```llvm
%1 = add i32 %0, 17     ; 17 is an inlined constant
```

Constants that do occupy memory are defined using the `constant` keyword:


```llvm
@hello = internal constant [6 x i8] c"hello\00"
%struct = type { i32, i8 }
@struct_constant = internal constant %struct { i32 16, i8 4 }
```

Such a constant is really a global variable whose visibility can be limited with `private` or `internal` so that it is

invisible outside the current module.


