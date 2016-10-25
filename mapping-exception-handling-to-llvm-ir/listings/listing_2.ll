; jmp_buf is very platform specific, this is for illustration only...
%jmp_buf = type { i32 }
declare i32 @setjmp(%jmp_buf* %env)
declare void @longjmp(%jmp_buf* %env, i32 %val)

;********************* External and Utility functions *********************

declare i8* @malloc(i32) nounwind
declare void @free(i8*) nounwind
declare i32 @printf(i8* noalias nocapture, ...) nounwind
declare i32 @puts(i8* noalias nocapture) nounwind

;***************************** Object class *******************************

%Object_vtable_type = type {
	%Object_vtable_type*,         ; 0: above: parent class vtable pointer
	i8*                           ; 1: class: class name (usually mangled)
	; virtual methods would follow here
}

@.Object_class_name = private constant [7 x i8] c"Object\00"

@.Object_vtable = private constant %Object_vtable_type {
	%Object_vtable_type* null,    ; This is the root object of the object hierarchy
	i8* getelementptr([7 x i8]* @.Object_class_name, i32 0, i32 0)
}

%Object = type {
	%Object_vtable_type*          ; 0: vtable: class vtable pointer (always non-null)
	; class data members would follow here
}

; returns true if the specified object is identical to or derived from the
; class with the specified name.
define i1 @Object_IsA(%Object* %object, i8* %name) nounwind {
.init:
	; if (object == null) return false
	%0 = icmp ne %Object* %object, null
	br i1 %0, label %.once, label %.exit_false

.once:
	%1 = getelementptr %Object* %object, i32 0, i32 0
	br label %.body

.body:
	; if (vtable->class == name)
	%2 = phi %Object_vtable_type** [ %1, %.once ], [ %7, %.next]
	%3 = load %Object_vtable_type** %2
	%4 = getelementptr %Object_vtable_type* %3, i32 0, i32 1
	%5 = load i8** %4
	%6 = icmp eq i8* %5, %name
	br i1 %6, label %.exit_true, label %.next

.next:
	; object = object->above
	%7 = getelementptr %Object_vtable_type* %3, i32 0, i32 0

	; while (object != null)
	%8 = icmp ne %Object_vtable_type* %3, null
	br i1 %8, label %.body, label %.exit_false

.exit_true:
	ret i1 true

.exit_false:
	ret i1 false
}

;*************************** Exception class ******************************

%Exception_vtable_type = type {
	%Object_vtable_type*,                        ; 0: parent class vtable pointer
	i8*                                          ; 1: class name
	; virtual methods would follow here.
}

@.Exception_class_name = private constant [10 x i8] c"Exception\00"

@.Exception_vtable = private constant %Exception_vtable_type {
	%Object_vtable_type* @.Object_vtable,        ; the parent of this class is the Object class
	i8* getelementptr([10 x i8]* @.Exception_class_name, i32 0, i32 0)
}

%Exception = type {
	%Exception_vtable_type*,                     ; 0: the vtable pointer
	i8*                                          ; 1: the _text member
}

define void @Exception_Create_String(%Exception* %this, i8* %text) nounwind {
	; set up vtable
	%1 = getelementptr %Exception* %this, i32 0, i32 0
	store %Exception_vtable_type* @.Exception_vtable, %Exception_vtable_type** %1

	; save input text string into _text
	%2 = getelementptr %Exception* %this, i32 0, i32 1
	store i8* %text, i8** %2

	ret void
}

define i8* @Exception_GetText(%Exception* %this) nounwind {
	%1 = getelementptr %Exception* %this, i32 0, i32 1
	%2 = load i8** %1
	ret i8* %2
}

;******************************* Foo class ********************************

%Foo = type { i32 }

define void @Foo_Create_Default(%Foo* %this) nounwind {
	%1 = getelementptr %Foo* %this, i32 0, i32 0
	store i32 0, i32* %1
	ret void
}

define i32 @Foo_GetLength(%Foo* %this) nounwind {
	%1 = getelementptr %Foo* %this, i32 0, i32 0
	%2 = load i32* %1
	ret i32 %2
}

define void @Foo_SetLength(%Foo* %this, i32 %value) nounwind {
	%1 = getelementptr %Foo* %this, i32 0, i32 0
	store i32 %value, i32* %1
	ret void
}

;********************************* Foo function ***************************

@.message1 = internal constant [30 x i8] c"Exception requested by caller\00"

define i32 @Bar(%jmp_buf* %throw, i1 %fail) nounwind {
	; Allocate Foo instance
	%foo = alloca %Foo
	call void @Foo_Create_Default(%Foo* %foo)

	call void @Foo_SetLength(%Foo* %foo, i32 17)

	; if (fail)
	%1 = icmp eq i1 %fail, true
	br i1 %1, label %.if_begin, label %.if_close

.if_begin:
	; throw new Exception(...)
	%2 = call i8* @malloc(i32 8)
	%3 = bitcast i8* %2 to %Exception*
	%4 = getelementptr [30 x i8]* @.message1, i32 0, i32 0
	call void @Exception_Create_String(%Exception* %3, i8* %4)
	%5 = ptrtoint %Exception* %3 to i32
	call void @longjmp(%jmp_buf* %throw, i32 %5)
	; we never get here
	br label %.if_close

.if_close:
	; foo.SetLength(24)
	call void @Foo_SetLength(%Foo* %foo, i32 24)
	%6 = call i32 @Foo_GetLength(%Foo* %foo)
	ret i32 %6
}

;********************************* Main program ***************************

@.message2 = internal constant [11 x i8] c"Error: %s\0A\00"
@.message3 = internal constant [44 x i8] c"Internal error: Unhandled exception detectd\00"

define i32 @main(i32 %argc, i8** %argv) nounwind {
	; "try" keyword expands to a call to @setjmp
	%env = alloca %jmp_buf
	%status = call i32 @setjmp(%jmp_buf* %env)
	%1 = icmp eq i32 %status, 0
	br i1 %1, label %.body, label %.catch_block

.body:
	; Body of try block.
	; fail = (argc >= 2)
	%fail = icmp uge i32 %argc, 2

	; Function call.
	%2 = call i32 @Bar(%jmp_buf* %env, i1 %fail)
	br label %.exit

.catch_block:
	%3 = inttoptr i32 %status to %Object*
	%4 = getelementptr [10 x i8]* @.Exception_class_name, i32 0, i32 0
	%5 = call i1 @Object_IsA(%Object* %3, i8* %4)
	br i1 %5, label %.catch_exception, label %.catch_all

.catch_exception:
	%6 = inttoptr i32 %status to %Exception*
	%7 = getelementptr [11 x i8]* @.message2, i32 0, i32 0
	%8 = call i8* @Exception_GetText(%Exception* %6)
	%9 = call i32 (i8*, ...)* @printf(i8* %7, i8* %8)
	br label %.exit

.catch_all:
	%10 = getelementptr [44 x i8]* @.message3, i32 0, i32 0
	%11 = call i32 @puts(i8* %10)
	br label %.exit

.exit:
	%result = phi i32 [ 0, %.body ], [ 1, %.catch_exception ], [ 1, %.catch_all ]
	ret i32 %result
}
