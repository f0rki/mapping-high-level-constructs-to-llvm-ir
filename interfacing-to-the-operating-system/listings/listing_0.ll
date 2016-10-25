declare i32 @puts(i8* nocapture) nounwind

@.hello = private unnamed_addr constant [13 x i8] c"hello world\0A\00"

define i32 @main(i32 %argc, i8** %argv) {
	%1 = getelementptr [13 x i8]* @.hello, i32 0, i32 0
	call i32 @puts(i8* %1)
	ret i32 0
}
