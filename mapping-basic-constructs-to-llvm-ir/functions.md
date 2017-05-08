## Function Definitions and Declarations

The translation of function definitions depends on a range of factors, ranging
from the calling convention in use, whether the function is exception-aware or
not, and if the function is to be publicly available outside the module.


### Simple Public Functions

The most basic model is:

```cpp
int Bar(void)
{
	return 17;
}
```

Becomes:

```llvm
define i32 @Bar() nounwind {
	ret i32 17
}
```


### Simple Private Functions

A static function is a function private to a module that cannot be referenced from outside of the defining module:

```llvm
define private i32 @Foo() nounwind {
	ret i32 17
}
```


### Function Prototypes

A function prototype, aka a profile, is translated into an equivalent `declare` declaration in LLVM IR:

```cpp
int Bar(int value);
```
Becomes:

```llvm
declare i32 @Bar(i32 %value)
```

Or you can leave out the descriptive parameter name:

```llvm
declare i32 @Bar(i32)
```


### Functions with a Variable Number of Parameters

To call a so-called vararg function, you first need to define or declare it using the elipsis (...) and then you need to make use
of a special syntax for function calls that allows you to explictly list the types of the parameters of the function that is being
called. This "hack" exists to allow overriding a call to a function such as a function with variable parameters.  Please notice
that you only need to specify the return type once, not twice as you'd have to do if it was a true cast:

```llvm
declare i32 @printf(i8*, ...) nounwind

@.text = internal constant [20 x i8] c"Argument count: %d\0A\00"

define i32 @main(i32 %argc, i8** %argv) nounwind {
	; printf("Argument count: %d\n", argc)
	%1 = call i32 (i8*, ...)* @printf(i8* getelementptr([20 x i8]* @.text, i32 0, i32 0), i32 %argc)
	ret i32 0
}
```


### Function Overloading

Function overloading is actually not dealt with on the level of LLVM IR, but on
the source language. Function names are mangled, so that they encode the types
they take as parameter and return in their function name. For a C++ example:

```cpp
int function(int a, int b) {
    return a + b;
}

int function(double a, double b, double x) {
    return a*b + x;
}
```

For LLVM these two are completely different functions, with different names
etc.

```llvm
define i32 @_Z4funcii(i32 %a, i32 %b) #0 {
; [...]
  ret i32 %5
}

define double @_Z4funcddd(double %a, double %b, double %x) #0 {
; [...]
  ret double %8
}
```


### Struct by Value as Parameter or Return Value

Classes or structs are often passed around by value, implicitly cloning the
objects when they are passed. But they are not

```cpp
struct Point {
    double x;
    double y;
    double z;
};

Point add_points(Point a, Point b) {
  Point p;
  p.x = a.x + b.x;
  p.y = a.y + b.y;
  p.z = a.z + b.z;
  return p;
}
```

This simple example is in turn compiled to

```llvm
%struct.Point = type { double, double, double }

define void @add_points(%struct.Point* noalias sret %agg.result,
                        %struct.Point* byval align 8 %a,
                        %struct.Point* byval align 8 %b) #0 {
; there is no alloca here for Point p;
; p.x = a.x + b.x;
  %1 = getelementptr inbounds %struct.Point, %struct.Point* %a, i32 0, i32 0
  %2 = load double, double* %1, align 8
  %3 = getelementptr inbounds %struct.Point, %struct.Point* %b, i32 0, i32 0
  %4 = load double, double* %3, align 8
  %5 = fadd double %2, %4
  %6 = getelementptr inbounds %struct.Point, %struct.Point* %agg.result, i32 0, i32 0
  store double %5, double* %6, align 8
; p.y = a.y + b.y;
  %7 = getelementptr inbounds %struct.Point, %struct.Point* %a, i32 0, i32 1
  %8 = load double, double* %7, align 8
  %9 = getelementptr inbounds %struct.Point, %struct.Point* %b, i32 0, i32 1
  %10 = load double, double* %9, align 8
  %11 = fadd double %8, %10
  %12 = getelementptr inbounds %struct.Point, %struct.Point* %agg.result, i32 0, i32 1
  store double %11, double* %12, align 8
; p.z = a.z + b.z;
  %13 = getelementptr inbounds %struct.Point, %struct.Point* %a, i32 0, i32 2
  %14 = load double, double* %13, align 8
  %15 = getelementptr inbounds %struct.Point, %struct.Point* %b, i32 0, i32 2
  %16 = load double, double* %15, align 8
  %17 = fadd double %14, %16
  %18 = getelementptr inbounds %struct.Point, %struct.Point* %agg.result, i32 0, i32 2
  store double %17, double* %18, align 8
; there is no real returned value, because the previous stores directly wrote
; to the caller allocated value via %agg.result
  ret void
}
```

We can see that the funtion now actually returns `void` and another parameter
was added. The first parameter is a pointer to the result, which is allocated
by the caller. The pointer has the attirbute `noalias` because there is no way
that one of the parameters might point to the same location. The `sret`
attribute indicates that this is the return value.

The parameters have the `byval` attribute, which indicates that they are
structs that are passed by value.

Let's see how this function would be called.

```cpp
int main() {
  Point a = {1.0, 3.0, 4.0};
  Point b = {2.0, 8.0, 5.0};
  Point c = add_points(a, b);
  return 0;
}
```

is compiled to:

```llvm
define i32 @main() #1 {
; these are the a, b, c in the scope of main
  %a = alloca %struct.Point, align 8
  %b = alloca %struct.Point, align 8
  %c = alloca %struct.Point, align 8
; these are copies, which are passed as arguments
  %1 = alloca %struct.Point, align 8
  %2 = alloca %struct.Point, align 8
; copy the global initializer main::a to %a
  %3 = bitcast %struct.Point* %a to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %3, i8* bitcast (%struct.Point* @main.a to i8*), i64 24, i32 8, i1 false)
; copy the global initializer main::b to %b
  %4 = bitcast %struct.Point* %b to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %4, i8* bitcast (%struct.Point* @main.b to i8*), i64 24, i32 8, i1 false)
; clone a to %1
  %5 = bitcast %struct.Point* %1 to i8*
  %6 = bitcast %struct.Point* %a to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %5, i8* %6, i64 24, i32 8, i1 false)
; clone b to %1
  %7 = bitcast %struct.Point* %2 to i8*
  %8 = bitcast %struct.Point* %b to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %7, i8* %8, i64 24, i32 8, i1 false)
; call add_points with the cloned values
  call void @add_points(%struct.Point* sret %c, %struct.Point* byval align 8 %1, %struct.Point* byval align 8 %2)
  ; [...]
}
```

We can see that the caller, in our case `main`, allocates space for the return
value `%c` and also makes sure to clone the parameters `a` and `b` before
actually passing them by reference.


### Exception-Aware Functions

A function that is aware of being part of a larger scheme of exception-handling
is called an exception-aware function.  Depending upon the type of exception
handling being employed, the function may either return a pointer to an
exception instance, create a `setjmp`/`longjmp` frame, or simply specify the
`uwtable` (for UnWind Table) attribute.  These cases will all be covered in
great detail in the chapter on *Exception Handling* below.


## Function Pointers

Function pointers are expressed almost like in C and C++:

```cpp
int (*Function)(char *buffer);
```

Becomes:

```llvm
@Function = global i32(i8*)* null
```

