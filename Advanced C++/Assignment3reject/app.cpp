/*
Brandon Danielski
2/24/2017
CS 202
Assignment 3
This is the .ccp for the app class of the program.
*/
#include "app.h"
#include <iostream>
using namespace std;



/*
This function will greet the user when the progam is started.
INPUT: NONE
OUTPUT: NONE
*/
void app::first_greeting()
{
	cout<<"Hello and welcome to the emergency braodcast contacting system."<<endl;
}



/*
This function is the main menu for the program, guiding the user through the program.
INPUT: A TREE PASSED BY REFERENCE
OUTPUT: NONE
*/
void app::main_menu(tree& main_tree)
{
	int user_input = 0;
	cout<<"Please choose from the following optons:"<<endl;
	cout<<"1. Display All Contacts "<<endl;
	cout<<"2. Add contact"<<endl;
	cout<<"3. Find Contact"<<endl;
	cout<<"4. Delete contact"<<endl;
	cout<<"5. Delete all contacts"<<endl;
	cout<<"6. Exit"<<endl;
	cin>>user_input;
	if(cin.fail()||user_input <0 || user_input >6)
	{
		cout<<"What you have entered is incorrect, please enter only a number corresponding to the options."<<endl;
		cin.clear();
		cin.ignore();
		return main_menu(main_tree);
	}
	if(user_input ==1)
	{

	}
	else if(user_input ==2)
	{

	}
	else if(user_input ==3)
	{

	}
	else if(user_input ==4)
	{

	}
	else if(user_input ==5)
	{

	}
	else if(user_input ==6)
	{
		return;
	}
	else
	{
		cout<<"There was an error detecting your input, please try again."<<endl;
		cin.clear();
		cin.ignore();
		return main_menu(main_tree);
	}
}
