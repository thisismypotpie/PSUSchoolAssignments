#include<stdio.h>
#include"walker_functions.h"
#ifndef MAZE_FUNCTIONS_H
#define MAZE_FUNCTIONS_H

struct maze
{
	char** complete_maze;
	int starting_x_point;
	int starting_y_point;
	int ending_x_point;
	int ending_y_point;
	int height;
	int width;
};

void construct_maze(struct maze* to_allocate);
int retrieve_maze(struct maze* the_maze, struct maze_runner* running_man, char*filename);
void delete_maze(struct maze* to_delete);
void print_maze(struct maze* to_print);
#endif
