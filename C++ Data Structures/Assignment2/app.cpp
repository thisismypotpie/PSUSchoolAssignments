/*Brandon Danielski
CS163
10/25/2016
Assignment 2
This is the cpp file for the app of my program.  As stated in the .h file, this part of the program takes the user through various menues and collects user input to get data to put into the queue.
*/
#include"app.h"
//#include"tripPlan.h"
#include<cstring>
#include<iostream>
using namespace std;



/*This is the contructor for the app, it sets all of the numbers to 0 and allocates 100 chars for the trip name array.*/
app::app()
{
user_input_for_selections = 0;
trip_name = new char[100];
total_spent_on_gas = 0.0;
}

app::~app()
{
if(trip_name)
{
delete[] trip_name;
trip_name = NULL;
}
}

/*This function first greets the user and welcomes them to the app.  I put this in its own function ecause I only want it to be displayed the first time the user runs the program, not every time the loop goes back to the main menu.
INPUT: NONE
OUTPUT: cout statement.
*/
void app::first_greeting()
{
cout<< "Welcome to the Trip Planning App!"<<endl;
}



/*In main, there is a loop that acts as choices for the main menu.  Depending on which choice the user inputs, there is an if else series checking for matching input, if for some reason there is not match and the error is not cause I have an else statement that will display this message to the user.
INPUT: NONE
OUTPUT: cout statment.
*/
void app::error_message()
{
  cout<<"There was an error with the menu you are on."<<endl;
}



/*This allows the user to input the information that will name the trip.  The user will be prompted to input a name that will be checked and if the user has not inputted anything the function will repear until they do insuring no null data.
INPUT: A char array to copy into main so that main can input the name into future stops so all stops will have the same trip name.
OUTPUT: cout statemnt asking the user what they want to name the trip, an error message if they leave it blank, and a bool reporting success or failure.
*/
bool app:: name_trip(char* main_name)
{
bool isEmpty = true;//This is false if the array has data and true if the array does not have data.
cout<<"What would you like to name this trip?"<<endl;
cin.getline(trip_name,100);
 for(int i=0; i<100;i++)
 {
   if(*(trip_name+i))
   {
    isEmpty = false;
    i = 100;
   }
   if(i == 99 && isEmpty == true)
   {
    cout <<"You have not enetered anything, please enter something."<<endl;
    cin.clear();
    return name_trip(main_name);
   }
 }
  main_name[strlen(trip_name)];
  main_name = trip_name;
}


 
/*This is the main menu for the program.  From here the usr can decide where to go next by input the number that corresponds with the desired option.
INPUT: A number that will communicate backt to main what the user has chosen.
OUTPUT: A menu for the user to select and option, error messages if they do not enter valid info, and a bool to report success or failure. 
*/
bool app:: main_menu(int & input)
{
 cout<<"Please select a number from the following options:"<<endl;
 cout<<"1. Add a stop"<<endl;
 cout<<"2. View All Stops"<<endl;
 cout<<"3. Take trip"<<endl;
 cout<<"4. Exit"<<endl;
 cin >> user_input_for_selections;
 if(cin.fail()|| user_input_for_selections < 1 || user_input_for_selections > 4)
 {
  cout<<"What you have entered is incorrect, please enter only a number between 1 and 3."<<endl;
  cin.clear();
  cin.ignore();
  return main_menu(input);
 }
input = user_input_for_selections;
return true;
}



