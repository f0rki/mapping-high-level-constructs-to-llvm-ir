@variable = global i32 14

define i32 @main() nounwind {
	%1 = load i32* @variable
	ret i32 %1
}
