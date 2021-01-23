/*
   Brandon Danielski
   2/13/2017
   Assignment 2
   CS202
   This the the .h file for both the rider class and thei history class.
 */
#include"transport.h"
#ifndef RIDER_H 
#define RIDER_H 

class transport;//forward declaration for the trasnport class


class history//history class that acts as a node for the rider linked list.
{
	public:
		history();//default constructor
		~history();//history destructor
		int get_at_index();//gets the current idex that will be filled next.
		int get_array_size();//gets the size of the array of the history node.
		//void display_history();
		void add_ride_to_history(transport*& to_add, history*& most_recent_rides);//adds a ride to the history node.
		void get_next(history*& next_node);//gets the next node for the inputted node.
		//void get_ride_from_history(int index, transport*& to_copy);
		void display_history(history*& head, int display_index);//displays the history of the node.
	protected:
		transport** rides;
		int at_index;
		int array_size;
		history* next;
};

class rider
{
	public:
		rider();//defualt constructor
		~rider();//destructo
		void display_history();//wrapper to display history.
		void add_ride_to_history(transport*& to_add);//adds ride to history.
	protected:
		void display_history(history*& head, int display_index);
		history* most_recent_ride;
};

#endif
