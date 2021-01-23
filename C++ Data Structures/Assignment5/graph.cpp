/*
   Brandon Danielski
   12/6/2016
   CS 163
   Assignment 5
   This is the graph file for the program.  It maniulates an adjaceny list and a LLL to show connected verticies.
 */
#include"graph.h"
#include<cstring>
#include<iostream>
using namespace std;



/*
   This is the constructor the the graph.  It starts with an adjacency list of size 0 and the list grows as the user inputs more verticies.
INPUT: NONE
OUTPUT: NONE
 */
graph::graph()
{
	//	cout<<"making new adj list"<<endl;
	list_size = 0;
	adjacency_list = new vertex*[list_size];
	for(int i = 0; i< list_size; i++)
	{
		//		cout<<"i= "<<i<<endl;
		adjacency_list[i] = new vertex;
		adjacency_list[i]->head = NULL;
		adjacency_list[i]->goal = new char[2000];
	}
	//	cout<<"done"<<endl;
	//	cin.get();
}



/*
   This is the destructor for the graph. It deallocates all data in teh graph.
INPUT: NONE
OUTPUT: NONE
 */
graph::~graph()
{
	if(list_size > 0)
	{
//		cout<<"stating deletion."<<endl;
		node* temp = NULL;
		node* temp2 = NULL;
		for(int i=0;i < list_size; i++)
		{
//			cout<<"loop "<<i<<endl;
			if(adjacency_list[i]->goal)
			{
//				cout<<"Deleting goal"<<endl;
				delete[] adjacency_list[i]->goal;
			}
			temp = adjacency_list[i]->head;
			while(temp)
			{
//				cout<<"Deleting a node"<<endl;
				temp2 = temp->next;
				delete temp;
				temp = temp2;
			}
			if(adjacency_list[i])
			{
//				cout<<"deleting a vertex"<<endl;
				delete adjacency_list[i];
			}
		}

		if(adjacency_list)
		{
//			cout<<"deleting a list."<<endl;
			delete[] adjacency_list;
		}
	}
//	cout<<"Everythingi s delted."<<endl;
	list_size = 0;
}



/*
   This is the function that inserts a vertex.  Since the adjacencny list grows dynamically an anew adjaceny list of one size larger is created, the contents are then copied to that new array and the old one is deallocated and the new array becomes the adjacency list.
INPUT: A CHAR ARRAY FOR THE GOAL OF THE NEW VERTEX.
OUTPUT: AN INT TO REPORT SUCCESS OR FAILURE.
 */
int graph::insert_vertex(char*& new_goal)
{
	//	cout<<"Beginning insert function, list size is: "<<list_size<<endl;
	//	strcpy(adjacency_list[list_size-1]->goal,new_goal);
	//	adjacency_list[list_size -1]->head = NULL;
	node* dtemp = NULL;
	node* dtemp2 = NULL;
	vertex** temp = new vertex*[(list_size+1)];
	for(int i=0; i < list_size+1;i++)
	{
		temp[i] = new vertex;
		temp[i]->head = NULL;
		temp[i]->goal = new char[2000];
	}
	if(list_size > 0)
	{
		for(int i =0; i < list_size; i++)
		{
			//			cout<<"i is: "<<i<<endl;
			strcpy(temp[i]->goal,adjacency_list[i]->goal);			
			//			cout<<"goal stored"<<endl;
			if(adjacency_list[i]->head)
			{
				temp[i]->head = adjacency_list[i]->head;
			}
		}
	}
	//	cout<<"loop done"<<endl;
	++list_size;
//	cout<<"copying: "<<new_goal<<endl;
	strcpy(temp[list_size-1]->goal,new_goal);
//	cout<< temp[list_size-1]->goal<<endl;
	//	cout<<"strcpy done"<<endl;
	for(int i=0; i < list_size-1; i++)
	{
		if(adjacency_list[i]->goal)
		{
			delete[] adjacency_list[i]->goal;
		}
		dtemp = adjacency_list[i]->head;
		if(dtemp)
		{
			while (dtemp)
			{
			dtemp2 = dtemp->next;
			delete dtemp;
			dtemp = dtemp2;
			}
		}
		delete adjacency_list[i];
		}
		if(adjacency_list)
		{
		delete[] adjacency_list;
		}
	//	cout<<"Deletion done"<<endl;
	adjacency_list = temp;
	//	cout<<"=============================="<<endl;
	/*	cout<<"List so far:"<<endl;	
		for(int i=0; i< list_size;i++)
		{
		cout<<adjacency_list[i]->goal<<endl;
		}
		cout<<"=============================="<<endl;
		cout<<"Pointer assigned"<<endl;
	//	++ list_size;
	cout<<"List size is now: "<<list_size<<endl;*/
//	cout<<"done"<<endl;
	return 0;
}



/*
   This is the function that just displays all verticies in the adjacency list.
INPUT: NONE
OUTPUT: NONE
 */
void graph::display_verticies()
{
	if(list_size == 0)
	{
		cout<<"You have not goals entered yet."<<endl;
		return;
	}
	cout<<"==================================================="<<endl;
	cout<<"All Goals in the List"<<endl;
	for(int i=0; i < list_size;i++)
	{
		cout << i+1 << ". "<<adjacency_list[i]->goal<<endl;
	}
	cout<<"==================================================="<<endl;
}



/*
   Returns the size of the adjacency list.
INPUT: NONE
OUTPUT: NONE
 */
int graph::get_list_size()
{
	return list_size;
}



/*
   This function inserts a new edge via two integers to user as indexes for the verticies that are about to e connected.
INPUT: TWO INTEGERS FOR ARRAY ACCESS
OUPTUT: AN INT TO REPORT SUCCESS OR FAILURE
 */
int graph::insert_edge_via_integers(int source, int connect_to)
{
	node* new_node = new node();
	new_node->adjacent = adjacency_list[connect_to];
	node* temp = adjacency_list[source]->head;
	adjacency_list[source]->head = new_node;	
	new_node->next = temp;
}




/*
   This function checks all edges that are connected to the vertex inputted b the user.
INPUT: AN IN THAT IS AN ARRAY INDEX.
OUPTUT: AN INT TO REPORT SUCCESS OR FAILURE.
 */
int graph::check_connections(int array_index)
{
	int count = 1;
	node* temp = adjacency_list[array_index]->head;
	if(!temp)
	{
		cout<<"You have no pre-requisite goals to complete : "<<"|"<<adjacency_list[array_index]->goal<<"|"<<endl;
	}
	else if(temp)
	{
		cout<<"========================================================================"<<endl;
		cout<<"Here are the things you need to do before you can complete: "<<"|"<<adjacency_list[array_index]->goal<<"|"<<endl;
		while(temp)
		{
			cout<<"loop start"<<endl;
			cout<<count<<". "<<temp->adjacent->goal<<endl;	
			temp = temp->next;
			++ count;
		}
		cout<<"========================================================================"<<endl;
	}
	else
	{
		cout<<"You have no pre-requisite goals to complete : "<<"|"<<adjacency_list[array_index]->goal<<"|"<<endl;
	}
	return 0;
}
