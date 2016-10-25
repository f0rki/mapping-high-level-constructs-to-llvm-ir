@int = global i32 -1
@char = global i8 0

define void @main() nounwind {
	%1 = load i32* @int
	%2 = trunc i32 %1 to i8
	store i8 %2, i8* @char
	ret void
}
