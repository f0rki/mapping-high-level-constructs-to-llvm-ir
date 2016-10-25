## Function Definitions



The translation of function definitions depends on a range of factors, ranging from the calling convention in use, whether the
function is exception-aware or not, and if the function is to be publicly available outside the module.


### Simple Public Functions

The most basic model is:

```cpp
int Bar(void)
{
	return 17;
}
```

Becomes:


```ll
define i32 @Bar() nounwind {
	ret i32 17
}
```

### Simple Private Functions


A static function is a function private to a module that cannot be referenced from outside of the defining module:

```ll
define private i32 @Foo() nounwind {
	ret i32 17
}
```

### Functions with a Variable Number of Parameters


To call a so-called vararg function, you first need to define or declare it using the elipsis (...) and then you need to make use
of a special syntax for function calls that allows you to explictly list the types of the parameters of the function that is being
called.  This "hack" exists to allow overriding a call to a function such as a function with variable parameters.  Please notice
that you only need to specify the return type once, not twice as you'd have to do if it was a true cast:

```ll
declare i32 @printf(i8*, ...) nounwind

@.text = internal constant [20 x i8] c"Argument count: %d\0A\00"

define i32 @main(i32 %argc, i8** %argv) nounwind {
	; printf("Argument count: %d\n", argc)
	%1 = call i32 (i8*, ...)* @printf(i8* getelementptr([20 x i8]* @.text, i32 0, i32 0), i32 %argc)
	ret i32 0
}
```

### Exception-Aware Functions


A function that is aware of being part of a larger scheme of exception-handling is called an exception-aware function.  Depending
upon the type of exception handling being employed, the function may either return a pointer to an exception instance, create a
`setjmp`/`longjmp` frame, or simply specify the `uwtable` (for UnWind Table) attribute.  These cases will all be covered in
great detail in the chapter on *Exception Handling* below.


