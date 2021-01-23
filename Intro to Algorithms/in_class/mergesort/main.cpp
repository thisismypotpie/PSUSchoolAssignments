#include<iostream>
#include<cstdlib>
#include<time.h>
#include"mergesort.h"

using namespace std;
int main()
{
srand(time(NULL));
int length = rand()%20+5;
int array[length];
for(int i=0; i < length; i++)
{
  array[i] = rand()%100+1;
}

mergesort sorter;
sorter.display(array, length);
sorter.sort(array,0,length-1);
sorter.display(array, length);
return 0;
}

