/*
Brandon Danielski
1/31/2017
CS202 
Asignment 1
This is the .h file for the streetcar class of the program.
*/
#include"stop.h"
#ifndef STREETCAR_H
#define STREETCAR_H

class line_stop;
class loop_stop;

class streetcar//This is the streetcar class.
{
public:
streetcar();//constructor 
streetcar(char* new_name, int new_ID,bool new_online, bool return_trip);//non default constructors.
streetcar(streetcar& copy_to);//copy constuctor.
void copy_streetcar(streetcar& copy_to);//copy streetcar function.
//void copy_streetcar(streetcar*& copy_to);//may not be in use.
void display_streetcar();//displays a streetcar.
void set_online(bool new_online);//sets online to new_online.
bool get_online_status();//gets the online status.
//void go_online_loop(loop_stop*& to_add);
//void go_online_line(line_stop*& to_add);
int getID();//gets the streetcar id
void set_at_loop_stop(loop_stop*& to_add);//this sets the at loop stop for the streetcar.
void set_return_trip(bool new_return);//sets the return trip bool.
void set_at_line_stop(line_stop*& to_add);//seets the at line stop for the streetcar.
void display_streetcar_as_option();//special display for streetcar.
void get_name(char*& new_name);//gets the name of the streetcar
bool get_on_return_trip_for_line();//gets return trip bool.
bool on_line_one();//test to see if at line stop is null.
bool on_loop_one();//test to see if at loop stop is null.
void get_at_line_stop(line_stop*& temp);//gets at stop line
void get_at_loop_stop(loop_stop*& temp);//gets at stop loop
void set_at_to_null();//sets at line and at loop to null.
~streetcar();//destructor
protected:
int ID;//id for steetcar
char* name;//name of streetcar
bool online;//online status
bool on_return_trip_for_line;//on return trip bool
line_stop* at_line_stop;//points which stop the streetcar is at.
loop_stop* at_loop_stop;//points which stop the stretcar is at for a loop.
};
#endif
