/*
Brandon Danielski
12/6/2016
Cs 163
Assignment 5

This is the cpp file of the app.  It has the function definitions of all of the functions associated with the app.
*/
#include<iostream>
#include<cstring>
#include"app.h"
using namespace std;



/*
This is the first greeting the user recieves when the program begins.
INPUT: NONE
OUTPUT: NONE
*/
void app::first_greeting()
{
	cout<<"Welcome to the winter vacation trip planner."<<endl;
}



/*
This is the main menu for the app.  It has five options that he user can choose from.
INPUT: NONE
OUTPUT: AN INT TO DETERMINE SUCESS OR FAILURE.
*/
int app:: main_menu()
{
	int user_input = 0;
	bool valid_input = false;
	while(valid_input == false)
	{
		cout<<"Please choose from the following options."<<endl;
		cout<<"1. Insert a Vertex"<<endl;
		cout<<"2. Insert an Edge"<<endl;
		cout<<"3. Check Goal Progress"<<endl;
		cout<<"4. Erase entire Graph"<<endl;
		cout<<"5. Exit"<<endl;
		cin >> user_input;
		if(cin.fail())
		{
			cout <<" What you have entered is incorrect, please enter only a 1-5."<<endl;
			cin.clear();
			cin.ignore();
		}
		if( user_input < 1 || user_input > 5)
		{
			cout<<" Please enter only a number between 1 and 5."<<endl;
			user_input = 0;
		}
		else
		{
			valid_input = true;
		}
	}
	return user_input;
}




/*
This gets uer input for inserting a vertex into the adjacency list.  The user inputs a goal and that goal is inserted as a new vertex.
INPUT: A CHAR ARRAY TO COPY THE GOAL TO.
OUTPUT: AN INT TO DETERMINE SUCCESS OR FAILURE.
*/
int app:: user_input_for_insert(char*& user_input)
{
	bool is_empty = true;
	char* temp = new char[2000];
	cin.clear();
	cin.ignore();
	while(is_empty == true)
	{
		cout<<"What is the goal you want to add?"<<endl;
		cin.getline(temp,2000);
	//	cout<<"Stored"<<endl;
		for(int i=0; i < 2000; i++)
		{
			if(*(temp+i))
			{
				is_empty = false;
				i =2000;
			}
			if(!*(temp+i)&& i==1999)
			{
				cout<<"You have not ented anything, you need to enter something for you goal."<<endl;
				cin.clear();
				cin.ignore();
			}
		}
	}
	strcpy(user_input,temp);
//	the_graph.insert_vertex(temp);
	if(temp)
	{
		delete[] temp;
	}
	return 0;	
}



/*
This function is for the insert of an edge between two verticies.  This function then calls a graph function to connect the two vertiices hence the graph getting passed into the function.
INPUT: A GRAPH OBJECT
OUTPUT: AN INT TO DETERMINE SUCCESS OR FAILURE.
*/
int app:: user_input_for_edge_insertion(graph& the_graph)
{
	int input1=0;
	int input2=0;
	int list_size = the_graph.get_list_size();
	bool valid_input = false;
	the_graph.display_verticies();
	if(the_graph.get_list_size() ==0)
	{
		cout<<"You have no goals, please enter some goals before proceeding."<<endl;
		return 0;
	}
	while (valid_input == false)
	{
		cout<<"Please choose a number for the source edge."<<endl;
		cin>>input1;
		if(cin.fail() || input1 < 1 || input1 > list_size)
		{
			cout<<"What you have inputted is invalid, please only ennter anumber between 1 and "<<list_size<<"."<<endl;
			cin.clear();
			cin.ignore();
		}
		else
		{
			valid_input = true;
		}
	}
	valid_input = false;
	while(valid_input == false)
	{
		cout<<"Please choose a number to connect the edge to."<<endl;
		cin>>input2;
		if(cin.fail() || input2 < 1 || input2 > list_size)
		{
			cout<<"What you have inputted is invalid, please only enter a number between 1 and "<<list_size<<"."<<endl;
			cin.clear();
			cin.ignore();
		}
		else
		{
			valid_input = true;
		}
		the_graph.insert_edge_via_integers(input1-1,input2-1);
	}
	return 0;
}



/*
This function will show all edges associated with the vertex inputed by the user.  A function from the graph is called to then display all of the associated edges.
INPUT: A GRAPH OBJECT
OUTPUT: AN INT TO DETERMINE SUCCESS OR FAILURE.
*/
int app::user_input_for_check_connections(graph& the_graph)
{
	int user_input=0;
	bool valid_input = false;
	the_graph.display_verticies();
	cin.clear();
	cin.ignore();
	if(the_graph.get_list_size() ==0)
	{
		cout<<"You have no goals, please enter some goals before proceeding."<<endl;
		return 0;
	}
	while(valid_input == false)
	{
		cout<<"Please select the number of the vertex you want to see the connections of."<<endl;		
		cin>>user_input;
		if(cin.fail() || user_input < 1 || user_input > the_graph.get_list_size())
		{
			cout<<"What you have input is invalid, please only enter a number between 1 and "<<the_graph.get_list_size()<<"."<<endl;
			cin.clear();
			cin.ignore();
		}
		else
		{
			valid_input = true;
		}
	}
	the_graph.check_connections(user_input-1);	
	return 0;
}
