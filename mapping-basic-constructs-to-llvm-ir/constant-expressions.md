## Constant Expressions



### Size-Of Computations

Even though the compiler ought to know the exact size of everything in use (for statically checked languages), it can at times be
convenient to ask LLVM to figure out the size of a structure for you.  This is done with the following little snippet of code:

```llvm
%Struct = type { i8, i32, i8* }
@Struct_size = constant i32 ptrtoint (%Struct* getelementptr (%Struct* null, i32 1)) to i32
```

`@Struct_size` will now contain the size of the structure `%Struct`. The trick is to compute the offset of the second element

in the zero-based array starting at `null` and that way get the size of the structure.


