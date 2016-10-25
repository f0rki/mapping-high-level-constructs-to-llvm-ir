## Structure Expressions


As already told, structure members are referenced by index rather than by name in LLVM IR.  And at no point do you need to, or
should you, compute the offset of a given structure member yourself.  The `getelementptr` instruction is available to compute a
pointer to any structure member with no overhead (the `getelementptr` instruction is typically coascaled into the actual `load`
or `store` instruction).


### Getting a Pointer to a Structure Member

The C++ code below illustrates various things you might want to do:

```cpp
struct Foo
{
	int a;
	char *b;
	double c;
};

int main(void)
{
	Foo foo;
	char **bptr = &foo.b;

	Foo bar[100];
	bar[17].c = 0.0;

	return 0;
}
```

Becomes:


```ll
%Foo = type {
	i32,        ; 0: a
	i8*,        ; 1: b
	double      ; 2: c
}

define i32 @main() nounwind {
	; Foo foo
	%foo = alloca %Foo
	; char **bptr = &foo.b
	%1 = getelementptr %Foo* %foo, i32 0, i32 1

	; Foo bar[100]
	%bar = alloca %Foo, i32 100
	; bar[17].c = 0.0
	%2 = getelementptr %Foo* %bar, i32 17, i32 2
	store double 0.0, double* %2

	ret i32 0
}
```




