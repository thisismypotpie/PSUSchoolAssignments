#include <iostream>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <unistd.h>
#include <vector>

using namespace std;

#define INF  1000000
   // infinity
// The adjacency matrix for the graph :
int N ; // number of nodes (vertices)
int A[100][100] ; // adjacency matrix of the graph
struct node
{
	int start;
	int destination;
	int weight;
};
vector<node> edges;
vector<node> selected_edges;
bool path_found = false;

int input_graph()
{
  int r,c ;
  char w[10] ;

  scanf("%d",&N) ;

  // scan the first row of labels....not used
  for (c = 0 ; c < N ; c++) {
    scanf("%s",w) ;
  }


  for (r = 0 ; r < N ; r++) {
    scanf("%s",w) ; // label ... not used
    for (c = 0 ; c < N ; c++) {
      scanf("%s",w) ;
      if (w[0] == '-') {
	A[r][c] = -1 ;
      } else {
	A[r][c] = atoi(w) ;// ascii to integer
	node to_push;
	to_push.start = r;
	to_push.destination = c;
	to_push.weight = atoi(w);
	edges.push_back(to_push);
      }

    }
  }

}




int print_graph()
{
  int r,c ;

  printf("\n%d\n\n",N) ;

  printf("  ") ;
  for (c = 0 ; c < N ; c++) {
    printf("   %c",c+'A') ;
  }

  printf("\n") ;

  for (r = 0 ; r < N ; r++) {
    printf("%c  ",r+'A') ;
    for (c = 0 ; c < N ; c++) {
      if (A[r][c] == -1) {
	printf("  - ") ;
      } else {
	printf("%3d ",A[r][c]) ;
      }
    }
    printf("\n") ;
  }
  printf("\n") ;
}

void display_edge(node to_show)
{
  cout<<(char)(65+to_show.start)<<" to " <<(char)(65+to_show.destination) << " weight: "<<to_show.weight<<endl;
}

void partition_sort(int index_one, int index_two)
{
	cout <<"Array at this level: "<<endl;
	//display(array,index_two,index_one);
	cout <<"Index One: "<<index_one<<"\nIndex Two: "<<index_two<<endl;
	//cout<<"Press any key to continute..."<<endl;
	//cin.get();
	//return if there is one left.
	if(index_one == index_two)
	{
		cout <<edges[index_one].weight<<" is all alone, returning."<<endl;
		//cout<<"Press any key to continute..."<<endl;
		//cin.get();
		return;
	}
	//return if there are two left.
	else if(index_one +1 == index_two)
	{
		if(edges[index_one].weight > edges[index_two].weight)
		{
			cout<<"Swapping: "<<edges[index_one].weight<<" and "<<edges[index_two].weight<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			node holder;
			holder = edges[index_one];
			edges[index_one] = edges[index_two];
			edges[index_two] = holder;
			cout <<"Returning array as:"<<endl;
			//display(array,index_two,index_one);
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			return;
		}
		else
		{
			cout <<"Returning array as:"<<endl;
			//display(array, index_two,index_one);
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			return;
		}
	}
	else
	{
		int at_left = index_one;
		int at_right = index_two;
		node holder_swap;
		while(index_one < index_two)
		{
			//These lines are here to prevent self_comparison
			if(at_left < at_right)
			{
				at_left++;
			}
			//Look for first array element where at left is greater than index one.
			cout <<"Beginning comparisions from the left at index: "<<at_left<<" with a value of: "<<edges[at_left].weight<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			while(edges[index_one].weight > edges[at_left].weight && at_left < index_two)
			{
				cout <<"Comparing: "<<edges[index_one].weight<<" and "<<edges[at_left].weight;
				//cout<<"Press any key to continute..."<<endl;
				//cin.get();
				at_left ++;
			}
			cout << "Stopping at left moving index: "<<at_left<<" with a value of: "<<edges[at_left].weight<<" which is more than or equal to: "<<edges[index_one].weight<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();

			cout <<"Beginning comparisions from the right at index: "<<at_right<<" with a value of: "<<edges[at_right].weight<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();
			while(edges[index_one].weight < edges[at_right].weight && at_right > index_one)
			{
				cout <<"Comparing: "<<edges[index_one].weight<<" and "<<edges[at_right].weight;
				//cout<<"Press any key to continute..."<<endl;
				//cin.get();
				at_right--;
			}
			cout << "Stopping at right  moving index: "<<at_right<<" with a value of: "<<edges[at_right].weight<<" which is less than: "<<edges[index_one].weight<<endl;
			//cout<<"Press any key to continute..."<<endl;
			//cin.get();

			//swap those at the right and the left
			if(at_left >= at_right)
			{
				//index one was the highest number.
				if(at_left == index_two && edges[index_one].weight > edges[index_two].weight)
				{
					cout <<edges[index_one].weight<<" was the highest number"<<endl;
					cout <<"Swapping: "<<edges[index_one].weight<<" and "<<edges[index_two].weight<<endl;
					holder_swap = edges[index_two];
					edges[index_two] = edges[index_one];
					edges[index_one] = holder_swap;
					partition_sort(index_one,index_two -1);
					return;
				}
				//Index one was the lowest number.
				else if(at_right == index_one)
				{
					cout <<edges[index_one].weight<<" was the lowest number"<<endl;
					partition_sort(index_one+1,index_two);
					return;
				}
				else
				{
					cout <<"Final swap this level: "<<edges[index_one].weight<<" and "<<edges[at_right].weight<<endl;
					//cin.get();
					holder_swap = edges[index_one];
					edges[index_one]=edges[at_right];
					edges[at_right] = holder_swap;
					cout<<"Array level complete\nArray so far: "<<endl;
					//display(array,index_two,index_one);
					//cout<<"Press any key to continute..."<<endl;
					//cin.get();
					partition_sort(index_one,at_right-1);
					partition_sort(at_left,index_two);
					return;

				}

			}
			else
			{
				cout <<"Swapping: "<<edges[at_left].weight<<" and "<<edges[at_right].weight<<endl;
				holder_swap = edges[at_left];
				edges[at_left] = edges[at_right];
				edges[at_right] = holder_swap;
				at_right --;//Already compared numbers being compared.
				cout<<"Array progress:"<<endl;
				//display(array,index_two,index_one);
				//cout<<"Press any key to continute..."<<endl;
				//cin.get();
			}

		}
	}

}


