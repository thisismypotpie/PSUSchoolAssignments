//This is te linked list class.  It is a simple linear linked list that stores tutor datatypes into the list.  This particular linked list comes with a few extra functions such as traversing to a speicif node on the list and displaying only certain nodes with a high enough rating in their  tutor data.
#include<iomanip>
#include<iostream>
#include"linkedlist.h"

using namespace std;
//constructor for linked list.
list::list()
{
head = NULL;
tail = NULL;
currentNodeUserIsUsing = NULL;
list::listLength = 0;
}
//Destructor for linked list.
list::~list()
{
 
 node* current = new node();
 current = head;
 while (current !=NULL)
 {
   node* next = new node;
   next = current -> next;
   delete current;
   current = next;
 }
}
//traverses to a specific node specified by the user.  This is used when the user wants to either change the rating of a specific item or wants to see the brief desciption of the item.
int list::traversetoNode(int toNode, node* current, int nodeAt)
{
  if(toNode == nodeAt)
 {
   currentNodeUserIsUsing = current;
   currentNodeUserIsUsing->data.detailedDisplayTutor();  
   return 1;
 }
 if(current ->next != NULL)
{
 nodeAt++;
 current = current -> next;
 traversetoNode( toNode, current, nodeAt);
}
 else if(current->next == NULL)
{
 cout <<" No match was found" <<endl;
 return 0;
}
}
//This is a wrapper function for the function directly above.
bool list::traversetoNode(int toNode)
{
  traversetoNode(toNode, head, 1);
}

void list::addNode(tutor& addTutor)
{

node* newNode = new node();
newNode->data = addTutor;
//newNode->data.displayTutor();
//addTutor.displayTutor(); 
if(head == NULL)//if head is null made the new node the head.
{
  head = newNode;
}
if( tail == NULL)
{
   tail = newNode;
}
if(tail !=NULL)
{
 tail->next = newNode;
}
tail = newNode;
listLength++;
}

//shows all of the nodes on the list.  Each tutor comes with its own display function so when each node is called it calls the display function from the tutor class.
int list::showAllNodes(node* current, int labelNum)
{
  if(current == NULL)
	{
	return 0;
	}  
  cout << labelNum<<".";
  current->data.displayTutor();
  labelNum++;
  return showAllNodes(current->next, labelNum);
}
 
bool list::showAllNodes()
{
cout<<setfill('-')<<setw(10)<<"SUBJECT"<<setw(8)<<"RATING"<<setw(12)<<"HELP TYPE"<<setw(15)<<"LOCATION"<<setw(20)<<"DAYS"<<setw(14)<<"HOURS"<<endl;
 list::showAllNodes(head,1);
 return true;
}
//returns the length of the list to main so it can be used in checkNum in the app.
int list::getLength()
{
 return listLength;
}
//Physically changes the rating of a specific node.
bool list:: changeRating(int changeTo)
{
  if(currentNodeUserIsUsing == NULL)
{
 return false;
}
 currentNodeUserIsUsing->data.changeRating(changeTo);
}
//Deletes nodes that are of rating 3 or lower.  This function was not finished in time because my list was unsorted and it was difficlt to delete from an unsorted list.
bool list::deleteLowRatedNodes()
{
  if(head == NULL)
  {
   return true;
  }
  node* current = head;
  node* previous = head;
  node* temp = NULL;
  cout <<"Nodes created"<<endl;
  bool firstLoop = true;
  while(current !=NULL)
{
  if(current ->data.getRating() < 4 && current !=NULL)//if the rating is 3 or les, do this.
{ 
  if (current == head)
  {
   cout<<"Head deletion triggered"<<endl;
   if(head->next)
     {
      temp = head->next;
     }
    delete head;
    head = temp; 
  }
  else if(current == tail)
  {
   cout<<"Tail deletion triggered"<<endl;
   temp = previous;
   delete tail;
   tail = temp;
  }
  else 
  {
   cout<<"Body deletion triggered"<<endl;
   if(current->next)
   {
    previous->next = current->next;
   }
   delete current;
  }
} 
  if(firstLoop == false)
  {  
   previous = previous ->next;
  }
  if( current->next)
  {
   current = current -> next;
  }  
  firstLoop= false;
//  cout<<"Current is: "<<current->data.displayTutor()<<endl;
 // cout<<"Previous is: "<<previous->data.displayTutor()<<endl;
}
}
//Displays any node that has a rating of 8 or higher.
bool list::displayHighRatedNodes(node* current, int labelNum)
{
  if(current == NULL)
  { 
    return true;
  } 
  if(current->data.getRating() > 7)
  {
    cout<<labelNum<<".";
    current->data.displayTutor();
    labelNum++;
  }
  return displayHighRatedNodes(current->next, labelNum);
}
//wrapper function for the above function.
bool list::displayHighRatedNodes()
{  
cout<<setfill('-')<<setw(14)<<"SUBJECT"<<setw(10)<<"RATING"<<setw(15)<<"HELP TYPE"<<setw(22)<<"LOCATION"<<setw(20)<<"DAYS"<<setw(14)<<"HOURS"<<endl;
  displayHighRatedNodes(head, 1); 
}
