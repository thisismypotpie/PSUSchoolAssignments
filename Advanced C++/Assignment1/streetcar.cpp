/*
Brandon Danielski
1/31/2017
CS202 
Asignment 1
This is the streetcar .cpp file of the program.
*/

#include "streetcar.h"
#include <cstring>
#include<iostream>
using namespace std;



/*
This function is the default constructor for the streetcar.
INPUT: NONE
OUTPUT: NONE
*/
streetcar::streetcar() : ID(0),online(false),at_line_stop(NULL), at_loop_stop(NULL), on_return_trip_for_line(false)
{
	name = new char[2000];
}



/*
This is a non defualt constructor for a streetcar.
INPUT: A CHAR ARRAY, AN INTEGER, AND TWO BOOLS
OUTPUT: NONE
*/
streetcar::streetcar(char* new_name, int new_ID, bool new_online, bool return_trip): ID(new_ID),online(new_online) ,at_line_stop(NULL),at_loop_stop(NULL), on_return_trip_for_line(return_trip)
{
	name = new char[2000];
	strcpy(name, new_name);
}



/*
This is a copy constructor for the streetcar.
INPUT: A STREETCAR OBJECT
OUTPUT: NONE
*/
streetcar::streetcar(streetcar& copy_to): ID(0),online(false),at_line_stop(NULL),at_loop_stop(NULL), on_return_trip_for_line(false)
{
	name = new char[2000];
	copy_streetcar(copy_to);
}



/*
This is the destuctor for the streetcar.
INPUT: NONE
OUTPUT: NONE
*/
streetcar:: ~streetcar()
{
	if(name)
	{
//		cout<<"Deleting streetcar name: "<<name<<endl;
		delete[] name;
	}
	at_line_stop = NULL;
	at_loop_stop = NULL;
	//add a deletion for the two pointers in this class later on.
}



/*
This function will copy a streetcar that is input into the function
INPUT: STREETCAR OBJECT
OUTPUT: NONE
*/
void streetcar::copy_streetcar(streetcar& copy_to)
{
	ID = copy_to.ID;
	online = copy_to.online;
	on_return_trip_for_line = copy_to.on_return_trip_for_line;
	strcpy(name,copy_to.name);
	at_line_stop = copy_to.at_line_stop;
	at_loop_stop = copy_to.at_loop_stop;
}



/*
This function is

void streetcar::copy_streetcar(streetcar*& copy_to)
{

	copy_to->ID = ID;
	copy_to->online = copy_to;
	copy_to->on_return_trip_for_line = on_return_trip_for_line;
	strcpy(name,copy_to->name);
	copy_to->at_line_stop=at_line_stop;
	copy_to->at_loop_stop=at_loop_stop;
}*/



/*
This function displays a streetcar.
INPUT: NONE
OUTPIT: NONE
*/
void streetcar:: display_streetcar()
{
	cout<<"--------------------------------------"<<endl;
	cout<<"Streetcar Name: "<<name<<endl;
	cout<<"Streetcar ID: "<<ID<<endl;
//	cout<<"on_return_trip_for_line is: "<< on_return_trip_for_line<<endl;
	if(online == true)
	{
	//	cin.get();
		cout<<"Status: Online";
		if(at_line_stop && !at_loop_stop)
		{
			cout<<" at line one, stop number: ";
			if(on_return_trip_for_line == true)
			{
				cout<<20- at_line_stop->get_stop_num()+1<<endl;
			}	
			else
			{
				cout<<at_line_stop->get_stop_num()<<endl;
			}
		}
		//even when set the true the stop num +10 does not work, check streetcar one.
		else if(!at_line_stop && at_loop_stop)
		{
			cout<<" at loop one, stop number: "<<at_loop_stop->get_stop_num()<<endl;
		}
		else
		{
			cout<<" error!  Online on both loop one and line one"<<endl;
		}
	}
	else
	{
		cout<<"Status: Offline"<<endl;
	}
	cout<<"--------------------------------------"<<endl;
}



/*
This function is to set the online bool of a streetcar.
INPUT: BOOL
OUTPUT: NONE
*/
void streetcar::set_online(bool new_online)
{
	online = new_online;
	//cout<<"online is now: "<<online<<endl;
}


/*
This function will retireve the online status of the streetcar.
INPUT: NONE
OUTPUT: BOOL
*/
bool streetcar:: get_online_status()
{
	return online;
}



/*
This functon 

void streetcar::go_online_loop(loop_stop*& to_add)
{
	if(online == true)
	{
		cout<<"The streetcar you have chosen is already oneline, returning to main menu."<<endl;
		return;
	}
}*/



/*
This function returns the id number of the streetcar.
INPUT: NONE
OUTPUT: INTEGER
*/
int streetcar::getID()
{
	return ID;
}



/*
This function sets the at loop stop for a streetcar.
INPUT: A LOOP STOP POINTER
OUTPUT: NONE
*/
void streetcar::set_at_loop_stop(loop_stop*& to_add)
{
	at_loop_stop = to_add;
}



/*
This function sets return trip to a new input bool.
INPUT: A BOOL
OUTPUT: NONE
*/
void streetcar:: set_return_trip(bool new_return)
{
	on_return_trip_for_line = new_return;
//	cout<<"Set return trip is now: "<<on_return_trip_for_line<<endl;
}



/*
This function is set the line stop of a streetcar to what is inputted.
INPUT: LINE STOP POINTER
OUTPIT: NONE 
*/ 
void streetcar::set_at_line_stop(line_stop*& to_add)
{
	at_line_stop = to_add;
}



/*
This function will display a streetcar as an option for a play to choose from.
INPUT: NONE
OUTPUT: NONE
*/
void streetcar::display_streetcar_as_option()
{
	cout<<ID<<". "<<name<<endl;
}



/*
This function gets the name of the streetcar.
INPUT: CHAR ARRAY
OUTPUT: NONE
*/
void streetcar::get_name(char*& new_name)
{
	strcpy(new_name, name);
}



/*
This function will get the return trip bool for the streetcar.
INPUT: NONE
OUTPUT: A BOOL
*/
bool streetcar::get_on_return_trip_for_line()
{
	return on_return_trip_for_line;
}



/*
This function will test to see if at line stop is null or not.
INPUT: NONE
OUTPUT: a BOOL
*/
bool streetcar:: on_line_one()
{
	if(at_line_stop)
	{
		return true;
	}
	else
	{
		return false;
	}
}



/*
This function will test to see if at loop stop is null or not.
INPUT: NONE
OUTPUT: A BOOL
*/
bool streetcar:: on_loop_one()
{
	if(at_loop_stop)
	{
		return true;
	}
	else
	{
		return false;
	}
}



/*
This function will retrieve the at line stop pointer.
INPUT: A LINE STOP POINTER
OUTPUT: NONE
*/
void streetcar:: get_at_line_stop(line_stop*& temp)
{
	temp = at_line_stop;
}



/*
This function retrieves the at loop stop pointer.
INPUT: LOOP STOP POINTER
OUTPUT: NONE
*/
void streetcar::get_at_loop_stop(loop_stop*& temp)
{
	temp = at_loop_stop;
}



/*
This function sets both at line stop and at loop stop to null.
INPUT: NONE
OUTPUT: NONE
*/
void streetcar::set_at_to_null()
{
at_line_stop = NULL;
at_loop_stop = NULL;
}
