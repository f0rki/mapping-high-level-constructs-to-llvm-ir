; ModuleID = 'struct_member_access.cpp'
source_filename = "struct_member_access.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.Foo = type { i32, i8*, double }

; Function Attrs: noinline norecurse nounwind uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.Foo, align 8
  %3 = alloca i8**, align 8
  %4 = alloca [100 x %struct.Foo], align 16
  store i32 0, i32* %1, align 4
  %5 = getelementptr inbounds %struct.Foo, %struct.Foo* %2, i32 0, i32 1
  store i8** %5, i8*** %3, align 8
  %p = getelementptr [100 x %struct.Foo], [100 x %struct.Foo]* %4, i64 0, i64 17, i32 0, i32 2
  store double 0.000000e+00, double* %p, align 8
  ret i32 0
}

attributes #0 = { noinline norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 4.0.1 (tags/RELEASE_401/final)"}
