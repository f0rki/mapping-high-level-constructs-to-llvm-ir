; ModuleID = 'rust_enum.cgu-0.rs'
source_filename = "rust_enum.cgu-0.rs"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%str_slice = type { i8*, i64 }
%"core::fmt::ArgumentV1" = type { %"core::fmt::Void"*, [0 x i8], i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)*, [0 x i8] }
%"core::fmt::Void" = type { {}, [0 x i8] }
%"core::fmt::Formatter" = type { %"core::option::Option<usize>", [0 x i8], %"core::option::Option<usize>", [0 x i8], { i8*, void (i8*)** }, [0 x i8], %"core::slice::Iter<core::fmt::ArgumentV1>", [0 x i8], { %"core::fmt::ArgumentV1"*, i64 }, [0 x i8], i32, [0 x i8], i32, [0 x i8], i8, [7 x i8] }
%"core::option::Option<usize>" = type { i64, [0 x i64], [1 x i64] }
%"core::slice::Iter<core::fmt::ArgumentV1>" = type { %"core::fmt::ArgumentV1"*, [0 x i8], %"core::fmt::ArgumentV1"*, [0 x i8], %"core::marker::PhantomData<&core::fmt::ArgumentV1>", [0 x i8] }
%"core::marker::PhantomData<&core::fmt::ArgumentV1>" = type {}
%"core::fmt::Arguments" = type { { %str_slice*, i64 }, [0 x i8], %"core::option::Option<&[core::fmt::rt::v1::Argument]>", [0 x i8], { %"core::fmt::ArgumentV1"*, i64 }, [0 x i8] }
%"core::option::Option<&[core::fmt::rt::v1::Argument]>" = type { { %"core::fmt::rt::v1::Argument"*, i64 }, [0 x i8] }
%"core::fmt::rt::v1::Argument" = type { %"core::fmt::rt::v1::Position", [0 x i8], %"core::fmt::rt::v1::FormatSpec", [0 x i8] }
%"core::fmt::rt::v1::Position" = type { i64, [0 x i64], [1 x i64] }
%"core::fmt::rt::v1::FormatSpec" = type { %"core::fmt::rt::v1::Count", [0 x i8], %"core::fmt::rt::v1::Count", [0 x i8], i32, [0 x i8], i32, [0 x i8], i8, [7 x i8] }
%"core::fmt::rt::v1::Count" = type { i64, [0 x i64], [1 x i64] }
%Foo = type { i8, [7 x i8], [1 x i64] }

@_ZN9rust_enum4main15__STATIC_FMTSTR17h593e97caa92fe17aE = internal constant { %str_slice*, i64 } { %str_slice* getelementptr inbounds ([2 x %str_slice], [2 x %str_slice]* @ref.2, i32 0, i32 0), i64 2 }, align 8
@_ZN9rust_enum4main15__STATIC_FMTSTR17h55b6efdcfd70c0fbE = internal constant { %str_slice*, i64 } { %str_slice* getelementptr inbounds ([2 x %str_slice], [2 x %str_slice]* @ref.2, i32 0, i32 0), i64 2 }, align 8
@_ZN9rust_enum4main15__STATIC_FMTSTR17hbde30b16cc9bb817E = internal constant { %str_slice*, i64 } { %str_slice* getelementptr inbounds ([2 x %str_slice], [2 x %str_slice]* @ref.2, i32 0, i32 0), i64 2 }, align 8
@str.0 = internal constant [11 x i8] c"A boolean! "
@str.1 = internal constant [1 x i8] c"\0A"
@ref.2 = internal unnamed_addr constant [2 x %str_slice] [%str_slice { i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.0, i32 0, i32 0), i64 11 }, %str_slice { i8* getelementptr inbounds ([1 x i8], [1 x i8]* @str.1, i32 0, i32 0), i64 1 }], align 8

