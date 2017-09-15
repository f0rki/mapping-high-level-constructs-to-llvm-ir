@byte = global i8 117
@word = global i32 0

define void @main() nounwind {
	%1 = load i8* @byte
	%2 = zext i8 %1 to i32
	store i32 %2, i32* @word
	ret void
}
