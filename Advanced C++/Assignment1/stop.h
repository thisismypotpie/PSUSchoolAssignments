/*
Brandon Danielski
1/31/2017
CS202 
Asignment 1
This is the .h file the loop stop, line stop, loop, and line classes.  They are basically a doubly linked list and a circly linked list.
*/
#include"location.h"
#ifndef STOP_H
#define STOP_H
class location;
class graph;
class streetcar;

class line_stop//: public location //the class that acts as a node for a line.
{
public:
line_stop();//default constructor.
line_stop(location*& new_location, int new_stop_num);//non-defualt constuctor
void destroy_all_line_stops(line_stop*& head);//destructor for the line stop.
void connection_addition(line_stop*& to_add, line_stop*& head);//make new connection in line.
void display_there_trip(line_stop*& head);//displays half of all line stops.
void get_stop_location(location*& get_location);//gets stop location pointer.
void check_streetcar_connections(line_stop*& head, graph& to_find);//checks all steetcar connections
void next_stop(line_stop*& head);//gets next stop.
int get_stop_num();//gets stop number.
void move_all_streetcars(line_stop*& current, graph& map_one, bool has_moved);
protected:
void display_return_trip(line_stop*& end, int return_stop_num);//displays other half of stops.
location* stop_location;//points to the location of a stop.
int stop_num;//stop number
bool return_trip;//tells if a car is going on thre trip or return trip.
line_stop* next;//next pointer piece of node
line_stop* prev;//previous pointer piece of node
};

class loop_stop//: public location
{
public:
loop_stop();//defualt constructor
loop_stop(location*& new_location, int new_stop_num);//non-defualt constructor
void destroy_all_loop_stops(loop_stop*& head, loop_stop*& tail);//detructo for loop stops.
void connection_addition(loop_stop*& new_stop, loop_stop*& beginning_stop, loop_stop*& tail);//makes new connection for the loop.
void display_all_stops(loop_stop*& current, loop_stop*& head);//displays all loop stops.
void move_streetcars(loop_stop*& head);//moves all streetcars in a loop
void next_stop(loop_stop*& head);//allows loop clas to go to next stop.
void get_stop_location(location*& get_location);//gets stop location pointer
void check_streetcar_connections(loop_stop*& head, loop_stop*& tail, graph& to_find);//checks streetcar connections.
int  get_stop_num();//gets stop number
void move_all_streetcars(loop_stop*& current, loop_stop*& head,graph& map_one, bool first_head, streetcar**& move_list);//moves all streetcars forward.
protected:
location* stop_location;//location pointer
int stop_num;//a stop number
loop_stop* next;//next loop pointer.
};


class line: public line_stop // line class, inherits from line stop.
{
public:
line();//constructor
~line();//destuctor
void add_stop(location*& location_for_stop);//adds a new stop to a line.
void display_all_stops(); //displays all stops.
void move_streetcars();//moves streetcars for a line.
void check_streetcar_connections(graph& to_find);//checks streetcar connections.
void get_beginning_stop(line_stop*& to_get);//gets beginning stop.
void move_streetcars(graph& map_one);//wrapper to move streetcars.
protected:
line_stop* beginning_stop;//first stop on a line.
int num_of_stops;// number of stops on a line.
};


class loop: public loop_stop//loop class, inherits from loop stop.
{
public:
loop();//defualt constructor
~loop();//destuctor
void add_stop(location*& location_for_stop);//adds a stop to a loop.
void display_all_stops();//displays all loop stops.
void check_streetcar_connections(graph& to_find);//checks all streetcar connections.
void get_beginning_stop(loop_stop*& to_get);//gets beginnig stop.
void move_streetcars(graph& map_one);//moves all streetcars forward in a loop
protected:
loop_stop* beginning_stop;//first stop in a loop.
loop_stop* tail;//last stop of a loop.
int num_of_stops;// number of stops in a loop.
};
#endif
