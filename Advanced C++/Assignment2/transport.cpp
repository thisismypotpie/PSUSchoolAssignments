/*
   Brandon Danielski
   2/13/2017
   Assignment 2
   CS202
   This the .cpp for the heirarchy of the project.  It conatins the following classes: transport, uber, maxline, bus, and popularity.
 */
#include"transport.h"
#include<cstring>
#include<iostream>
using namespace std;



/*
   Defualt constructor for the popularity class.
INPUT: NONE
OUTPUT: NONE
 */
popularity::popularity()
{
	next = NULL;
}



/*
   Destructor for popularity class.
INPUT: NONE
OUTPUT: NONE	
 */ 
popularity:: ~popularity() 
{ 
	/*	cout<<"popularity destuctor initiated."<<endl; if(price)
		{
	//		cout<<"Deleting price"<<endl;
	delete[] price;
	}
	if(time)
	{
	//		cout<<"Deleting time"<<endl;
	delete[] time;
	}	
	if(day)
	{
	//		cout<<"Deleting day"<<endl;
	delete[] day;
	}*/
	if(data)
	{
		delete data;
	}
}



/*
   Defualt constructor for the transport class.
INPUT: NONE
OUTPUT: NONE
 */
transport::transport()
{
	pop_list_size = 7;//each array elements is a day of the week and each node is a time of the day.
	pop_list = new popularity*[pop_list_size];
	for(int i=0;i<pop_list_size;i++)
	{
		//		pop_list[i] = new popularity();
		pop_list[i] = NULL;
	}
	price = new char[100];
	time = new char[100];
	day = new char[100];
	percent_capacity = 0;
	transport_type = new char[10];
}



/*
   This is a non default constructor for the transport class.
INPUT: a char pointer
OUTPUT: NONE
 */
transport::transport(char* type)
{

	pop_list_size = 7;//each array elements is a day of the week and each node is a time of the day.
	pop_list = new popularity*[pop_list_size];
	for(int i=0;i<pop_list_size;i++)
	{
		//		pop_list[i] = new popularity();
		pop_list[i] = NULL;
	}
	price = new char[100];
	time = new char[100];
	day = new char[100];
	percent_capacity = 0;
	transport_type = new char[10];
	strcpy(transport_type,type);
}



/*
   This is a non default constructor for the transport class.
INPUT: A char pointer, and int, and four char pointers passed by reference.
OUTPUT: NONE
 */
transport::transport(char* type, char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day): percent_capacity(new_percent_capacity)
{
	/*	cout<<type<<endl;
		cout<<new_price<<endl;
		cout<<new_time<<endl;
		cout<<new_day<<endl;*/
	pop_list_size = 7;//each array elements is a day of the week and each node is a time of the day.
	pop_list = new popularity*[pop_list_size];
	for(int i=0;i<pop_list_size;i++)
	{
		//		pop_list[i] = new popularity();
		pop_list[i] = NULL;
	}
	transport_type = new char[10];
	price = new char[100];
	time = new char[100];
	day = new char[100];
	strcpy(price,new_price);	
	strcpy(time, new_time);
	strcpy(day, new_day);
	strcpy(transport_type,type);	
}	

/*
   This is a copy constructor for the transport class.
INPUT: Transport object passed by reference.
OUTPUT: NONE
 */
transport::transport(transport*& to_copy)
{
	pop_list = new popularity*[pop_list_size];
	for(int i=0;i<pop_list_size;i++)
	{
		//		pop_list[i] = new popularity();
		pop_list[i] = NULL;
	}
	price = new char[100];
	time = new char[100];
	day = new char[100];
	transport_type = new char[10];
	pop_list = to_copy->pop_list;
	pop_list_size = to_copy->pop_list_size;
	percent_capacity = to_copy->percent_capacity;
	strcpy(transport_type, to_copy->transport_type);
	strcpy(price, to_copy->price);
	strcpy(time, to_copy->time);
	strcpy(day, to_copy->day);
}

/*popularity::popularity(char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day): percent_capacity(new_percent_capacity)
  {
  next = NULL;
  price = new char[100];
  time = new char[100];
  day = new char[100];
  strcpy(price,new_price);	
  strcpy(time, new_time);
  strcpy(day, new_day);
  }*/



/*
   Destuctor for the transport class.
INPUT: NONE
oUTPUT: NONE */ 
transport::~transport()
{
}



