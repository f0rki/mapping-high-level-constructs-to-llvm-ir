## How to Interface to POSIX Operating Systems


On POSIX, the presence of the C run-time library is an unavoidable fact for which reason it makes a lot of sense to directly call
such C run-time functions.


### Sample POSIX "Hello World" Application

On POSIX, it is really very easy to create the `Hello world` program:

```ll
declare i32 @puts(i8* nocapture) nounwind

@.hello = private unnamed_addr constant [13 x i8] c"hello world\0A\00"

define i32 @main(i32 %argc, i8** %argv) {
	%1 = getelementptr [13 x i8]* @.hello, i32 0, i32 0
	call i32 @puts(i8* %1)
	ret i32 0
}
```
### How to Interface to the Windows Operating System


On Windows, the C run-time library is mostly considered of relevance to the C and C++ languages only, so you have a plethora
(thousands) of standard system interfaces that any client application may use.


### Sample Windows "Hello World" Application

`Hello world` on Windows is nowhere as straightforward as on POSIX:

```ll
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-f80:128:128-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S32"
target triple = "i686-pc-win32"

%struct._OVERLAPPED = type { i32, i32, %union.anon, i8* }
%union.anon = type { %struct.anon }
%struct.anon = type { i32, i32 }

declare dllimport x86_stdcallcc i8* @"\01_GetStdHandle@4"(i32) #1

declare dllimport x86_stdcallcc i32 @"\01_WriteFile@20"(i8*, i8*, i32, i32*, %struct._OVERLAPPED*) #1

@hello = internal constant [13 x i8] c"Hello world\0A\00"

define i32 @main(i32 %argc, i8** %argv) nounwind {
	%1 = call i8* @"\01_GetStdHandle@4"(i32 -11)    ; -11 = STD_OUTPUT_HANDLE
	%2 = getelementptr [13 x i8]* @hello, i32 0, i32 0
	%3 = call i32 @"\01_WriteFile@20"(i8* %1, i8* %2, i32 12, i32* null, %struct._OVERLAPPED* null)
	; todo: Check that %4 is not equal to -1 (INVALID_HANDLE_VALUE)
	ret i32 0
}

attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"
"no-infs-fp-math"="fa lse" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false"
"use-soft-float"="false"
}
```
