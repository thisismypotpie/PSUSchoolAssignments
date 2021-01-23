/*
Brandon Danielski
11/13/2016
CS 163
Assignment 3
This is the cpp file for the app.  It controls everything the user sees and gives the user error messages if something goes wrong.
*/
#include"app.h"
#include"game.h"
#include"table.h"
#include<iostream>
#include<cstring>
#include<cctype>
using namespace std;

/*
This is the greeting message to greet the user to the program before showing the main menu.
INPUT: none
OUTPUT: none
*/
void app::first_greeting()
{
cout<<"Welcome to the Game Database!"<<endl;
}



/*
The main menu for the entire program.  The user can choose from one of six options.
INPUT: none
OUTPUT: Returns a number corresponding to what the user inputted.
*/
int app::main_menu()
{
int choice = 0;
cout<<"Please select the number coresponding to the option you want."<<endl;
cout<<"1. Add a Game"<<endl;
cout<<"2. Remove a Game"<<endl;
cout<<"3. Search for a Game"<<endl;
cout<<"4. View All Games"<<endl;
cout<<"5. View Games by Platform"<<endl;
cout<<"6. Exit"<<endl;
cin>>choice;
if(cin.fail() || choice >6 || choice<1)
{
cout<<"The choice you have entered is incorrent, please enter only a 1-5."<<endl;
cin.clear();
cin.ignore();
 main_menu();
}
return choice;
}




/*
This function is used when the user decides to seach for a game.  The program searhces by game name so this function asks the user which game they want to find.
INPUT: A char array that will bring the name of the game inputted by the user to the table.
OUTPUT: a bool to return success or failure.
*/
bool app::name_input_for_search(char*& copy_to)
{
 bool is_empty = true;
 cin.clear();
 cin.ignore();
 cout<<"What is the name of the game you are seaching for?"<<endl;
  cin.getline(copy_to,2000);
  for(int i=0; i<2000; i++)
  {
   if(*(copy_to+i))
   {
    is_empty=false;
    i=2000;
   }
   if(i == 1999 && is_empty == true)
   {
    cout<<"You have not entered anything,please enter something."<<endl;
    cin.clear();
    cin.ignore();
    return name_input_for_search(copy_to);
   }
  }
  for(int i=0;i<strlen(copy_to);i++)
  {
   *(copy_to+i)=tolower(*(copy_to+i));
  }
}





/*
The function adds a game to the table.  The first thing this function does is gather user input on the information of the new game and then sends the new game to the table.
INPUT: The hash table for the program.  This is passed in order to call the insert fuction for adding the game created in this functin.
OUTPUT: a bool to report success or failure.
*/
bool app::add_game(table& to_add)
{
char*name = new char[2000];
char*desc = new char[2000];
char*type = new char[2000];
char*plat = new char[2000];
char*star = new char[2000];
char*reco = new char[2000];
char*alter_plat = new char[2000];//rememeber to delete this later.
int stars = 0;
int plat_choice = 0;
int at = 0;
bool is_empty = true;
bool add_another = true;
for(int i=0;i<2000;i++)//This loop is here because for some reason the char* arrays are being populated with gabage.  Its strange because in all other instances the arrays were populated with NULL except in this function where the arrays are populated with garbage.
{
*(name+i)=0;
*(desc+i)=0;
*(type+i)=0;
*(plat+i)=0;
*(star+i)=0;
*(reco+i)=0;
}
cin.clear();
cin.ignore();
while(is_empty ==true)
{
cout<<"What is the name of the game?"<<endl;
cin.getline(name,2000);
for(int i=0; i <2000;i++)
{
if(*(name+i))
{
//cout<<"index: "<<i<<endl;
//cout<<*(name+i)<<endl;
is_empty = false;
i = 2000;
}
if(is_empty==true && i==1999)
{
cout<<"You have not entered anything, please enter something."<<endl;
cin.clear();
}
}
}
is_empty = true;
for(int i =0; i< strlen(name);i++)
{
 *(name+i)=tolower(*(name+i));
}
while(is_empty ==true)
{
cout<<"What would a good description of this game be?"<<endl;
cin.getline(desc,2000);
for(int i=0; i <2000;i++)
{
if(*(desc+i))
{
is_empty = false;
i = 2000;
}
if(is_empty==true && i==1999)
{
cout<<"You have not entered anything, please enter something."<<endl;
cin.clear();
}
}
}
is_empty = true;
while(is_empty ==true)
{
cout<<"What game type is this game?"<<endl;
cin.getline(type,2000);
for(int i=0; i <2000;i++)
{
if(*(type+i))
{
is_empty = false;
i = 2000;
}
if(is_empty==true && i==1999)
{
cout<<"You have not entered anything, please enter something."<<endl;
cin.clear();
}
}
}
is_empty = true;
while(is_empty ==true)
{
cout<<"Please record one platform this game is on."<<endl;
cin.getline(plat,2000);
for(int i=0; i <2000;i++)
{
if(*(plat+i))
{
is_empty = false;
i = 2000;
}
if(is_empty==true && i==1999)
{
cout<<"You have not entered anything, please enter something."<<endl;
cin.clear();
}
}
while(add_another == true)
{
cout<<"Is there another platform you wanted to add? Press 1 for yes and 2 for no."<<endl;
cin.clear();
cin >> plat_choice;
if(plat_choice == 1)
{
cin.clear();
cin.ignore();
strcat(plat,",");
cout<<"What is another platform this console is on?"<<endl;
cin.getline(alter_plat,2000);
strcat(plat,alter_plat);
}
else if(plat_choice == 2)
{
  add_another = false;
}
else
{
 cout<<"What you have enetered is incorrect, please enter either a 1 or a 2."<<endl;
 cin.clear();
 cin.ignore();
}
} 
}
is_empty = true;
for(int i=0; i<strlen(alter_plat);i++)
{
 *(alter_plat+i)=0;
}
for(int i =0; i< strlen(plat);i++)
{
 *(plat+i)=toupper(*(plat+i));
  if(*(plat+i)!=' ')
  {
    *(alter_plat+at)=*(plat+i);
     ++at;    
  }
}
while(is_empty ==true)
{

cout<<"How many stars out of 5 would you give this game?"<<endl;
cin >> stars;
if(cin.fail()||stars<0 ||stars>5)
{
cout<<"Please enter only a number between 0 and 5."<<endl;
cin.clear();
cin.ignore();
}
else
{
if(stars == 0)
{
*(star)=48;
}
else if(stars == 1)
{
*(star)=49;
}
else if(stars == 2)
{
*(star)=50;
}
else if(stars == 3)
{
*(star)=51;
}
else if(stars == 4)
{
*(star)=52;
}
else if(stars == 5)
{
*(star)=53;
}
strcat(star," of 5 stars.");
is_empty = false;
cin.clear();
cin.ignore();
}
}
is_empty = true;
while(is_empty ==true)
{
cout<<"What recommendations would you have for this game?"<<endl;
cin.getline(reco,2000);
for(int i=0; i <2000;i++)
{
if(*(reco+i))
{
is_empty = false;
i = 2000;
}
if(is_empty==true && i==1999)
{
cout<<"You have not entered anything, please enter something."<<endl;
cin.clear();
}
}
}
is_empty = true;
game new_game(name,desc,type,alter_plat,star,reco);
to_add.insert(new_game);
if(name)
{
delete[] name;
}
if(desc)
{
delete[] desc;
}
if(type)
{
delete[] type;
}
if(plat)
{
delete[] plat;
}
if(star)
{
delete[] star;
}
if(reco)
{
delete[] reco;
}
if(alter_plat)
{
delete[] alter_plat;
}
return true;
}




