//Tutor is my ADT for this project. it has several parts to it and many private data memebers.  Each tutor has a subject, rating, location, days and time avaialbe and description.  Helptype is whether or not the tutor is online or on campus.
#ifndef TUTOR_H
#define TUTOR_H
using namespace std;
#include<iostream>

class tutor
{
public:
tutor();//default constructor for turor.
tutor(char* Subject, int Rating, char* HelpType, char* Location, char* DaysAvailable, char* TimeAvailble, char*decription);//constructor for tutor.
bool changeRating(int newRating);//changes the rating of the tutor.
bool displayTutor();//displays the tutor's information.
bool detailedDisplayTutor();//displays the tutor including the descrption.
int getRating();//returns rating.
private:
char* subject;
int rating;
char* helpType;
char* location;
char* daysAvailable;
char* timeAvailable;
char*  description;
};
#endif
