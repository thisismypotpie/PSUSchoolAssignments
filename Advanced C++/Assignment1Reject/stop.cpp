/*
Brandon Danielski
CS 202
1/16/2017
Assignment One
This is the .cpp file for the stop portion of the streetcar network.  It has all of the functions that will be associated with the stops used in this project.
*/
#include<cstring>
#include"stop.h"
using namespace std;


/*
This is the default constructor for the line class in stops.h.
INPUT: NONE
OUTPUT: NONE
*/
line::line()
{
	name = NULL;
	line_loop_stops = NULL;
}



/*
This is a constructor for the line class if a new loop is created.
INPUT: The name of the loop and a pointer to the stops included in the new loop.
OUTPUT: NONE
*/
line::line(char* loop_name, line_loop_node*& new_line_loop)
{
	name = new char[2000];
	name = loop_name;
	line_loop_stops = new_line_loop;
}



/*
This is the destuctor for the line class.
INPUT: NONE
OUTPUT: NONE
*/
line::~line()
{
	if(name)
	{
		delete[] name;
	}
	//add a deletion of loop stops and line stops when destuctors are created for them.
}



/*
This is the default constructor for the stop class.
*/
stop::stop()
{
	stop_name = NULL;
	occupied_by_streetcar = NULL;
	direction = NULL;
	stop_num = 0;
}


/*
This is a constructor for a stop given all of the information needed to create a stop.
INPUT: The name for the new stop, a streetcar that is at the current stop, the direction of the stop, and the stop number.
OUTPUT: NONE
*/
stop::stop(char* new_stop_name, streetcar*& new_occupied_by_streetcar, char* new_direction, int new_stop_num)
{
	stop_name = new char[2000];
	direction = new char[2000];
	strcpy(stop_name, new_stop_name);
	strcpy(direction, new_direction);
	occupied_by_streetcar = new_occupied_by_streetcar;//make a copy function.
	stop_num = new_stop_num;	
}



/*
This is the destructor for the stop class.
INPUT: NONE
OUTPUT: NONE
*/
stop::~stop()
{
	if(stop_name)
	{
		delete[] stop_name;
	}
	if(direction)
	{
		delete[] direction;
	}
	if(occupied_by_streetcar)
	{
		delete occupied_by_streetcar;
	}//there may be a leak here if the streetcar is not destroyed correctly.
}
