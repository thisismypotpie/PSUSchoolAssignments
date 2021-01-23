/*
   Brandon Danielski
   1/31/2017
   CS202 
   Asignment 1
   This is the .cpp file for my location and graph classes.  The location class acts as the adjacents to the graph class.  The graph class handles two adjacency lists, streetcars ad locations.  the graph acts as a base class since it has a hand in every class except the app class.
 */
#include <cstring>
#include<fstream>
#include<iostream>
#include "location.h"
#include "streetcar.h"
#include "stop.h"
using namespace std;



/*
   This is the default constructor for the location class.  It allocates memory for the name of the location.
INPUT: NONE
OUTPUT: NONE */
location::location(): occupied(0)
{
	//	cout<<"starting defualt constructor"<<endl;
	name = new char[2000];
}



/*
   This is a non-default constructor the the location class, it takes in a name and an ID of a streetcar at that location.
INPUT: A CHAR AND AN INT
OUTPUT: NONE 
 */
location::location(char* new_name, int new_occupied): occupied(new_occupied)
{
	//	cout<<"non defualt constuctor started."<<endl;
	//	cout<<"new name: "<<new_name<<endl;
	name = new char[2000];
	strcpy(name, new_name);
	//	cout<<"location constructed"<<endl;
}



/*
   This is a copy constructor for the location class it takes in a new location that then copies information to it.
INPUT: LOCATION OBJECT PASSED BY REFERENCE
OUTPUT: NONE
 */
location::location(location& copy_to):occupied(0)
{
	//	cout<<"starting copy contructor."<<endl;
	name = new char[2000];
	copy_location(copy_to);
}



/*
   This is the destructor for the location class.  It deletes any allocated memory caused by a location object.
INPUT: NONE
OUTPUT:NONE
 */
location::~location()
{
	if(name)
	{
		//		cout<<"deleteing location name: "<<name<<endl;
		delete[] name;
	}
}



/*
   This is the default constructor for the graph class, it sets the size of the locaton and streetcar adjacency lists.
INPUT: NONE
OUTPUT: NONE
 */
graph::graph(): adj_list_size(30), all_cars_size(8)
{
	adj_list = new location*[adj_list_size];
	for(int i =0; i < adj_list_size; i++)
	{
		//		cout<<"index "<<i<<" for location is now null."<<endl;
		adj_list[i] = NULL;
	}

	all_cars = new streetcar*[all_cars_size];
	for(int i=0; i < all_cars_size; i++)
	{

		//		cout<<"index "<<i<<" for streetcars is now null."<<endl;
		all_cars[i] = NULL;
	}
}




/*
   This is the destructor for my graph class. It destroys all allocated memory caused by the graph class.
INPUT: NONE
OUTPUT: NONE */
graph::~graph()
{
	for(int i=0; i < adj_list_size; i++)
	{
		if(adj_list[i])
		{
			//			cout<<"deleting adj list index "<<i<<endl;
			delete adj_list[i];
		}
	}

	for(int i=0; i < all_cars_size; i++)
	{
		if(all_cars[i])
		{
			//			cout<<"deleteing all cars index "<<i<<endl;
			delete all_cars[i];
		}
	}
	//	cout<<"Deleting all cars"<<endl;
	delete[] all_cars;
	//	cout<<"Deleting adj list"<<endl;
	delete[] adj_list;
}




/*
   This function copies the information from this location to a new one passed in by reference.
INPUT: A LOCATION OBJECT 
OUTPUT: NONE */
void location::copy_location(location& copy_to)
{
	//cout<<"copy function started"<<endl;
	//cout<<"Name to copy is: "<<copy_to.name<<endl;
	strcpy(name,copy_to.name); 
	//cout<<"Name is now:"<<name<<endl;
	occupied = copy_to.occupied;
	//cout<<"copy function ended"<<endl;
}




/*
   This function displays all information from the location class for the user to see.
INPUT: NONE
OUTPUT: NONE
 */
