#include <iostream>
#include <cmath>
using namespace std;

struct Item {
  bool b;
  float d;
};

struct Link {
  Item itm;
  Link *next;
  Link(Item argitm,Link *argnext) : itm(argitm), next(argnext) {}
};

float f(Link *list) {
  float sum = 0;
  while (list != NULL) {
    sum += list->itm.b ? list->itm.d : 0.0;//f b is true, then add it, otherwise add zero.
    list = list->next;
  }
  return sum;
}

int main(int argc, char **argv) {
  int n = stoi(argv[1]); //converts input string to integer.
  Link *list = NULL;//sets a link to null.
  Item itm;//Struct that is just a bool and float.

  //from 1 to n do the following.
  for (int i = 1; i <= n; i++)  {
    itm.b = i%2; //get modulo of i, either 0 or 1.
    itm.d = sqrt(i);//get sqrt of i.
    list = new Link(itm,list);//add new link to list.
  }
  float s = f(list);//take all added links and store them in a float.
  cout << "sum = " << s << endl;//display sum.
}

