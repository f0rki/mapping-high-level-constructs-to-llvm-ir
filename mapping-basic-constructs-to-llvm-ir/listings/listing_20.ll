@char = global i8 -17
@int  = global i32 0

define void @main() nounwind {
	%1 = load i8* @char
	%2 = sext i8 %1 to i32
	store i32 %2, i32* @int
	ret void
}
