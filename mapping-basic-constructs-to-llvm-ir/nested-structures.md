## Nested Structures



Nested structures are straightforward:

```ll
%Object = type {
	%Object*,      ; 0: above; the parent pointer
	i32            ; 1: value; the value of the node
}
```