/*When adding a stop this function will collect the user input for the data of the stop and then copy the data to a triPlan that was pssed in by refernce.  The function will ask the user for theinformation and tell the user if they info they entered was valid or not.
INPUT: User input and a tripPlan to_copy
OUTPUT: A series of question to collect data from the user, error messages for invalid data, and a bool to report success or failure.
*/
bool app::add_stop(tripPlan& to_copy)
{
 char* city=new char[100];// an array to get info from the user to input into the to_copy datatype.
 char* state=new char [100];// an array to get info from the user to input into the to_copy datatype.
 char* lodging=new char[100];// an array to get info from the user to input into the to_copy datatype.
 char* address= new char [100];// an array to get info from the user to input into the to_copy datatype.
 int price = 0;// an integer to get info from the user to input into the to_copy datatype.
 int miles = 0;// an integer to get info from the user to input into the to_copy datatype.
 bool isEmpty = true;// a bool to see if any array is empty or not.
 cin.clear();
 cin.ignore();
 while(isEmpty == true)
 {
 cout<<"What is the name of the city of you next destination?"<<endl;
 cin. getline(city,100);
 for(int i=0; i<100;i++)
 {
   if(*(city+i))
   {
    isEmpty = false;
    i = 100;
   }
   if(i == 99 && isEmpty == true)
   {
    cout <<"You have not enetered anything, please enter something."<<endl;
    cin.clear();
   }
 }
 }
 isEmpty = true;
 while(isEmpty == true)
 {
 cout<<"What is the name of the state of you next destination?"<<endl;
 cin. getline(state,100);
 for(int i=0; i<100;i++)
 {
   if(*(state+1))
   {
    isEmpty = false;
    i = 100;
   }
   if(i == 99 && isEmpty == true)
   {
    cout <<"You have not enetered anything, please enter something."<<endl;
    cin.clear();
   }
 }
 }
 isEmpty = true;
 while(isEmpty == true)
 {
 cout<<"What is the name of the hotel of you next destination?"<<endl;
 cin. getline(lodging,100);
 for(int i=0; i<100;i++)
 {
   if(*(lodging+i))
   {
    isEmpty = false;
    i = 100;
   }
   if(i == 99 && isEmpty == true)
   {
    cout <<"You have not enetered anything, please enter something."<<endl;
    cin.clear();
   }
 }
 } 
 isEmpty = true;
 while(isEmpty == true)
 {
 cout<<"What is the address of the hotel of you next destination?"<<endl;
 cin. getline(address,100);
 for(int i=0; i<100;i++)
 {
   if(*(address+i))
   {
    isEmpty = false;
    i = 100;
   }
   if(i == 99 && isEmpty == true)
   {
    cout <<"You have not enetered anything, please enter something."<<endl;
    cin.clear();
   }
 }
 } 
 isEmpty = true;
 while(isEmpty == true)
 {
 cout<<"What is the price of the hotel of your next destination?"<<endl<<"$ ";
 cin >> price; 
 if(cin.fail() || price < 0)
 {  
  cout<<" The price you have entered is invalid, please enter a number greater than -1."<<endl;
  cin.clear();
  cin.ignore();
 }
 else
 {
  isEmpty = false;
 }
 }
 isEmpty = true;
 while(isEmpty == true)
 {
 cout<<"How many miles did you travel to get to your current stop?"<<endl;
 cin >> miles;
 if(cin.fail() || miles< 0)
 {  
  cout<<" The miles you have entered are invalid, please enter a number greater than -1."<<endl;
  cin.clear();
  cin.ignore();
 }
 else
 {
  isEmpty = false;
 }
 // cin.fail block.
 }
 cout<<1<<endl; 
 tripPlan temp_stop(trip_name,city,state,lodging,address,price,miles);
 cout<<"new stop in app created: "<<&temp_stop<<endl;
 to_copy.copy(temp_stop); 
 cout <<"Your stop has been saved."<<endl;
 
if( city)
{
delete[] city;
city=NULL;
}
if(state)
{
delete[] state;
state=NULL;
}
if(lodging)
{
delete[] lodging;
lodging=NULL;
}
if(address)
{
 delete[] address;
 address = NULL;
} 
return true;
}



bool app::take_trip(queue& there_trip, stack& return_trip)
{
float gas_money = -1.0;
int rating = 0;
tripPlan current_stop;

while( there_trip.peek(current_stop)== true)
{
//cout<<"Loop start"<<endl;
//current_stop.display_trip();
while(gas_money <0)
{
   cout<<"How much did you spend on gas to get here?"<<endl<<"$ ";
   cin>>gas_money;
   if(cin.fail()||gas_money <0.0)
   {
    cout<<"What you have entered is incorrent, please enter a number that is greater than $0.  You may enter $0.00."<<endl;
    gas_money = -1.0;
    cin.clear();
    cin.ignore();
   }
   else
   {
    current_stop.copy_money_spent_on_gas(gas_money); 
   }
}

cin.clear();
cin.ignore();
while(rating < 1)
{
 cout<<"On a scale of 1-10, how would you rate your current lodging?"<<endl;
cin >> rating;
if(cin.fail()||rating <0 || rating > 10)
  {
   cout<<"Please only enter a whole number between 1 and 10."<<endl;
   rating = 0;
   cin.clear();
   cin.ignore();
  } 
  else
  {
   current_stop.copy_lodging_rating(rating);
  }
}
//current_stop.display_return_trip();
cout<<"Traveling to next stop"<<endl;
cin.clear();
cin.ignore();
return_trip.push(current_stop);
there_trip.dequeue();
gas_money =-1.0;
rating = 0;
}
cout<<"You will now be taking the return trip."<<endl;
cout<<"Press any key to take return trip"<<endl;
cin.get();
//return_trip.display_all();
while(return_trip.peek()==true)
{
cout<<"Press any key to go to the next stop."<<endl;
cin.get();  
return_trip.pop();
}
cout<<"Your trip is completed,  press any key to continue."<<endl;
cin.get();
return true;
}



/*When the trip is complete the user is asked if they want to take another trip.  If they do they are taken to the main menu to make a new trip, if not them the program is exited.
INPUT: user input on whether ot not they want to plan another trip.
OUTPUT: Cout statment asking if they want to go on another trip.
*/
bool app::another_trip()
{
int input = 0;//local integer for usr input.
while(input==0)
{
cout <<"Would you like to take another trip?"<<endl;
cout<<"Press 1 for yes or 2 for no."<<endl;
cin >> input;
if(input == 1)
{
 return true;
}
else if(input == 2)
{
 return false;
}
else
{
input = 0;
cin.clear();
cin.ignore();
cout<<"What you have entered is invalid, please enter a 1 or yes or 2 for no."<<endl;
}
}
}