void location::display_location()
{
	cout<< name;
	//	cout<<occupied<<endl;
}



/*
   This function returns the occupied integer, which is an ID for a streetcar.
INPUT: NONE
OUTPUT: AN INTEGER
 */
int location::get_occupied()
{
	return occupied;
}



/*
   This function sets the occupied integer to the input integer.
INPUT: AN INTEGER
OUTPUT: NONE
 */
void location::set_occupied(int new_occ)
{
	occupied = new_occ;
}



/*
   This function strcpy's the contents of a char array to a new char array through passing by reference.
INPUT: A CHAR ARRAY
OUTPUT: NONE 
 */
void location::get_name(char*& new_name)
{
	strcpy(new_name, name);
}



/*
   This function takes all info from both expernal data files used in the program and populates itself with the information within through passes by reference.
INPUT: TWO CHAR ARRAYS AND A GRAPH OBJECT
OUTPUT: NONE
 */
void graph::load_locations_and_streetcars(char* location_file_name, char* streetcar_file_name, graph& add_info)
{
	ifstream datafile;
	char* new_name = new char[2000];
	char* new_online = new char[2000];
	char* return_trip = new char[2000];
	int new_ID = 0;
	datafile.open(location_file_name);
	if(datafile.is_open())
	{
		while(!datafile.eof())
		{	
			datafile.getline(new_name,2000);
			if(*(new_name + strlen(new_name)-1)==13)
			{
				*(new_name + strlen(new_name)-1)=0;
			}
			//		cout<<"new name before creating an object is: "<<new_name<<endl;
			datafile >> new_ID;
			datafile.ignore();
			location new_location(new_name,new_ID);
			//		cout<<"New location created, the name is :";
			//		new_location.display_location();
			//		cout<<endl;
			if(add_info.add_location(new_location)==false)
			{
				//			cout<<"There is no more room in the graph to add more locations."<<endl;	
				break;
			}
			//		cout<<"new location added"<<endl;
			//		cin.get();
		}
	}
	else
	{
		cout<<"Locations file not found."<<endl;
	}
	datafile.close();
	datafile.clear(ios_base::goodbit);
	//cout<<"location loading complete"<<endl;
	/*for(int i=0; i < adj_list_size;i++)
	  {
	  if(adj_list[i])
	  {
	  adj_list[i]->display_location();
	  }
	  }*/
	datafile.open(streetcar_file_name);
	if(datafile.is_open())
	{
		while(!datafile.eof())
		{
			datafile.getline(new_name,2000);
			datafile>>new_ID;
			datafile.ignore();
			//	datafile.getline(new_online,2000);
			datafile.getline(return_trip, 2000);
			streetcar new_car(new_name,new_ID,false,false);
			/*		if(strcmp(new_online,"true")==0)
					{
					cout<<"setting online to true"<<endl;
					cin.get();
					new_car.set_online(true);	
					}*/
//			cout<<"Return trip for: "<<new_name<<" is: "<<return_trip<<endl;
			if(strcmp(return_trip,"true")==0)
			{
//				cout<<"setting return trip to true."<<endl;
//				cin.get();
				new_car.set_return_trip(true);
			}
			if(add_info.add_streetcar(new_car)==false)
			{
				//			cout<<"There is no more room in the graph to add more streetcars."<<endl;
				break;
			}		
		}
	}
	datafile.close();
	datafile.clear(ios_base::goodbit);
	//cout<<"streetcar loading complete"<<endl;
	/*for(int i=0; i < all_cars_size;i++)
	  {
	  if(all_cars[i])
	  {
	  all_cars[i]->display_streetcar();
	  }
	  }*/
	if(new_name)
	{
		//	cout<<"deleteing new name"<<endl;
		delete[] new_name;
	}
	if(new_online)
	{
		delete[] new_online;
	}
	if(return_trip)
	{
		delete[] return_trip;
	} 
} 



