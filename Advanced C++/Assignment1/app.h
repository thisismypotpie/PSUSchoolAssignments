/*
   Brandon Danielski
   1/31/2017
   CS202 
   Asignment 1
   This is the .h file for my app class, it contains the prototypes for all menus and user interaction within the program,
 */
#include "stop.h"

class loop;
class line;

class app//This is the app class, the only class in this .h file, the app class does what is descried above, control menus and user interaction.
{
	public:
		void first_greeting(line& line_one, loop& loop_one, graph& map_one);//greets the user and navigates them to one of two menus.
		void main_menu_line(line& line_one, loop& loop_one, graph& map_one);//the main menu for the line object.  
		void main_menu_loop(line& line_one, loop& loop_one, graph& map_one);//the main menu for the loop object.
	private:
};

