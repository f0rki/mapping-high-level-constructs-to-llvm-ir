declare i8* @malloc(i32) nounwind

%X = type { i32 }

define void @X_Create_Default(%X* %this) nounwind {
	%1 = getelementptr %X* %this, i32 0, i32 0
	store i32 0, i32* %1
	ret void
}

define void @main() nounwind {
	%n = alloca i32                  ; %n = ptr to the number of elements in the array
	store i32 100, i32* %n

	%i = alloca i32                  ; %i = ptr to the loop index into the array
	store i32 0, i32* %i

	%1 = load i32* %n                ; %1 = *%n
	%2 = mul i32 %1, 4               ; %2 = %1 * sizeof(X)
	%3 = call i8* @malloc(i32 %2)    ; %3 = malloc(100 * sizeof(X))
	%4 = bitcast i8* %3 to %X*       ; %4 = (X*) %3
	br label %.loop_head

.loop_head:                         ; for (; %i < %n; %i++)
	%5 = load i32* %i
	%6 = load i32* %n
	%7 = icmp slt i32 %5, %6
	br i1 %7, label %.loop_body, label %.loop_tail

.loop_body:
	%8 = getelementptr %X* %4, i32 %5
	call void @X_Create_Default(%X* %8)

	%9 = add i32 %5, 1
	store i32 %9 i32* %i

	br label %.loop_head

.loop_tail:
	ret void
}