/*
   This function adds a location to the adjacency list by checking if there is room in the list for the new location.
INPUT: A LOCATION OBJECT
OUTPUT: A BOOL TO REPORT IF THERE WAS ROOM IN THE ADJACENCY LIST OR NOT.  
 */
bool graph::add_location(location& add_location)
{
	bool space_found_for_new_location = false;
	for(int i=0; i<adj_list_size;i++)
	{
		if(!adj_list[i])
		{	
			//			cout<<"Space found at array index: "<<i<<endl;
			//Thirty new allocations for locations here.
			adj_list[i] = new location(add_location);
			//			adj_list[i]->copy_location(add_location);
			//			adj_list[i] = new location();
			//			adj_list[i]->copy_location(add_location);
			space_found_for_new_location = true;
			i = adj_list_size;
		}
		/*		else
				{
				cout<<"Index: "<<i<<" is occupied"<<endl;
				}*/
	}
	//	cout<<"returning: "<<space_found_for_new_location<<endl;
	return space_found_for_new_location;
}



/*
   This function checks to see if there is room for a new streetcar on the streetcar adjacency list.
INPUT: A STREETCAR OBJECT
OUTPUT: A BOOL TO REPORT IF THERE IS ROOM IN THE ADJACENCY LIST.
 */
bool graph::add_streetcar(streetcar& add_car)
{
	bool space_found_for_new_car = false;
	for(int i=0; i<all_cars_size;i++)
	{
		if(!all_cars[i])
		{
			// Eight new allocations for streetcars here.
			all_cars[i] = new streetcar(add_car);
			space_found_for_new_car = true;
			i = all_cars_size;
		}
	}
	return space_found_for_new_car;
}



/*
   This function is a wrapper to add a stop to a line.
INPUT: A LINE TO ADD TO, AND AN INTEGER TO ACT AS AN INDEX FOR WHICH ELEMENT OF THE ADJACENCY LIST TO ADD TO.
OUTPUT: NONE
 */
void graph::add_location_reference_for_line_stop(line& to_add, int adj_list_index)
{
	to_add.add_stop(adj_list[adj_list_index]);
}



/*
   This function is a wrapper to add a stop to a loop.
INPUT: A LOOP TO ADD TO, AND AN INTGER TO ACT AS AN INDEX FOR WHICH ELEMENT OF TH ADJACENCY LIST TO ADD TO.
OUTPUT: NONE
 */
void graph::add_location_reference_for_loop_stop(loop& to_add, int adj_list_index)
{
	to_add.add_stop(adj_list[adj_list_index]);
}



/*
   This function displays all locations in the adjacency list.
INPUT: NONE
OUTPUT: NONE
 */
void graph::display_all_locations()
{
	for(int i=0; i < adj_list_size; i++)
	{
		adj_list[i]->display_location();
	}
}



/*
   This function displays all streetcars in the streetcar adjacency list.
INPUT: NONE
OUTPUT: NONE
 */
void graph::display_all_streetcars()
{
	for(int i=0; i < all_cars_size;i++)
	{
		all_cars[i]->display_streetcar();
	}
}




/*
   This function displays all streetcars that are not active on either line one or loop one.
INPUT: NONE
OUTPUT: A BOOL TO REPORT IF THERE IS NO OFFLINE STREETCARS.
 */
bool graph::display_offline_streetcars()
{
	bool found = false;
	int total_offline_cars =0;
	for(int i=0; i < all_cars_size; i++)
	{
		if(all_cars[i]->get_online_status()==false)
		{
			all_cars[i]->display_streetcar_as_option();
			found = true;
		}	
	}
	return found;
}



/*
   This function will display all streetcars on loop one.
INPUT: NONE
OUTPUT:  A BOOL TO REPORT IF THERE ARE NO ONLINE STREETCARS.
 */
