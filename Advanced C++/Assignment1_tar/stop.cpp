/*
   Brandon Danielski
   1/31/2017
   CS202 
   Asignment 1
   This is the .cpp for the line stop, loop, stop, loop , andline for the program.
 */
#include "stop.h"
#include <cstring>
#include <iostream>
#include "streetcar.h"
using namespace std;



/*
   This is the defualt constructor the the line_stop class.
INPUT: NONE
OUTPUT: NONE
 */
line_stop::line_stop():stop_location(NULL),stop_num(0),return_trip(false),next(NULL),prev(NULL)
{
	//	cout<<"Default constructor for line stop initialized."<<endl;
}



/*
   This is a non-default constructor for the line stop class.  
INPUT: A LOCATION PASSED BY REFERENCE AND A INTEGER THAT IS THE STOP NUMBER.
OUTPUT: NONE
 */
line_stop::line_stop(location*& new_location, int new_stop_num) : stop_num(new_stop_num) ,next(NULL), prev(NULL),stop_location(new_location)
{
	//	cout<<"Non defualt constructor for line stop initialized"<<endl;
	//	cout<<"Num of stops in constructor: "<<num_of_stops<<endl;;
	//	cout<<"new stop num: "<<new_stop_num<<endl;
	//	stop_location = new_location;
}



/*
   This is the default constructor for the loop stop class.
INPUT: NONE
OUTPUT: NONE
 */
loop_stop::loop_stop():stop_location(NULL),stop_num(0),next(NULL)
{

}



/*
   This function is a non-default constuctor.
INPUT: A LOCATION AND AN INTEGER.
OUTPUT: NONE
 */
loop_stop::loop_stop(location*& new_location, int new_stop_num):next(NULL), stop_num(new_stop_num),stop_location(new_location)
{
	//	cout<<"new stop num in loop constructor: "<<new_stop_num<<endl;
	//	stop_num = new_stop_num;
	//	stop_location = new_location;
}



/*
   This is the default constructor for the line class.
INPUT: NONE
OUTPUT: NONE 
 */
line::line():beginning_stop(NULL),num_of_stops(0)
{

}



/*
   This is the destuctor for the line class, it then goes and destroys all line_stops that are linked to its beginning stop.
INPUT: NONE
OUTPUT: NONE
 */
line::~line()
{
	//	cout<<"Destructor for line initiated"<<endl;
	destroy_all_line_stops(beginning_stop);
	//	cout<<" Line stops have been destroyed."<<endl;
	if(beginning_stop)
	{
		delete beginning_stop;
	}
}

loop::loop() : beginning_stop(NULL),tail(NULL),num_of_stops(0)
{

}

loop::~loop()
{
	//tail->next = NULL;
	//	cout<<"Destructor for loop initiated"<<endl;
	destroy_all_loop_stops(beginning_stop, tail);
}



/*
   This function acts as a destructor for the line stop.  It needs arguments in order to work, using recursion, and that is why there is no destructor for the line stop.
INPUT: A LINE STOP
OUTPU: NONE
 */
void line_stop::destroy_all_line_stops(line_stop*& head)
{
	if(!head)
	{
		return;
	}	
	destroy_all_line_stops(head->next);
	if(head)
	{
		delete head;
		head = NULL;
	}
}



/*
   This function connects a new node to the line doubly linked list.
INPUT: A NEW LINE STOP TO ADD AND THE HEAD POINTER THAT WILL BE REPLACED WITH THE NEW LINE STOP SINCE I AM INSERTING AT THE FRONT.
OUTPUT: NONE
 */
void line_stop::connection_addition(line_stop*& to_add, line_stop*& head)
{
	if(!head->next)
	{
		head->next = to_add;
		to_add->prev = head;
		return;
	}
	connection_addition(to_add, head->next);
	/*	to_add->next = head;
		head->prev = to_add;
		head = to_add;*/
}



/*
   This function will display all of the stops on the line list going from the head to the final pointer in the list using recursion.
INPUT: THE CURRENT NODE BEING USED IN TEH RECURSIVE FUNCTION.
OUTPUT: NONE
 */
