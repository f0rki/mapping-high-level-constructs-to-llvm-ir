%foo_context = type {
	i8*,      ; 0: block (state)
	i32       ; 1: value (result)
}

define void @foo_setup(%foo_context* %context) nounwind {
	; set up 'block'
	%1 = getelementptr %foo_context, %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.yield1), i8** %1

	ret void
}

; The boolean returned indicates if a result was available or not.
; Once no more results are available, the caller is expected to not call
; the iterator again.
define i1 @foo_yield(%foo_context* %context) nounwind {
	; dispatch to the active generator block
	%1 = getelementptr %foo_context, %foo_context* %context, i32 0, i32 0
	%2 = load i8*, i8** %1
	indirectbr i8* %2, [ label %.yield1, label %.yield2, label %.yield3, label %.done ]

.yield1:
	; store the result value (1)
	%3 = getelementptr %foo_context, %foo_context* %context, i32 0, i32 1
	store i32 1, i32* %3

	; make 'block' point to next block to execute
	%4 = getelementptr %foo_context, %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.yield2), i8** %4

	ret i1 1

.yield2:
	; store the result value (2)
	%5 = getelementptr %foo_context, %foo_context* %context, i32 0, i32 1
	store i32 2, i32* %5

	; make 'block' point to next block to execute
	%6 = getelementptr %foo_context, %foo_context* %context, i32 0, i32 0
	store i8* blockaddress(@foo_yield, %.yield3), i8** %6

	ret i1 1

.yield3:
	; store the result value (3)
	%7 = getelementptr %foo_context, %foo_context* %context, i32 0, i32 1
	store i32 3, i32* %7

	; make 'block' point to next block to execute
	%8 = getelementptr %foo_context, %foo_context* %context, i32 0, i32 0
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
	%2 = getelementptr %foo_context, %foo_context* %context, i32 0, i32 1
	%3 = load i32, i32* %2
	%4 = call i32 (i8*, ...) @printf(i8* getelementptr([11 x i8], [11 x i8]* @.string, i32 0, i32 0), i32 %3)
	br label %.head

.tail:
	ret void
}
