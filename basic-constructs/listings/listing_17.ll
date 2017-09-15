%Foo = type { i32 }

declare i8* @malloc(i32)
declare void @free(i8*)

define void @allocate() nounwind {
	%1 = call i8* @malloc(i32 4)
	%foo = bitcast i8* %1 to %Foo*
	%2 = getelementptr %Foo* %foo, i32 0, i32 0
	store i32 12, i32* %2
	call void @free(i8* %1)
	ret void
}