void line_stop::display_there_trip(line_stop*& head)
{
	if(!head->next)
	{
		cout<<"Stop "<<head->stop_num<<": ";
		head->stop_location->display_location();
		cout<<" Northbound"<<endl;
		display_return_trip(head,1);
		return;
	}	
	cout<<"Stop "<<head->stop_num<<": ";
	head->stop_location->display_location();
	cout<<" Northbound"<<endl;	
	display_there_trip(head->next);
}



/*
   This function will recursively search through a line to find a streetcar at a stop.
INPUT: A LINE STOP AND A GRAPH
OUTPUT: NONE
 */
void line_stop::check_streetcar_connections(line_stop*& head, graph& to_find)
{
	if(head == NULL)
	{
		return;
	}	
	if(head->stop_location->get_occupied()!=0)
	{
//		cout<<"Line connection has been found."<<endl;
//		cin.get();			
		to_find.check_streetcar_connections(head);			
	}
//	cout<<"Checking next stop."<<endl;
	check_streetcar_connections(head->next,to_find);
}



/*
   This function displays all stops on the line linked list from the last node to the first.
INPUT: LINE STOP TO RECUSRIVELY TRAVERSE THE LIST AND A NUMBER TO DISPLAY A STOP NUMBER.
OUTPUT: NONE
 */
void line_stop::display_return_trip(line_stop*& end, int return_stop_num)
{
	if(!end)
	{
		return;
	}
	cout<<"Stop "<<end->stop_num+return_stop_num<<": ";
	end->stop_location->display_location();
	cout<<" Southbound"<<endl;
	display_return_trip(end->prev,return_stop_num+2);
}



/*
   This function location gets the location that a lie stop is pointing to.
INPUT: LOCATION PASSES BY REFERNCE
OUTPUT: NONE
 */
void line_stop::get_stop_location(location*& get_location)
{
	get_location = stop_location;
}



/*
   This function returns a line stop's stop number.
INPUT: NONE
OUTPUT: AN INTEGER THAT IS A STOP NUMBER.
 */
int line_stop::get_stop_num()
{
	return stop_num;
}



/*
   This function allows the line class to get a line stop in an entire line.
INPUT: A LINE STOP TO TRAVERSE BY ONE.
OUTPUT: NONE
 */
void line_stop::next_stop(line_stop*& head)
{
	head = next;
}



/*
This function will move the streetcar on the line if there is one on the line.
INPUT:A LINE STOP POINTER AND A GRAPH OBJECT
OUTPUT: NONE
*/
void line_stop::move_all_streetcars(line_stop*& current, graph& map_one, bool has_moved)
{
	streetcar* tempcar = NULL;
	char* temp_name = new char[2000];
	if(has_moved == true||!current)
	{
		if(temp_name)
		{
			delete[] temp_name;
			temp_name = NULL;
		}
		return;
	}	
	if(current->stop_location->get_occupied()!=0)
	{
		map_one.get_streetcar(tempcar, current->stop_location->get_occupied()-1);
		tempcar->get_name(temp_name);
		if(!current->next && tempcar->get_on_return_trip_for_line()==false)//end of there trip.
		{
//			tempcar->get_name(temp_name);
			cout<<temp_name<<" has begun its return trip."<<endl;
			tempcar->set_return_trip(true);
			has_moved = true;
		}
		else if(!current->prev && tempcar->get_on_return_trip_for_line()==true)//end of return trip.
		{
//			tempcar->get_name(temp_name);
			cout<<temp_name<<" has completed the line."<<endl;
			tempcar->set_return_trip(false);
			has_moved = true;	
		}
		else if(current->next && tempcar->get_on_return_trip_for_line()==false)
		{
			current->next->stop_location->set_occupied(current->stop_location->get_occupied());
			current->stop_location->set_occupied(0);
			tempcar->set_at_line_stop(current->next);
			cout<<temp_name<<" has moved to the next stop."<<endl;
			has_moved = true;
		}
		else if(current->prev && tempcar->get_on_return_trip_for_line()==true)
		{
			current->prev->stop_location->set_occupied(current->stop_location->get_occupied());
			current->stop_location->set_occupied(0);
			tempcar->set_at_line_stop(current->prev);
			cout<<temp_name<<" has moved to the next stop."<<endl;	
			has_moved = true;
		}
		else
		{
			cout<<temp_name<<" could not be moved at the moment."<<endl;
			has_moved = true;
		}
	}	
	if(temp_name)
	{
		delete[] temp_name;
		temp_name = NULL;
	}
	move_all_streetcars(current->next, map_one, has_moved);
}



