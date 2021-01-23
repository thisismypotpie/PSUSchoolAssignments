/*
Brandon Danielski
2/24/2017
CS202
Assignment 3
This is the .cpp file for the person and person node class.
*/
#include<iostream>
#include<cstring>
#include"person.h"
using namespace std;



/*
THIS IS THE DEFAULT CONSTRUCTOR FOR THE PERSON CLASS.
INPUT: NONE
OUTPUT: NONE
*/
person::person()
{
	first_name = new char[100];
	last_name = new char[100];
	strcpy(first_name,"");
	strcpy(last_name,"");
	emergency = new contact*[3];
	emergency[0] = NULL;
	emergency[1] = NULL;
	emergency[2] = NULL;
}



/*
THIS IS A NON DEFAULT CONSTRUCTOR FOR THE PERSON CLASS.
INPUT: TWO CHAR POINTERS BY REFERENCE.
OUTPUT: NONE
*/
person::person(char*& first, char*& last)
{
	first_name = new char[100];
	last_name = new char[100];
	strcpy(first_name,first);
	strcpy(last_name, last);
	emergency = new contact*[3];
	emergency[0] = NULL;
	emergency[1] = NULL;
	emergency[2] = NULL;
}



/*
THIS IS A NON DEFUALT CONSTRUCTOR FOR THE PERSON CLASS.
INPUT: TWO CHAR POINTERS BY REFERENCE AND THREE EMERGENCY POINTES BY REFERENCE.
OUTPUT: NONE
*/
person::person(char*& first, char*& last, contact*& c_one, contact*& c_two, contact*& c_three)
{	
	first_name = new char[100];
	last_name = new char[100];
	char* type;
	contact* copy_from;
	strcpy(first_name,first);
	strcpy(last_name, last);
	emergency = new contact*[3];
	emergency[0] = c_one;
	emergency[1] = c_two;
	emergency[2] = c_three;
	
/*	for(int i=0; i<3;i++)
	{
		if(i==0)
		{
			c_one->get_type(type);
			copy_from = c_one;
		}
		else if(i==1)
		{
			c_two->get_type(type);
			copy_from =c_two;
		}
		else if(i==2)
		{
			c_three->get_type(type);
			copy_from=c_three;
		}
		if(strcmp(type,"phone")==0)
		{
			emergency[i] = new phone((phone*&)copy_from);
		}
		else if(strcmp(type,"email")==0)
		{
			emergency[i] = new email((email*&)copy_from);
		}
		else if(strcmp(type,"radio")==0)
		{
			emergency[i] = new radio((radio*&)copy_from);
		}
		else if(strcmp(type,"social media")==0)
		{
			emergency[i] = new social_media((social_media*&)copy_from);
		}
		else if(strcmp(type,"television")==0)
		{
			emergency[i] = new television((television*&)copy_from);
		}
		else
		{
			cout<<"Could not find type of contact."<<endl;
		}

	}*/
}



/*
THIS IS A COPY CONSTUCTOR FOR THE PERSON CLASS
INPUT: PERSON BY REFERENCE.
OUTPUT: NONE
*/
person::person(person*& copy_from)
{	
	first_name = new char[100];
	last_name = new char[100];
	char* last;
	strcpy(first_name, copy_from->first_name);
	strcpy(last_name, copy_from->last_name);
	emergency = new contact*[3];
	for(int i=0; i<3;i++)
	{
		copy_from->emergency[i]->get_type(last);
		if(strcmp(last,"phone")==0)
		{
			emergency[i] = new phone((phone*&)copy_from->emergency[i]);
		}
		else if(strcmp(last,"email")==0)
		{
			emergency[i] = new email((email*&)copy_from->emergency[i]);
		}
		else if(strcmp(last,"radio")==0)
		{
			emergency[i] = new radio((radio*&)copy_from->emergency[i]);
		}
		else if(strcmp(last,"social media")==0)
		{
			emergency[i] = new social_media((social_media*&)copy_from->emergency[i]);
		}
		else if(strcmp(last,"television")==0)
		{
			emergency[i] = new television((television*&)copy_from->emergency[i]);
		}
		else
		{
			cout<<"Could not find type of contact."<<endl;
		}

	}
}



