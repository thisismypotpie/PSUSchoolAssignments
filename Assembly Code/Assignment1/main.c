#include <stdio.h>
#include "maze_functions.h"
#include "walker_functions.h"
int main(int argc, char* argv[])
{
	struct maze* billy_maze;
	billy_maze = (struct maze*)malloc(sizeof(struct maze));
	construct_maze(billy_maze);
	struct maze_runner* running_man;
	running_man =(struct maze_runner*)malloc(sizeof(struct maze_runner));
	construct_walker(running_man);
	
	retrieve_maze(billy_maze,running_man,argv[1]);

	printf("Maze Size: %d by %d\n",billy_maze->width,billy_maze->height);
	printf("Starting Location: %d,%d\n",billy_maze->starting_x_point, billy_maze->starting_y_point);
	printf("Ending Locations: %d,%d\n",billy_maze->ending_x_point, billy_maze->ending_y_point);
	printf("\n Running man starting coordinates: %d,%d\n",running_man->vertical_pos,running_man->horizontal_pos);
	printf("Direction is: %d\n",running_man->direction);
	print_maze(billy_maze);

	traverse_the_maze(billy_maze, running_man);

	free(running_man);
	delete_maze(billy_maze);
	free(billy_maze);
	return (0);
}
