int foo(int a)
{
  auto function = [a](int x) { return x + a; };
  return function(10);
}
