/*
   Brandon Danielski
   11/16/2016
   CS 163
   Assignment 4
   This is the game ADT of my program.  This ADT is each piece of the game.  It contains the name, description, type, platform, etc.  Each piece of data in the node of each table element will have this ADT as the data.
 */
#ifndef GAME_H
#define GAME_H
class game
{
	public:
		game();//contructor for the game ADT.
		game(char* new_game_name, char* new_description, char* new_game_type, char* new_platform, char* new_stars, char* new_reccomendations);//Non-default constructor for game ADT.
		~game();//destructor for the game ADT.
		bool display_game();//displays all of the information stored in the game ADT.
		bool copy(game& copy_to);//This copies information into the game ADT.
		bool copy_name(char*& copy_to);//Lets table get the keyword.
		bool get_data(char*&name,char*&desc,char*&type,char*&plat,char*&star,char*&recc);//gets the data from a game by copying to the the arrays passed into the function.
		bool copy_platform(char*& to_copy);//copies the platform to a char array passed to the function.
	private:
		char* game_name;
		char* description;
		char* game_type;
		char* platform;
		char*  stars;
		char* reccomendations;
		int MAX_SIZE;
};

#endif