/*
   Default constuctor for uber.
INPUT: NONE
OUTPUT: NONE
 */
uber::uber()
{

}



/*
   This is a non defualt constructor for the uber class.
INPUT: A char pointer
OUTPUT: NONE
 */
uber::uber(char* type): transport(type)
{

}



/*
   Default constructor for the uber class.
INPUT: A char pointer, an int, and four char pointers passed by reference.
OUTPUT: NONE
 */
uber::uber(char* type,char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day):
	transport(type, new_price,  new_percent_capacity,  new_time,  new_day)
{

}



/*
   This is a copy constructor for the uber class.
INPUT: A transport pointer passed by reference.
OUTPUT: NONE
 */
uber::uber(transport*& to_copy):transport(to_copy)
{

}



/*
   This is the destructor for the uber class.
INPUT: NONE
OUTPUT: NONE
 */
uber::~uber()
{

	//	cout<<"Transport destructor initiated."<<endl;
	popularity* temp = NULL;
	popularity* temp2 = NULL;
	for(int i=0;i<pop_list_size;i++)
	{
		temp = pop_list[i];//temp is now an element of the popularity list array.
		//		cout<<"temp is now pop list: "<<i<<endl;
		if(temp)
		{
			//			cout<<"Temp exisits."<<endl;
			while(temp)
			{
				//				cout<<"Starting loop."<<endl;
				temp2 = temp;
				temp->next_node(temp);
				//				cout<<"Temp next node has been stored"<<endl;
				if(temp2)
				{
					//					cout<<"Deleting temp."<<endl;
					delete temp2;
				}	
				//				cout<<"Temp changed."<<endl;
			}
		}
	}
	delete[] pop_list;
	if(transport_type)
	{
		delete[] transport_type;
	}
	//	cout<<"popularity destuctor initiated."<<endl;
	if(price)
	{
		//		cout<<"Deleting price"<<endl;
		delete[] price;
	}
	if(time)
	{
		//		cout<<"Deleting time"<<endl;
		delete[] time;
	}	
	if(day)
	{
		//		cout<<"Deleting day"<<endl;
		delete[] day;
	}
}



/*
   This is the default constructor for the maxline.
INPUT: NONE
OUTPUT: NONE
 */
MaxLine::MaxLine()
{

}



/*
   This is a maxline contructor.
INPUT: A char passs by reference.
OUTPUT: NONE
 */
MaxLine::MaxLine(char* type): transport(type)
{

}



/*
   Default constructor for the MAXLINE class.
INPUT: A char pointer, an int, and four char pointers passed by reference.
OUTPUT: NONE
 */

MaxLine::MaxLine(char* type,char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day):
	transport(type, new_price,  new_percent_capacity,  new_time,  new_day)
{


}





/* This is a copy constructor for the maxline class.
INPUT: A transport pointer passed by reference.
OUTPUT: NONE
 */

MaxLine::MaxLine(transport*& to_copy):transport(to_copy)
{

}




/*
   This is the destructor for the maxline class.
INPUT: NONE
OUTPUT: NONE
 */
MaxLine::~MaxLine()
{
	//	cout<<"Transport destructor initiated."<<endl;
	popularity* temp = NULL;
	popularity* temp2 = NULL;
	for(int i=0;i<pop_list_size;i++)
	{
		temp = pop_list[i];//temp is now an element of the popularity list array.
		//		cout<<"temp is now pop list: "<<i<<endl;
		if(temp)
		{
			//			cout<<"Temp exisits."<<endl;
			while(temp)
			{
				//				cout<<"Starting loop."<<endl;
				temp2 = temp;
				temp->next_node(temp);
				//				cout<<"Temp next node has been stored"<<endl;
				if(temp2)
				{
					//					cout<<"Deleting temp."<<endl;
					delete temp2;
				}	
				//				cout<<"Temp changed."<<endl;
			}
		}
	}
	delete[] pop_list;
	if(transport_type)
	{
		delete[] transport_type;
	}
	//	cout<<"popularity destuctor initiated."<<endl;
	if(price)
	{
		//		cout<<"Deleting price"<<endl;
		delete[] price;
	}
	if(time)
	{
		//		cout<<"Deleting time"<<endl;
		delete[] time;
	}	
	if(day)
	{
		//		cout<<"Deleting day"<<endl;
		delete[] day;
	}
}



