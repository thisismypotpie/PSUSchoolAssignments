#include<iostream>
#include<cstdlib>
#include<time.h>
using namespace std;
int main()
{

srand(time(NULL));
int length = rand()%20+5;
cout << "length: "<<length<<endl;
//int array[8] = {8,7,6,5,4,3,2,1};
int array[length];
int holder = 0;
//int length = 8;

for(int i =0; i < length; i++)
{
  array[i] = rand()%100+1;
}

cout <<"array out of order: " <<array[0];
for(int i=1 ; i < length;i++)
{
cout <<"," <<array[i];
}
cout << endl;

for(int i=0; i < length;i++)
{
  for(int j=i+1; j < length;j++)
  {
    if(array[j] < array[i])
    {
      holder = array[i];
      array[i] = array[j];
      array[j] = holder;
    }
  }
}
cout <<"array in order: " <<array[0];
for(int i=1 ; i < length;i++)
{
cout <<"," <<array[i];
}
cout << endl;
return 0;
}
