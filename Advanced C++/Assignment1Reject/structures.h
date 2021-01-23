/*
Brandon Danielski
CS202
1/16/2017
Assignemnt One
This is the .h file for miscellaneous structues for the program.  This will include the graph used for lines and loops, loop nodes, and line nodes.
*/
#ifndef STRUCTURES_H
#define STRUCTURES_H
#include"stop.h"
class stop;
class line;
/*

*/
class line_loop_node 
{
public:
line_loop_node();
private:
line_loop_node* next;
stop* data;
};
/**/
/*
This class is the loader for the program.  It takes all the map info from external data files and loads them into the program.
*/
class graph
{
public:
void load_line_files(char* line_file_name, char* streetcar_file_name);
private:
void load_streetcar_file(char* file_name);
line* adjacency_list;
};
#endif
