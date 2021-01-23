/*
Brandon Danielski
3/1/2017
CS202
Assignment 3
This is the .cpp file for the person and person node class of the project.
*/
#include"person.h"
#include<cstring>
#include<iostream>
using namespace std;
///////////////////////////////////////////////////////////////////////////////PERSON FUNCTIONS///////////////////////////////////////////////////////



/*
THIS IS THE DEFUALT CONSTRUCTOR FOR THE PERSON CLASS.
INPUT: NONE
OUTPUT: NONE
*/
person::person()
{
	first_name = NULL;
	last_name = NULL;
	emergency = NULL;
}



/*
THIS IS THE NON DEFAULT CONSTUCTOR FOR THE PERSON CLASS.
INPUT: TWO CHAR POINTERS BY REFERENCE AND THREE CONTACT POINTERS BY REFERENCE.
OUPUT: NONE
*/
person::person(char* first,char* last,contact*& e1, contact*& e2, contact*& e3)
{
	first_name = new char[100];
	last_name = new char[100];
	emergency = new contact* [3];
	contact** temp = new contact*[3];
	temp[0] = e1;
	temp[1] = e2;
	temp[2] = e3;	
	for(int i=0; i<3; i++)
	{
		if(temp[i])
		{
			if(strcmp(temp[i]->get_type(),"phone")==0)
			{
				emergency[i] = new phone((phone*&)temp[i]);	
			}	
			else if(strcmp(temp[i]->get_type(),"email")==0)
			{
				emergency[i] = new email((email*&)temp[i]);	
			}	
			else if(strcmp(temp[i]->get_type(),"radio")==0)
			{
				emergency[i] = new radio((radio*&)temp[i]);	
			}	
			else if(strcmp(temp[i]->get_type(),"social media")==0)
			{
				emergency[i] = new social_media((social_media*&)temp[i]);	
			}	
			else if(strcmp(temp[i]->get_type(),"tv")==0)
			{
				emergency[i] = new tv((tv*&)temp[i]); 	
			}	
			else
			{
				emergency[i] = new contact(temp[i]);	
			}	
		}
	}
	strcpy(first_name,first);
	strcpy(last_name,last);
	delete[] temp;
}



/*
THIS IS THE COPY CONSTUCTOR FOR THE PERSON CLASS.
INPUT: A PERSON POINTER BY REFERENCE.
OUTPUT: NONE
*/
person::person(person*& to_copy)
{	
	first_name = new char[100];
	last_name = new char[100];
	emergency = new contact* [3];
	strcpy(first_name,to_copy->first_name);
	strcpy(last_name, to_copy->last_name);
	for(int i=0; i<3; i++)
	{
		if(to_copy->emergency[i])
		{
			if(strcmp(to_copy->emergency[i]->get_type(),"phone")==0)
			{
				emergency[i] = new phone((phone*&)to_copy->emergency[i]);	
			}	
			else if(strcmp(to_copy->emergency[i]->get_type(),"email")==0)
			{
				emergency[i] = new email((email*&)to_copy->emergency[i]);	
			}	
			else if(strcmp(to_copy->emergency[i]->get_type(),"radio")==0)
			{
				emergency[i] = new radio((radio*&)to_copy->emergency[i]);	
			}	
			else if(strcmp(to_copy->emergency[i]->get_type(),"social media")==0)
			{
				emergency[i] = new social_media((social_media*&)to_copy->emergency[i]);	
			}	
			else if(strcmp(to_copy->emergency[i]->get_type(),"tv")==0)
			{
				emergency[i] = new tv((tv*&)to_copy->emergency[i]); 	
			}	
			else
			{
				emergency[i] = new contact(to_copy->emergency[i]);	
			}	
		}
	}
}



/*
THIS IS A DESTRUCTOR FOR THE PERSO CLASS.
INPUT: NONE
OUTPUT:NONE
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
THIS RETURNS THE FIRST NAME OF THE PERSON CLASS.
INPUT: NONE
OUTPUT: A CHAR POINTER BY REFERENCE.
*/
char*& person::get_first_name()
{
	return first_name;
}



/*
THIS RETURNS THE LAST NAME OF THE PESON CLASS.
INPUT: NONE
OUTPUT: A CHAR POINTER BY REFERENCE.
*/
char*& person::get_last_name()
{
	return last_name;
}



/*
THIS IS A DISPLAY FUNCTION FOR THE PERSON CLASS.
INPUT: NONE
OUTPUT:NONE
*/
void person::display() const
{
	cout<<"================================================================================"<<endl;
	cout<<"First Name: "<<first_name<<endl;
	cout<<"Last Name: "<<last_name<<endl<<endl;
	for(int i=0; i<3;i++)
	{
		if(emergency[i])
		{
			cout<<"------------------------------------------------"<<endl;
			cout<<emergency[i]<<endl;
			cout<<"------------------------------------------------"<<endl;
		}
	}
	cout<<"================================================================================"<<endl;
}



/*
MAKES SURE THE PERSON DATA MEMBER ARE FULLY POPULATED.
INPUT: NONE
OUTPIT: A BOOL
*/
bool person::is_valid()
{
	if(strlen(first_name)>0 && strlen(last_name)>0 && emergency)
	{
		if(emergency[0] && emergency[1] && emergency[2])
		{
			return true;
		}
	}
	return false;
}

////////////////////////////////////////////////////////////////////////////OVERLOADED OPERATORS FOR PERSON///////////////////////////////////////////////////////


