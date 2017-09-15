; ModuleID = 'lambda_func_1_cleaned.ll'
source_filename = "lambda_func_1_cleaned.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%lambda_args = type { i32, i32, i32 }

declare i32 @integer_parse()

define i32 @lambda(%lambda_args* %args, i32 %x) {
  %1 = getelementptr %lambda_args, %lambda_args* %args, i32 0, i32 0
  %a = load i32, i32* %1
  %2 = getelementptr %lambda_args, %lambda_args* %args, i32 0, i32 1
  %b = load i32, i32* %2
  %3 = getelementptr %lambda_args, %lambda_args* %args, i32 0, i32 2
  %c = load i32, i32* %3
  %4 = add i32 %a, %b
  %5 = sub i32 %4, %c
  %6 = mul i32 %5, %x
  ret i32 %6
}

define i32 @foo(i32 %a, i32 %b) {
  %args = alloca %lambda_args
  %1 = getelementptr %lambda_args, %lambda_args* %args, i32 0, i32 0
  store i32 %a, i32* %1
  %2 = getelementptr %lambda_args, %lambda_args* %args, i32 0, i32 1
  store i32 %b, i32* %2
  %c = call i32 @integer_parse()
  %3 = getelementptr %lambda_args, %lambda_args* %args, i32 0, i32 2
  store i32 %c, i32* %3
  %4 = call i32 @lambda(%lambda_args* %args, i32 10)
  ret i32 %4
}
