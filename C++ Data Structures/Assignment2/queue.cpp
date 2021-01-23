/*
Brandon Danieski
CS163
10/25/2016
Assignment 2
This is the queue cpp file.  It will allow for enqueueing and dequeueing of  tripPlan datatypes.  They will be used to store stops the user adds and remove them as the user goes on the trip.  The queue is used stictly for the arrival trip and not the return trip.
*/
#include "queue.h"
#include<iostream>
#include<cstring>
using namespace std;



/*constructor for the queue, it just sets rear to NULL. */
queue::queue()
{
rear = NULL;
}



/*
This part was tricky, I needed to find a way to delete all nodes on a circular linked list so I broke it into a linear linked list and then deleted the nodes that way.
*/
queue::~queue()
{
  if(!rear)
  {
   return;
  }
  
  q_node* head = rear->next;
  q_node* temp;
  rear->next = NULL;
  while(head)
  {
   temp = head;
   head = head->next;

   delete temp;   
   temp = NULL;
  }
  if(temp)
  {
    delete temp;
    temp = NULL;
  }
  delete head;
  head = NULL;
}



/*
Adds a tripPlan datatype to the queue.  It creates a rear node with there are no items on the queue and makes sure that queue items are entered in the back.
INPUT: TripPlan datatype to add to the queue.
OUTPUT: bool to report success or failure.
*/
bool queue::enqueue(tripPlan& to_add)
{
//cout<<"Enqueue triggered"<<endl;
q_node* temp = NULL;//This node is a new not to be added to the queue.

 if(!rear)
 {
  q_node* newNode = new q_node;
  newNode->data.copy( to_add);
  rear = newNode;
  rear->next = rear;
  return true;
 }
 temp = rear->next;
 rear->next=new q_node;
 rear = rear->next;
 rear->data.copy(to_add);
 rear->next = temp;
 return true;
}



/*
Removes the front most item from the queue.  I made sure that when there is one node in the queue to make rear NULL if the only node is dequeued.
INPUT:  NONE
OUTPUT: An error message
*/
bool queue::dequeue()
{
 //cout<<"dequeue triggered"<<endl;
  if(!rear)
  {
   cout<<"There are no stops on the trip, please add some stops."<<endl;
   return true;
  }
  if(rear->next!=rear)
  {
  q_node* temp = NULL;
  temp = rear->next;
  rear ->next = rear ->next->next;
  delete temp;
  temp = NULL;  
  return true;
  }
  if(rear->next == rear)
  {
  // cout<<"Deleting rear"<<endl;
   delete rear;
   rear = NULL;
   return true;
  } 

}



/*
The user can see what is next on the queue to be dequeued.  The user then gets the trip plan copied.  This is used in the app.cpp so that when the user is asked how much was spend on gas and the rating for lodging, the tripPlan datatype is updated.
INPUT: A tripPlan datatype.
OUTPUT: An error message if something goes wrong, a display of the stop to peek at, a bool to report success or failure.
*/
bool queue::peek(tripPlan& to_copy)
{
if(!rear)
{
cout<<"There are no stops on this trip, please add some stops."<<endl;
return false;
}
if(rear->next->data.display_trip() == false)
{
return false;
}
 cout<<"You are curently at this stop:"<<endl;
to_copy.copy (rear->next->data);
return true;
}



/*
This function displays all of the nodes in the list.  It is used in the main menu when the user wants to see all of the nodes.  It lets the user know if there are no nodes in the queue.
INPUT: NONE.
OUTPUT: bool to report success or failure, an error message if there are no nodes in the queue, all nodes in the queue.
*/
bool queue::display_all()
{
int stop_num = 1;//Displays the number of the stop when all stops are displayed.
char* name = new char[100];//Display to get the name of the trip.
if(!rear)
{
 cout<<"There are no stops on the trip, enter some stops to view them."<<endl;
 return true;
}
q_node* current = rear->next;
//current->data.display_trip();
current->data.display_name(name);
cout<<"Here are all of the stops on trip: "<<name <<endl;
while(current != rear)
{
 cout<<" Stop #"<<stop_num<<endl;
 current->data.display_trip();
 current = current->next;
 ++stop_num; 
}
 cout<<" Final Destination"<<endl;
 rear->data.display_trip();
cout<<"All nodes displayed."<<endl;
delete[] name;
return true;
}
