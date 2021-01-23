/*
   Brandon Danielski
   1/31/2017
   CS202 
   Asignment 1
 */
#ifndef LOCATION_H
#define LOCATION_H
#include"stop.h"

class streetcar;
class line;
class loop;

class location//This is the location class that acts as an adjacent for the graph class.
{
	public:
		location();//defualt constuctor
		location(char* new_name, int new_occupied);//non-default constructor
		location(location& copy_to);//copy constuctor
		void copy_location(location& copy_to);//copies one location to what is passed in by reference.
		void display_location();//Displays data members to the user.
		int get_occupied();//returns occupied.
		void set_occupied(int new_occ);//sets occupied
		void get_name(char*& new_name);//copies name into the char* passed by reference.
		~location();//destuctor 
	protected:
		char* name;//The name of the location.
		int occupied;//this will be an ID number of the streetcar at this location.
};


class graph//Graph class, carries two adjacency lists and a butt ton of functions.
{
	public:
		graph();//defualt constuctor
		~graph();//destuctor
		void load_locations_and_streetcars(char* location_file_name, char* streetcar_file_name ,graph& add_info);//loads data from external datafiles to graph.
		bool add_location(location& add_location);//adds location to location adj list.
		bool add_streetcar(streetcar& add_car);//adds  streetcar to streetcar adj list.
		void add_location_reference_for_line_stop(line& to_add, int adj_list_index);//adds a location to a line
		void add_location_reference_for_loop_stop(loop& to_add, int adj_list_index);//adds a location to a loop
		void display_all_locations();//displays all locations in locaton adj list.
		void display_all_streetcars();//displays all streetcars in streetcar adj list.
		bool display_offline_streetcars();//displays offline streetcars.
		bool display_online_streetcars_loop();//displays online streetcars for loop.
		bool display_online_streetcars_line();//displays online streetcars for line.
		void check_streetcar_connections(loop_stop*& head);//checks loop stop connection to streetcar.
		void check_streetcar_connections(line_stop*& head);//checks line stop connection to streetcar.
		void bring_loop_car_online(int check_ID, loop& add_loop);//brings streetcar online in a loop.
		void bring_line_car_online(int check_ID, line& add_line);//brings streetcar online in a line.
		void bring_loop_car_offline(int check_ID);//brings a streetcar offline in a loop.
		void bring_line_car_offline(int check_ID);//brings a streetcar offline in a line.
		void close_program(char* location_file_name, char* streetcar_file_name);//saves data at end of program.
		void get_streetcar(streetcar*& to_get, int index);//writes a streetcar to a passed object for us outside of the graph class.
		int get_all_cars_size();// getter to get the size of the adj list for streetcars.
	protected:
		int adj_list_size;//size of the location adj list.
		int all_cars_size;//size of the streetcar adj list.
		location** adj_list;//location adj list.
		streetcar** all_cars;//streetcar adj list.
};
#endif
