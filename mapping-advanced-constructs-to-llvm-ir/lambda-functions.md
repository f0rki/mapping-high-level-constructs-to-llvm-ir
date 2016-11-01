## Lambda Functions


A lambda function is an anonymous function with the added spice that it may freely refer to the local variables (including argument
variables) in the containing function.  Lambdas are implemented just like Pascal's nested functions, except the compiler is
responsible for generating an internal name for the lambda function.  There are a few different ways of implementing lambda
functions (see `Wikipedia on nested functions [Wikipedia on Nested Functions](en.wikipedia.org/wiki/Nested_function) for more
information).

```cpp
int foo(int a)
{
	auto function = [a](int x) { return x + a; }
	return function(10);
}
```

Here the "problem" is that the lambda function references a local variable of the caller, namely `a`, even though the lambda

function is a function of its own.  This can be solved easily by passing the local variable in as an implicit argument to the
lambda function:

```llvm
define internal i32 @lambda(i32 %a, i32 %x) alwaysinline nounwind {
	%1 = add i32 %a, %x
	ret i32 %1
}

define i32 @foo(i32 %a) nounwind {
	%1 = call i32 @lambda(i32 %a, i32 10)
	ret i32 %1
}
```

Alternatively, if the lambda function uses more than a few variables, you can wrap them up in a structure which you pass in a

pointer to the lambda function:

```cpp
int foo(int a, int b)
{
	int c = integer_parse();
	auto function = [a, b, c](int x) { return (a + b - c) * x; }
	return function(10);
}
```

Becomes:


```llvm
%Lambda_Arguments = type {
	i32,        ; 0: a (argument)
	i32,        ; 1: b (argument)
	i32         ; 2: c (local)
}

define i32 @lambda(%Lambda_Arguments* %args, i32 %x) nounwind {
	%1 = getelementptr %Lambda_Arguments* %args, i32 0, i32 0
	%a = load i32* %1
	%2 = getelementptr %Lambda_Arguments* %args, i32 0, i32 1
	%b = load i32* %2
	%3 = getelementptr %Lambda_Arguments* %args, i32 0, i32 2
	%c = load i32* %3
	%4 = add i32 %a, %b
	%5 = sub i32 %4, %c
	%6 = mul i32 %5, %x
	ret i32 %6
}

declare i32 @integer_parse()

define i32 @foo(i32 %a, i32 %b) nounwind {
	%args = alloca %Lambda_Arguments
	%1 = getelementptr %Lambda_Arguments* %args, i32 0, i32 0
	store i32 %a, i32* %1
	%2 = getelementptr %Lambda_Arguments* %args, i32 0, i32 1
	store i32 %b, i32* %2
	%c = call i32 @integer_parse()
	%3 = getelementptr %Lambda_Arguments* %args, i32 0, i32 2
	store i32 %c, i32* %3
	%4 = call i32 @lambda(%Lambda_Arguments* %args, i32 10)
	ret i32 %4
}
```

Obviously there are some possible variations over this theme:


- You could pass all implicit as explicit arguments as arguments.
- You could pass all implicit as explicit arguments in the structure.
- You could pass in a pointer to the frame of the caller and let the lambda function extract the arguments and locals from the input frame.