void edge_validation(int org_dest,int key, int index)
{
  cout <<"Starting iteration at vertex: "<<(char)(65+org_dest)<<endl;
  for(int i=index; i < selected_edges.size();i++)
  {
    if(org_dest== selected_edges[i].start)
    {
        cout<<"Jumping from vertex " <<(char)(65+org_dest) <<" to vertex "<<(char)(65+selected_edges[i].destination)<<endl;;
	edge_validation(selected_edges[i].destination,key,index);
    }
    if(org_dest== selected_edges[i].destination)
    {
        cout<<"Jumping from vertex " <<(char)(65+org_dest) <<" to vertex "<<(char)(65+selected_edges[i].start)<<endl;;
	edge_validation(selected_edges[i].start,key,index+1);
    }
    if(org_dest == key)
    {
      cout<<"Path found, do not add to list."<<endl;
      path_found = true;
      return;
    }
  }
  cout<<"Jumping out of iteration."<<endl;
}

void check_dups(node to_check)
{
  for(int i=0; i < edges.size();i++)
  {
    if(to_check.start == edges[i].destination && to_check.destination == edges[i].start)
    {
      edges.erase(edges.begin()+i);
    }
  }
}

int main()
{
  input_graph() ;// N, A{}{}
  print_graph() ;
  partition_sort(0,edges.size());
  for(int i=0; i < edges.size();i++)
  {
    if(edges[i].weight < 1)
    {
	edges.erase(edges.begin()+i);
    }
    check_dups(edges[i]);
    cout<<"Starting at point"<<(char)(65+edges[i].start)<<endl;
    edge_validation(edges[i].destination,edges[i].start,0);
    if(path_found  == false)
    {
      cout <<" Edge from "<<(char)(65+edges[i].start) <<" to "<<(char)(65+edges[i].destination)<<" added to the list."<<endl;
      selected_edges.push_back(edges[i]);
    }
    else
    {
      display_edge(edges[i]);
      cout <<"WAS NOT ADDED TO THE LIST!"<<endl;
      path_found = false;
    }
  }
    cout <<"All edges:"<<endl;
    for(int i=0; i < edges.size();i++)
    {
      display_edge(edges[i]);
    }
    cout<<endl<<"Selected edges"<<endl;
    for(int i=0; i < selected_edges.size();i++)
    {
      display_edge(selected_edges[i]);
    }
	return 0;
}
