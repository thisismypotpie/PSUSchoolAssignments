#include <iostream>

int main () {
  int x = 0;
  std::cout << (x=1) + (x=2) << "\n";
  std::cout << x << "\n";
}

