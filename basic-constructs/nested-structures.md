## Nested Structures



Nested structures are straightforward:

```llvm
%Object = type {
	%Object*,      ; 0: above; the parent pointer
	i32            ; 1: value; the value of the node
}
```