/*
THIS IS A DESTUCTOR FOR THE PERSON CLASS.
INPUT: NONE
OUTPUT: NONE
*/
person::~person()
{
	if(first_name)
	{
		delete[] first_name;
	}
	if(last_name)
	{
		delete[] last_name;
	}
	for(int i=0; i<3;i++)
	{
		if(emergency[i])
		{
			delete emergency[i];
		}
	}
	delete[] emergency;
}



/*
THIS IS THE DEFUALT CONSTRUCTOR FOR THE PERSON NODE CLASS
INPUT: NONE
OUTPUT: NONE
*/
person_node::person_node()
{
	next = NULL;
	data = NULL;
}



/*
THIS IS A COPY DEFAULT CONTRUCTOR FOR THE PERSON NODE.
INPUT: PERSON BY REFERENCE
OUTPUT: NONE
*/
person_node::person_node(person& new_person)
{
	next = NULL;
	data = new person(new_person);
}


person_node::person_node(person_node*& to_add)
{
	next = to_add->next;	
	data = new person(to_add->data);
}



person_node::~person_node()
{
	if(data)
	{
		delete[] data;
	}	
}



/*
OVERLOADED OPERATOR FOR << IN THE PERSON CLASS.
INPUT: OSTREAM BY REFERENCE AND PERSON BY REFERENCE.
OUTPUT: OSTREAM BY REFERENCE.
*/
ostream& operator <<(ostream& out, person& p)
{
	p.display();
	return out;
}



/*
THIS IS A DISPLAY FUNCTION FOR THE PERSON CLASS.
INPUT: NONE
OUTPUT: NONE
*/
void person::display() 
{

	char* new_type = new char[100];
	cout<<"======================================================"<<endl;
	if(first_name)
	{
		cout<<"First Name: "<<first_name<<endl;	
	}
	if(last_name)
	{	
		cout<<"Last Name: "<<last_name<<endl;
	}
	for(int i=0; i <3 ;i++)
	{
		if(emergency[i])
		{
			emergency[i]->get_type(new_type);
			//			cout<<"New type is: "<<new_type<<endl;
			if(strcmp(new_type,(char*)"phone")==0)
			{
				cout<<static_cast<phone&>(*emergency[i])<<endl;
			}
			else if(strcmp(new_type,(char*)"email")==0)
			{
				cout<<static_cast<email&>(*emergency[i])<<endl;
			}
			else if(strcmp(new_type,(char*)"radio")==0)
			{
				cout<<static_cast<radio&>(*emergency[i])<<endl;
			}
			else if(strcmp(new_type,(char*)"social media")==0)
			{
				cout<<static_cast<social_media&>(*emergency[i])<<endl;
			}
			else if(strcmp(new_type,(char*)"television")==0)
			{
				cout<<static_cast<television&>(*emergency[i])<<endl;
			}
			else
			{
				cout<<"Could not display"<<endl;
			}
		}
	}
	cout<<"======================================================"<<endl;
	if(new_type)
	{
		delete[] new_type;
	}
}



/*
GETS THE CURRENT NODE'S NEXT.
INPUT: NONE
OUTPUT: A PERSON NODE POINTER BY REFERENCE.
*/
person_node*& person_node::next_node()
{
	return this->next;
}

