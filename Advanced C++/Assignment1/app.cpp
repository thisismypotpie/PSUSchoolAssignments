/*
   Brandon Danielski
   1/31/2017
   CS202 
   Asignment 1
   This is the app cpp file for my program, the menus and user input are managed here as well as most of what the user sees when interacting with the program, the exception being some error messages for each respective class.
 */

#include"app.h"
#include"stop.h"
#include"location.h"
#include<iostream>
using namespace std;



/*
   This function greets the user and then offeres them a choice between whether they want to interact with the line or loop first.  This can be changed in the main menu be selecting option number six.
INPUT: A LINE OBJECT, A LOOP OBJECT, AND A GRAPH OBJECT
OUTPUT: NONE
 */
void app::first_greeting(line& line_one, loop& loop_one, graph& map_one)
{
	int choice=0;
	cout<<"Hello and welcome to the streetcar manager."<<endl;
	cout<<"Please enter a 1 to work with line one or press 2 to work with loop one."<<endl;
	cin >>choice;
	if(cin.fail() || choice !=1 && choice!=2)
	{
		cout<<"The number you have entered is invalid, please only press 1 or 2."<<endl;
		cin.clear();
		cin.ignore();
		return first_greeting(line_one, loop_one, map_one);
	}
	else if(choice == 1)
	{
		main_menu_line(line_one, loop_one, map_one);				
	}
	else if(choice == 2)
	{
		main_menu_loop(line_one,loop_one, map_one);
	}
	else
	{
		cout<<"There was an error, you will have to input your choice again."<<endl;
		cin.clear();
		cin.ignore();
		return first_greeting(line_one, loop_one, map_one);
	}
}



/*
   This function controls the main menu for the line object. It offeres the user multiple ways to manipulate streetcars as well as switching to the loop and exiting the program.  All changes are saved upon exiting the program.
INPUT: A LINE, LOOP, AND GRAPH OBJECT
OUTPUT: NONE
 */
void app::main_menu_line(line& line_one, loop& loop_one, graph& map_one)
{
	int user_input = 0;
	cout<<"-------------------------------------------"<<endl;
	cout<<"You are currently in the menu for line one."<<endl;
	cout<<"-------------------------------------------"<<endl;
	cout<<"Please choose from the following options: "<<endl;
	cout<<"1.View All Stops"<<endl;
	cout<<"2.View All Streetcars"<<endl;
	cout<<"3. Take Streetcar Offline"<<endl;
	cout<<"4. Take Streetcar Online"<<endl;
	cout<<"5. Move Steetcars"<<endl;
	cout<<"6.Change to Loop "<<endl;
	cout<<"7.Exit Program"<<endl;
	cin >> user_input;
	if(cin.fail() || user_input > 7 && user_input < 1)
	{
		cout<<"What you have put in is incorrect, please only enter 1-7."<<endl;
		cin.clear();
		cin.ignore();
		return main_menu_line(line_one, loop_one, map_one);
	}	
	if(user_input ==1)
	{
		cout<<"Here are all of the stops included in line one: "<<endl;
		line_one.display_all_stops();
		cout<<"Press any key to continue"<<endl;
		cin.clear();
		cin.ignore();
		cin.get();
		return main_menu_line(line_one, loop_one, map_one);
	}
	else if(user_input ==2)
	{
		cout<<"Here is the status of all streetcars."<<endl;
		map_one.display_all_streetcars();	
		cout<<"Press any key to continue"<<endl;
		cin.clear();
		cin.ignore();
		cin.get();
		return main_menu_line(line_one, loop_one, map_one);
	}
	else if(user_input ==3)
	{
		cout<<"Please choose the ID number of the streetcar you would like to bring offline"<<endl;
		if(map_one.display_online_streetcars_line()==false)
		{
			cout<<"There are no online streetcars FOR LINE ONE  at the moment. If there are online streetcars on loop one you would like to take offlie, please use option six to naviagte to the loop one menu to take a car on loop one offline.  Press any key to continue."<<endl;
			cin.get();
			cin.clear();
			cin.ignore();
			return main_menu_line(line_one, loop_one, map_one);
		}
		cin >> user_input;
		if(cin.fail())
		{
			cout<<"What you have entered is invalid, please only enter a number."<<endl;
			cin.clear();
			cin.ignore();
			return main_menu_line(line_one, loop_one, map_one);
		}
		map_one.bring_line_car_offline(user_input);
		return main_menu_line(line_one, loop_one, map_one);	
	}
	else if(user_input ==4)
	{
		cout<<"Please choose the ID number of the streetcar you would like to bring online."<<endl;
		if(map_one.display_offline_streetcars()==false)
		{

			cout<<"There are no offline streetcars at the moment.  Press any key to continue."<<endl;
			cin.get();
			cin.clear();
			cin.ignore();
			return main_menu_line(line_one, loop_one, map_one);
		}
		cin >> user_input;
		if(cin.fail())
		{
			cout<<"What you have entered is incorrect, please enter only a number."<<endl;
			cin.clear();
			cin.ignore();
			return main_menu_line(line_one, loop_one, map_one);
		}		
		map_one.bring_line_car_online(user_input, line_one);
		return main_menu_line(line_one, loop_one, map_one);	
	}
	else if(user_input ==5)
	{
		line_one.move_streetcars(map_one);
		return main_menu_line(line_one, loop_one, map_one);
	}
	else if(user_input ==6)
	{
		cout<<"You will be transfered to loop one, press any key to continue."<<endl;
		cin.clear();
		cin.ignore();
		cin.get();
		return main_menu_loop(line_one,loop_one, map_one);
	}
	else if(user_input ==7)
	{	
		map_one.close_program((((char*)"locations.txt")),((char*)"streetcars.txt"));//add the names of each file here.
		return;
	}
	else
	{
		cout<<"What you have entered is incorrect, please enter only a number corresponding with the options."<<endl;
		cin.clear();
		cin.ignore();
		return main_menu_line(line_one, loop_one, map_one);
	}
}



