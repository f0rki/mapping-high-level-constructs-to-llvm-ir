## Generators


A generator is a function that repeatedly yields a value in such a way that the function's state is preserved across the repeated
calls of the function; this includes the function's local offset at the point it yielded a value.

The most straigthforward way to implement a generator is by wrapping all of its state variables (arguments, local variables, and
return values) up into an ad-hoc structure and then pass the address of that structure to the generator.

Somehow, you need to keep track of which block of the generator you are doing on each call.  This can be done in various ways; the
way we show here is by using LLVM's `blockaddress` instruction to save the address of the next local block of code that should be
executed.  Other implementations use a simple state variable and then do a `switch`-like dispatch according to the value of the
state variable.  In both cases, the end result is the same: A different block of code is executed for each local block in the
generator.

The important thing is to think of iterators as a sort of micro-thread that is resumed whenever the iterator is called again. In
other words, we need to save the address of how far the iterator got on each pass through so that it can resume as if a microscopic
thread switch had occured.  So we save the address of the instruction after the return instruction so that we can resume running
as if we never had returned in the first place.

I resort to pseudo-C++ because C++ does not directly support generators. First we look at a very simple case then we advance on to
a slightly more complex case:

```cpp
#include <stdio.h>

generator int foo()
{
	yield 1;
	yield 2;
	yield 3;
}

int main()
{
	foreach (int i in foo())
		printf("Value: %d\n", i);

	return 0;
}
```

This becomes:

; Compiled and run successfully against LLVM v3.4 on 2013.12.06.

```ll
%foo_context = type {
	i8*,      ; 0: block (state)
	i32       ; 1: value (result)
}

define void @foo_setup(%foo_context* %context) nounwind {
	; set up 'block'
	%1 = getelementptr %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.yield1), i8** %1

	ret void
}

; The boolean returned indicates if a result was available or not.
; Once no more results are available, the caller is expected to not call
; the iterator again.
define i1 @foo_yield(%foo_context* %context) nounwind {
	; dispatch to the active generator block
	%1 = getelementptr %foo_context* %context, i32 0, i32 0
	%2 = load i8** %1
	indirectbr i8* %2, [ label %.yield1, label %.yield2, label %.yield3, label %.done ]

.yield1:
	; store the result value (1)
	%3 = getelementptr %foo_context* %context, i32 0, i32 1
	store i32 1, i32* %3

	; make 'block' point to next block to execute
	%4 = getelementptr %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.yield2), i8** %4

	ret i1 1

.yield2:
	; store the result value (2)
	%5 = getelementptr %foo_context* %context, i32 0, i32 1
	store i32 2, i32* %5

	; make 'block' point to next block to execute
	%6 = getelementptr %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.yield3), i8** %6

	ret i1 1

.yield3:
	; store the result value (3)
	%7 = getelementptr %foo_context* %context, i32 0, i32 1
	store i32 3, i32* %7

	; make 'block' point to next block to execute
	%8 = getelementptr %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.done), i8** %8

	ret i1 1

.done:
	ret i1 0
}

declare i32 @printf(i8*, ...) nounwind

@.string = internal constant [11 x i8] c"Value: %d\0A\00"

define void @main() nounwind {
	; allocate and initialize generator context structure
	%context = alloca %foo_context
	call void @foo_setup(%foo_context* %context)
	br label %.head

.head:
	; foreach (int i in foo())
	%1 = call i1 @foo_yield(%foo_context* %context)
	br i1 %1, label %.body, label %.tail

.body:
	%2 = getelementptr %foo_context* %context, i32 0, i32 1
	%3 = load i32* %2
	%4 = call i32 (i8*, ...)* @printf(i8* getelementptr([11 x i8]* @.string, i32 0, i32 0), i32 %3)
	br label %.head

.tail:
	ret void
}
```

And now for a slightly more complex example that involves local variables:


```cpp
#include <stdio.h>

generator int foo(int start, int after)
{
	for (int index = start; index < after; index++)
	{
		if (index % 2 == 0)
			yield index + 1;
		else
			yield index - 1;
	}
}

int main(void)
{
	foreach (int i in foo(0, 5))
		printf("Value: %d\n", i);

	return 0;
}
```

