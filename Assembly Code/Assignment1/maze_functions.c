#include <stdio.h>
#include "maze_functions.h"



void construct_maze(struct maze* the_maze)
{	
	the_maze->starting_x_point=0;
	the_maze->starting_y_point=0;
	the_maze->ending_x_point=0;
	the_maze->ending_y_point=0;
	the_maze->height=0;
	the_maze->width=0;
}

void delete_maze(struct maze* the_maze)
{
	int i;
	for(i=0;i<the_maze->height;i++)
	{
		free(the_maze->complete_maze[i]);
	}
	free(the_maze->complete_maze);

}

int retrieve_maze(struct maze* the_maze, struct maze_runner* running_man, char* filename)
{

	char numbers[20];
	char* endptr;
	int i=0;
	FILE* mazefile = fopen(filename,"r");
	if(mazefile==NULL)
	{
		printf("file could not be opened\n");
		return 1;
	}	
	else
	{
		printf("file has been opened\n");
		fgets(numbers, 20, mazefile);
		the_maze->width = strtol(numbers,&endptr,10);
		endptr++;
		the_maze->height = strtol(endptr,NULL,10); 

		fgets(numbers,20,mazefile);
		the_maze->starting_x_point = strtol(numbers,&endptr,10);
		endptr++;
		the_maze->starting_y_point = strtol(endptr,NULL,10);

		fgets(numbers,20,mazefile);
		the_maze->ending_y_point = strtol(numbers,&endptr,10);
		endptr++;
		the_maze->ending_x_point = strtol(endptr,NULL,10);
		running_man->horizontal_pos = the_maze->starting_x_point;
		running_man->vertical_pos= the_maze->starting_y_point;
		if(the_maze->starting_x_point ==0 && the_maze->starting_y_point >0)/*starts in the west*/
		{
			running_man->direction=2;
		}
		else if(the_maze->starting_y_point==0 && the_maze->starting_x_point >0)/*starts in the north*/
		{
			running_man->direction=3;
		}
		else if(the_maze->starting_x_point == the_maze->width-1 && the_maze->starting_y_point>0)/*starts in the east*/
		{
			running_man->direction=4;
		}
		else if(the_maze->starting_y_point == the_maze->height-1 && the_maze->starting_x_point>0)
		{
			running_man->direction=1;
		}
		else
		{
			printf("Running man was not given a direction, setting to South default.");
			running_man->direction=1;
		}
		the_maze->complete_maze=(char**)malloc(sizeof(char*)*the_maze->height);	
		for(i=0;i<the_maze->height;i++)
		{
			the_maze->complete_maze[i]=(char*)malloc(sizeof(char)*the_maze->width+2);	
			printf("%d",i);
		}
		i=0;
		printf("woah\n");
		while(!feof(mazefile))
		{
			fgets(the_maze->complete_maze[i],the_maze->width+2,mazefile);
			i++;
		}
		the_maze->complete_maze[running_man->vertical_pos][running_man->horizontal_pos]=87;
		fclose(mazefile);
		return 0;
	}
}


void print_maze(struct maze* to_print)
{
	int i=0;
	for(i=0; i< to_print->height;i++)
	{
		printf("%s",to_print->complete_maze[i]);
	}	
}
