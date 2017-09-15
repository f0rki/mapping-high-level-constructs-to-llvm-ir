define i32 @max(i32 %a, i32 %b) {
entry:
  %retval = alloca i32, align 4
  %0 = icmp sgt i32 %a, %b
  br i1 %0, label %btrue, label %bfalse

btrue:                                      ; preds = %2
  store i32 %a, i32* %retval, align 4
  br label %end

bfalse:                                     ; preds = %2
  store i32 %b, i32* %retval, align 4
  br label %end

end:                                     ; preds = %btrue, %bfalse
  %1 = load i32, i32* %retval, align 4
  ret i32 %1
}
