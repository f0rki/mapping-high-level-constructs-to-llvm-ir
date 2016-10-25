## Function Prototypes


A function prototype, aka a profile, is translated into an equivalent `declare` declaration in LLVM IR:

```cpp
int Bar(int value);
```
Becomes:


```ll
declare i32 @Bar(i32 %value)
```
Or you can leave out the descriptive parameter name:


```ll
declare i32 @Bar(i32)
```
