%Lambda_Arguments = type {
	i32,        ; 0: a (argument)
	i32,        ; 1: b (argument)
	i32         ; 2: c (local)
}

define i32 @lambda(%Lambda_Arguments* %args, i32 %x) nounwind {
	%1 = getelementptr %Lambda_Arguments* %args, i32 0, i32 0
	%a = load i32* %1
	%2 = getelementptr %Lambda_Arguments* %args, i32 0, i32 1
	%b = load i32* %2
	%3 = getelementptr %Lambda_Arguments* %args, i32 0, i32 2
	%c = load i32* %3
	%4 = add i32 %a, %b
	%5 = sub i32 %4, %c
	%6 = mul i32 %5, %x
	ret i32 %6
}

declare i32 @integer_parse()

define i32 @foo(i32 %a, i32 %b) nounwind {
	%args = alloca %Lambda_Arguments
	%1 = getelementptr %Lambda_Arguments* %args, i32 0, i32 0
	store i32 %a, i32* %1
	%2 = getelementptr %Lambda_Arguments* %args, i32 0, i32 1
	store i32 %b, i32* %2
	%c = call i32 @integer_parse()
	%3 = getelementptr %Lambda_Arguments* %args, i32 0, i32 2
	store i32 %c, i32* %3
	%4 = call i32 @lambda(%Lambda_Arguments* %args, i32 10)
	ret i32 %4
}
