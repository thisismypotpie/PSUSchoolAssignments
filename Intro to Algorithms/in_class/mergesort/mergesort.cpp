#include<iostream>
#include"mergesort.h"
using namespace std;

mergesort::mergesort()
{
}

int mergesort::sort( int* array, int lo, int hi)
{
  if(lo == hi)
  {
    return array[lo];
  }
  int* operand_one = sort(array,lo,hi/2)//first half
  int* operand_two = sort(array,(hi/2)+1,hi)//second half

}

void mergesort::display(int * array, int length)
{
  cout << "Array: "<<array[0];
  for(int i=1; i < length;i++)
  {
    cout<<", "<<array[i];
  }
  cout<<endl;
}