This becomes something like this:


; Compiled and run successfully against LLVM v3.4 on 2013.12.06.

```ll
%foo_context = type {
	i8*,      ; 0: block (state)
	i32,      ; 1: start (argument)
	i32,      ; 2: after (argument)
	i32,      ; 3: index (local)
	i32       ; 4: value (result)
}

define void @foo_setup(%foo_context* %context, i32 %start, i32 %after) nounwind {
	; set up 'block'
	%1 = getelementptr %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.init), i8** %1

	; set up 'start'
	%2 = getelementptr %foo_context* %context, i32 0, i32 1
	store i32 %start, i32* %2

	; set up 'after'
	%3 = getelementptr %foo_context* %context, i32 0, i32 2
	store i32 %after, i32* %3

	ret void
}

define i1 @foo_yield(%foo_context* %context) nounwind {
	; dispatch to the active generator block
	%1 = getelementptr %foo_context* %context, i32 0, i32 0
	%2 = load i8** %1
   indirectbr i8* %2, [ label %.init, label %.loop_close, label %.end ]

.init:
	; copy argument 'start' to the local variable 'index'
	%3 = getelementptr %foo_context* %context, i32 0, i32 1
	%start = load i32* %3
	%4 = getelementptr %foo_context* %context, i32 0, i32 3
	store i32 %start, i32* %4
	br label %.head

.head:
	; for (; index < after; )
	%5 = getelementptr %foo_context* %context, i32 0, i32 3
	%index = load i32* %5
	%6 = getelementptr %foo_context* %context, i32 0, i32 2
	%after = load i32* %6
	%again = icmp slt i32 %index, %after
	br i1 %again, label %.loop_begin, label %.exit

.loop_begin:
	%7 = srem i32 %index, 2
	%8 = icmp eq i32 %7, 0
	br i1 %8, label %.even, label %.odd

.even:
	; store 'index + 1' in 'value'
	%9 = add i32 %index, 1
	%10 = getelementptr %foo_context* %context, i32 0, i32 4
	store i32 %9, i32* %10

	; make 'block' point to the end of the loop (after the yield)
	%11 = getelementptr %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.loop_close), i8** %11

	ret i1 1

.odd:
	; store 'index - 1' in value
	%12 = sub i32 %index, 1
	%13 = getelementptr %foo_context* %context, i32 0, i32 4
	store i32 %12, i32* %13

	; make 'block' point to the end of the loop (after the yield)
	%14 = getelementptr %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.loop_close), i8** %14

	ret i1 1

.loop_close:
	; increment 'index'
	%15 = getelementptr %foo_context* %context, i32 0, i32 3
	%16 = load i32* %15
	%17 = add i32 %16, 1
	store i32 %17, i32* %15
	br label %.head

.exit:
	; make 'block' point to the %.end label
	%x = getelementptr %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.end), i8** %x
	br label %.end

.end:
	ret i1 0
}

declare i32 @printf(i8*, ...) nounwind

@.string = internal constant [11 x i8] c"Value: %d\0A\00"

define i32 @main() nounwind {
	; allocate and initialize generator context structure
	%context = alloca %foo_context
	call void @foo_setup(%foo_context* %context, i32 0, i32 5)
	br label %.head

.head:
	; foreach (int i in foo(0, 5))
	%1 = call i1 @foo_yield(%foo_context* %context)
	br i1 %1, label %.body, label %.tail

.body:
	%2 = getelementptr %foo_context* %context, i32 0, i32 4
	%3 = load i32* %2
	%4 = call i32 (i8*, ...)* @printf(i8* getelementptr([11 x i8]* @.string, i32 0, i32 0), i32 %3)
	br label %.head

.tail:
	ret i32 0
}
```

Another possible way of doing the above would be to generate an LLVM IR function for each state and then store a function pointer

in the context structure, which is updated whenever a new state/function needs to be invoked.


