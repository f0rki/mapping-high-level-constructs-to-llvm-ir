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