/*
THIS IS AN OVERLOADED OPERATOR FOR THE PERSON CLASS.
INPUT: AN OSTREAM BY REFERENCE AND A PERSON BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator <<(ostream& out, person& p)
{
	p.display();	
	return out;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE PERSON CLASS.
INPUT: A CHAR POINTER BY CLASS AND A PERSON BY CLASS.
OUTPUT: A PERSON BY VALUE.
*/
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
person* person::operator += (const char* new_name)
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
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: A PHONE POINTER PASSED BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person* person::operator+=(phone*& new_contact)
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
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: AN EMAIL POINTER BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person* person::operator+=(email*& new_contact)
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
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: A RADIO POINTER BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person* person::operator+=(radio*& new_contact)
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
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: A SOCIAL MEDIA POINTER BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person* person::operator+=(social_media*& new_contact)
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
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE += IN THE PERSON CLASS.
INPUT: A TELEVISION BY REFERENCE.
OUTPUT: A PERSON BY REFERENCE.
*/
person* person::operator+=(tv*& new_contact)
{
	if(!this->emergency[0])
	{
		emergency[0] = new tv(new_contact);
	}		
	else if(!this->emergency[1])
	{
		emergency[1] = new tv(new_contact);
	}
	else if(!this->emergency[2])
	{
		emergency[2] = new tv(new_contact);
	}
	else
	{
		cout<<"All contacts for this person are full, here is the data already recorded: "<<endl;
		cout<<*this<<endl;
	}
	return this;
}

//////////////////////////////////////////////////////////////////////////PERSON NODE///////////////////////////////////////////////////////////////



/*
THE DEFUALT CONSTRUCTOR FOR THE PERSON NODE.
INPUT: NONE
OUTPUT: NONE
*/
person_node::person_node()
{
	data = NULL;
	next = NULL;
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE PERSON NODE.
INPUT: A PERSON POINTER BY REFERENCE.
OUTPUT: NONE
*/
person_node::person_node(person*& to_copy)
{
	data = new person(to_copy);
	next = NULL;	
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE PERSON NODE.
INPUT: A PERSON NODE POINTER BY REFERENCE.
OUTPUT: NONE
*/
person_node::person_node(person_node*& to_copy)
{
	data = new person(to_copy->data);
	next = to_copy->next;//change this to new if something goes wrong.
}



/*
THIS IS THE DESTUCTOR FOR THE PERSON NODE.
INPUT: NONE
OUTPUT: NONE
*/
person_node::~person_node()
{
	if(data)
	{
		delete data;
	}
}



/*
THIS RETURNS THE DATA OF A PERSON NODE, WHICH IS A PERSON.
INPUT: NONE
OUTPUT:  A PERSON POINTER BY REFERNECE.
*/
person*& person_node::get_data()
{
	return data;
}



/*
THIS RETURNS THE LAST NAME OF THE DATA OF A PERSON NODE.
INPUT: NONE
OUTPUT: A CHAR POINTER BY REFERENCE.
*/
char*& person_node::get_last_name()
{
	return data->get_last_name();
}



/*
THIS RETURNS THE FIRST NAME OF THE DATA OF THE PERSON NODE.
INPUT: NONE
OUTPUT: A CHAR POINTER BY REFERENCE.
*/
char*& person_node::get_first_name()
{
	return data->get_first_name();
}



/*
THIS RETURNS THE NEXT POINTER OF THE PERSON NODE.
INPUT: NONE
OUTPUT: A PERSON NODE POINTER BY REFERENCE.
*/
person_node*& person_node::next_node()
{
	return next;
}




/*
THIS SETS A PERSON NODE'S NEXT.
INPUT: A PERSO NODE POINTER BY REFERNECE.
OUTPUT: NONE
*/
void person_node::set_next(person_node*& to_add)
{
	this->next = to_add;
}

/////////////////////////////////////////////////////////////////////OVERLOADED OPERATORS FOR PERSON NODE////////////////////////////////////////////////////////



/*
THIS IS AN OVERLOADED OPERATOR FOR THE PERSON NODE CLASS.
INPUT: AN OSTREAM BY REFERENCE AND A PERSON NODE BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator<<(ostream& out, person_node& pn)
{
	cout<<*pn.data<<endl;
	return out;
}



/*
THIS IS AN OVERELAODED OPERATOR FOR THE PRESON NODE CLASS.
INPUT: TWO PERSON NODES BY REFERNCE.
OUTPUT: A BOOL
*/
bool operator<(person_node& one,person_node& two)
{
	if(strcmp(one.get_first_name(),two.get_last_name())<=1)
	{
		return true;
	}
	return false;

}



/*
THIS IS AN OVERELAODED OPERATOR FOR THE PRESON NODE CLASS.
INPUT: TWO PERSON NODES BY REFERNCE.
OUTPUT: A BOOL
*/
bool operator >(person_node& one, person_node& two)
{
	if(strcmp(one.get_first_name(),two.get_last_name())>=1)
	{
		return true;
	}
	return false;
}



/*
THIS IS AN OVERELAODED OPERATOR FOR THE PRESON NODE CLASS.
INPUT: TWO PERSON NODES BY REFERNCE.
OUTPUT: A BOOL
*/
bool operator <=(person_node& one, person_node& two)
{
	if(strcmp(one.get_first_name(),two.get_last_name())<=0)
	{
		return true;
	}
	return false;

}



/*
THIS IS AN OVERELAODED OPERATOR FOR THE PRESON NODE CLASS.
INPUT: TWO PERSON NODES BY REFERNCE.
OUTPUT: A BOOL
*/
bool operator >=(person_node& one, person_node& two)
{
	if(strcmp(one.get_first_name(),two.get_last_name())>=0)
	{
		return true;
	}
	return false;
}