person operator +(const char*& name, person& p)
{
	person new_person;
	new_person = p;
	if(strlen(new_person.first_name)==0)
	{
//		new_person.first_name = new char[100];
		strcpy(new_person.first_name,name);
	}
	else if(strlen(new_person.last_name)==0)
	{
//		new_person.last_name = new char[100];
		strcpy(new_person.last_name, name);
	}
	else
	{
		cout<<"Name is full, cannot add name that was added"<<endl;
	}
	return new_person;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR + IN THE PERSON CLASS.
INPUT: A PERSON BY REFERENCE AND A CHAR POINTER BY REFERENCE.
OUTPUT: A PERSON BY VALUE.
*/
person operator +(person& p, const char*& name)
{

	person new_person;
	new_person = p;
	if(!strlen(new_person.first_name)==0)
	{
//		new_person.first_name = new char[100];
		strcpy(new_person.first_name,name);
	}
	else if(strlen(new_person.last_name)==0)
	{
//		new_person.last_name = new char[100];
		strcpy(new_person.last_name, name);
	}
	else
	{
		cout<<"Name is full, cannot add name that was added"<<endl;
	}
	return new_person;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE + IN THE PERSON CLASS.
INPUT: A CONTACT BY REFERENCE AND A PERSON BY REFERENCE.
OUTPUT: A PERSON BY VALUE.
*/
person operator +(const contact& c,  person& p)
{
	person new_person;
	new_person = p;
	for(int i=0;i<3;i++)
	{
		if(!new_person.emergency[i])
		{
			new_person.emergency[i] = new contact(c);	
			i=3;
		}
	}
	return new_person;

}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE + IN THE PERSON CLASS.
INPUT: A CONTACT BY REFERENCE AND A PERSON BY REFERENCE.
OUTPUT: A PERSON BY VALUE.
*/
person operator +(person& p, const contact& c)
{

	person new_person;
	new_person = p;
	for(int i=0;i<3;i++)
	{
		if(!new_person.emergency[i])
		{
			new_person.emergency[i] = new contact(c);	
			i=3;
		}
	}
	return new_person;
}



/*
THIS IS AN OERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: A CHAR POINTER
OUTPUT: A PERSON BY REFERENCE.
*/
person& person::operator += (const char* new_name)
{
	if(strlen(first_name)==0)
	{
		this->first_name = new char[100];
		strcpy(this->first_name,new_name);
	}
	else if(strlen(last_name)==0)
	{
		this->last_name = new char[100];
		strcpy(this->last_name, new_name);
	}
	else
	{
		cout<<"This person's name is full, the name here is: "<<this->first_name<<" "<<this->last_name<<endl;
	}
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: A PHONE POINTER PASSED BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person& person::operator+=(phone*& new_contact)
{
	if(!this->emergency[0])
	{
		emergency[0] = new phone(new_contact);
	}		
	else if(!this->emergency[1])
	{
		emergency[1] = new phone(new_contact);
	}
	else if(!this->emergency[2])
	{
		emergency[2] = new phone(new_contact);
	}
	else
	{
		cout<<"All contacts for this person are full, here is the data already recorded: "<<endl;
		cout<<*this<<endl;
	}
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: AN EMAIL POINTER BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person& person::operator+=(email*& new_contact)
{
	if(!this->emergency[0])
	{
		emergency[0] = new email(new_contact);
	}		
	else if(!this->emergency[1])
	{
		emergency[1] = new email(new_contact);
	}
	else if(!this->emergency[2])
	{
		emergency[2] = new email(new_contact);
	}
	else
	{
		cout<<"All contacts for this person are full, here is the data already recorded: "<<endl;
		cout<<*this<<endl;
	}
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: A RADIO POINTER BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person& person::operator+=(radio*& new_contact)
{
	if(!this->emergency[0])
	{
		emergency[0] = new radio(new_contact);
	}		
	else if(!this->emergency[1])
	{
		emergency[1] = new radio(new_contact);
	}
	else if(!this->emergency[2])
	{
		emergency[2] = new radio(new_contact);
	}
	else
	{
		cout<<"All contacts for this person are full, here is the data already recorded: "<<endl;
		cout<<*this<<endl;
	}
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: A SOCIAL MEDIA POINTER BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person& person::operator+=(social_media*& new_contact)
{
	if(!this->emergency[0])
	{
		emergency[0] = new social_media(new_contact);
	}		
	else if(!this->emergency[1])
	{
		emergency[1] = new social_media(new_contact);
	}
	else if(!this->emergency[2])
	{
		emergency[2] = new social_media(new_contact);
	}
	else
	{
		cout<<"All contacts for this person are full, here is the data already recorded: "<<endl;
		cout<<*this<<endl;
	}
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: A TELEVISION BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person& person::operator+=(television*& new_contact)
{
	if(!this->emergency[0])
	{
		emergency[0] = new television(new_contact);
	}		
	else if(!this->emergency[1])
	{
		emergency[1] = new television(new_contact);
	}
	else if(!this->emergency[2])
	{
		emergency[2] = new television(new_contact);
	}
	else
	{
		cout<<"All contacts for this person are full, here is the data already recorded: "<<endl;
		cout<<*this<<endl;
	}
	return *this;
}




/*
THIS IS AN OVERLOADED OPERATOR FOR THE = IN THE PERSON CLASS.
INPUT: A PERSON BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person& person::operator=(const person& p)
{
	char* last;
	strcpy(first_name,p.first_name);
	strcpy(last_name, p.last_name);
	for(int i=0;i<3;i++)
	{
		p.emergency[i]->get_type(last);
		if(strcmp(last,"phone")==0)
		{
			emergency[i] = new phone((phone*&)p.emergency[i]);
		}
		else if(strcmp(last,"email")==0)
		{
			emergency[i] = new email((email*&)p.emergency[i]);
		}
		else if(strcmp(last,"radio")==0)
		{
			emergency[i] = new radio((radio*&)p.emergency[i]);
		}
		else if(strcmp(last,"social media")==0)
		{
			emergency[i] = new social_media((social_media*&)p.emergency[i]);
		}
		else if(strcmp(last,"television")==0)
		{
			emergency[i] = new television((television*&)p.emergency[i]);
		}
		else
		{
			cout<<"Could not find type of contact."<<endl;
		}
	}
	return *this;
//	cout<<*this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE == OPERATOR IN THE PERSON CLASS.
INPUT: A PERSON BY REFERENCE.
OUTPUT: A BOOL.
*/
bool person::operator ==( const person& p)
{
	if(strcmp(this->first_name,p.first_name)==0 && strcmp(this->last_name,p.last_name)==0 && this->emergency[0]==p.emergency[0] && this->emergency[1] ==p.emergency[1] && this->emergency[2] == p.emergency[2])
	{
		return true;
	}
	else
	{
		return false;
	}

}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE = OPERATOR IN THE PERSON CLASS.
INPUT: A PERSON NODE BY REFERENCE.
OUTPUT: A PERSON NODE BY REFERENCE.
*/
person_node& person_node::operator=(const person_node& p)
{
	this->next = p.next;
	this->data = p.data;
	return *this;
}



/*
THIS FUNCTION GETS THE LAST NAME OF A PERSON CLASS.
INPUT: A CHAR POINTER BY REFERENCE.
OUTPUT: NONE
*/
void person::get_last_name(char*& to_copy)
{
	strcpy(to_copy,last_name);
}



/*
THIS FUNCTION CHECKS TO SEE THAT EVERY ITEM IN A PERSON CLASS IS POPULATED WITH SOME SORT OF DATA.
INPUT: NONE
OUTPUT:  A BOOL
*/
bool person::is_fully_populated()
{
	if(first_name && last_name && emergency[0] && emergency[2] && emergency[3])
	{
		return true;
	}
	else
	{
		return false;
	}
}



/*
THIS IS AN OERLOADED OPERATOR FOR THE << OPERATOR IN THE PERSON NODE CLASS.
INPUT: AN OSTREAM BY REFERENCE AND A PERSON NODE BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator<<(ostream& out,const person_node& n)
{
	n.data->display();
	out<<"";
	return out;
}



/*
THIS GETS THE PAST NAME IN THE DATA POINTER OF A PEROSN NODE.
INPUT: A CHAR POINTER BY REFERENCE.
OUTPUT: NONE.
*/
void person_node::get_last_name(char*& to_copy)
{
	data->get_last_name(to_copy);
}



/*
THIS SETS THE NEXT NODE OF A PERSON NODE CLASS.
INPUT: A PERSON NODE BY REFERENCE.
OUTPUT: NONE
*/
void person_node::set_next(person_node*& to_add)
{
	this->next = to_add;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE == OPERATOR FOR THE PERSON NODE CLASS.
INPUT: A PERSON NODE BY REFERENCE.
OUTPUT: A BOOL
*/
bool person_node::operator==(const person_node& one)
{
	if( this->data == one.data)
	{
		return true;
	}
	else
	{
		return false;
	}
}
