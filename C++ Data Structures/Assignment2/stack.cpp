 /*
Brandon Danielski
10/25/2016
CS163
Assignment 2
This is the stakc cpp file.  The stack is used for the return trip of the program.  It goes through the queue in reverse order so that the user can get through the trip.  Each node of the stack an array of five tripPlans.
*/
#include "stack.h"
 #include<iostream>
//#include "tripPlan.h"
using namespace std;



/*
This is the constructor.
*/
stack::stack()
{
head = NULL;
top_index = 0;
MAX = 5;
}



/*
This is the destructor.
*/
stack:: ~stack()
{
node*temp = NULL;
if(head)
{
while(head!=NULL)
{
temp = head->next;
delete[] head->stops;
delete head;
head = NULL;
head = temp;
}
}
}

/*
rhis function pushes one  tripPlan onto the stack which is a complilaton of array nodes.  If an array is filled then a new node with an empty array is created. The reason we have to index becoming -1 every time we start a new node is because the top index iterates before operations so in oder to prevent the nodes skipping over element zero we set the top index to -1 so that when the top index increments once it starts at zero.  Top index is still initialzed to 0 in the constructor.
INPUT: tripPlan to be added onto the stack.
OUTPUT:  NONE
*/
bool stack::push( tripPlan& to_add)
{
//cout<<"push triggered"<<endl;
if(!head)
{
 //cout<<"creating head"<<endl;
 //cout<<"Top index is: "<<top_index<<endl;
 head = new node;
 head -> next = NULL;
 head -> stops = new  tripPlan[MAX]; 
 //cout<<"pushing: "<<to_add.display_trip();
(head->stops+ top_index)->copy(to_add);
 return true;
}
++ top_index;
//cout<<"top index is now: "<<top_index<<endl;
//cout<<"pushing: "<<to_add.display_trip();
(head->stops+ top_index)->copy(to_add);
if(top_index == 4)
{
 node* new_node = new node;
 new_node->next = head;
 head = new_node;
 new_node -> stops = new  tripPlan[MAX];
 top_index = -1;
//cout<<"top index is now: "<<top_index<<endl;
return true;
}
return true; 
}



/*
This function removes the item on the top of the stack.  When an item is removed the top index is decremented and if the entire array is empty the node is deleted and head becomes the next node.
INPUT: NONE
OUTPUT:An error message.
*/
bool stack::pop()
{
 node* temp = NULL;
 if(!head)
 {
  cout<<"There are currently no stops."<<endl;
  return true;
 }
 if(top_index == 0||-1)//we removed the -1 from top index.
 {
//  cout<<"Top index is zero"<<endl;
  if(head-> next)
  { 
 //  cout<<"Head->next exists"<<endl;
   temp = head->next;
    delete[]head -> stops;
    delete head;
    head = temp;
    temp = NULL;
    top_index = 4;
//cout<<"top index is now: "<<top_index<<endl;
   return true;
  }  
 else if(!head->next&& top_index == 0 || top_index ==-1)
  {
  // cout<<"Deleting head"<<endl;
   delete head;
   head = NULL;
   top_index = 0;
   return true;
  }
 }
 // cout<<"Top index decremented"<<endl;
  --top_index; 
//cout<<"top index is now: "<<top_index<<endl;
 
//cout<<"Popped"<<endl;
// delete temp;
return true;
}



/*
Allows the user to see what is on top of the stack without popping it. This is used in teh return trip to let the user know where they are on the trip.
INPUT: NONE
OUTPUT:  node at the top of the stack.
*/
bool stack::peek()
{
 if(head)
 { 
 //cout<<"Top index is: "<<top_index<<endl;
 if(top_index >=0)
 {
 cout<<"You are currently at this stop: "<<(head->stops+top_index)->return_trip_display()<<endl;//we removed the -1 from the top index.
 }
 else if(top_index == -1)
 {
 cout<<"You are currently at this stop: "<<(head->stops+0)->return_trip_display()<<endl;//we removed the -1 from the top index.
 }
 }
 else
{
//cout<<"There are no stops."<<endl;
return false;
}
 return true;
}



/*
Displays all of the nodes on the stack.
INPUT:NONE
OUTPUT: Displays all nodes on the stack.
*/
bool stack::display_all()
{
int temp_top_index = top_index-1;
node* current = head;
while(current)
{

  if(temp_top_index >=0)
  {
 (current->stops+temp_top_index)->display_trip();
  --temp_top_index;
  }
  else if(temp_top_index< 0)
  {
  if(current->next)
  {
   current = current->next;
   temp_top_index = 4;
  }
  else
  {
   current = NULL;
  }
  }
}
delete current;
}
