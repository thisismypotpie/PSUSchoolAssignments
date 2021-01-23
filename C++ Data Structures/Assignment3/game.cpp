/*
Brandon Danielski
11/3/2016
CS 163
Assignment 3
This is the game.cpp file which will implement all of the functions of the game.h file.
*/

#include"game.h"
#include<cstring>
#include<iostream>
using namespace std;



/*
This is the default constructor for the game ADT in case the ADT is loaded in as blank.
INPUT: NONE
OUTPUT:NONE
*/
game::game()
{
MAX_SIZE = 2000;
game_name=NULL;
description=NULL;

platform=NULL;
stars =NULL;
reccomendations=NULL;
game_name = new char[MAX_SIZE];
description = new char[MAX_SIZE];
game_type = new char[MAX_SIZE];
platform = new char[MAX_SIZE];
stars = new char[MAX_SIZE];
reccomendations = new char[MAX_SIZE];
}



/*
This is the constructor for the game ADT when data is being passed into the game.
INPUT: NONE
OUTPUT: NONE
*/
game::game(char* new_game_name, char* new_description, char* new_game_type, char* new_platform, char* new_stars, char* new_reccomendations)
{
MAX_SIZE = 2000;
game_name=NULL;
description=NULL;
game_type=NULL;
platform=NULL;
stars=NULL;
reccomendations=NULL;
game_name = new char[MAX_SIZE];
description = new char[MAX_SIZE];
game_type = new char[MAX_SIZE];
platform = new char[MAX_SIZE];
stars = new char[MAX_SIZE];
reccomendations = new char[MAX_SIZE];
strcpy(game_name,new_game_name);
strcpy(description, new_description);
strcpy(game_type, new_game_type);
strcpy(platform,new_platform);
strcpy(stars,new_stars);
//cout<<"Stars: "<<stars<<" "<<new_stars<<endl;
strcpy(reccomendations,new_reccomendations);
}



/*
This is the destuctor for the gae ADT.  It checks to see if there is any data to delete from each memember before attempting a delete to avoid errors.
INPUT: NONE
OUTPUT: NONE
*/
game::~game()
{
//cout<<"deleting game"<<endl;
if(game_name)
{
//cout<<"d1"<<endl;
delete[]game_name;
game_name = NULL;
}
if(description)
{
//cout<<"d2"<<endl;
delete[]description;
description = NULL;
}
if(game_type)
{
//cout<<"d3"<<endl;
delete[] game_type;
game_type = NULL;
}
if(platform)
{
//cout<<"d4"<<endl;
delete[] platform;
platform =NULL;
}
if(stars)
{
//cout<<"d5"<<endl;
delete[] stars;
stars = NULL;
}
if(reccomendations)
{
//cout<<"d6"<<endl;
delete[] reccomendations;
reccomendations = NULL;
}
}



/*
This function displays all of the data stored in each game. Checks to see if each piece is null before displaysing
INPUT: NONE
OUTPUT: Displays all data in the game ADT, returns a bool for success or failure.
*/
bool game::display_game()
{
cout<<"----------------------------------------------------------------"<<endl;
if(game_name)
{
cout<<"Game Name: "<<game_name<<endl;
}
else
{
cout<<"Game Name: No Name Stored"<<endl;
}
if(description)
{
cout<<"Description: "<<description<<endl;
}
else
{
cout<<"Description: No Description Stored"<<endl;
}
if(game_type)
{
cout<<"Game Type: "<<game_type<<endl;
}
else
{
cout<<"Game Type: No Game Type Stored"<<endl;
}
if(platform)
{
cout<<"Platform: "<<platform<<endl;
}
else
{
cout<<"Platform: No Platform Stored"<<endl;
}
if(stars)
{
cout<<"Rating: "<<stars<<endl;
}
else
{
cout<<"No rating stored"<<endl;
}
if(reccomendations)
{
cout<<"Recommendations: "<<reccomendations<<endl;
}
else
{
cout<<"Recommendations: No recommendations Stored "<<endl;
}
cout<<"----------------------------------------------------------------"<<endl;
return true;
}



/*
this function copies a game ADT into another.  This allows for the user operator'=' to not be used, this function is used instead.
INPUT: A game ADT.
OUTPUT: a bool to report success or failure.
*/
bool game::copy(game& copy_to)
{
strcpy(game_name,copy_to.game_name);
strcpy(description,copy_to.description);
strcpy(game_type,copy_to.game_type);
strcpy(platform,copy_to.platform);
strcpy(stars,copy_to.stars);
strcpy(reccomendations,copy_to.reccomendations);
return true;
}



/*
This function simply copies the name of a game into an array.
INPUT: a char array to copy the name of a game to.
OUTPUT: a bool to report success or failure.
*/
bool game::copy_name(char*& copy_to)
{
strcpy(copy_to,game_name);
return true;
}



/*
Gets data for all pieces of a games and copies them.
INPUT: a bunch or arrays to copies pieces of game data.
OUTPUT: A bool to report success or failure.
*/
bool game::get_data(char*&name,char*&desc,char*&type,char*&plat,char*&star,char*&recc)
{
strcpy(name,game_name);
strcpy(desc,description);
strcpy(type,game_type);
strcpy(plat,platform);
strcpy(star,stars);
strcpy(recc,reccomendations);
return true;
}



/*
A function that copies the name of the platforms of a game.
INPUT: a char array to copy a platform to.
OUTPUT: a bool to report success or failure.
*/
bool game::copy_platform(char*& to_copy)
{
 strcpy( to_copy, platform);
  return true;
}
