//This is the .h file for the app class.  There is only one private data member and this for user input in the form of an int.
#ifndef APP_H
#define APP_H

#include<iostream>
#include"tutor.h"
class app
{
public:
app();//construcor
void intro();//the first output seen by user.
int  choosingAnItem();//lets the
bool checkNum(int numToCheck, int listLength);//makes sure what player enters is valid regarding the list.
bool menuOne();//main menu viewed by user.
bool menuForViewingList();//second menu viewed by user.
bool menuForViewingItemOnList();//third menu viewed by user.
int getUserInputForSelections();//retrieved what user had most recently inputted;
bool setUserInputForSelections(int setTo);//can set user input, used in main to keep the menu loops going.
bool selectedtutorMenu();//fourth menu viewed by user.
bool MenuError();//in case of emergency of main menu.
bool addTutorInfo(tutor & newTutor);//adds new tutor to be added to list.
int changeRating();//changes rating of selected item.
private:
int userInputForSelections;
};
#endif
