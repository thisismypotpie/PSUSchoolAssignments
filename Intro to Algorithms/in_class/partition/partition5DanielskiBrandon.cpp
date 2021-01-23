#include<iostream>
#include<cstdlib>
#include<time.h>

using namespace std;


void display(int array[], int hi, int lo)
{
	cout <<array[lo];
	if(lo == hi)
	{
		cout<< " is the only element in this array level, returning."<<endl;
		return;
	}
	for(int i=lo+1; i <= hi;i++)
	{
		cout<<","<<array[i];
	}
	cout<<endl;
}

void partition_sort(int index_one, int index_two,int* array)
{
	cout <<"Array at this level: "<<endl;
	display(array,index_two,index_one);
	cout <<"Index One: "<<index_one<<"\nIndex Two: "<<index_two<<endl;
	//cout<<"Press any key to continute..."<<endl;
	//cin.get();
	//return if there is one left.
	if(index_one == index_two)
	{
		cout <<array[index_one]<<" is all alone, returning."<<endl;
		//cout<<"Press any key to continute..."<<endl;
		//cin.get();
		return;
	}
	//return if there are two left.
	else if(index_one +1 == index_two)
	{
		if(array[index_one] > array[index_two])
		{
			cout<<"Swapping: "<<array[index_one]<<" and "<<array[index_two]<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			int holder = 0;
			holder = array[index_one];
			array[index_one] = array[index_two];
			array[index_two] = holder;
			cout <<"Returning array as:"<<endl;
			display(array,index_two,index_one);
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			return;
		}
		else
		{
			cout <<"Returning array as:"<<endl;
			display(array, index_two,index_one);
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			return;
		}
	}
	else
	{
		int at_left = index_one;
		int at_right = index_two;
		int holder_swap=0;
		while(index_one < index_two)
		{
			//These lines are here to prevent self_comparison
			if(at_left < at_right)
			{
				at_left++;
			}
			//Look for first array element where at left is greater than index one.
			cout <<"Beginning comparisions from the left at index: "<<at_left<<" with a value of: "<<array[at_left]<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			while(array[index_one] > array[at_left] && at_left < index_two)
			{
				cout <<"Comparing: "<<array[index_one]<<" and "<<array[at_left];
				//cout<<"Press any key to continute..."<<endl;
				//cin.get();
				at_left ++;
			}
			cout << "Stopping at left moving index: "<<at_left<<" with a value of: "<<array[at_left]<<" which is more than or equal to: "<<array[index_one]<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();

			cout <<"Beginning comparisions from the right at index: "<<at_right<<" with a value of: "<<array[at_right]<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			while(array[index_one] < array[at_right] && at_right > index_one)
			{
				cout <<"Comparing: "<<array[index_one]<<" and "<<array[at_right];
				//cout<<"Press any key to continute..."<<endl;
				//cin.get();
				at_right--;
			}
			cout << "Stopping at right  moving index: "<<at_right<<" with a value of: "<<array[at_right]<<" which is less than: "<<array[index_one]<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();

			//swap those at the right and the left
			if(at_left >= at_right)
			{
				//index one was the highest number.
				if(at_left == index_two && array[index_one] > array[index_two])
				{
					cout <<array[index_one]<<" was the highest number"<<endl;
					cout <<"Swapping: "<<array[index_one]<<" and "<<array[index_two]<<endl;
					holder_swap = array[index_two];
					array[index_two] = array[index_one];
					array[index_one] = holder_swap;
					partition_sort(index_one,index_two -1,array);
					return;
				}
				//Index one was the lowest number.
				else if(at_right == index_one)
				{
					cout <<array[index_one]<<" was the lowest number"<<endl;
					partition_sort(index_one+1,index_two,array);
					return;
				}
				else
				{
					cout <<"Final swap this level: "<<array[index_one]<<" and "<<array[at_right]<<endl;
					//cin.get();
					holder_swap = array[index_one];
					array[index_one]=array[at_right];
					array[at_right] = holder_swap;
					cout<<"Array level complete\nArray so far: "<<endl;
					display(array,index_two,index_one);
					//cout<<"Press any key to continute..."<<endl;
					//cin.get();
					partition_sort(index_one,at_right-1,array);
					partition_sort(at_left,index_two,array);
					return;

				}

			}
			else
			{
				cout <<"Swapping: "<<array[at_left]<<" and "<<array[at_right]<<endl;
				holder_swap = array[at_left];
				array[at_left] = array[at_right];
				array[at_right] = holder_swap;
				at_right --;//Already compared numbers being compared.
				cout<<"Array progress:"<<endl;
				display(array,index_two,index_one);
				//cout<<"Press any key to continute..."<<endl;
				//cin.get();
			}

		}
	}

}

int main()
{
	srand(time(NULL));
	int length = rand()%61+39;
	int array[length];
	for(int i=0; i < length; i++)
	{
		array[i] = rand()%999+1;
	}
	cout<<"Array before sort"<<endl;
	display(array,length-1,0);
	cout<<"Press any key to continue..."<<endl;
	cin.get();
	partition_sort(0,length-1,array);
	cout<<"Array after sort"<<endl;
	display(array,length-1,0);

	return 0;
}

