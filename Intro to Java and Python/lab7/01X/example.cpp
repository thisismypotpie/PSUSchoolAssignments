
#include <iostream>
#include<cstdlib>
using namespace std;
//credit for help on this program given to: https://riptutorial.com/cplusplus/example/19369/evaluation-order-of-function-arguments
void eval(int x, int y)
{
  if(x == 2 && y == 1)
  {
    cout <<"Left-to-Right"<<endl;
  }
  else if(x == 1 && y == 2)
  {
    cout<<"Right-to-Left"<<endl;
  }
  else
  {
    cout <<"Error!"<<endl;
  }
}

int get_int(){
  static int x =0;
  return ++x;
}

int main()
{
  eval(get_int(),get_int());
}