; core::fmt::ArgumentV1::new
; Function Attrs: uwtable
define internal void @_ZN4core3fmt10ArgumentV13new17h177fce648e2d33b4E(%"core::fmt::ArgumentV1"* noalias nocapture sret dereferenceable(16), i8* noalias readonly dereferenceable(1), i8 (i8*, %"core::fmt::Formatter"*)*) unnamed_addr #0 {
start:
  %transmute_temp1 = alloca %"core::fmt::Void"*
  %transmute_temp = alloca i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)*
  %3 = bitcast i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)** %transmute_temp to i8 (i8*, %"core::fmt::Formatter"*)**
  store i8 (i8*, %"core::fmt::Formatter"*)* %2, i8 (i8*, %"core::fmt::Formatter"*)** %3, align 8
  %4 = load i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)*, i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)** %transmute_temp, !nonnull !1
  br label %bb1

bb1:                                              ; preds = %start
  %5 = bitcast %"core::fmt::Void"** %transmute_temp1 to i8**
  store i8* %1, i8** %5, align 8
  %6 = load %"core::fmt::Void"*, %"core::fmt::Void"** %transmute_temp1, !nonnull !1
  br label %bb2

bb2:                                              ; preds = %bb1
  %7 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %0, i32 0, i32 0
  store %"core::fmt::Void"* %6, %"core::fmt::Void"** %7
  %8 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %0, i32 0, i32 2
  store i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)* %4, i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)** %8
  ret void
}

; core::fmt::Arguments::new_v1
; Function Attrs: inlinehint uwtable
define internal void @_ZN4core3fmt9Arguments6new_v117hb35981d82b379493E(%"core::fmt::Arguments"* noalias nocapture sret dereferenceable(48), %str_slice* noalias nonnull readonly, i64, %"core::fmt::ArgumentV1"* noalias nonnull readonly, i64) unnamed_addr #1 {
start:
  %_6 = alloca %"core::option::Option<&[core::fmt::rt::v1::Argument]>"
  %5 = getelementptr inbounds %"core::option::Option<&[core::fmt::rt::v1::Argument]>", %"core::option::Option<&[core::fmt::rt::v1::Argument]>"* %_6, i32 0, i32 0, i32 0
  store %"core::fmt::rt::v1::Argument"* null, %"core::fmt::rt::v1::Argument"** %5
  %6 = getelementptr inbounds %"core::fmt::Arguments", %"core::fmt::Arguments"* %0, i32 0, i32 0
  %7 = getelementptr inbounds { %str_slice*, i64 }, { %str_slice*, i64 }* %6, i32 0, i32 0
  store %str_slice* %1, %str_slice** %7
  %8 = getelementptr inbounds { %str_slice*, i64 }, { %str_slice*, i64 }* %6, i32 0, i32 1
  store i64 %2, i64* %8
  %9 = getelementptr inbounds %"core::fmt::Arguments", %"core::fmt::Arguments"* %0, i32 0, i32 2
  %10 = bitcast %"core::option::Option<&[core::fmt::rt::v1::Argument]>"* %_6 to i8*
  %11 = bitcast %"core::option::Option<&[core::fmt::rt::v1::Argument]>"* %9 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %11, i8* %10, i64 16, i32 8, i1 false)
  %12 = getelementptr inbounds %"core::fmt::Arguments", %"core::fmt::Arguments"* %0, i32 0, i32 4
  %13 = getelementptr inbounds { %"core::fmt::ArgumentV1"*, i64 }, { %"core::fmt::ArgumentV1"*, i64 }* %12, i32 0, i32 0
  store %"core::fmt::ArgumentV1"* %3, %"core::fmt::ArgumentV1"** %13
  %14 = getelementptr inbounds { %"core::fmt::ArgumentV1"*, i64 }, { %"core::fmt::ArgumentV1"*, i64 }* %12, i32 0, i32 1
  store i64 %4, i64* %14
  ret void
}

