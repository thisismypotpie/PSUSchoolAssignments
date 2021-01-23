/*
   Brandon Danielski
   11/13/2016
   CS 163
   Assignment 4
   This is the app file for all prototypes of the app ADT.  The app deals with two things: error messages and getting use input.
 */
#include"tree.h"
#ifndef APP_H
#define APP_H
class app
{
	public:
		void first_greeting();//welcomes the user to the program.
		int main_menu();//this is the main menu.  The user sees all available options.
		bool name_input_for_search(char*& copy_to);//gets user input for a name of a game. Used when searching for a game by name.
		bool add_game(tree& to_add);//gets user input for adding a game to the hash table.
		void table_retrieve_error();//en error if something goes wrong with retrieving a game.
		void table_display_all_error();//en error if something goes wrong with displaying games.
		void misc_error();//en error if something goes wrong in choosing an option at the main menu.
		bool remove_game(tree& to_edit);//prompts the user to enter a game they want to remove.
		bool search_by_range(char*& copy_to);//searches all games that start with a letter within a range of letters.
		void add_game_error();//an error message if something goes wrong adding a game.
		void remove_game_error();//an error message if something goes wrong with removing a game.
                void enter_name_error();// tells the user if there is a problem when entereing a name for a game.
		void range_error();//an error message if there is an error when inputting a range of letters.
		void game_found();//tells the user a new game has been added.
		void game_removed();//tells the user a game has been removed.
	private:
};
#endif
