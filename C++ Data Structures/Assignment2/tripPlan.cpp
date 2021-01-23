/*
Brandon Danielski
10/25/2016
CS163
Assignment 2
This is the tripPlan.cpp.  I have two contructors in here, one defualt contructor and a non-defualt construction that takes arguments.  All of the functions are for displaying and copying data.
*/
#include<iostream>
#include<iomanip>
#include "tripPlan.h"
#include<cstring>
using namespace std;



/*Default constuctor*/
tripPlan::tripPlan()
{
 
  trip_name = NULL;
  city = NULL;
  state = NULL;
  lodging = NULL;
 address_for_lodging = NULL;
 trip_name = new char[100];
 city = new char[100];
 state = new char[100];
 lodging = new char[100];
 address_for_lodging = new char[100];
 price_for_lodging = 0;
 miles_from_last_stop = 0;
 lodging_rating = 0;
 money_spent_on_gas =0.00;
}


/*Default constructor that takes in arguments for the tripPlan with the exception of gas money and lodging rating. */
tripPlan::tripPlan(char* trip_name_new, char* city_new, char* state_new, char* lodging_new, char* address_for_lodging_new,int  price_for_lodging_new,int miles_from_last_stop_new)
{

 trip_name = NULL;
 city = NULL;
 state = NULL;
 lodging = NULL;
 address_for_lodging = NULL;
 trip_name = new char [100];
 city = new char[100];
 state = new char[100];
 lodging = new char[100];
 address_for_lodging = new char[100];
 price_for_lodging = 0;
 miles_from_last_stop = 0;
 lodging_rating = 0;
 money_spent_on_gas = 0.0;
 strcpy(trip_name,trip_name_new);
 strcpy(city,city_new);
 strcpy(state,state_new);
 strcpy(lodging, lodging_new);
 strcpy(address_for_lodging, address_for_lodging_new);
 price_for_lodging = price_for_lodging_new;
 miles_from_last_stop= miles_from_last_stop_new;
} 

tripPlan::~tripPlan()
{
//cout<<"deleteing: "<<this<<endl;
if(trip_name)
{
//cout<<"deleteing trip name: "<<trip_name<<endl;
delete[] trip_name;
trip_name = NULL;
}
if(city)
{
//cout<<"Deleteing city: "<<city<<endl;
delete[] city;
city = NULL;
}
if(state)
{
//cout<<"Deleting state: "<<state<<endl;
delete[] state;
state = NULL;
}
if(lodging)
{
//cout<<"Deleting lodging: "<<lodging<<endl;
delete[] lodging;
lodging = NULL;
}
if(address_for_lodging)
{
//cout<<"Deleting Address: "<<address_for_lodging<<endl;
delete[] address_for_lodging;
address_for_lodging = NULL;
}
}

/*
Displays all of the data on the trip except for gas money and lodging rating.  This is for the first half of the trip, the rest of the data is displayed while the program gets user info about gas money and lodging rating.
INPUT: NONE
OUTPUT: A bool to return sucess or failure.  All of the info on the trip except for gas and rating, an error message if the trip is null.
*/
bool tripPlan::display_trip()const
{
 cout<<"------------------------------------------------------------------"<<endl;
 if(trip_name == NULL ||city == NULL || state == NULL || lodging==NULL || address_for_lodging ==NULL)
 {
  return false;
 }
 cout<<"Desitnation: "<<city<<", "<<state<<endl;
 cout<<"Lodging: "<<lodging<<endl;;
 cout<<"Address: "<<address_for_lodging<<endl;
 cout<<"price: $"<<price_for_lodging<<endl;
 cout<<"Miles from previous stop: "<< miles_from_last_stop<<endl;
 cout<<"------------------------------------------------------------------"<<endl;
 return true;
}



/*
Displays the name of the trip that the user is taking.  Has an error message if the trip name is null.
INPUT: A name to copy.
OUTPUT: bool for success or failure, an error message, trip name display.
*/
bool tripPlan::display_name(char*& name)
{
if(trip_name == NULL)
{
 cout<<"No trip name"<<endl;
 return false;
}
 for(int i= 0; i <100; i++)
 {
  name[i] = trip_name[i];
 }
}



/*
Copies the lodging rating into the tripPlan.
INPUT: The rating from the app.
OUTPUT: bool to report success or failure.
*/
bool tripPlan::copy_lodging_rating(int new_rating)
{
// cout<<"New rating: "<<new_rating<<endl;
 lodging_rating = new_rating;
 //cout<< "Lodge rating: "<<lodging_rating<<endl;
}



/*
Copies the gas cost into the tripPlan.
INPUT: The gas price fom the app.
OUTPUT: bool to report success of failure.
*/
bool tripPlan::copy_money_spent_on_gas(float new_gas)
{
// cout<<"copy_money_spend_on new gas: "<<new_gas<<endl;
 money_spent_on_gas = new_gas;
// cout<<"gas money: "<<money_spent_on_gas<<endl;
}



/*
Displays each trip information, includeing the rating and gas price.  This is used for the second half of the trip.
INPUT: NONE
OUTPUT: bool to report success or failure, error message, display of all tripPlan information.
*/
bool tripPlan::return_trip_display()const
{
 cout<<"------------------------------------------------------------------"<<endl;
 if(trip_name == NULL ||city == NULL || state == NULL || lodging==NULL || address_for_lodging ==NULL)
 {
  return false;
 }
 
 cout<<"Desitnation: "<<city<<", "<<state<<endl;
 cout<<"Lodging: "<<lodging<<endl;
 cout<<"Address: "<<address_for_lodging<<endl;
 cout<<"price: $"<<price_for_lodging<<endl;
 cout<<"Miles from previous stop: "<< miles_from_last_stop<<endl;
 cout<<"Money spent on gas: $"<<money_spent_on_gas<<endl;
 cout<<"Rating for lodging: "<<lodging_rating<<endl;
 cout<<"------------------------------------------------------------------"<<endl;
 return true;
}
/*
This function takes in a tripPlan and copies it into the tripPlan is that calling the function.  this function is used in place of the '=' operatior.
INPUT: A tripPlan datatype.
OUTPUT: a bool to report success or failure.
*/
bool tripPlan::copy(tripPlan& to_copy)
{
  if(to_copy.trip_name == NULL || to_copy.city==NULL || to_copy.state==NULL || to_copy.lodging==NULL || to_copy.address_for_lodging ==NULL)
  {
   return false;
  }
  strcpy( trip_name, to_copy.trip_name);  
  strcpy(city,to_copy.city);
  strcpy (state,to_copy.state);
  strcpy(lodging,to_copy.lodging);
  strcpy(address_for_lodging,to_copy.address_for_lodging);
  price_for_lodging=to_copy.price_for_lodging;
  miles_from_last_stop=to_copy.miles_from_last_stop;
  lodging_rating = to_copy.lodging_rating;
  money_spent_on_gas = to_copy.money_spent_on_gas;
  return true;
}