; rust_enum::main
; Function Attrs: uwtable
define internal void @_ZN9rust_enum4main17hbfbce8e9dfa39c4cE() unnamed_addr #0 {
start:
  %tmp_ret5 = alloca %"core::fmt::ArgumentV1"
  %tmp_ret4 = alloca %"core::fmt::ArgumentV1"
  %tmp_ret = alloca %"core::fmt::ArgumentV1"
  %_42 = alloca { i8*, [0 x i8] }
  %_41 = alloca [1 x %"core::fmt::ArgumentV1"]
  %_36 = alloca %"core::fmt::Arguments"
  %x3 = alloca i8
  %_28 = alloca { i8*, [0 x i8] }
  %_27 = alloca [1 x %"core::fmt::ArgumentV1"]
  %_22 = alloca %"core::fmt::Arguments"
  %x2 = alloca i8
  %_19 = alloca {}
  %_13 = alloca { i8*, [0 x i8] }
  %_12 = alloca [1 x %"core::fmt::ArgumentV1"]
  %_7 = alloca %"core::fmt::Arguments"
  %x1 = alloca i8
  %_4 = alloca {}
  %z = alloca %Foo
  %y = alloca %Foo
  %x = alloca %Foo
  %_0 = alloca {}
  %0 = getelementptr inbounds %Foo, %Foo* %x, i32 0, i32 0
  store i8 1, i8* %0
  %1 = bitcast %Foo* %x to { i8, [3 x i8], i32, [0 x i8] }*
  %2 = getelementptr inbounds { i8, [3 x i8], i32, [0 x i8] }, { i8, [3 x i8], i32, [0 x i8] }* %1, i32 0, i32 2
  store i32 42, i32* %2
  %3 = getelementptr inbounds %Foo, %Foo* %y, i32 0, i32 0
  store i8 2, i8* %3
  %4 = bitcast %Foo* %y to { i8, [7 x i8], double, [0 x i8] }*
  %5 = getelementptr inbounds { i8, [7 x i8], double, [0 x i8] }, { i8, [7 x i8], double, [0 x i8] }* %4, i32 0, i32 2
  store double 1.337000e+03, double* %5
  %6 = getelementptr inbounds %Foo, %Foo* %z, i32 0, i32 0
  store i8 0, i8* %6
  %7 = bitcast %Foo* %z to { i8, [0 x i8], i8, [0 x i8] }*
  %8 = getelementptr inbounds { i8, [0 x i8], i8, [0 x i8] }, { i8, [0 x i8], i8, [0 x i8] }* %7, i32 0, i32 2
  store i8 1, i8* %8
  %9 = getelementptr inbounds %Foo, %Foo* %x, i32 0, i32 0
  %10 = load i8, i8* %9, !range !2
  %11 = zext i8 %10 to i64
  switch i64 %11, label %bb1 [
    i64 0, label %bb2
  ]

bb1:                                              ; preds = %start
  br label %bb3

bb2:                                              ; preds = %start
  %12 = bitcast %Foo* %x to { i8, [0 x i8], i8, [0 x i8] }*
  %13 = getelementptr inbounds { i8, [0 x i8], i8, [0 x i8] }, { i8, [0 x i8], i8, [0 x i8] }* %12, i32 0, i32 2
  %14 = load i8, i8* %13, !range !3
  %15 = trunc i8 %14 to i1
  %16 = zext i1 %15 to i8
  store i8 %16, i8* %x1
  %17 = load %str_slice*, %str_slice** getelementptr inbounds ({ %str_slice*, i64 }, { %str_slice*, i64 }* @_ZN9rust_enum4main15__STATIC_FMTSTR17h593e97caa92fe17aE, i32 0, i32 0), !nonnull !1
  %18 = load i64, i64* getelementptr inbounds ({ %str_slice*, i64 }, { %str_slice*, i64 }* @_ZN9rust_enum4main15__STATIC_FMTSTR17h593e97caa92fe17aE, i32 0, i32 1)
  %19 = getelementptr inbounds { i8*, [0 x i8] }, { i8*, [0 x i8] }* %_13, i32 0, i32 0
  store i8* %x1, i8** %19
  %20 = getelementptr inbounds { i8*, [0 x i8] }, { i8*, [0 x i8] }* %_13, i32 0, i32 0
  %21 = load i8*, i8** %20, !nonnull !1
