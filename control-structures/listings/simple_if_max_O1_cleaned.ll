define zeroext i1 @max(i32 %a, i32 %b) {
  %1 = icmp sgt i32 %a, %b
  %2 = select i1 %1, i32 %a, i32 %b
  %3 = icmp ne i32 %2, 0
  ret i1 %3
}
