//This is the .h file for me linked  list.  My plan here is to create
// a normal standard linked list.
#ifndef LINKEDLIST_H
#define LINKEDLIST_H
#include<iostream>
#include<cstdlib>
#include"tutor.h"
using namespace std;
struct node
{
node* next;
tutor data;
};

class list
{
public:
list();//constructor
~list();//destructor
bool traversetoNode(int toNode);//traverse to inputted number node.(wrapper).
int traversetoNode(int toNode, node* current, int nodeAt);//traverse to inputted node recursively.
void addNode(tutor& addTutor);//adds node to the list.
bool changeRating(int changeTo);//changes rating of selected node.
bool displayHighRatedNodes();//wrapper
bool displayHighRatedNodes(node* current, int labelNum);//display nodes with rating 8 or higher.
bool showAllNodes();//wrapper
int  showAllNodes(node* head, int labelNum);// label num is there so that each node gets a number on the output.
int getLength();//returns length of list.
bool deleteLowRatedNodes();//deletes low rated nodes.
private:
node* head;
node* tail;
node* currentNodeUserIsUsing;
int listLength;
};
#endif
