/*
Brandon Danielski
12/6/2016
CS 163
Assignment 5

This is the graph.h file of the program.  This file will take manipulate an adjacency list and all of the nodes attached to each vertex in the list.
*/
#ifndef GRAPH_H
#define GRAPH_H

struct vertex// each element of the adjacency list will be a vertex.  Each vertex will have a goal and a head pointer for a linked list to say which verticies this one is connected to.
{
	char* goal;
	struct node* head;
};



struct node//this node is an edge that connects to adjacent and a next node.
{
	vertex* adjacent;
	node* next;
};
class graph
{
public:
	graph();//constructor
	~graph();//destructor
	int insert_vertex(char*& new_goal);//inserts a vertex into the adjacency list.
	void display_verticies();//displays all verticies in the adjacency list.
	int get_list_size();//returns the size of the ajacency list.
	int insert_edge_via_integers(int source, int connect_to);//inserts an edge between two verticies by index number.
//	int insert_edge_via_vertex( vertex*& source, vertex*& connect_to);
	int check_connections(int array_index);//checks all edges associated with the vertex given by the index in teh adjacency list.
//	int insert_edge();
//	int insert_edge(vertex& source, vertex& to_attach_to);
	
private:
	vertex** adjacency_list;
	int list_size;
};
#endif