; call core::fmt::ArgumentV1::new
  call void @_ZN4core3fmt10ArgumentV13new17h177fce648e2d33b4E(%"core::fmt::ArgumentV1"* noalias nocapture sret dereferenceable(16) %tmp_ret, i8* noalias readonly dereferenceable(1) %21, i8 (i8*, %"core::fmt::Formatter"*)* @"_ZN43_$LT$bool$u20$as$u20$core..fmt..Display$GT$3fmt17h404028510cff9d6fE")
  %22 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %tmp_ret, i32 0, i32 0
  %23 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %tmp_ret, i32 0, i32 2
  %24 = load %"core::fmt::Void"*, %"core::fmt::Void"** %22, !nonnull !1
  %25 = load i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)*, i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)** %23, !nonnull !1
  br label %bb4

bb3:                                              ; preds = %bb6, %bb1
  %26 = getelementptr inbounds %Foo, %Foo* %y, i32 0, i32 0
  %27 = load i8, i8* %26, !range !2
  %28 = zext i8 %27 to i64
  switch i64 %28, label %bb7 [
    i64 0, label %bb8
  ]

bb4:                                              ; preds = %bb2
  %29 = getelementptr inbounds [1 x %"core::fmt::ArgumentV1"], [1 x %"core::fmt::ArgumentV1"]* %_12, i32 0, i32 0
  %30 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %29, i32 0, i32 0
  store %"core::fmt::Void"* %24, %"core::fmt::Void"** %30
  %31 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %29, i32 0, i32 2
  store i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)* %25, i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)** %31
  %32 = bitcast [1 x %"core::fmt::ArgumentV1"]* %_12 to %"core::fmt::ArgumentV1"*
; call core::fmt::Arguments::new_v1
  call void @_ZN4core3fmt9Arguments6new_v117hb35981d82b379493E(%"core::fmt::Arguments"* noalias nocapture sret dereferenceable(48) %_7, %str_slice* noalias nonnull readonly %17, i64 %18, %"core::fmt::ArgumentV1"* noalias nonnull readonly %32, i64 1)
  br label %bb5

bb5:                                              ; preds = %bb4
; call std::io::stdio::_print
  call void @_ZN3std2io5stdio6_print17h7ce09810ca5a75e5E(%"core::fmt::Arguments"* noalias nocapture dereferenceable(48) %_7)
  br label %bb6

bb6:                                              ; preds = %bb5
  br label %bb3

bb7:                                              ; preds = %bb3
  br label %bb9

bb8:                                              ; preds = %bb3
  %33 = bitcast %Foo* %y to { i8, [0 x i8], i8, [0 x i8] }*
  %34 = getelementptr inbounds { i8, [0 x i8], i8, [0 x i8] }, { i8, [0 x i8], i8, [0 x i8] }* %33, i32 0, i32 2
  %35 = load i8, i8* %34, !range !3
  %36 = trunc i8 %35 to i1
  %37 = zext i1 %36 to i8
  store i8 %37, i8* %x2
  %38 = load %str_slice*, %str_slice** getelementptr inbounds ({ %str_slice*, i64 }, { %str_slice*, i64 }* @_ZN9rust_enum4main15__STATIC_FMTSTR17h55b6efdcfd70c0fbE, i32 0, i32 0), !nonnull !1
  %39 = load i64, i64* getelementptr inbounds ({ %str_slice*, i64 }, { %str_slice*, i64 }* @_ZN9rust_enum4main15__STATIC_FMTSTR17h55b6efdcfd70c0fbE, i32 0, i32 1)
  %40 = getelementptr inbounds { i8*, [0 x i8] }, { i8*, [0 x i8] }* %_28, i32 0, i32 0
  store i8* %x2, i8** %40
  %41 = getelementptr inbounds { i8*, [0 x i8] }, { i8*, [0 x i8] }* %_28, i32 0, i32 0
  %42 = load i8*, i8** %41, !nonnull !1