/*
   This is the default constructor for the bus class.
INPUT: NONE
OUTPUT: NONE
 */
Bus::Bus()
{

}



/*
   This is a contructor for the bus class.
INPUT: a char pointer
OUTPIT:NONE
 */
Bus::Bus(char* type): transport(type)
{

}




/*
   Default constructor for the bus class.
INPUT: A char pointer, an int, and four char pointers passed by reference.
OUTPUT: NONE
 */
Bus::Bus(char* type,char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day):
	transport(type, new_price,  new_percent_capacity,  new_time,  new_day)
{

}




/*
   This is a copy constructor for the bus class.
INPUT: A transport pointer passed by reference.
OUTPUT: NONE
 */
Bus::Bus(transport*& to_copy):transport(to_copy)
{

}



/*
   This is the destructor for the bus class.
INPUT: NONE
OUTPUT: NONE
 */
Bus::~Bus()
{
	//	cout<<"Transport destructor initiated."<<endl;
	popularity* temp = NULL;
	popularity* temp2 = NULL;
	for(int i=0;i<pop_list_size;i++)
	{
		temp = pop_list[i];//temp is now an element of the popularity list array.
		//		cout<<"temp is now pop list: "<<i<<endl;
		if(temp)
		{
			//			cout<<"Temp exisits."<<endl;
			while(temp)
			{
				//				cout<<"Starting loop."<<endl;
				temp2 = temp;
				temp->next_node(temp);
				//				cout<<"Temp next node has been stored"<<endl;
				if(temp2)
				{
					//					cout<<"Deleting temp."<<endl;
					delete temp2;
				}	
				//				cout<<"Temp changed."<<endl;
			}
		}
	}
	delete[] pop_list;
	if(transport_type)
	{
		delete[] transport_type;
	}
	//	cout<<"popularity destuctor initiated."<<endl;
	if(price)
	{
		//		cout<<"Deleting price"<<endl;
		delete[] price;
	}
	if(time)
	{
		//		cout<<"Deleting time"<<endl;
		delete[] time;
	}	
	if(day)
	{
		//		cout<<"Deleting day"<<endl;
		delete[] day;
	}
}

/*void popularity::display_data()
  {
  cout<<"TIME OF DAY: "<<time<<endl;
  cout<<"Price: $"<<price<<endl;
  cout<<"Crowd capacity: "<<percent_capacity<<"%"<<endl<<endl;
  }*/

/*void popularity::get_day(char*& new_day)
  {
  strcpy(new_day, day);
  }*/



/*
   This function will add the info needed to create a new popularity list figure.
INPUT: Two integers, and four char pointers.
OUTPUT: NONE
 */
void transport::add_popularity_info(int new_index, char* new_price, int new_percent_capacity, char* new_time, char* new_day, char* type)
{
	//	cout<<"new price is: "<<new_price<<endl;
	//	cout<<"new_time is: "<<new_time<<endl;
	//	cout<<"new_day is: "<<new_day<<endl;
	transport* new_ptr = NULL;
	if(strcmp(type,"Uber")==0)
	{
		//	cout<<"creting uber"<<endl;
		new_ptr = new uber(type,new_price,new_percent_capacity,new_time,new_day);
		//	new_ptr->display();
	}	
	else if(strcmp(type,"MaxLine")==0)
	{
		//	cout<<"creating maxline"<<endl;
		new_ptr = new MaxLine(type,new_price,new_percent_capacity,new_time,new_day);	
		//	new_ptr->display();
	}
	else if(strcmp(type,"Bus")==0)
	{
		///	cout<<"creating bus"<<endl;
		new_ptr = new Bus(type,new_price,new_percent_capacity,new_time,new_day);	
		//	new_ptr->display();
	}
	if(!pop_list[new_index])
	{
		//	cout<<"Popularity list index "<<new_index<<" is empty."<<endl;
		pop_list[new_index] = new popularity();
		pop_list[new_index]->add_data(new_ptr);
		//	cout<<"Popularity list index: "<<new_index<<"is now populated"<<endl;
		return;
	}	
	popularity* temp = pop_list[new_index];
	pop_list[new_index] = new popularity();
	pop_list[new_index]->add_data(new_ptr);
	pop_list[new_index]->add_connection(pop_list[new_index], temp);

}



