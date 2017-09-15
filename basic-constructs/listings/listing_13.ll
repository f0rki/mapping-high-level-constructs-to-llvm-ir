declare i32 @printf(i8*, ...) nounwind

@.text = internal constant [20 x i8] c"Argument count: %d\0A\00"

define i32 @main(i32 %argc, i8** %argv) nounwind {
	; printf("Argument count: %d\n", argc)
	%1 = call i32 (i8*, ...)* @printf(i8* getelementptr([20 x i8]* @.text, i32 0, i32 0), i32 %argc)
	ret i32 0
}