/*
   This function will destroy all loop stops in an entire loop recursively.
INPUT: A LOOP STOP AND A TAIL NODE
OUTPUT: NONE
 */
void loop_stop::destroy_all_loop_stops(loop_stop*& head, loop_stop*& tail)
{
	if(head == tail)
	{
		head->next = NULL;
		if(tail)
		{
			delete tail;
		}
		return;
	}
	destroy_all_loop_stops(head->next,tail);
	if(head)
	{
		delete head;
		head = NULL;
	}
}



/*
   This function adds to the loop creating a new stop.
INPUT: THREE LOOP STOPS 
OUTPUT: NONE
 */
void loop_stop::connection_addition(loop_stop*& to_add,loop_stop*& beginning_stop, loop_stop*& tail)
{
	tail->next = to_add;
	to_add->next = beginning_stop;
	tail = to_add;
} 



/*
   This function will display all stops on a loop.
INPUT: TWO LOOP STOP POINTERS
OUTPUT: NONE
 */
void loop_stop::display_all_stops(loop_stop*& current,loop_stop*& head)
{
	if(current->next == head)
	{

		cout<<"Stop "<<current->stop_num<<": ";
		current->stop_location->display_location();
		cout<<endl;
		return;
	}
	cout<<"Stop "<<current->stop_num<<": ";
	current->stop_location->display_location();
	cout<<endl;
	display_all_stops(current->next,head);
}



/*
   This function allows the loop to get the next loop stop in the list.
INPUT: LOOP STOP
OUTPUT: NONE
 */
void loop_stop::next_stop(loop_stop*& head)
{
	head = next;
}



/*
   This function will retrieve the stop location in a loop stop.
INPUT: A LOCATION POINTER
OUTPUT: NONE
 */
void loop_stop::get_stop_location(location*& get_location)
{
	get_location = stop_location;
}



/*
   This function will create and check all connections that sreetcars have to see if there are any occupations.
INPUT: TWO LOOP STOPS AND A GRAPH
OUTPUT: NONE
 */
void loop_stop::check_streetcar_connections(loop_stop*& head, loop_stop*& tail, graph& to_find)
{
	if(head == tail)
	{
		if(head->stop_location->get_occupied() !=0)
		{
//			cout<<"Found an occupied stop, about to search for streetcar"<<endl;
		//	cin.get();
			to_find.check_streetcar_connections(head);			
		}
	//	cout<<"Connection check complete, returning to main menu"<<endl;
		return;	
	}
	if(head->stop_location->get_occupied() !=0)
	{
//		cout<<"Found an occupied stop, about to search for streetcar"<<endl;
//		cin.get();
		to_find.check_streetcar_connections(head);			
	}
//	cout<<"Checking next stop"<<endl;
	check_streetcar_connections(head->next, tail, to_find);
}



/*
   This function will retrieve the stop number of a loop stop.
INPUT: NONE
OUTPUT: AN INTEGER
 */
int loop_stop::get_stop_num()
{
	return stop_num;
}



/*
   This moves all streetcars that are active in the loop. 
INPUT: TWO LOOP STOP POINTERS AND A GRAPH, AND A BOOL, and a pointer to an array of stretcar pointers..
OUTPIT: NONE
 */
void loop_stop::move_all_streetcars(loop_stop*& current, loop_stop*& head, graph& map_one, bool first_head, streetcar**& move_list)
{
//	streetcar* tempcar = NULL;
	char* temp_name = new char[2000];
	loop_stop* temp = NULL;
	if(current == head && first_head == true)
	{
		for(int i=0; i < map_one.get_all_cars_size();i++)
		{
			if(move_list[i])
			{
				move_list[i]->get_at_loop_stop(temp);
				temp->next_stop(temp);
				move_list[i]->set_at_loop_stop(temp);			
				temp->stop_location->set_occupied(move_list[i]->getID());
				move_list[i]->get_name(temp_name);
				cout<<temp_name<<" has moved to the next stop."<<endl;
			}
		}
		if(temp_name)
		{
			delete[] temp_name;
			temp_name = NULL;
		}
		return;
	}	
	if(current->stop_location->get_occupied()!=0)
	{
		for(int i=0; i < map_one.get_all_cars_size();i++)
		{
			if(!move_list[i])
			{
				map_one.get_streetcar(move_list[i],current->stop_location->get_occupied()-1);	
				i= map_one.get_all_cars_size();
			}
		}
	}	
	first_head = true;
	if(temp_name)
	{
		delete[] temp_name;
		temp_name = NULL;
	}
	current->stop_location->set_occupied(0);// delete this later possibly
	move_all_streetcars(current->next, head, map_one, first_head, move_list);
}



