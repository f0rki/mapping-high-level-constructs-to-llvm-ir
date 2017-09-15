declare i8* @malloc(i32) nounwind

%X = type { i8 }

define void @X_Create_Default(%X* %this) nounwind {
	%1 = getelementptr %X* %this, i32 0, i32 0
	store i8 0, i8* %1
	ret void
}

define void @main() nounwind {
	%1 = call i8* @malloc(i32 1)
	%2 = bitcast i8* %1 to %X*
	call void @X_Create_Default(%X* %2)
	ret void
}
