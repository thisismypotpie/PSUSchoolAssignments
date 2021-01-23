#include <iostream>
using namespace std;

int f(int a,int b) {
  return a*b/b;
}

int main(int argc, char **argv) {
  int a = stoi(argv[1]);
  int b = stoi(argv[2]);
  int c = f(a,b);
  cout << "a = " << a << " b = " << b << " c = " << c << endl;
 }
 
