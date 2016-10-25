## Structures



LLVM IR already includes the concept of structures so there isn't much to do:

```cpp
struct Foo
{
  size_t _length;
};
```

It is only a matter of discarding the actual field names and then index with

numerals starting from zero:

```ll
%Foo = type { i32 }
```

