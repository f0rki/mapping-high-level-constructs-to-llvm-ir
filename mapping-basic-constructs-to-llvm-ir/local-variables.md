## Local Variables


There are two kinds of local variables in LLVM:

- Register-allocated local variables (temporaries).
- Stack-allocated local variables.

The former is created by introducing a new symbol for the variable:

```ll
%1 = some computation
```

The latter is created by allocating the variable on the stack:


```ll
%2 = alloca i32
```

Please notice that `alloca` yields a pointer to the allocated type.  As is generally the case in LLVM, you must explicitly use a

`load` or `store` instruction to read or write the value respectively.

The use of `alloca` allows for a neat trick that can simplify your code generator in some cases.  The trick is to explicitly
allocate all mutable variables, including arguments, on the stack, initialize them with the appropriate initial value and then
operate on the stack as if that was your end goal.  The trick is to run the "memory to register promotion" pass on your code as
part of the optimization phase.  This will make LLVM store as many of the stack variables in registers as it possibly can.  That
way you don't have to ensure that the generated program is in SSA form but can generate code without having to worry about this
aspect of the code generation.

This trick is also described in chapter 7.4,
[Mutable Variables in Kaleidoscope](llvm.org/docs/tutorial/OCamlLangImpl7.html-mutable-variables-in-kaleidoscope), in the OCaml
tutorial on the [LLVM website](www.llvm.org).


