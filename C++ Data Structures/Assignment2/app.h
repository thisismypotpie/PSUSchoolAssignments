
/*Brandon Danielski
CS163
10/25/2016
Assignment 2
This is the header for my app.  This is everything the user sees and where the user will input information that will be put into the queue when a new stop of the trip is added.  Each one of these functions is used to help guide the user throught using the program.

*/
#ifndef APP_H
#define APP_H
#include"tripPlan.h"
#include"stack.h"
#include"queue.h"
class app
{
public:
app();//constructor for app.
~app();
void first_greeting();//Displays a single output welcoming the user to the program.
void error_message();//If any of the other functions return false this error message will apprear.
bool name_trip(char* main_name);//gets input from the user on what the trip will be named.
bool main_menu(int & input);//This menu appears when the user has selected a trip.
bool add_stop(tripPlan& to_copy);//This adds a stop to the trip to be enqueued.
bool take_trip(queue& there_trip,stack& return_trip );//This takes the trip.  the user is taken to each stop and then goes through the return trip.
bool another_trip();//At the end of the trip the user is asked if they want to take another trip.
private:
int user_input_for_selections;//Lets the app know what option the usr has selected in the menus.
char* trip_name;//is an array for the name of the trip.
float total_spent_on_gas;//total money spend on gas for each stop.
};


#endif
