/*
Brandon Danieski
CS163
10/25/2016
Assignment 2
This is the queue part of the program.  This queue is implemented as a circular linked list.  It will enqueue stops when the user enters a new stop and it will dequeue stops as the user takes the trip.
*/

#ifndef QUEUE_H
#define QUEUE_H
#include"tripPlan.h"

//This is the struct that will store info on each node of the queue.
struct q_node
{
tripPlan data;
q_node* next;
};

class queue
{
public:
queue();//constructor
~queue();//destructor
bool enqueue(tripPlan& to_add);//Adds a tripPlan to the queue.  Each item added is added to the back of the queue.
bool dequeue();//removed itesm from the front of the queue.  
bool peek(tripPlan& to_copy);//Allows the user to see what is next on the queue.  
bool display_all();//Allows the user to see all of the items on the queue.
private:

q_node* rear;//rear pointer for the circular linked list queue.
};


#endif
