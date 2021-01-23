//This is the tutor class.  It is my ADT and has a bunch of private data members to keep track of.
#include"tutor.h"
#include<string.h>// this was just to add stcmp to compare my arrrays, there are not declared strings in this entire project.
#include<iostream>
#include<iomanip>
using namespace std;
//constucor for the tutor class.  takes in all of these areguments and stores them into the tutor object.
tutor::tutor(char* Subject, int Rating, char* HelpType, char* Location, char* DaysAvailable, char* TimeAvailable, char* Description)
{
int MAX_SIZE = 50;
subject =Subject;
if(Rating > 10)
{
rating = 10;
}
else if(Rating < 1)
{
rating = 1;
}
else
{
rating = Rating;
}
helpType = HelpType;
location = Location;
daysAvailable = DaysAvailable;
timeAvailable = TimeAvailable;
description = Description;
}
//defualt contstructor makes a bunch or arrays fo the data memebers and sets rating to 0.
tutor::tutor()
{
int MAX_SIZE = 50;
subject[MAX_SIZE];
rating = 0;
helpType[MAX_SIZE];
location[MAX_SIZE];
daysAvailable[MAX_SIZE];
timeAvailable[MAX_SIZE];
}
//Diesplays the tutor's data members with the exception of the descrption in a fancy way using iomanip.
bool tutor::displayTutor()
{
cout<<setfill(' ')<<left<<setw(14)<<subject<<setw(7)<<rating<<setw(15)<<helpType<<setw(25)<<location<<setw(15)<<daysAvailable<<setw(10)<<timeAvailable<<endl; 
return true;
}
//Returns the rating .
int tutor::getRating()
{
 return rating;
}
// Dsplays the tutor's data members including the description.
bool tutor::detailedDisplayTutor()
{
cout<<endl<<endl;
cout << "Subject:  "<<subject<<endl;
cout << "Rating:  "<<rating<<endl;
cout <<"This type of help is located "<<helpType<<" at "<<location<<endl;
if(strcmp("online",helpType)!=0)
{
 cout<< "The tutors are available "<<timeAvailable<<" on "<<daysAvailable<<endl;
}
cout<< "DESCRIPTION:"<<endl;
cout<< description<<endl;
cout<<endl;
}
//Chages rating to the number passed into the function.  App makes sure the number is somewhere between 1 and 10.
bool tutor::changeRating(int newRating)
{
 rating = newRating;
cout <<" the new rating is now: "<<rating<<endl;
 return true;
}
