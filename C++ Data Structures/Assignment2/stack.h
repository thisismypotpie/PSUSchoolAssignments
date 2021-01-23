/*
Brandon Danielski
10/25/2016
CS163
Assignment 2
This is the stack portion of the program.  It is used int the later half of the take trip menu option.  When a queue item is dequeued the same item is then pushed into the stack.  On the return ttip the stack is popped as the user returns home.  
*/
#ifndef STACK_H
#define STACK_H
#include<cstdlib>
#include"tripPlan.h"

struct node
{
tripPlan* stops;
node* next;
};

class stack
{
public:
stack();//constructor
~stack();//destuctor
bool push( tripPlan& to_add);//puts an item on top of the stack.
bool pop();//removes item from top of stack.
bool peek();//looks are item on top of the stack.
bool display_all();//shows all items onthe stack.
private:
int top_index;//keeps track of which array element is the top of the stack.
node* head;//keeps track of the head of the linkedlist stack.
int MAX ;//maximum size of the array for each node of the stack.
};


#endif 