/*
   This function will dispay all items int eh popularity list.
INPUT: NONE
OUTPUT: NONE
 */
void transport::display_pop_list()
{
	popularity* temp = NULL;
	char* new_day = new char[100];
	for(int i=0; i < pop_list_size; i++)
	{
		temp = pop_list[i];
		temp->get_day(new_day,pop_list[i]);
		//		get_day(new_day);
		cout<<endl<<"---------------------------"<<endl;
		cout<<"Day: "<<new_day<<endl;
		cout<<"---------------------------"<<endl;
		while(temp)
		{
			//			temp->display_data();					
			temp->display_data();	
			temp->next_node(temp);
		}	
		cout<<"---------------------------"<<endl;
	}
	if(new_day)
	{
		delete[] new_day;
	}
}



/*
   This function will get the type of trnsport.
INPUT: A char pointer passed by reference.
OUTPUT: NONE
 */
void transport::get_transport_type(char*& to_copy)
{
	strcpy(to_copy,transport_type);
}



/*
   This function wll display a transport from the rider histoy perspective.
INPUT: NONE
OUTPIT: NONE
 */
void transport::display_history()
{
	cout<<"Transport type: "<<transport_type<<endl;
	cout<<"Price: "<<price<<endl;
	cout<<"Day: "<<day<<endl;

}



/*
   This function will give the next node sent by the input.
INPU: A popularity pointer passed by reference.
OUTPUT: NONE
 */
void popularity::next_node(popularity*& next_node)
{
	next_node = next_node->next;	
}



/*
   Adds a connection to the popularity list.
INPUT: Two popularity pointers passed by reference.
OUTPUT: NONE
 */
void popularity::add_connection(popularity*& new_node, popularity*& existing_list)
{
	new_node->next = existing_list ;
}



/*
   This function is add data to a popularity node.
INPUT: A transport pointer passed by reference.
OUTPUT: NONE
 */
void popularity::add_data(transport*& new_data)
{
	this->data = new_data;	
	/*	char* type = new char [100];
		new_data->get_transport_type(type);
		if(strcmp(type,"MaxLine")==0)
		{
		cout<<"Creating max line in add data."<<endl;
		this->data = new MaxLine(new_data);	
		}	
		else if(strcmp(type,"uber")==0)
		{
		cout<<"Creating uber  in add data."<<endl;
		this->data = new uber(new_data);
		}
		else if(strcmp(type,"Bus")==0)
		{
		cout<<"Creating bud in add data."<<endl;
		this->data = new Bus(new_data);	
		}
		if(type)
		{
		delete[] type;
		}*/
	//delete copy constuctors if you do not use the commented out code here.
}



/*
   This function calls a display.
INPUT: NONE
OUTPUT: NONE
 */
void popularity::display_data()
{
	data->display();
}



/*
   This will get change the input rray to the given popularity's day data membe.
INPUT: A char array passed by reference and a popularity pointer passed by reference.
OUTPUT: NONE
 */
void popularity::get_day(char*& new_day, popularity*& to_copy)
{
	to_copy->data->get_day(new_day);
}



/*
   Shows all data member for this class.
INPUT: NONE
OUTPIT: NONE
 */
void uber::display()
{
	cout<<"Time of day: "<< time<<endl;
	cout<<"Price: $"<<price<<" per ride average."<<endl;
	cout<<"Crowd capacity: "<<percent_capacity<<"%"<<endl;
}




/*
   Shows all data member for this class.
INPUT: NONE
OUTPIT: NONE
 */
void MaxLine::display()
{
	cout<<"Time of day: "<< time<<endl;
	cout<<"Price: $"<<price<<" per ticket."<<endl;
	cout<<"Crowd capacity: "<<percent_capacity<<"%"<<endl;
}




/*
   Shows all data member for this class.
INPUT: NONE
OUTPIT: NONE
 */
void Bus::display()
{
	cout<<"Time of day: "<< time<<endl;
	cout<<"Price: $"<<price<<" per ticket."<<endl;
	cout<<"Crowd capacity: "<<percent_capacity<<"%"<<endl;
}




/*
   This will change the input to the day data member.
INPUT: A CHAR POINTER PASSED BY REFERENCE.
OUTPUT: NONE
 */
void transport::get_day(char*& to_copy)
{
	strcpy(to_copy,day);	
}
