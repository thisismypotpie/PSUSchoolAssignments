#include <stdio.h>
#include "walker_functions.h"
#include "maze_functions.h"
void construct_walker(struct maze_runner* running_man)
{
	running_man->vertical_pos = 0;
	running_man->horizontal_pos = 0;
	running_man->direction = 0;
}

int turn_right(struct maze_runner* running_man, struct maze* the_maze)
{
	int is_walkable = 0;
	printf("checking for right turn\n");
	if(running_man->direction==1)
	{
		if(the_maze->complete_maze[running_man->vertical_pos][running_man->horizontal_pos+1]!=88)
		{
			is_walkable = 1;
		}
	}	
	else if(running_man->direction==2)
	{
		if(the_maze->complete_maze[running_man->vertical_pos+1][running_man->horizontal_pos]!=88)
		{
			is_walkable = 1;
		}
	}
	else if(running_man->direction==3)
	{
		if(the_maze->complete_maze[running_man->vertical_pos][running_man->horizontal_pos-1]!=88)
		{
			is_walkable = 1;
		}
	}
	else if(running_man->direction==4)
	{
		if(the_maze->complete_maze[running_man->vertical_pos-1][running_man->horizontal_pos]!=88)
		{
			is_walkable = 1;
		}

	}
	else
	{
		printf("No directions are walkable, you are trapped\n");
		return 0;
	}	

	if(is_walkable==1)
	{
		printf("Turning right\n");
		running_man->direction++;
		if(running_man->direction>4)
		{
			running_man->direction=1;
		}			
		walk(running_man,the_maze);
	}
	return is_walkable;
}

int turn_left(struct maze_runner* running_man, struct maze* the_maze)
{
	int is_walkable=0;
	printf("Checking for left turn\n");
	if(running_man->direction==1)
	{
		if(the_maze->complete_maze[running_man->vertical_pos][running_man->horizontal_pos-1]!=88)
		{
			is_walkable = 1;
		}
	}	
	else if(running_man->direction==2)
	{
		if(the_maze->complete_maze[running_man->vertical_pos-1][running_man->horizontal_pos]!=88)
		{
			is_walkable = 1;
		}
	}
	else if(running_man->direction==3)
	{
		if(the_maze->complete_maze[running_man->vertical_pos][running_man->horizontal_pos+1]!=88)
		{
			is_walkable = 1;
		}
	}
	else if(running_man->direction==4)
	{
		if(the_maze->complete_maze[running_man->vertical_pos+1][running_man->horizontal_pos]!=88)
		{
			is_walkable = 1;
		}

	}

	else
	{
		printf("Orientation lost, setting to North\n");
		running_man->direction=1;
		return 0;
	}	

	if(is_walkable==1)
	{
		printf("Performing left turn\n");
		running_man->direction--;
		if(running_man->direction<1)
		{
			running_man->direction=4;
		}
		walk(running_man,the_maze);
	}
	return is_walkable;
}

void turn_around(struct maze_runner* running_man)
{
	printf("Turning around\n");
	if(running_man->direction ==1)
	{
		running_man->direction=3;
	}
	else if(running_man->direction ==2)
	{
		running_man->direction=4;
	}
	else if(running_man->direction==3)
	{
		running_man->direction=1;
	}
	else if(running_man->direction==4)
	{
		running_man->direction=2;
	}
	else
	{
		printf("Runner has no directions, setting direction to north.\n");
		running_man->direction=1;
	}
}

int walk(struct maze_runner* running_man, struct maze* the_maze)
{
	int is_walkable =0;
	if(running_man->direction ==1)
	{
		if(the_maze->complete_maze[running_man->vertical_pos-1][running_man->horizontal_pos]!=88)
		{
			is_walkable=1;
			running_man->vertical_pos--;
			printf("Walking North\n");
		}
	}
	else if(running_man->direction ==2)
	{
		if(the_maze->complete_maze[running_man->vertical_pos][running_man->horizontal_pos+1]!=88)
		{
			is_walkable=1;
			running_man->horizontal_pos++;
			printf("Walking East\n");
		}
	}
	else if(running_man->direction==3)
	{
		if(the_maze->complete_maze[running_man->vertical_pos+1][running_man->horizontal_pos]!=88)
		{
			is_walkable=1;
			running_man->vertical_pos++;
			printf("Walking South\n");
		}
	}
	else if(running_man->direction==4)
	{
		if(the_maze->complete_maze[running_man->vertical_pos][running_man->horizontal_pos-1]!=88)
		{
			is_walkable=1;
			running_man->horizontal_pos--;
			printf("Walking West\n");
		}
	}
	else
	{
			printf("Orientation lost, setting to North\n");
			running_man->direction=1;
	}
		return is_walkable;	
}

void traverse_the_maze(struct maze* the_maze, struct maze_runner* running_man)
{
		while(running_man->vertical_pos!=the_maze->ending_x_point || running_man->horizontal_pos!=the_maze->ending_y_point)
		{
/*			printf("Current position: %d,%d\n",running_man->vertical_pos,running_man->horizontal_pos);*/
			the_maze->complete_maze[running_man->vertical_pos][running_man->horizontal_pos]=87;
			if(turn_right(running_man,the_maze)==0)
			{
				if(walk(running_man,the_maze)==0)
				{
					if(turn_left(running_man,the_maze)==0)
					{
						turn_around(running_man);
					}
				}
			}
			the_maze->complete_maze[running_man->vertical_pos][running_man->horizontal_pos]=87;
			print_maze(the_maze);
		}
/*		printf("Current: %d,%d and ending %d,%d\n",running_man->vertical_pos,running_man->horizontal_pos,the_maze->ending_x_point, the_maze->ending_y_point);*/
		printf("Maze is complete\n");
}

