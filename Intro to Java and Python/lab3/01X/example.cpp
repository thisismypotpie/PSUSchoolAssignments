#include <iostream>
using namespace std;

int main(int argc, char **argv) {
  int a = stoi(argv[1]);
  int b = a + 2000000000;
  if (a <= b)
    cout << a << " <= " << b << endl;
  else
    cout << a << " > " << b << endl;
}

  