bool graph::display_online_streetcars_loop()
{
	bool found = false;
	for(int i=0; i<all_cars_size;i++)
	{
//		cout<<"online bool status: "<<all_cars[i]->get_online_status()<<endl;
//		cout<<"one loop one: "<<all_cars[i]->on_loop_one()<<endl;
		if(all_cars[i]->get_online_status() == true && all_cars[i]->on_loop_one() == true)
		{
			all_cars[i]->display_streetcar_as_option();
			found = true;
		}
	}	
	return found;
}



/*
   This function displays all streetcars that are active on line one.
INPUT: NONE
OUTPUT: A BOOL TO REPORT IF THRE ARE NO ONLINE STREETCARS.
 */
bool graph::display_online_streetcars_line()
{
	bool found = false;
	for(int i=0; i<all_cars_size;i++)
	{
		if(all_cars[i]->get_online_status() == true && all_cars[i]->on_line_one() == true)
		{
			all_cars[i]->display_streetcar_as_option();
			found = true;
		}
	}	
	return found;
}



/*
   when a location class has an ID of a stretcar to signify that a streetcar is there, this function will search the entire streetcar adjacency list to find a streetcar with a matching ID number.  This function does that for loops.
INPUT: A POINTER TO A STOP ALONG A LOOP.
OUTPUT: NONE
 */
void graph::check_streetcar_connections(loop_stop*& head)
{
	location* temp = NULL;
	head->get_stop_location(temp);
	for(int i=0; i < all_cars_size; i++)
	{
//		cout<<"Checking streetcar ID: "<<i+1<<endl;
		if(temp->get_occupied() == all_cars[i]->getID())
		{
//			cout<<"streetcar found, setting loop stop for streetcar: "<<endl;
//			all_cars[i]->display_streetcar();
//			cout<<endl;
//			cin.get();
			all_cars[i]->set_at_loop_stop(head);
			all_cars[i]->set_online(true);
			i = all_cars_size;
		}
	}	
}



/*
   when a location class has an ID of a stretcar to signify that a streetcar is there, this function will search the entire streetcar adjacency list to find a streetcar with a matching ID number.  This function does that for lines.
INPUT: A POINTER TO A STOP ALONG A LINE.
OUTPUT: NONE
 */
void graph:: check_streetcar_connections(line_stop*& head)
{
	location* temp = NULL;
	head->get_stop_location(temp);
	for(int i=0; i < all_cars_size;i++)
	{
//		cout<<"Checking streetcar ID: "<<i+1<<endl;
		if(temp->get_occupied() == all_cars[i]->getID())
		{
//			cout<<"streetcar found , setting line stop for streetcar: "<<endl;
			//all_cars[i]->display_streetcar();
		//	cout<<endl;
			//cin.get();
			all_cars[i]->set_at_line_stop(head);
			all_cars[i]->set_online(true);
			i = all_cars_size;
		}
	}
}



/*
   This function will bring an offline streetcar onto loop one.
INPUT: AN INT THAT ACTS AS A INEX FOR THE STREETCAR ADJACENCY LIST AND A LOOP TO ADD THAT STREETCAR TO.
OUTPUT: NONE
 */
void graph:: bring_loop_car_online(int check_ID, loop& add_loop)
{
	loop_stop* temp = NULL;
	location* temp_loc = NULL;
	char* temp_name = new char[2000];
	if(check_ID > all_cars_size)
	{
		cout<<"The number you have put in is invalid, please try again.  Returning to main menu."<<endl;
		cout<<"Press any key to continue."<<endl;
		cin.get();
		if(temp_name)// if something goes wrong with a double free, delete this block.
		{
			delete[] temp_name;
		}
		return;
	}
	if(all_cars[check_ID-1]->get_online_status()==false)
	{
		add_loop.get_beginning_stop(temp);
		temp -> get_stop_location(temp_loc);
		if(temp_loc->get_occupied()==0)
		{
			all_cars[check_ID-1]->set_online(true);
			all_cars[check_ID-1]->set_at_loop_stop(temp);		
			temp_loc->set_occupied(all_cars[check_ID-1]->getID());
			all_cars[check_ID-1]->get_name(temp_name);
			cout<< temp_name<<" is now online."<<endl;
			cin.get();
		}
		else
		{
			cout<<" There is a streetcar at the beginning loop stop.  You must move the streetcar there first in order to move your car online.  Returning to main menu."<<endl;
			cout<<"Press any key to continue."<<endl;
			cin.get();
		}

	}
	else if(all_cars[check_ID-1]->get_online_status()==true)
	{
		cout<<"The street car for the ID you have entered is already online. Returning to main menu."<<endl;
		cout<<"Press any key to continue."<<endl;
		cin.get();
	}
	else
	{
		cout<<"Error: The number you have entered does not register with any ID number of any streetcar.  Returning you to main menu."<<endl;
		cout<<"Press any key to continue."<<endl;
		cin.get();
	}
	if(temp_name)
	{
		delete[] temp_name;
	}
}



