## Function Pointers


Function pointers are expressed almost like in C and C++:

```cpp
int (*Function)(char *buffer);
```
Becomes:


```ll
@Function = global i32(i8*)* null
```
