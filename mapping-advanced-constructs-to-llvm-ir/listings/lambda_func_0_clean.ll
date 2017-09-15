define internal i32 @lambda(i32 %a, i32 %x) {
	%1 = add i32 %a, %x
	ret i32 %1
}

define i32 @foo(i32 %a) {
	%1 = call i32 @lambda(i32 %a, i32 10)
	ret i32 %1
}