/*
   This function will bring an offline streetcar onto line one.
INPUT: AN INT TO INDEX THE STREETCAR ADJACENCY LIST AND A LINE TO PUT THAT STREETCAR ON.
OUTPUT: NONE
 */
void graph::bring_line_car_online(int check_ID, line& add_line)
{
	line_stop* temp = NULL;
	location* temp_loc = NULL;
	char* temp_name = new char[2000];
	if(check_ID > all_cars_size)
	{
		cout<<"The number you have put in is invalid, please try again.  Returning to main menu."<<endl;
		cout<<"Press any key to continue."<<endl;
		cin.get();
		if(temp_name)//added this here to prevnt leak.
		{
			delete[] temp_name;
		}
		return;
	}
	if(all_cars[check_ID-1]->get_online_status()==false)
	{
		add_line.get_beginning_stop(temp);
		while(temp)
		{
			temp->get_stop_location(temp_loc);
			if(temp_loc->get_occupied()==1)
			{
				cout<<"There is already a streetcar on line one.  If there were another the two would crash.  Please take the streetcar on line one offline before putting a new one online."<<endl;
				cin.get();
		if(temp_name)//added this here to prevnt leak.
		{
			delete[] temp_name;
		}
				return;
			}
			temp->next_stop(temp);	
		}	
		all_cars[check_ID-1]->set_online(true);
		add_line.get_beginning_stop(temp);
		temp->get_stop_location(temp_loc);
//		cout<<"stop num being stored: "<<temp->get_stop_num()<<endl;
		all_cars[check_ID-1]->set_at_line_stop(temp);		
		temp_loc->set_occupied(all_cars[check_ID-1]->getID());
		all_cars[check_ID-1]->get_name(temp_name);
		cout<< temp_name<<" is now online."<<endl;
		cin.get();

	}
	else if(all_cars[check_ID-1]->get_online_status()==true)
	{
		cout<<"The street car for the ID you have entered is already online. Returning to main menu."<<endl;
		cout<<"Press any key to continue."<<endl;
		cin.get();
	}
	else
	{
		cout<<"Error: The number you have entered does not register with any ID number of any streetcar.  Returning you to main menu."<<endl;
		cout<<"Press any key to continue."<<endl;
		cin.get();
	}
	if(temp_name)
	{
		delete[] temp_name;
	}
}



/*
   This function will bring on online streetcar from a loop offline.
INPUT: AN INTEGER TO USE AS AN INDEX FOR THE STREETCAR ADJACENCY LIST.
OUTPUT: NONE
 */
