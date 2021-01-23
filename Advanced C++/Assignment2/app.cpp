/*
   Brandon Danielski
   2/13/2017
   Assignment 2
   CS202
   This file is the .cpp file for the app class.  The app class handles user input and menus used in the program.
 */
#include"app.h"
#include<iostream>
using namespace std;



/*
   This function greets the user upon starting the program.
INPUT: NONE
OUTPUT: NONE */ 
void app::first_greeting() 
{
	cout<<"Welcome to the ride choosing application."<<endl;
}



/*
   This function is the main menu of the program.  It lets the user interact with the various things the program does.
INPUT: Three transport objects and a rider object.
OUTPUT: NONE 
 */
void app::main_menu(transport*& max, transport*& ubers, transport*& bus, rider& the_person)
{
	int user_input=0;
	cout<<"Please choose from the following options."<<endl;
	cout<<"1. Check Deatils on Uber."<<endl;
	cout<<"2. Check Details on TriMet Bus."<<endl;
	cout<<"3. Check Details on The MAX Line."<<endl;
	cout<<"4. Check Rider History"<<endl;
	cout<<"5. Exit Program"<<endl;
	cin >> user_input;
	if(cin.fail())
	{
		cout<<"What you have entered is invalid, please only enter a number."<<endl;	
		cin.clear();
		cin.ignore();
		return main_menu(max, ubers, bus, the_person);
	}
	else if(user_input > 5 || user_input < 1)
	{
		cout<<"Please only enter a number corresponding to the options presented."<<endl;
		cin.clear();
		cin.ignore();
		return main_menu(max, ubers, bus, the_person);
	}
	else if(user_input == 1)
	{
		ubers->display_pop_list();
		cout<<"Press any key to continue."<<endl;
		cin.get();
		cin.clear();
		cin.ignore();
		return main_menu(max,ubers,bus,the_person);
	}
	else if(user_input == 2)
	{
		bus->display_pop_list();
		cout<<"Press any key to continue."<<endl;
		cin.get();
		cin.clear();
		cin.ignore();
		return main_menu(max,ubers,bus,the_person);
	}
	else if(user_input == 3)
	{
		max->display_pop_list();
		cout<<"Press any key to continue."<<endl;
		cin.get();
		cin.clear();
		cin.ignore();
		return main_menu(max,ubers,bus,the_person);
	}
	else if(user_input == 4)
	{
		the_person.display_history();
		cout<<"Press any key to continue."<<endl;
		cin.get();
		cin.clear();
		cin.ignore();
		return main_menu(max,ubers,bus,the_person);
	}
	else if(user_input == 5)
	{
		return;
	}
}



