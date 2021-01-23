/*
   Brandon Danielski
   2/13/2017
   Assignment 2
   CS202
   This is the .h file for the transport class, the three classes derived from the transport class, and the popularity class.
 */
#ifndef TRANSPORT_H
#define TRANSPORT_H


class transport;//Forward declaration for the transport class.


class popularity//Acts as a node in a linked list.
{
	public:
		popularity();//Defualt constuctor
		//popularity(char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day); 
		~popularity();//Destructor
		void next_node(popularity*& next_node);//changes input to next node of the node inputted.
		void add_connection(popularity*& new_node, popularity*& existing_list);//adds a new node to the list.
		void add_data(transport*& new_data);//adds data to a node of a list.
		void display_data();//displays data of a node.
		//void display_data();
		void get_day(char*& new_day, popularity*& to_copy);//changes input char array to the day datamember of its own data.
	protected:
		popularity* next;
		transport* data;
		/*char* price;
		  int percent_capacity;
		  char* time;
		  char* day;*/
};

class transport//Abstract base class for the project.
{
	public:
		//make all functions in this class virtual.
		virtual ~transport();//destructor
		transport();//defualt constuctor
		transport(char* type);//non defualt constructor
		transport(char* type,char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day);//non defualt constructor
		transport(transport*& to_copy);//copy constuctor
		virtual void display() =0;//pure virtual function, used to display function in derived classes.
		void add_popularity_info(int new_index, char* new_price, int new_percent_capacity, char* new_time, char* new_day, char* type);//adds a new node to the popularity list.
		virtual void display_pop_list();//displays the popularity list of a transport pointer.
		void get_transport_type(char*& to_copy);//returns the transport type data member.
		void get_day(char*& to_copy);//returns the day data memeber.
		void display_history();//displays a trasnport for rider history purposes.
	protected:
		popularity** pop_list;//array of node pointers 
		int pop_list_size;
		char* transport_type;
		char* price;
		int percent_capacity;
		char* time;
		char* day;
};

class uber : public transport//One of three derived classes derived from the transport class.
{
	public:
		uber();//defualt constructor
		uber(char* type);//non default constructor
		uber(char* type,char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day);//non default constructor
		uber(transport*& to_copy);//copy constuctor
		~uber();//destructor
		//void get_status();
		void display();//display for uber
	protected:
};

class MaxLine: public transport
{
	public: 
		MaxLine();//defualt constuctor
		MaxLine(char* type);//non defualt constructor
		MaxLine(char* type,char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day);//non default constructor
		MaxLine(transport*& to_copy);//copy constructor.
		~MaxLine();//destuctor
		//void get_status();
		void display();//displays for maxline.
	protected:

};

class Bus : public transport
{
	public:
		Bus();//defualt constructor
		Bus(char* type);//non defualt constructor
		Bus(char* type,char*& new_price, int new_percent_capacity, char*& new_time, char*& new_day);//non defualt constucto
		Bus(transport*& to_copy);//copy constructor
		~Bus();//destructor
		//void get_status();
		void display();//display for the bus.
	protected:
};

#endif
