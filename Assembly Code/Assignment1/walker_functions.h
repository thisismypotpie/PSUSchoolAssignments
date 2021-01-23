#include <stdio.h>
#ifndef WALKER_FUNCTIONS_H
#define WALKER_FUNCTIONS_H

struct maze;
struct maze_runner
{
	int direction; /*1=north, 2=east, 3=south, 4=west*/
	int vertical_pos;
	int horizontal_pos;

};

void construct_walker(struct maze_runner* running_man);
int turn_right(struct maze_runner* running_man, struct maze* the_maze);
int turn_left(struct maze_runner* running_man, struct maze* the_maze);
void turn_around(struct maze_runner* running_man);
int walk(struct maze_runner* running_man, struct maze* the_maze);
void traverse_the_maze(struct maze* the_maze, struct maze_runner* running_man);
#endif
