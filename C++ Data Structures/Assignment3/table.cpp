/*
Brandon Danielski
11/4/2016
CS 163 
Assigment 3
This is the Tble ADT.  It is the data stucture that will store video game data into a table.  It will store with an index and can be retrieved by a keyword.
*/
#include<iostream>
#include<cstring>
#include"table.h"
using namespace std;



/*
Contructor for the table ADT.
INPUT: none
OUTPUT: none
*/
table::table()
{
MAX = 101;
hasher = new node*[MAX];
for(int i=0; i< MAX;i++)
{
*(hasher+i)=NULL;
}
}



/*
Destructor for the table ADT.
INPUT: none
OUTPUT: none
*/
table::~table()
{
node* temp = NULL;
node* temp_temp =NULL;
for(int i =0; i<MAX; i++)
{
  if(*(hasher + i))
  {
//      cout<<"deleteing index "<<i<<endl;
      temp = *(hasher + i);
      while(temp)
      {
  //      cout<<"TEMP IS:" << temp->data.display_game()<<endl;
        temp_temp = temp; 
        temp = temp_temp->next; 
        delete temp_temp;
      }
   }
}
delete[] hasher;
}




/*
This function inserts a game into the hash table.  Ther are two cases this function is called are when the data files uses it to insert all of the games in the file and when the user inputs a new game into the table.
INPUT: A game that will be stored into the hash table.
OUTPUT: The element that the game gets put into.
*/
int table::insert(game& to_store)
{
char* name = new char[2000];
int index = 0;
to_store.copy_name(name);
index=hash_function(name);
node* new_node = new node();
new_node->data.copy(to_store);
new_node->next = *(hasher+index);
*(hasher+index) = new_node;

if(name)
{
delete[] name;
}
return index;
}



/*
This is my hash function for the hash table.  Fo this function I add the ASCII values of all the the chars of the name of the game and then mod by the size of the hash table, which in this case is 101.
INPUT: a key char array
OUTPUT: a key index int
*/
int table::hash_function(char*& key)
{
// cout<<"key is: "<<key<<endl;
// cout<< "length is: "<<strlen(key)<<endl;
//cout<<key<": ";
 int sum = 0;
 for(int i=0;i<strlen(key); i++)
 {
//   cout<<(int(*(key+i)))<<", ";
    if((int(*(key+i)))!=13)//each game added has a 13 at the end for some reason so here i am amaking sure this is not added in the hash function.
    {
    sum  = sum + *(key + i);   
    }
 }
// cout<<"index is: "<<sum%MAX<<endl<<endl;
 return sum%MAX;
}



/*
The function displays all of the games in the hash table by index an by chain if one exists.
INPUT: The current index that is being searched.OUTPUT: A bool to report sucess or failure.
*/
bool table::display_all(int index)
{
 node* temp = *(hasher + index);
 if(index == MAX)
 {
  return true;
 }
 while(temp)
{
//  cout<<"Index: "<<index<<endl;
  temp->data.display_game();
  temp = temp->next;
}
 display_all(++index); 
}



/*
The function retrieves a game's informtion by name by strcmp with what the user inputs.  The function searches by entereing a key char array into the hash function and then searhing the chain by strcmp each name until there is a match.
INPUT: the game that will be retrieved and a char array to be sent into the hash function to find a match.
OUTPUT: A bool to report success or failure. 
*/
bool table::retrieve(game& copy_to, char*& key)
{
  int index = hash_function(key);
  //cout<<"index: "<<index<<endl;
//  cout<<"key returned from hash function: "<<index<<endl;
  char* game_name = new char[2000];
  if(!*(hasher + index))
  {
 //  cout<<"does not exist"<<endl; 
  if(game_name)
  {
  delete[] game_name;
  }
    return false;
  }  
  node* temp = *(hasher + index);
  //cout<<"Temp assigned as: "<<temp->data.display_game();
    while(temp)
    {
   //  cout<<"loop started"<<endl;
     temp->data.copy_name(game_name);
    // cout<<"key: "<<key<<endl;
    // cout<<"game name: "<<game_name<<endl;
     if(strcmp(key,game_name)==0)
     {
       cout<<"Here is the game that was matched with your input."<<endl;
       copy_to.copy(temp->data);
       temp->data.display_game();
       delete[]game_name;
       return true;
     }
     else
     { 
      temp = temp->next;  
     }
   }
  return false;
}
int table::list_size()
{
return MAX;
}




/*
A special copy furnction just for ex_file to geta node and which then ex_file copies into the data file.
INPUT: A node to be copied to.
OUTPUT: A bool to report success or failure.
*/
bool table::retrieve_for_ex_file(node*&  copy_to,int pos)
{
  copy_to = *(hasher+pos);
}



