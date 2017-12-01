#include <iostream>
#include <variant>

using namespace std::literals;

int main()
{
  std::variant<bool, int, double> x, y, z;
  x = 42;
  y = 1337.0;
  z = true;

  if (std::holds_alternative<bool>(x)) {
    std::cout << "A boolean! " << std::get<bool>(x) << std::endl;
  }
  if (std::holds_alternative<bool>(y)) {
    std::cout << "A boolean! " << std::get<bool>(y) << std::endl;
  }
  if (std::holds_alternative<bool>(z)) {
    std::cout << "A boolean! " << std::get<bool>(z) << std::endl;
  }
}
