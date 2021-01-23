/*
Brandon Danielski
CS202
1/16/2017
Assignment One
This is the .h file for the streetcar, location, and pace classes.  The location and pace classes are both children of the streetcar class.
*/
#ifndef STREETCAR_H
#define STREETCAR_H
#include "stop.h"
/*
This is the streetcar class for the program.
*/
class stop;

/*

*/
class streetcar_location 
{
public:
streetcar_location();
streetcar_location(char* direction);
void get_direction(char*& copy_to);
protected:
char* direction;
stop* at_stop;
int closest_streetcar;
};

class streetcar : public streetcar_location
{
public:
streetcar();
streetcar(bool mode, char* id_name, int id);
bool get_online_status();
void get_name(char*& copy_to);
protected:
bool online;
char* name;
int ID_number;
};
#endif
