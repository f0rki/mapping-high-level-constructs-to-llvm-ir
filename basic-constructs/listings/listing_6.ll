%Struct = type { i8, i32, i8* }
@Struct_size = constant i32 ptrtoint (%Struct* getelementptr (%Struct* null, i32 1)) to i32
