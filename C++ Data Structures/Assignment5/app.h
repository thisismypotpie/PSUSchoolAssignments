/*
Brandon Danielski
12/6/2016
CS 163
Assignment 5
This is the app.h file of the program.  This controls all of the menus and user input needed for the program.  It is get user input for inserting an edge, inserting a vertex, or checking all edges connected to a vertex.
*/
#ifndef APP_H
#define APP_H
#include "graph.h"
class app
{
	public:
		void first_greeting();//greets the user then the program is run.
		int main_menu();//the user chooses from the options the main menu presents.
		//void insert_edge();
		int user_input_for_insert(char*& user_input);//gets user input for inserting a vertex.
		int user_input_for_edge_insertion(graph& the_graph);//gets user input for inserting an edge and then that input is passed into the graph function for adding an edge.
		int user_input_for_check_connections(graph& the_graph);//gets user input for checking all edges associated with a vertex and then passes that information to the passed graph.  A function for that graph is called so the user can see the edges of the vertex they entered.
	private:
};
#endif
