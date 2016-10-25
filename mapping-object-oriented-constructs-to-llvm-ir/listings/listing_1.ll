; The structure definition for class Foo.
%Foo = type { i32 }

; The default constructor for class Foo.
define void @Foo_Create_Default(%Foo* %this) nounwind {
	%1 = getelementptr %Foo* %this, i32 0, i32 0
	store i32 0, i32* %1
	ret void
}

; The Foo::GetLength() method.
define i32 @Foo_GetLength(%Foo* %this) nounwind {
	%1 = getelementptr %Foo* %this, i32 0, i32 0
	%2 = load i32* %this
	ret i32 %2
}

; The Foo::SetLength() method.
define void @Foo_SetLength(%Foo* %this, i32 %value) nounwind {
	%1 = getelementptr %Foo* %this, i32 0, i32 0
	store i32 %value, i32* %1
	ret void
}
