/*:
  Brandon Danielski
  2/13/2017
  Assignment 2
  CS202
  This is the .ccp file for the rider class.  It is used to display rider history and add to that history if prompted.
 */
#include"rider.h"
#include<cstring>
#include<iostream>
#include"stdlib.h"
using namespace std;



/*
   This is the defualt constructor for the history class.
INPUT: NONE
OUTPUT: NONE */
history::history() : at_index(0), array_size(5)
{
	rides = new transport*[array_size];
	for(int i=0; i < array_size; i++)
	{
		*(rides + i) = NULL;
	}
	next = NULL;
}



/*
   This is the destructor for the history class.
INPUT: NONE
OUTPUT: NONE
 */
history::~history()
{
	for(int i=0; i < array_size;i++)
	{
		if(rides[i])
		{
			delete rides[i];
		}	
	}	
	if(rides)
	{
		delete[] rides;
	}
}



/*
   This function is a defualt contructor for the rider class.
INPUT: NONE
OUTPUT: NONE 
 */
rider::rider()
{
	most_recent_ride = new history();
}



/*
   This is a destructor for the rider class.
INPUT: NONE
OUTPUT: NONE 
 */ 
rider::~rider()
{
	delete most_recent_ride;
}



/*
   This function will return the index that the current node is at.
INPUT: NONE
OUTPUT: an integer
 */
int history::get_at_index()
{
	return at_index;
}



/*
   This function will return the size of the array of rides in a history node.
INPUT: NONE
OUTPUT: an integer
 */
int history::get_array_size()
{
	return array_size;
}



/*
   This function is a wrapper to display the rides in a history node.
INPUT: NONE
OUTPUT: NONE
 */
void rider::display_history()
{
	most_recent_ride->display_history(most_recent_ride, most_recent_ride->get_at_index());
}



/*
   This function will add a ride to the history of the user.
INPUT: a transport objet and a history object
OUTPUT: NONE
 */
void history::add_ride_to_history(transport*& to_add, history*& most_recent_rides)
{
	char* temp_type = new char[100];
	to_add->get_transport_type(temp_type);
	//	cout<<"transport type is: "<<temp_type<<endl;
	if(strcmp(temp_type,"MaxLine")==0)
	{
		if(most_recent_rides->at_index < most_recent_rides->array_size)
		{
			most_recent_rides->rides[at_index] = new MaxLine(to_add);
			++ most_recent_rides->at_index;
		}		
		else
		{
			history* new_node = new history();
			new_node->next = most_recent_rides;
			most_recent_rides = new_node;
			new_node->rides[new_node->at_index] = new MaxLine(to_add);
			++ new_node->at_index;
		}

	}
	else if(strcmp(temp_type,"uber")==0)
	{
		if(most_recent_rides->at_index < most_recent_rides->array_size)
		{
			most_recent_rides->rides[at_index] = new uber(to_add);
			++ most_recent_rides->at_index;
		}		
		else
		{
			history* new_node = new history();
			new_node->next = most_recent_rides;
			most_recent_rides = new_node;
			new_node->rides[new_node->at_index] = new uber(to_add);
			++ new_node->at_index;
		}
	}
	else if(strcmp(temp_type,"Bus")==0)
	{
		if(most_recent_rides->at_index < most_recent_rides->array_size)
		{
			most_recent_rides->rides[at_index] = new Bus(to_add);
			++ most_recent_rides->at_index;
		}		
		else
		{
			history* new_node = new history();
			new_node->next = most_recent_rides;
			most_recent_rides = new_node;
			new_node->rides[new_node->at_index] = new Bus(to_add);
			++ new_node->at_index;
		}
	}
	if(temp_type)
	{
		delete[] temp_type;
	}
}



/*
   This function will return a next node of the inputted history node.
INPUT: A history object pointer
OUTPUT: NONE
 */
void history::get_next(history*& next_node)
{
	next_node = next_node->next;
}

/*void history::get_ride_from_history(int index, transport*& to_copy)
  {
  to_copy = rides[index];
  }//may not be used*/



/*
   This function displays the elements in each array of each history node.
INPUT: An integer and a history object
OUTPUT: NONE
 */
void history::display_history(history*& head, int display_index)
{
	if(!head)
	{
		return;
	}	
	if(display_index-1> 0)
	{
		//	transport* temp = NULL;
		//		head->get_ride_from_history(display_index-1,temp);	
		//	temp->display();
		//		cout<<"Display index: "<<display_index-1<<endl;
		cout<<"----------------------------------"<<endl;
		if(head->rides[display_index-1]);
		{
			head->rides[display_index-1]->display_history();
		}
		cout<<"----------------------------------"<<endl;
		display_history(head,display_index-1);
	}
	else
	{

		//		cout<<"Display index: "<<display_index<<endl;
		cout<<"----------------------------------"<<endl;
		head->rides[display_index]->display_history();
		cout<<"----------------------------------"<<endl;
		int new_array_size = head->get_array_size()-1;
		//	head->next_node(head);
		head->get_next(head);
		//		cout<<"Going to next node"<<endl;
		display_history(head,new_array_size);
	}

}



/*
   This function is a wrapper that will add a ride to the history of the user.
INPUT: transport pointer
OUTPUT: NONE
 */
void rider::add_ride_to_history(transport*& to_add)
{
	most_recent_ride->add_ride_to_history(to_add, most_recent_ride);
}