/*
An error message in case no match is found for when the user retrieves a game.
INPUT: none
OUTPUT: none
*/
void app::table_retrieve_error()
{
cout<<"No match was found for what you put in."<<endl;
}




/*
An error message for when the user wants to display al games.
INPUT: none
OUTPUT: none
*/
void app::table_display_all_error()
{
cout<<"There was a problem displaying the games, returning to main menu."<<endl;
}




/*
A function to remove a game from the hash table.  This function works  by the user inputting the name of the game the user wants to delete and then the name is sent to the remove function of the hash table.
INPUT: A table to invoke the remove funnction withe the user input passed.
OUTPUT: a bool to report sucess or failure.
*/
bool app::remove_game(table& to_edit)
{
bool is_empty = true;
char* name = new char[2000];
for(int i=0; i<2000;i++)
{
*(name)=0;
}
cin.clear();
cin.ignore();
while(is_empty == true)
{
cout<<"What is the name of the game you would like to remove?"<<endl;
cin.getline(name,2000);
for(int i =0;i<2000;i++)
{
if(*(name+i))
{
//cout<<"found: "<<i<<endl;
is_empty = false;
i =2000;
}
if( i==1999&& is_empty == true)
{
cout<<"You have not entered anything, please enter something."<<endl;
cin.clear();
cin.ignore();
}
}
}
to_edit.remove(name);
if(name)
{
delete[] name;
}
}



/*
A function that prmpts the user to input the name of a plarform they want to search for.  The table then calls the search by platform function to display all games that play on that platform.
INPUT: a table to call the search by platform.
OUTPUT: a bool to report success or failure.
*/
bool app::search_by_platform(table& to_find)
{
char* name = new char[2000];
char* new_name = new char[2000];
int at =0;
bool is_empty = true;
cin.clear();
cin.ignore();
for(int i=0;i<2000;i++)
{
*(name+i)=0;
*(new_name+i)=0;
}
while(is_empty == true)
{ 
cout<<"What is the platform you are seaching for?"<<endl;
cin.getline(name,2000);
for(int i=0;i<2000;i++)
{
 if(*(name))
 {
   is_empty = false;
   i = 2000;
 }
 if(is_empty == true && i ==1999)
 {
   cout<<"You have not entered anything, enter something."<<endl;
 }
}
}
//cout<<"1st name is: "<<name<<endl;
for(int i =0; i<strlen(name);i++)
{
*(name+i)=toupper(*(name+i));
}
//cout<<"2nd name is: "<<name<<endl;
//cout<<"length is: "<<strlen(name)<<endl;
for(int i =0; i<strlen(name);i++)
{
if(*(name+i)!=' ')
{
//cout<<"Adding: "<<*(name+i)<<endl;
*(new_name+at)=*(name+i);
++at;
}
else
{
 //cout<<"white space removed"<<endl;
}
}
//cout<<"going to retrieve with key: "<<new_name<<endl;
to_find.retreive_platform(new_name);
if(name)
{
delete[] name;
}
if(new_name)
{
delete[] new_name;
}
}




/*
An error if the main menu for some reason breaks.
INPUT: none
OUTPUT: none
*/
void app::misc_error()
{
 cout<<"There was an error with the program. Returning to main menu."<<endl; 
}




/*
An error message if there is a problem adding a game.
INPUT: none
OUTPUT: none
*/
void app::add_game_error()
{
cout<<"There was a problem adding the game."<<endl;
}



/*
An error message in case there is a problem removing a game.
INPUT: none
OUTPUT: none
*/
void app::remove_game_error()
{
cout<<"The game you are trying to remove was not found."<<endl;
}



/*
An error message in case there is a problem searching for a game by platform.
INPUT: none
OUTPUT: none
*/
void app:: platform_search_error()
{
cout<<"There was an error searching by platform."<<endl;
}
