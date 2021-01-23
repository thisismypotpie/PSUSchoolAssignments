/*
   Brandon Danielski
   2/13/2017
   Assignment 2
   CS202
 */
#include"transport.h"
#include"rider.h"

/*
   This class is the app, it regulates all the user interaction and everything the user sees.
 */
class app
{
	public:
		void first_greeting();//greets the user upons starting the program.
		void main_menu(transport*& max, transport*& uber, transport*& bus, rider& the_person);//The main menu for the user to interact with.
	protected:
};