void graph:: bring_loop_car_offline(int check_ID)
{
	loop_stop* temp_at_loop_stop = NULL;
	location* temp_loc = NULL;
	//	loop_stop* null_loop_stop = NULL;
	//	line_stop* null_line_stop = NULL;
	if(all_cars[check_ID-1]->get_online_status()==false)
	{
		cout<<"The streetcar you have selected is aleady offline."<<endl;
		/*	if(temp_at_loop_stop)
			{
			delete temp_at_loop_stop;
			}
			if(temp_loc)
			{
			delete temp_loc;
			}*/
		return;
	}
	all_cars[check_ID-1]->set_online(false);
	if(all_cars[check_ID-1]->get_online_status() == true)
	{
		cout<<"Streetcar is still online."<<endl;
	}
	all_cars[check_ID-1]->set_return_trip(false);
	all_cars[check_ID-1]->get_at_loop_stop(temp_at_loop_stop);
	if(!temp_at_loop_stop)
	{
		cout<<"temp at loop stop is null"<<endl;
	}
	temp_at_loop_stop->get_stop_location(temp_loc);
	if(!temp_loc)
	{
		cout<<"loc is still null."<<endl;
	}
	temp_loc->set_occupied(0);
	if(temp_loc->get_occupied() !=0)
	{
		cout<<"occupied not set to zero."<<endl;
	}
	all_cars[check_ID-1]->set_at_to_null();
	/*	all_cars[check_ID-1]->set_at_loop_stop(null_loop_stop);
		all_cars[check_ID-1]->set_at_line_stop(null_line_stop);	*/	
	/*	if(temp_at_loop_stop)
		{
		delete temp_at_loop_stop;
		}
		if(temp_loc)
		{
		delete temp_loc;
		}*/
	cout<<"car offline complete."<<endl;
}



/*
   This funtion will being an online streetcar of a line offline.
INPUT: AN INT TO USE AS AN INDEX FOR THE STREETCAR ADJACENCY LIST.
OUTPUT: NONE
 */
void graph::bring_line_car_offline(int check_ID)
{
	line_stop* temp_at_line_stop = NULL;
	location* temp_loc = NULL;
	if(all_cars[check_ID-1]->get_online_status()==false)
	{
		cout<<"The streetcar you have selected is already offline."<<endl;
		return;
	}	
	all_cars[check_ID-1]->set_online(false);
	all_cars[check_ID-1]->set_return_trip(false);
	all_cars[check_ID-1]->get_at_line_stop(temp_at_line_stop);
	temp_at_line_stop->get_stop_location(temp_loc);
	temp_loc->set_occupied(0);
	all_cars[check_ID-1]->set_at_to_null();


}



/*
   This function writes to the data files and is run right before the program terminates.
INPUT: TWO CHAR ARRAYS
OUTPUT: NONE
 */
void graph::close_program(char*location_file_name, char* streetcar_file_name)
{
	char* temp_name = new char[2000];
	ofstream datafile;
	datafile.open(location_file_name);
	if(datafile.is_open())
	{
		for(int i=0; i < adj_list_size;i++)
		{
			adj_list[i]->get_name(temp_name);
//			cout<<"temp name is now "<<temp_name<<endl;
			datafile<<temp_name<<endl;
			datafile<<adj_list[i]->get_occupied()<<endl;			
			//	cout<<"get occupied is: "<<adj_list[i]->get_occupied()<<endl;
		}
	}
	datafile.close();		
	datafile.clear(ios_base::goodbit);
	datafile.open(streetcar_file_name);
	if(datafile.is_open())
	{
		for(int i=0; i < all_cars_size;i++)
		{
			all_cars[i]->get_name(temp_name);
			datafile<<temp_name<<endl;
			datafile<<all_cars[i]->getID()<<endl;
			if(all_cars[i]->get_on_return_trip_for_line()==true)
			{
				datafile<<"true"<<endl;
			}
			else
			{
				datafile<<"false"<<endl;
			}
		}
	}
	datafile.close();
	datafile.clear(ios_base::goodbit);
	if(temp_name)
	{
		delete[] temp_name;
	}
}



/*
This function is used to copy a streetcar to another passed by reference.
INPUT: STREETAR POINTER AND AN INTEGER
OUTPUT: NONE
*/
void graph::get_streetcar(streetcar*& to_get, int index)
{
	to_get = all_cars[index];	
}



/*
This function is used to return the size of the streetcar adj list.
INPUT: NONE
OUTPUT: AN INTEGER
*/
int graph:: get_all_cars_size()
{
	return all_cars_size;
}
