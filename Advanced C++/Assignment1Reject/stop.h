/*
Brandon Danielski
CS202
1/16/22017
Assignment One
This is the .h file for the stop portion of the streetcar network.  It has the class for the stops used in this program.
*/
#ifndef STOP_H
#define STOP_H
#include"streetcar.h"
#include"structures.h"

class line_loop_node;
class streetcar;

class line
{
public:
line();
line(char* loop_name, line_loop_node*& new_loop);
~line();
private:
char* name;
line_loop_node* line_loop_stops;//basically head for a linked list.
line_loop_node* final_stop;
streetcar* streetcars[1];//i need an array of streetcars that are in each line.  I need this to not be a pointer so that each streetcar can be physically stored in each line as each line is created.
};




/*
This is the stop class for the project.  Each stop contains a name, stop number, a pointer to a streetcar to determine if there is a streetcar at that stop, and the direction of the stop.
*/
class stop : public line
{
public:
stop();
stop(char* new_stop_name, streetcar*& new_occupied_by_streetcar,char* new_direction ,int new_stop_num);
~stop();
void get_name(char*& copy_to);
bool get_stop_occupied_by_streetcar();
private:
char* stop_name;
streetcar* occupied_by_streetcar;
char* direction;
int stop_num;
};

#endif