/*
   This function will add a stp to a line.
INPUT: A LOCATION POINTER
OUTPUT: NONE
 */
void line::add_stop(location*& location_for_stop)
{
	//	line_stop* temp = NULL;
	++num_of_stops;
	//	cout<<"Line stop number added up "<<num_of_stops<<endl;
	line_stop* new_stop = new line_stop(location_for_stop,num_of_stops);
	if(!beginning_stop)
	{
		beginning_stop = new_stop;	
	}
	else
	{
		beginning_stop->connection_addition(new_stop, beginning_stop);
		/*		new_stop->next = beginning_stop; 
				beginning_stop ->prev = new_stop;
				beginning_stop = new_stop;*/
	}
}



/*
   This function displays all stops in a line.
INPUT: NONE
OUTPUT: NONE
 */
void line::display_all_stops()
{
	beginning_stop->display_there_trip(beginning_stop);
}



/*
   This is a wrapper for check streetcar connections for a line.
INPUT: GRAPH
OUTPUT: NONE
 */
void line::check_streetcar_connections(graph& to_find)
{
//	cout<<"Beginning to check streetcar connectons for line one."<<endl;
	beginning_stop->check_streetcar_connections(beginning_stop,to_find);
}



/*
   This function will retrieve the first stop in the line.
INPUT: A LINE STOP POINTER
OUTPIT:NONE
 */
void line::get_beginning_stop(line_stop*& to_get)
{
	to_get = beginning_stop;
}



/*This function acts as a wrapper to move the streetcar on line one.
INPUT: A GRAPH OBJECT
OUTPUT: NONE
*/
void line::move_streetcars(graph& map_one)
{
	move_all_streetcars(beginning_stop, map_one, false);	
}
/*
   This function adds a stop to a loop.
INPUT: A LOCATION POINTER
OUTPUT: NONE
 */
void loop::add_stop(location*& location_for_stop)
{
	++num_of_stops;
	//	cout<<"Loop stop number added up "<<num_of_stops<<endl;
	loop_stop* new_stop = new loop_stop(location_for_stop,num_of_stops);
	if(!beginning_stop || !tail)
	{
		if(!beginning_stop)
		{
			beginning_stop = new_stop;
		}
		if(!tail)
		{
			tail = new_stop;
		}
	}
	else
	{
		beginning_stop->connection_addition(new_stop, beginning_stop, tail);
	}
}



/*
   This function displays all stops in a loop.
INPUT: NONE
OUTPUT: NONE
 */
void loop::display_all_stops()
{
	beginning_stop->display_all_stops(beginning_stop, beginning_stop);
}



/*
   This function is a wrapper to check streecar connections of a loop.
INPUT: A GRAPH
OUTPIT: NONE
 */
void loop::check_streetcar_connections(graph& to_find)
{
//	cout<<"Beginning to check streetcar connections for loop one."<<endl;
	beginning_stop->check_streetcar_connections(beginning_stop, tail, to_find);	
}



/*
   This function will get the first stop of a loop.
INPUT: A LOOP STOP
OUTPUT: NONE
 */
void loop::get_beginning_stop(loop_stop*& to_get)
{
	to_get = beginning_stop;
}



/*
   This is a fucntion that is a wrapper to move all of the streetcars in the loop.
INPUT: A GRAPH
OUTPIT: NONE
 */
void loop::move_streetcars(graph& map_one)
{
	cout<<"Moving all streetcars"<<endl;
	streetcar** move_list = new streetcar*[map_one.get_all_cars_size()];
	for(int i=0; i < map_one.get_all_cars_size();i++)
	{
		move_list[i] = NULL;
	}
	move_all_streetcars(beginning_stop, beginning_stop, map_one, false, move_list);	
/*	for(int i=0; i < map_one.get_all_cars_size();i++)
	{
		if(move_list[i])
		{
		delete move_list[i];
		move_list[i] = NULL;
		}
	}*/
	delete[] move_list;
}
