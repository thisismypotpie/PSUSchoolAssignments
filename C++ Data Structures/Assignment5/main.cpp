/*
Brandon Danielski 
12/6/2016
CS 163
Assignment 5

This is the main for my graph progam.  First each vertex, which is a goal I want to achieve during winter break, is inserted into the adjacency list and then each edge I want to add to the graph is added. After that the  user can then choose to add a vertex or edge, view edges, destroy the entire graph, or exit.
*/
#include "app.h"
#include "graph.h"
#include<iostream>
using namespace std;

int main()
{
	app the_app;
	graph the_graph;
	int user_input = 0;
	char* insert_goal = new char[2000];
	the_app.first_greeting();
	char* goal = ((char*)("Spend free Time"));
	the_graph.insert_vertex(goal);
	goal = ((char*)("Work Extra Hours"));
	the_graph.insert_vertex(goal);	
	goal = ((char*)("Purchse Christmas Gifts"));
	the_graph.insert_vertex(goal);
	goal = ((char*)("Clean the House"));
	the_graph.insert_vertex(goal);
	goal = ((char*)("Have money in the bank for the break"));
	the_graph.insert_vertex(goal);
	goal = ((char*)("Have my family visit my house"));
	the_graph.insert_vertex(goal);
	the_graph.insert_edge_via_integers(1,0);
	the_graph.insert_edge_via_integers(3,0);
	the_graph.insert_edge_via_integers(5,0);
	the_graph.insert_edge_via_integers(4,1);
	the_graph.insert_edge_via_integers(5,2);
	the_graph.insert_edge_via_integers(5,3);
	the_graph.insert_edge_via_integers(2,4);
	while(user_input == 0)
	{
		user_input = the_app.main_menu();	
		if(user_input == 1)
		{
			the_app.user_input_for_insert(insert_goal);
			the_graph.insert_vertex(insert_goal);
			user_input = 0;
		}
		else if(user_input == 2)
		{
			the_app.user_input_for_edge_insertion(the_graph);
//			the_graph.insert_edge();
			user_input = 0;
		}	
		else if(user_input == 3)
		{	
			the_app.user_input_for_check_connections(the_graph);
			user_input = 0;
		}
		else if(user_input == 4)
		{
			the_graph.~graph();
//			the_graph.graph();
			graph the_graph;
			cout<<"The entire graph has been deleted. press any key to continue."<<endl;
			cin.ignore();
			cin.get();
			user_input = 0;
		}
		else if(user_input == 5)
		{
			if(insert_goal)
			{
				delete[] insert_goal;
			}
			return 0;	
		}
	}
}
