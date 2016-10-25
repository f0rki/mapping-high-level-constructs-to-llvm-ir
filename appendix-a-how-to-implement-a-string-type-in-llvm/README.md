# Appendix A: How to Implement a String Type in LLVM

There are two ways to implement a string type in LLVM:

- To write the implementation in LLVM IR.
- To write the implementation in a higher-level language that generates IR.

I'd personally much prefer to use the second method, but for the sake of the example, I'll go ahead and illustrate a simple but
useful string type in LLVM IR.  It assumes a 32-bit architecture, so please replace all occurences of `i32` with `i64` if you
are targetting a 64-bit architecture.

We'll be making a dynamic, mutable string type that can be appended to and could also be inserted into, converted to lower case,
and so on, depending on which support functions are defined to operate on the string type.

It all boils down to making a suitable type definition for the class and then define a rich set of functions to operate on the type
definition:

```ll
; The actual type definition for our 'String' type.
%String = type {
	i8*,     ; 0: buffer; pointer to the character buffer
	i32,     ; 1: length; the number of chars in the buffer
	i32,     ; 2: maxlen; the maximum number of chars in the buffer
	i32      ; 3: factor; the number of chars to preallocate when growing
}

define fastcc void @String_Create_Default(%String* %this) nounwind {
	; Initialize 'buffer'.
	%1 = getelementptr %String* %this, i32 0, i32 0
	store i8* null, i8** %1

	; Initialize 'length'.
	%2 = getelementptr %String* %this, i32 0, i32 1
	store i32 0, i32* %2

	; Initialize 'maxlen'.
	%3 = getelementptr %String* %this, i32 0, i32 2
	store i32 0, i32* %3

	; Initialize 'factor'.
	%4 = getelementptr %String* %this, i32 0, i32 3
	store i32 16, i32* %4

	ret void
}

declare i8* @malloc(i32)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i32)

define fastcc void @String_Delete(%String* %this) nounwind {
	; Check if we need to call 'free'.
	%1 = getelementptr %String* %this, i32 0, i32 0
	%2 = load i8** %1
	%3 = icmp ne i8* %2, null
	br i1 %3, label %free_begin, label %free_close

free_begin:
	call void @free(i8* %2)
	br label %free_close

free_close:
	ret void
}

define fastcc void @String_Resize(%String* %this, i32 %value) {
	; %output = malloc(%value)
	%output = call i8* @malloc(i32 %value)

	; todo: check return value

	; %buffer = this->buffer
	%1 = getelementptr %String* %this, i32 0, i32 0
	%buffer = load i8** %1

	; %length = this->length
	%2 = getelementptr %String* %this, i32 0, i32 1
	%length = load i32* %2

	; memcpy(%output, %buffer, %length)
	%3 = call i8* @memcpy(i8* %output, i8* %buffer, i32 %length)

	; free(%buffer)
	call void @free(i8* %buffer)

	; this->buffer = %output
	store i8* %output, i8** %1

	ret void
}

define fastcc void @String_Add_Char(%String* %this, i8 %value) {
	; Check if we need to grow the string.
	%1 = getelementptr %String* %this, i32 0, i32 1
	%length = load i32* %1
	%2 = getelementptr %String* %this, i32 0, i32 2
	%maxlen = load i32* %2
	; if length == maxlen:
	%3 = icmp eq i32 %length, %maxlen
	br i1 %3, label %grow_begin, label %grow_close

grow_begin:
	%4 = getelementptr %String* %this, i32 0, i32 3
	%factor = load i32* %4
	%5 = add i32 %maxlen, %factor
	call void @String_Resize(%String* %this, i32 %5)
	br label %grow_close

grow_close:
	%6 = getelementptr %String* %this, i32 0, i32 0
	%buffer = load i8** %6
	%7 = getelementptr i8* %buffer, i32 %length
	store i8 %value, i8* %7
	%8 = add i32 %length, 1
	store i32 %8, i32* %1

	ret void
}
```