; call core::fmt::ArgumentV1::new
  call void @_ZN4core3fmt10ArgumentV13new17h177fce648e2d33b4E(%"core::fmt::ArgumentV1"* noalias nocapture sret dereferenceable(16) %tmp_ret4, i8* noalias readonly dereferenceable(1) %42, i8 (i8*, %"core::fmt::Formatter"*)* @"_ZN43_$LT$bool$u20$as$u20$core..fmt..Display$GT$3fmt17h404028510cff9d6fE")
  %43 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %tmp_ret4, i32 0, i32 0
  %44 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %tmp_ret4, i32 0, i32 2
  %45 = load %"core::fmt::Void"*, %"core::fmt::Void"** %43, !nonnull !1
  %46 = load i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)*, i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)** %44, !nonnull !1
  br label %bb10

bb9:                                              ; preds = %bb12, %bb7
  %47 = getelementptr inbounds %Foo, %Foo* %z, i32 0, i32 0
  %48 = load i8, i8* %47, !range !2
  %49 = zext i8 %48 to i64
  switch i64 %49, label %bb13 [
    i64 0, label %bb14
  ]

bb10:                                             ; preds = %bb8
  %50 = getelementptr inbounds [1 x %"core::fmt::ArgumentV1"], [1 x %"core::fmt::ArgumentV1"]* %_27, i32 0, i32 0
  %51 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %50, i32 0, i32 0
  store %"core::fmt::Void"* %45, %"core::fmt::Void"** %51
  %52 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %50, i32 0, i32 2
  store i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)* %46, i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)** %52
  %53 = bitcast [1 x %"core::fmt::ArgumentV1"]* %_27 to %"core::fmt::ArgumentV1"*
; call core::fmt::Arguments::new_v1
  call void @_ZN4core3fmt9Arguments6new_v117hb35981d82b379493E(%"core::fmt::Arguments"* noalias nocapture sret dereferenceable(48) %_22, %str_slice* noalias nonnull readonly %38, i64 %39, %"core::fmt::ArgumentV1"* noalias nonnull readonly %53, i64 1)
  br label %bb11

bb11:                                             ; preds = %bb10
; call std::io::stdio::_print
  call void @_ZN3std2io5stdio6_print17h7ce09810ca5a75e5E(%"core::fmt::Arguments"* noalias nocapture dereferenceable(48) %_22)
  br label %bb12

bb12:                                             ; preds = %bb11
  br label %bb9

bb13:                                             ; preds = %bb9
  br label %bb15

bb14:                                             ; preds = %bb9
  %54 = bitcast %Foo* %z to { i8, [0 x i8], i8, [0 x i8] }*
  %55 = getelementptr inbounds { i8, [0 x i8], i8, [0 x i8] }, { i8, [0 x i8], i8, [0 x i8] }* %54, i32 0, i32 2
  %56 = load i8, i8* %55, !range !3
  %57 = trunc i8 %56 to i1
  %58 = zext i1 %57 to i8
  store i8 %58, i8* %x3
  %59 = load %str_slice*, %str_slice** getelementptr inbounds ({ %str_slice*, i64 }, { %str_slice*, i64 }* @_ZN9rust_enum4main15__STATIC_FMTSTR17hbde30b16cc9bb817E, i32 0, i32 0), !nonnull !1
  %60 = load i64, i64* getelementptr inbounds ({ %str_slice*, i64 }, { %str_slice*, i64 }* @_ZN9rust_enum4main15__STATIC_FMTSTR17hbde30b16cc9bb817E, i32 0, i32 1)
  %61 = getelementptr inbounds { i8*, [0 x i8] }, { i8*, [0 x i8] }* %_42, i32 0, i32 0
  store i8* %x3, i8** %61
  %62 = getelementptr inbounds { i8*, [0 x i8] }, { i8*, [0 x i8] }* %_42, i32 0, i32 0
  %63 = load i8*, i8** %62, !nonnull !1