/*
This function removed the data of a user selected game from the hash table.
INPUT: a char array that was inputted by the user.
OUTPUT: a bool to report success or failure.
*/
bool table::remove(char*& key)
{
int index = hash_function(key);
char* game_name = new char[2000];
bool prev_found = false;
node* temp = NULL;
node* temp2 = NULL;
if(!*(hasher + index))//if there is no table yet.
{
if(game_name)
{
delete[] game_name;
}
return false;
}
temp = *(hasher + index);
temp2= *(hasher + index);
while(temp)//goes through the chain.
{
//cout<<"loop start"<<endl;
temp->data.copy_name(game_name);
if(strcmp(key,game_name) ==0)
{
  //cout<<"Match found"<<endl;
  if(temp == *(hasher + index))//if we are deleteing a head node
  {
  // cout<<"deleting head"<<endl;
   temp = *(hasher + index);
   temp = temp->next;
   delete *(hasher + index);
   *(hasher + index) = temp;
   cout<< game_name<<" has be removed."<<endl;
   if(game_name)
   {
    delete[] game_name;
   }
   return true;
  }
  else//not a head deletion.
  {
  while(prev_found == false)//find the prevous to the node we want to delete.
  {
    if(temp2->next == temp)
    {
    //  cout<<"Prev found"<<endl;
      prev_found = true;
    }
    if(!temp2)
    {
     // cout<<"returning false"<<endl;
      if(game_name)
      {
       delete[] game_name;
      }
      return false;
    }
  if(prev_found == false)
  {
  temp2 = temp2->next;
  }
  }  
   // cout<<"removing game"<<endl;
    temp2->next = temp->next;
    delete temp;
   cout<< game_name<<" has be removed."<<endl;
   if(game_name)
   {
    delete[] game_name;
   }
   return true;
  }
}
else
{
temp = temp->next;
}
}
cout<<"The game you are looking for could not be found."<<endl;
return false;
}



/*
This function finds all games that have a platform for what the user inputs and displays them.  This works by parsing the platform char array in each game's platform section and then strcmp withwhat the user inputs.  Each platform when inputted both by the user and ex_file hav all whitespaces removed and all letter converted to capital letters to for better comparison.
INPUT: a char array that is the platform the user is looking for.
OUTPUT: a bool to return success or failure.
*/
bool table::retreive_platform(char* platform)
{
  node* temp = NULL;
  char* game_plat = new char[2000];
  char* new_char = new char[2000];
  int char_value = 0;
  for(int i =0;i<2000;i++)
  {
    *(game_plat+i)=0;
    *(new_char+i)=0;
  }
  int at = 0;
  for(int i=0;i<MAX;i++)//goes through each element of the table.
  {
  //  cout<<"starting search of element: "<<i<<endl;
     temp = *(hasher+i);
     while(temp)//goes through each item in the chain.
     { 
//      temp->data.display_game();
      temp->data.copy_platform(game_plat);
      for(int j=0;j<strlen(game_plat);j++)//goes through each char of each item of each chain.
      {
        if(*(game_plat+j) ==',')
        {
         // cout<<"Comparing "<<new_char<<" and "<<platform<<endl;
         // cin.get();
          if(strcmp(new_char,platform)==0)
          {
            temp->data.display_game();
          }
          at = 0;
        //  cout<<"remove 1"<<endl;
          for(int k=0;k<2000;k++)
          {
            *(new_char+k)=0; 
          }
        }
        else
        {
         if(*(game_plat+j)!=' '&&*(game_plat+j)&&*(game_plat+j)!=13)
         {
      //    cout<<"adding: "<<*(game_plat+j)<<endl;
      //    cout<<"num: "<<(int(*(game_plat+j)))<<endl;
           char_value = (int(*(game_plat+j)));
	  *(new_char+at)= char_value;
       //   cout<<"new added: "<<*(new_char+at)<<endl;
          ++at;
     //     cout<<"new char so far: "<<new_char<<endl;
         }
        }
      }
  ///    cout<<"2Comparing "<<new_char<<" and "<<platform<<endl;
     // cin.get();
      if(strcmp(new_char,platform)==0)
      {
        temp->data.display_game();
      }
//          cout<<"remove2"<<endl;
          for(int k=0;k<2000;k++)
          {
            *(new_char+k)=0; 
          }
      at = 0;
      temp=temp->next;
     }
  }
if(game_plat)
{
delete[] game_plat;
}
if(new_char)
{
delete[] new_char;
}
return true;
}
