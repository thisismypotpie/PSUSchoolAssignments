//This cpp file is called app.  It controls everything the user sees and does the majority of the error handling caused by user input.  It contains a series of menus for the user to interact with and are mostly number based meaning the user will input a number and the app will deterine if the input is valid and move on from there.
#include<iostream>
#include"app.h"
#include"tutor.h"
using namespace std;
//the app constructor.  The only private data member of this class is the userInputRorSelctions which takes the user input and uses it to determine what to do next.
app::app()
{
 userInputForSelections = -1; 
}
// lets main retrieve what the user has most recently inputted.
int app::getUserInputForSelections()
{
 return userInputForSelections;
}
bool app::setUserInputForSelections(int setTo)
{
 userInputForSelections = setTo;
}
// This will introduce the user to the program, it is one line and is only output so it is void.
void app:: intro()
{
 cout << "Welcome to the help finding program, here are all of the subjects with cataloged forms of help." <<endl;
}
// This function takes user input from the user and compares it to the length of the linked list to see if the number inputted is less than or ewual to the length so that there are no out of bounds errors.
int app:: choosingAnItem()
{
 int returnnum = -1;
 cout <<"Please enter the number cooresponding with the subject you would like to find help in." <<endl;
 cin >> returnnum;
 if(cin.fail() || returnnum < 1)
{
 cout <<"What you have entered is incorrect, please enter only a number."<<endl;
 cin.clear();
 cin.ignore();
return choosingAnItem();
}
return returnnum;
}
//This is the first main menu the user will see, it is what the user will interact with and the first of many menus.
bool app::menuOne()
{
  cout<<"Please select the number of the option below:"<<endl;
  cout<<"1. View list of help available."<<endl;
  cout<<"2. Delete anything from the list with rating 3 or lower"<<endl;
  cout <<"3. Add new form of help to the list."<<endl;
cout<<"4. Exit"<<endl;
 cin >> userInputForSelections;
 if(cin.fail() || userInputForSelections > 5 || userInputForSelections < 1)
{
cin.clear();
cin.ignore();
cout <<"What you have entered is invalid, please only enter any number from one to four."<<endl;
userInputForSelections = -1;
return menuOne();
} 
}
//If for some reason user input is ot accepted in the main menu then this error will appear and the user wll be taken back to the main menu.
bool app::MenuError()
{
cout <<"Something went wrong with the app, returning you to main menu"<<endl;
userInputForSelections = -1;
}
// if the user chooses to view the list of help from the main menu this after it is displayed, this menu will appear and with further options for the user.
bool app::menuForViewingList()
{
 cout<<"What would you like to do now? Please enter the number of the option you want."<<endl;
 cout<<"1. Get more deatils on something from the list."<<endl;
 cout<<"2. View the list with items that are rated 8 or higher."<<endl;
cout <<"3. Return to main menu"<<endl;
cin >> userInputForSelections;
if(cin.fail() || userInputForSelections > 3 || userInputForSelections < 1)
{
 cin.clear();
 cin.ignore();
 cout<<"What you have entered is invalid, please only enter any number from one to three."<<endl;
userInputForSelections = -1;
return menuForViewingList();
}
}
//if the user chooses a particular tutor help from the list, this menu will give the user even more options.  Such as changing the rating of the tutor the user selected or returning to the frst main menu.
bool app::menuForViewingItemOnList()
{
 cout <<"What would you like to do now? Please enter the number of the option you want."<<endl;
cout <<"1.Change rating of this item."<<endl;
cout <<"2. Return to main Menu"<<endl;
cin >> userInputForSelections;
if(cin.fail()|| userInputForSelections !=1 && userInputForSelections!=2)
{
 cin.clear();
 cin.ignore();
 cout <<"What you have entered is invalid, please enter only a one or two"<<endl;
userInputForSelections = -1;
return menuForViewingItemOnList();
}
}
//This function checks for uer input vs the length of the list to make sure that when a user wants to select an item from the list, they dont pick a number larger than the list.
bool app::checkNum(int numToCheck, int listLength)
{
if(numToCheck == 0)
{
userInputForSelections = 0;
return true;
}
  cout <<"num to check: "<<numToCheck<<endl;
  cout <<"list length: " <<listLength<<endl;
  if(numToCheck < 0 || numToCheck > listLength)
{
  cout << "The number you have entered is not on the list, or a zero to add to the list, please try again."<<endl;
  return false;
}
else
{
userInputForSelections = numToCheck;
}
return true;
}
// this function changes the rating of the item on the list selected by the user.
int app::changeRating()
{
 int returnnum = 0;
 cout<<"What would you like to chnage the rating to?"<<endl;
 cin >> returnnum;
 if(cin.fail()||returnnum<1 || returnnum >10)
 {
  cout <<"What you have entered is invalid, please enter a number between 1 and 10."<<endl;
 cin.clear();
 cin.ignore();  
 return changeRating();
 }
 return returnnum;
}
//This app has a tutor passed by reference and then the user is prompted to enter information regarding the addition of a new item to later be added to the list.  In here the user is asked for a subject, type of help, times the tutor is availale, etc.
bool app::addTutorInfo(tutor& newTutor)
{
  int maxSize = 50;
  char*subject = new char[maxSize];
  int rating = 0;
  char* helpType = new char[maxSize];
  char*location = new char[maxSize];
  char*days = new char[maxSize];
  char*time = new char[10*maxSize];
  char*desc = new char[10*maxSize];
  int beginTime= 0;
  int endTime = 0;

  int userInput = 0;  
  bool isOnline = false;
  bool isEmpty = true;
  cin.clear();
  cin.ignore();
  while( isEmpty == true)
  {
  cout<<"Please enter a subject for the new form of help."<<endl;
  cin.getline(subject,maxSize);
    for(int i = 0; i < maxSize; i++)
    {  
      if(!location[i] && i ==maxSize-1)
      {
        cout<<"You have not entered anything, please enter something"<<endl;
        cin.clear();
      }
      if(subject[i])
      {
        isEmpty = false;
        i = maxSize;
      }
    }
  }
  isEmpty = true;
  while( rating == 0)
  {
  cout<<"Please enter a rating between 1 and 10."<<endl;
  cin >> rating;
  if(cin.fail() || rating > 10 || rating < 0)
  {
   cout <<"Please enter only a number between 1 and 10."<<endl;
   cin.clear();
   cin.ignore();
   rating = 0;
  }
  }
  userInput = 0;
  cin.clear();
  cin.ignore();
  while(userInput == 0)
  {
 
  cout <<"What kind of help is offered, press 1 for online and 2 for on campus."<<endl;
  cin >> userInput;
  if(userInput !=1 &&userInput!=2 || cin.fail())
  {
   cout<<"Please only enter a 1 or 2."<<endl;
   cin.clear();
   cin.ignore();
   userInput = 0;
  }
  else if(userInput == 1)
  {
   helpType =((char*) "online");  
   days = ((char*)"-");
   time = ((char*)"-");   
   isOnline = true;
  }
  else if(userInput == 2)
  {
   helpType = ((char*)"on campus");
   isOnline = false;
  }
  }
  cin.clear();
  cin.ignore();
  while(isEmpty == true)
 {
  cout<<"Please enter the location or URL of the new form of help."<<endl;
  cin.getline(location,maxSize);
  for(int i = 0; i< maxSize;i++)
  {
   if(!location[i] && i ==maxSize-1)
   {
    cout <<"You have not enterd anything, please enter somthing."<<endl;
    cin.clear();
   }
   if(location[i])
   {
    isEmpty = false;
    i = maxSize;
   }
  }
 }
  isEmpty = true;
  userInput = 0;
 if(isOnline == false)
 {
  while(userInput == 0)
  {
   cout<<"Is the tutor available on Monday?"<<endl;
   cout<<"1. yes"<<endl;
   cout<<"2.No" <<endl;
   cin>>userInput;
   if(cin.fail()||userInput!=1 && userInput !=2)
   {
    cout <<"Plese only enter a 1 or 2."<<endl;
    cin.clear();
    cin.ignore();
    userInput = 0;
   }
   else if(userInput == 1)
   {
    for(int i =0; i < maxSize; i++)
    {
     if(!days[i])
    {
       days[i] = 'M';
       days[i+1] = ',';
      i = maxSize; 
    }
    }
   }
  }
  userInput = 0;
  while(userInput == 0)
  {
   cout<<"Is the tutor available on Tuesday?"<<endl;
   cout<<"1. yes"<<endl;
   cout<<"2.No" <<endl;
   cin>>userInput;
   if(cin.fail()||userInput!=1 && userInput !=2)
   {
    cout <<"Plese only enter a 1 or 2."<<endl;
    cin.clear();
    cin.ignore();
    userInput = 0;
   }
   else if(userInput == 1)
   {
    for(int i =0; i < maxSize; i++)
    {
     if(!days[i])
      {
       days[i] = 'T';
       days[i+1] = ',';
       i = maxSize;
      }
    }
   }
  }
  userInput = 0;
  while(userInput == 0)
  {
   cout<<"Is the tutor available on Wednesday?"<<endl;
   cout<<"1. yes"<<endl;
   cout<<"2.No" <<endl;
   cin>>userInput;
   if(cin.fail()||userInput!=1 && userInput !=2)
   {
    cout <<"Plese only enter a 1 or 2."<<endl;
    cin.clear();
    cin.ignore();
    userInput = 0;
   }
   else if(userInput == 1)
   {
    for(int i =0; i < maxSize; i++)
    {
     if(!days[i])
      {
       days[i] = 'W';
       days[i+1] = ',';
       i = maxSize;
      }
    }
   }
  }
  userInput = 0;
  while(userInput == 0)
  {
   cout<<"Is the tutor available on Thursday?"<<endl;
   cout<<"1. yes"<<endl;
   cout<<"2.No" <<endl;
   cin>>userInput;
   if(cin.fail()||userInput!=1 && userInput !=2)
   {
    cout <<"Plese only enter a 1 or 2."<<endl;
    cin.clear();
    cin.ignore();
    userInput = 0;
   }
   else if(userInput == 1)
   {
    for(int i =0; i < maxSize; i++)
    {
     if(!days[i])
      {
       days[i] = 'T';
       days[i+1] = 'H';
       days[i+2] =',';
       i = maxSize;
      }
    }
   }
  }
  userInput = 0;
  while(userInput == 0)
  {
   cout<<"Is the tutor available on Friday?"<<endl;
   cout<<"1. yes"<<endl;
   cout<<"2.No" <<endl;
   cin>>userInput;
   if(cin.fail()||userInput!=1 && userInput !=2)
   {
    cout <<"Plese only enter a 1 or 2."<<endl;
    cin.clear();
    cin.ignore();
    userInput = 0;
   }
   else if(userInput == 1)
   {
    for(int i =0; i < maxSize; i++)
    {
     if(!days[i])
      {
       days[i] = 'F';
       days[i+1] = ',';
       i = maxSize;
      }
    }
   }
  }
  userInput = 0;
  while(userInput == 0)
  {
   cout<<"Is the tutor available on Saturday?"<<endl;
   cout<<"1. yes"<<endl;
   cout<<"2.No" <<endl;
   cin>>userInput;
   if(cin.fail()||userInput!=1 && userInput !=2)
   {
    cout <<"Plese only enter a 1 or 2."<<endl;
    cin.clear();
    cin.ignore();
    userInput = 0;
   }
   else if(userInput == 1)
   {
    for(int i =0; i < maxSize; i++)
    {
     if(!days[i])
      {
       days[i] = 'S';
       days[i+1] = 'T';
       days[i+2] = ',';
       i = maxSize;
      }
    }
   }
  }
  userInput = 0;
  while(userInput == 0)
  {
   cout<<"Is the tutor available on Sunday?"<<endl;
   cout<<"1. yes"<<endl;
   cout<<"2.No" <<endl;
   cin>>userInput;
   if(cin.fail()||userInput!=1 && userInput !=2)
   {
    cout <<"Plese only enter a 1 or 2."<<endl;
    cin.clear();
    cin.ignore();
    userInput = 0;
   }
   else if(userInput == 1)
   {
    for(int i =0; i < maxSize; i++)
    {
     if(!days[i])
      {
       days[i] = 'S';
       days[i+1] = 'N';
       days[i+2] = ',';
       i = maxSize;
      }
    }
   }
  }
  userInput = 0;
 while(userInput == 0)
 {
  cout<<"What time does the tuoring begin? Please enter any number between 1 and 12."<<endl;
  cin >> userInput;
  if(cin.fail() || userInput < 1 || userInput > 12)
  {
   cout<<"Plese only enter a number betwwen 1 and 12."<<endl;
   cin.clear();
   cin.ignore();
   userInput = 0;
  }
  else
  {
   
   beginTime = userInput;
  }
 }  
  userInput = 0;
 while(userInput == 0)
 {
  cout<<"What time does the tutor end? Please enter any number between 1 and 12."<<endl;
  cin >> userInput;
  if(cin.fail() || userInput < 1 || userInput > 12)
  {
   cout<<"Plese only enter a number between 1 and 12."<<endl;
   cin.clear();
   cin.ignore();
   userInput = 0;
  }
  else
  {
 
  endTime = userInput;
  /*strcpy(time,beginTime);
  strcat(time,((char*)"-"));
   strcat(time,endTime);*/
  }
 }
} 
 cout<<" Please enter a brief description of the tutor."<<endl;
cin. getline(desc,10*maxSize);
 tutor addTutor(subject,rating,helpType,location,days,time,desc);
  newTutor = addTutor;
}