/*
   This function is the main menu for the loop.  It offers the same choices as the line and can switch to the line menu through option number six.
INPUT: A LINE, LOOP, AND GRAPH OBJECT
OUTPUT: NONE
 */
void app:: main_menu_loop(line& line_one, loop& loop_one, graph& map_one)
{
	int user_input =0;
	//	streetcar temp_streetcar;
	cout<<"-------------------------------------------"<<endl;
	cout<<"You are currently in the menu for loop one."<<endl;
	cout<<"-------------------------------------------"<<endl;
	cout<<"Please choose from the following options: "<<endl;
	cout<<"1.View All Stops"<<endl;
	cout<<"2.View All Streetcars"<<endl;
	cout<<"3. Take Streetcar Offline"<<endl;
	cout<<"4. Take Streetcar Online"<<endl;
	cout<<"5. Move Steetcars"<<endl;
	cout<<"6.Change Line"<<endl;
	cout<<"7.Exit Program"<<endl;
	cin >> user_input;
	if(cin.fail() || user_input > 7 && user_input < 1)
	{
		cout<<"What you have put in is incorrect, please only enter 1-7."<<endl;
		cin.clear();
		cin.ignore();
		return main_menu_loop(line_one, loop_one, map_one);
	}	
	if(user_input == 1)
	{
		cout<<"Here are all of the stops in loop one"<<endl;
		loop_one.display_all_stops();
		cout<<"Press any key to continue."<<endl;
		cin.clear();
		cin.ignore();
		cin.get();
		return main_menu_loop(line_one, loop_one, map_one);
	}
	else if(user_input == 2)
	{
		cout<<"Here is the status of all of the streetcars."<<endl;
		map_one.display_all_streetcars();	
		cout<<"Press any key to continue"<<endl;
		cin.clear();
		cin.ignore();
		cin.get();
		return main_menu_loop(line_one, loop_one, map_one);
	}
	else if(user_input == 3)
	{
		cout<<"Please choose the ID number of the streetcar you would like to bring offline from loop one."<<endl;
		if(map_one.display_online_streetcars_loop()==false)
		{
			cout<<"There are no online streetcars FOR LOOP ONE at the moment.  If you are trying to get a streetcar from line one offline, please navigate the line one menu and take a streetcar offline from there.  Press any key to continue."<<endl;
			cin.get();
			cin.clear();
			cin.ignore();
			return main_menu_loop(line_one, loop_one, map_one);
		}
		cin >> user_input;
		if(cin.fail())
		{
			cout<<"What you have entered is incorretct, please enter only a number."<<endl;
			cin.clear();
			cin.ignore();
			return main_menu_loop(line_one, loop_one, map_one);
		}
		map_one.bring_loop_car_offline(user_input);
		return main_menu_loop(line_one, loop_one, map_one);

	}
	else if(user_input == 4)
	{	
		cout<<"Please choose the ID number of the streetcar you would like to bring online."<<endl;
		if(map_one.display_offline_streetcars()==false)
		{

			cout<<"There are no offline streetcars at the moment.  Press any key to continue."<<endl;
			cin.get();
			cin.clear();
			cin.ignore();
			return main_menu_loop(line_one, loop_one, map_one);
		}
		cin >> user_input;
		if(cin.fail())
		{
			cout<<"What you have entered is incorrect, please enter only a number."<<endl;
			cin.clear();
			cin.ignore();
			return main_menu_loop(line_one, loop_one, map_one);
		}		
		map_one.bring_loop_car_online(user_input, loop_one);
		return main_menu_loop(line_one, loop_one, map_one);	
	}
	else if(user_input == 5)
	{
		loop_one.move_streetcars(map_one);	
		return main_menu_loop(line_one, loop_one, map_one);

	}
	else if(user_input == 6)
	{
		cout<<"You will be taken to the menu for line one."<<endl;
		cout<<"Press any key to continue."<<endl;
		cin.clear();
		cin.ignore();
		cin.get();
		return main_menu_line(line_one, loop_one, map_one);
	}
	else if(user_input == 7)
	{
		map_one.close_program((((char*)"locations.txt")),((char*)"streetcars.txt"));//add the names of each file here.
		return;
	}	
	else
	{
		cout<<"What you have entered is incorrect, please enter only a number corresponding with the options."<<endl;
		cin.clear();
		cin.ignore();
		return main_menu_loop(line_one, loop_one, map_one);
	}
}

