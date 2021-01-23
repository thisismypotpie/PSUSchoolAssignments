/*
   Brandon Danielski
   1/31/2017
   CS202 
   Asignment 1
   This is the main .cpp filr for the program.  It calls the functions used to make sure the program runs as it needs to.
 */
#include "location.h"
#include "stop.h"
#include "app.h"
#include<iostream>
using namespace std;



/*
This is the main function.
INPUT: NONE
OUTPUT: NONE
*/
int main()
{
	graph location_map;
	line line_one;
	loop loop_one;
	app the_app;
	location_map.load_locations_and_streetcars(((char*)"locations.txt"),((char*)"streetcars.txt"),location_map);
	//location_map.display_all_locations();
	//location_map.display_all_streetcars();
	location_map.add_location_reference_for_line_stop(line_one,0);
	//line_one.display_all_stops();
	location_map.add_location_reference_for_line_stop(line_one,1);
	//line_one.display_all_stops();
	location_map.add_location_reference_for_line_stop(line_one,2);
	//line_one.display_all_stops();
	location_map.add_location_reference_for_line_stop(line_one,3);
	//line_one.display_all_stops();
	location_map.add_location_reference_for_line_stop(line_one,4);
	//line_one.display_all_stops();
	location_map.add_location_reference_for_line_stop(line_one,5);
	//line_one.display_all_stops();
	location_map.add_location_reference_for_line_stop(line_one,6);
	//line_one.display_all_stops();
	location_map.add_location_reference_for_line_stop(line_one,7);
	//line_one.display_all_stops();
	location_map.add_location_reference_for_line_stop(line_one,8);
	//line_one.display_all_stops();
	location_map.add_location_reference_for_line_stop(line_one,9);
	//line_one.display_all_stops();

	location_map.add_location_reference_for_loop_stop(loop_one,10);
	location_map.add_location_reference_for_loop_stop(loop_one,11);
	location_map.add_location_reference_for_loop_stop(loop_one,12);
	location_map.add_location_reference_for_loop_stop(loop_one,13);
	location_map.add_location_reference_for_loop_stop(loop_one,14);
	location_map.add_location_reference_for_loop_stop(loop_one,15);
	location_map.add_location_reference_for_loop_stop(loop_one,16);
	location_map.add_location_reference_for_loop_stop(loop_one,17);
	location_map.add_location_reference_for_loop_stop(loop_one,18);
	location_map.add_location_reference_for_loop_stop(loop_one,19);
	location_map.add_location_reference_for_loop_stop(loop_one,20);
	location_map.add_location_reference_for_loop_stop(loop_one,21);
	location_map.add_location_reference_for_loop_stop(loop_one,22);
	location_map.add_location_reference_for_loop_stop(loop_one,23);
	location_map.add_location_reference_for_loop_stop(loop_one,24);
	location_map.add_location_reference_for_loop_stop(loop_one,25);
	location_map.add_location_reference_for_loop_stop(loop_one,26);
	location_map.add_location_reference_for_loop_stop(loop_one,27);
	location_map.add_location_reference_for_loop_stop(loop_one,28);
	location_map.add_location_reference_for_loop_stop(loop_one,29);
	loop_one.check_streetcar_connections(location_map);
	line_one.check_streetcar_connections(location_map);
	//loop_one.display_all_stops();

	the_app.first_greeting(line_one, loop_one, location_map);
	return 0;
}
