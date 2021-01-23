/*Brandon Danielski
CS163
10/25/2016
Assignment 2
This is the main for my second program. This program's main implementation is to create a trip planning tracker for the user.  The user can input stops along the way and then take the trip, inputting details about the trip as they go about their way.  The app then takes the user through a return trip and displays the info inputted by the user on the trip.  The user can then decide if they want to take another trip or exit.
*/


#include"app.h"
#include"stack.h"
#include"queue.h"
#include<iostream>
using namespace std;
int main()
{
int user_input = -1;// this will control the flow of menu options.
bool another_trip = false;//this will let main know whether or not the user want to take another trip after completing a trip.
tripPlan new_stop;
char* trip_name = new char[100];//this will give the name of the trip to main so that when a new stop is added, the name will be put into the stop.
 app userApp;
 stack s_trip;
 queue q_trip;
 userApp.first_greeting();
//the following code is hard coded stops I entered into the program to test, feel free to uncomment it and use it if you want.  There are warnings about conversions when the example code is compiled but it still works.
/* tripPlan trip1(((char*)"trip1"),((char*)"Savhannah"),((char*)"Georgia"),((char*)"Shady Sands Inn"),((char*)"1234 shady sands Blvd"),200,0);
 tripPlan trip2(((char*)"trip1"),((char*)"Norfolf"),((char*)"Virginia"),((char*)"Best Western"),((char*)"346 Pluto Ave."),79,240);
 tripPlan trip3(((char*)"trip1"),((char*)"Nasville"),((char*)"Tennesee"),((char*)"Holliday Inn"), ((char*)"0076 over there st."),100, 218);
 tripPlan trip4(((char*)"trip1"),((char*)"Wooster"),((char*)"Ohio"),((char*)"The Four Seasons"),((char*)"432 Lane St."),300,591);
 tripPlan trip5(((char*)"trip1"),((char*)"Boulder"),((char*)"Colorado"),((char*)"under a bridge"),((char*)"no address"),0,1145);
 tripPlan trip6(((char*)"trip 1"),((char*)"Omaha"),((char*)"Nebraska"),((char*)"Nowhere Inn"),((char*)"13 corn place"), 22,245);

 q_trip.enqueue(trip1);
 q_trip.enqueue(trip2);
 q_trip.enqueue(trip3);
 q_trip.enqueue(trip4);
 q_trip.enqueue(trip5);
 q_trip.enqueue(trip6);*///This is the end of the hard code exmples.  Anything else after the is not meant to be uncommented.*/

/* s_trip.push(trip1);
 s_trip.push(trip2);
 s_trip.push(trip3);
 s_trip.push(trip4);
 s_trip.push(trip5);
 s_trip.push(trip6);*/
 userApp.name_trip(trip_name);
 while(user_input == -1)
 {
  userApp.main_menu(user_input);
  if(user_input == 1)
  {
//     tripPlan new_stop;
     userApp.add_stop(new_stop);
//     cout<<"newStop is now:"<<endl;
     new_stop.display_trip();
     q_trip.enqueue(new_stop); 
 //    s_trip.push(new_stop);
     user_input = -1;
  }
  else if(user_input ==2)
  {
   q_trip.display_all();
   user_input = -1;
  } 
  else if(user_input ==3)
  {
    userApp.take_trip(q_trip,s_trip); 
    another_trip =userApp.another_trip();
    if(another_trip == true)
      {
       cin.clear();
       cin.ignore();
       userApp.name_trip(trip_name);
    //   s_trip.~stack();
    //   q_trip.~queue();
       another_trip = false;
      }
    else if(another_trip == false)
      {
        cin.clear();
        cin.ignore();
        cout<<"Press any key to exit program"<<endl;
        cin.get();
        delete[] trip_name;
    //    s_trip.~stack();
   //     q_trip.~queue();    
        return 0;

      }
   //the_trip.~stack();  
//    userApp.name_trip(trip_name);
  //  cout<<"Exiting program"<<endl;
  //  cin.get();
//    return 0;
     user_input = -1;
  }
  else if(user_input == 4)
  {
     //destructors here.
    delete[] trip_name;
 //   s_trip.~stack();
//    q_trip.~queue();    
    userApp.~app();
    return 0;
  }
  else
  {
    userApp.error_message();
  }
 } 
}
