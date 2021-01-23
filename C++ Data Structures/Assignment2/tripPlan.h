/*
Brandon Danielski
10/25/2016
CS 163
Assignment 2
This is the trip plan ADT for my program.  Each tripPlan keeps the details of each stop such as city, state, lodging detail, and gas price. Its functions are all display functions and copy functions.
*/
#ifndef TRIPPLAN_H
#define TRIPPLAN_H

class tripPlan
{
public:
tripPlan();//defualt constuctor.
~tripPlan();
tripPlan(char* trip_name_new, char* city_new, char* state_new, char* lodging_new, char* address_for_lodging_new,int price_for_lodging_new,int miles_from_last_stop_new);//constructor
bool display_trip()const;//displays all of the stop deatils except the gas prices and lodging rating.
bool display_name(char*& name);//displays the trip name.
bool copy_lodging_rating(int new_rating);//copies lodging rating into the tripPlan.
bool copy_money_spent_on_gas(float new_gas); //copies gas price into the tripPlan.
bool return_trip_display()const;//returns all of the stop details.
bool copy(tripPlan& to_copy);//copies the temp tripPlan into this tripPlan which wil be stored as a stop.
private:
char *trip_name;//the name of the trip.
char *city;//the city of a stop
char *state;//the state of a stop.
char *lodging;//the lodging name of a stop.
char *address_for_lodging;//the address of a stop.
int price_for_lodging;//the price of the lodging.
int miles_from_last_stop;//the miles from the previous stop to this one.
int lodging_rating;//the rating of the lodging for this stop.
float money_spent_on_gas;//the money spent on gas from the prvious stop to this one.
};

#endif