; call core::fmt::ArgumentV1::new
  call void @_ZN4core3fmt10ArgumentV13new17h177fce648e2d33b4E(%"core::fmt::ArgumentV1"* noalias nocapture sret dereferenceable(16) %tmp_ret5, i8* noalias readonly dereferenceable(1) %63, i8 (i8*, %"core::fmt::Formatter"*)* @"_ZN43_$LT$bool$u20$as$u20$core..fmt..Display$GT$3fmt17h404028510cff9d6fE")
  %64 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %tmp_ret5, i32 0, i32 0
  %65 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %tmp_ret5, i32 0, i32 2
  %66 = load %"core::fmt::Void"*, %"core::fmt::Void"** %64, !nonnull !1
  %67 = load i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)*, i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)** %65, !nonnull !1
  br label %bb16

bb15:                                             ; preds = %bb18, %bb13
  ret void

bb16:                                             ; preds = %bb14
  %68 = getelementptr inbounds [1 x %"core::fmt::ArgumentV1"], [1 x %"core::fmt::ArgumentV1"]* %_41, i32 0, i32 0
  %69 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %68, i32 0, i32 0
  store %"core::fmt::Void"* %66, %"core::fmt::Void"** %69
  %70 = getelementptr inbounds %"core::fmt::ArgumentV1", %"core::fmt::ArgumentV1"* %68, i32 0, i32 2
  store i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)* %67, i8 (%"core::fmt::Void"*, %"core::fmt::Formatter"*)** %70
  %71 = bitcast [1 x %"core::fmt::ArgumentV1"]* %_41 to %"core::fmt::ArgumentV1"*
; call core::fmt::Arguments::new_v1
  call void @_ZN4core3fmt9Arguments6new_v117hb35981d82b379493E(%"core::fmt::Arguments"* noalias nocapture sret dereferenceable(48) %_36, %str_slice* noalias nonnull readonly %59, i64 %60, %"core::fmt::ArgumentV1"* noalias nonnull readonly %71, i64 1)
  br label %bb17

bb17:                                             ; preds = %bb16
; call std::io::stdio::_print
  call void @_ZN3std2io5stdio6_print17h7ce09810ca5a75e5E(%"core::fmt::Arguments"* noalias nocapture dereferenceable(48) %_36)
  br label %bb18

bb18:                                             ; preds = %bb17
  br label %bb15
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #2

; <bool as core::fmt::Display>::fmt
declare i8 @"_ZN43_$LT$bool$u20$as$u20$core..fmt..Display$GT$3fmt17h404028510cff9d6fE"(i8* noalias readonly dereferenceable(1), %"core::fmt::Formatter"* dereferenceable(96)) unnamed_addr #3

; std::io::stdio::_print
declare void @_ZN3std2io5stdio6_print17h7ce09810ca5a75e5E(%"core::fmt::Arguments"* noalias nocapture dereferenceable(48)) unnamed_addr #3

define i64 @main(i64, i8**) unnamed_addr {
top:
; call std::rt::lang_start
  %2 = call i64 @_ZN3std2rt10lang_start17h97aba2334c85f570E(void ()* @_ZN9rust_enum4main17hbfbce8e9dfa39c4cE, i64 %0, i8** %1)
  ret i64 %2
}

; std::rt::lang_start
declare i64 @_ZN3std2rt10lang_start17h97aba2334c85f570E(void ()*, i64, i8**) unnamed_addr #3

attributes #0 = { uwtable "probe-stack"="__rust_probestack" }
attributes #1 = { inlinehint uwtable "probe-stack"="__rust_probestack" }
attributes #2 = { argmemonly nounwind }
attributes #3 = { "probe-stack"="__rust_probestack" }

!llvm.module.flags = !{!0}

!0 = !{i32 1, !"PIE Level", i32 2}
!1 = !{}
!2 = !{i8 0, i8 3}
!3 = !{i8 0, i8 2}
