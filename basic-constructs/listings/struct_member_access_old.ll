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
