/*
Brandon Danielski
3/1/2017
CS202
Assignment 3
This is the .cpp file for the contact base class and all derived classes.
*/
#include"contact.h"
#include<cstring>
using namespace std;
/////////////////////////////////////////////////////////////////////contact classes/////////////////////////////////////////////////////////////////////////////////



/*
THIS IS THE DEFAULT CONSTRUCTOR FOR THE CONTACT BASE CLASS.
INPUT: NONE
OUTPUT: NONE
*/
contact::contact()
{
	contact_type = NULL;
	contact_detail = NULL;
}



/*
THIS IS A NON DEFUALT CONSTRUCTOR FOR THE CONTACT BASE CLASS.
INPUT: TWO CHAR POINTERS BY REFERENCE.
OUTPUT: NONE
*/
contact::contact(char*& type, char*& detail)
{
	contact_type = new char[100];
	contact_detail = new char[100];
	strcpy(contact_type,type);
	strcpy(contact_detail,detail);
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE CONTACT BASE CLASS.
INPUT: A CONTACT POINTER BY REFERENCE.
OUTPUT: NONE
*/
contact::contact(contact*& copy_to)
{
	contact_type = new char[100];
	contact_detail = new char[100];
//	cout<<"Test for constructor"<<endl;
//	cout<<copy_to<<endl;
	strcpy(contact_type,copy_to->contact_type);
	strcpy(contact_detail,copy_to->contact_detail);	
}



/*
THIS IS THE DESTRUCTOR FOR THE CONTACT BASE CLASS.
INPUT: NONE
OUTPUT:NONE
*/
contact::~contact()
{
	if(contact_type)
	{
		delete[] contact_type;
	}
	if(contact_detail)
	{
		delete[] contact_detail;
	}
}



/*
THIS RETURNS THE TYPE OF CONTACT DATA MEMBER.
INPUT: NONE
OUTPUT: A CHAR POINTER BY REFERENCE.
*/
char*& contact::get_type()
{
	return contact_type;
}
/////////////////////////////////////////////////////////////////////OVERLOADED OPERATORS FOR CONTACT CLASS///////////////////////////////////////////////////////////////////////////////// 



/*
THIS IS AN OVERLOADED OPERATOR FOR THE CONTACT BASE CLASS.
INPUT: A OSTREAM BY REFERENCE AND A CONTACT POINTER BY REFERENCE.
OUTPUT: OSTREAM BY REFERENCE.
*/
ostream& operator<<(ostream& out, contact*& c )
{	
	if(strcmp(c->get_type(),"phone")==0)
	{
		cout<<static_cast<phone&>(*c)<<endl;
	}	
	if(strcmp(c->get_type(),"email")==0)
	{
		cout<<static_cast<email&>(*c)<<endl;
	}
	if(strcmp(c->get_type(),"radio")==0)
	{
		cout<<static_cast<radio&>(*c)<<endl;
	}
	if(strcmp(c->get_type(),"social media")==0)
	{
		cout<<static_cast<social_media&>(*c)<<endl;
	}
	if(strcmp(c->get_type(),"tv")==0)
	{
		cout<<static_cast<tv&>(*c)<<endl;
	}
	return out;
}

/////////////////////////////////////////////////////////////////////phone classes/////////////////////////////////////////////////////////////////////////////////



/*
THIS IS THE DEFUALT CONSTRUCTOR FOR THE PHONE DERIVED CLASS.
INPUT: NONE
OUTPUT:NONE
*/
phone::phone():contact()
{
	contact_type = new char[100];
	strcpy(contact_type,(char*)"phone");
	contact_detail = new char[100];
	strcpy(contact_detail,(char*)"");
	phone_number = 0;	
}



/*
THIS IS A NON DEFAULT CONSTRUCTOR FOR THE PHONE DERIVED CLASS.
INPUT: TWO CHAR POINTER BY REFERENCE AND A LONG
OUTPUT: NONE
*/
phone::phone(char*& type,char*&detail,long number): contact(type,detail)
{
	phone_number = number;
}

phone::phone(phone*& copy_from):contact((contact*&)copy_from)
{
	phone_number = copy_from->phone_number;
}



/*
THIS WILL DISPLAY THE CONTENTS OF THE PHONE DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
void phone::display() const
{
	if(! contact_type || !contact_detail)
	{
		cout<<"There was not enough info to display a phone object."<<endl;
		return;
	}
	cout<<"Type: "<<contact_type<<endl;
	cout<<"Detail: "<<contact_detail<<endl;
	cout<<"Phone number: "<<phone_number<<endl;
}
/////////////////////////////////////////////////////////////////////OVERLOADED OPERATORS FOR PHONE CLASS///////////////////////////////////////////////////////////////////////////////// 



/*
THIS IS AN OVERLOADED OPERATOR FOR THE PHONE DRIVED CLASS.
INPUT: AN OSTREAM BY REFERENCE AND A PHONE BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENECE.
*/
ostream& operator<<(ostream& out, const phone& p)
{
	p.display();
	return out;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE PHONE DERIVED CLASS.
INPUT: A PHONE POINTER BY REFERENCE.
OUTPUT: A BOOL
*/
bool phone::operator ==(const phone*& one) const
{
	if(strcmp(this->contact_type,one->contact_type)==0 && strcmp(this->contact_detail,one->contact_type)==0 && this->phone_number == one->phone_number)
	{
		return true;
	}
	return false;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE PHONE DERIVED CLASS.
INPUT: A PHONE POINTER BY REFERENCE.
OUTPUT: A PHONE POINTER
*/
phone* phone::operator =(const phone*& one)
{
	if(this == one)
	{
		return this;
	}
	strcpy(this->contact_type,one->contact_type);
	strcpy(this->contact_detail,one->contact_detail);
	this->phone_number = one->phone_number;
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE PHONE DERIVED CLASS.
INPUT:A PHONE POINTER BY REFERENCE.
OUTPUT: A BOOL 
*/
bool phone::operator !=(const phone*& one)
{
	if(this == one)
	{
		return false;
	}
	return true;
}
/////////////////////////////////////////////////////////////////////Email classes/////////////////////////////////////////////////////////////////////////////////



/*
THIS IS THE DEFAULT CONSTRUCTOR FOR THE EMAIL DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
email::email(): contact()
{
	contact_type=new char[100];
	strcpy(contact_type,(char*)"email");
	contact_detail=new char[100];
	email_address = new char[100];
	strcpy(contact_detail,(char*)"");
	strcpy(email_address,(char*)"");	
}



/*
THIS IS A NON DEFUALT CONSTRUCTOR FOR THE EMAIL DERIVED CLASS.
INPUT: THREE CHAR PONTERS BY REFERENCE.
OUTPUT: NONE
*/
email::email(char*& type, char*& detail, char*& address):contact(type,detail)
{
	email_address = new char[100];
	strcpy(email_address,address);
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE EMAIL DRIVED CLASS.
INPUT: AN EMAIL POINTER BY REFERENCE.
OUTPUT: NONE
*/
email::email(email*& to_copy):contact((contact*&)to_copy)
{
	email_address = new char[100];
	strcpy(email_address,to_copy->email_address);
}



/*
THIS IS A DESTRUCTOR FOR THE EMAIL DRIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
email::~email()
{
	if(email_address)
	{
		delete[] email_address;
	}
}



/*
THIS IS A DISPLAY FUNCTION FOR THE EMAIL DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
void email::display() const
{
	cout<<"Type: "<<contact_type<<endl;
	cout<<"Detail: "<<contact_detail<<endl;
	cout<<"Email Address: "<<email_address<<endl;

}
/////////////////////////////////////////////////////////////////////OVERLOADED OPERATORS FOR EMAIL CLASS///////////////////////////////////////////////////////////////////////////////// 



/*
THIS IS AN OVERLOADED OPERATOR FOR THE EMAIL DERIVED CLASS.
INPUT: AN OSTREAM BY REFERENCE AND AN EMAIL BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERNECE.
*/
ostream& operator<<(ostream& out,const email& e)
{
	e.display();
	return out;
} 



/*
THIS IS AN OVERLOADED OPERATOR FOR THE EMAIL DERIVED CLASS.
INPUT: AN EMAIL POINTER BY REFERENCE.
OUTPUT:A BOOL
*/
bool email::operator ==(const email*& one) const
{
	if(strcmp(this->contact_type,one->contact_type)==0 && strcmp(this->contact_detail,one->contact_type)==0 && strcmp(this->email_address,one->email_address)==0)
	{
		return true;
	}
	return false;
}



/*
THIS IS A OVERLOADED OPERATOR FOR THE EMAIL DERIVED CLASS.
INPUT: AN EMAIL POINTER BY REFERENCE.
OUTPUT: AN EMAIL POINTER
*/
email* email::operator =(const email*& one)
{
	if(this == one)
	{
		return this;
	}
	strcpy(this->contact_type,one->contact_type);
	strcpy(this->contact_detail,one->contact_detail);
	strcpy(this->email_address,one->email_address);
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE EMAIL DERIVED CLASS.
INPUT: AN EMAIL POINER BY REFERENCE.
OUTPUT: A BOOL
*/
bool email::operator !=(const email*& one)
{
	if(this == one)
	{
		return false;
	}
	return true;
}
/////////////////////////////////////////////////////////////////////Radio classes/////////////////////////////////////////////////////////////////////////////////



/*
THIS IS THE DEFAULT CONSTRUCTOR FOR THE RADIO DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
radio::radio():contact()
{
	contact_type = new char[100];
	contact_detail = new char[100];
	strcpy(contact_type,(char*)"radio");
	strcpy(contact_detail,(char*)"");	
	frequency = 0.0;
}



/*
THIS IS A NON DEFUALT CONSTRUCTOR FOR THE RADIO DERIVED CLASS.
INPUT: TWO CHAR POINTER BY REFERENCE AND A FLOAT.
OUTPUT: NONE
*/
radio::radio(char*&type,char*& detail,float freq): contact(type,detail)
{
	frequency = freq;
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE RADIO DERIVED CLASS.
INPUT:  A RADIO POINTER BY REFERENCE.
OUTPUT: NONE
*/
radio::radio(radio*& to_copy): contact((contact*&)to_copy)
{
	frequency = to_copy->frequency;
}



/*
THIS IS THE DISPLAY FUNCTION FOR THE RADIO DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
void radio::display() const
{
	cout<<"Type: "<<contact_type<<endl;
	cout<<"Detail: "<<contact_detail<<endl;
	cout<<"Frequency: "<<frequency<<endl;
}
/////////////////////////////////////////////////////////////////////OVERLOADED OPERATORS FOR RADIO CLASS///////////////////////////////////////////////////////////////////////////////// 



/*
THIS IS AN OVERLOADED OPERATOR FOR THE RADIO DERIVED CLASS.
INPUT: AN OSTREAM BY REFERENCE AND A RADIO BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator<<(ostream& out, const radio& r)
{
	r.display();
	return out;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE RADIO DERIVED CLASS.
INPUT: A RADIO POINTER BY REFERENCE.
OUTPUT: A BOOL
*/
bool radio::operator ==(const radio*& one) const
{
	if(strcmp(this->contact_type,one->contact_type)==0 && strcmp(this->contact_detail,one->contact_type)==0 && this->frequency == one->frequency)
	{
		return true;
	}
	return false;
}



/*
THS IS AN OVERLOADED OPERATOR FOR THE RADIO DERIVED CLASS.
INPUT: A RADIO POINTER BY REFERENCE.
OUTPUT: A RADIO POINTER.
*/
radio* radio::operator =(const radio*& one)
{
	if(this == one)
	{
		return this;
	}
	strcpy(this->contact_type,one->contact_type);
	strcpy(this->contact_detail,one->contact_detail);
	this->frequency = one->frequency;
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE RADIO DERIVED CLASS.
INPUT: A RADIO POINTER BY REFERENCE.
OUTPUT: A BOOL
*/
bool radio::operator !=(const radio*& one)
{
	if(this == one)
	{
		return false;
	}
	return true;
}
/////////////////////////////////////////////////////////////////////Social Media classes/////////////////////////////////////////////////////////////////////////////////



/*
THIS IS THE DEFUALT CONSTRUCTOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: NONE
OUTPUT:NONE
*/
social_media::social_media(): contact()
{
	contact_type = new char[100];
	contact_detail = new char[100];
	username = new char[100];
	strcpy(contact_type,(char*)"social media");
	strcpy(contact_detail,(char*)"");
	strcpy(username,(char*)"");
}



/*
THIS IS A NON DEFAULT CONSTRUCTOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: THREE CHAR POINTERS BY REFERENCE.
OUTPUT: NONE
*/
social_media::social_media(char*& type,char*& detail,char*& name):contact(type,detail)
{
	username = new char[100];
	strcpy(username,name);
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE SOCIAL MEDIA DRIVED CLASS.
INPUT: A SOCIAL MEDIA POINTER BY REFERENCE.
OUTPUT: NONE
*/
social_media::social_media(social_media*& to_copy):contact((contact*&)to_copy)
{
	username = new char[100];
	strcpy(username,to_copy->username);
}



/*
THIS IS A DESTRUCTOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
social_media::~social_media()
{
	if(username)
	{
		delete[] username;
	}
}



/*
THIS IS THE DISPLAY FUNCTON FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: NONE
OUTPUT:NONE
*/
void social_media::display() const
{
	cout<<"Type: "<<contact_type<<endl;
	cout<<"Detail: "<<contact_detail<<endl;
	cout<<"Username: "<<username<<endl;
}
/////////////////////////////////////////////////////////////////////OVERLOADED OPERATORS FOR SOCIAL MEDIA CLASS///////////////////////////////////////////////////////////////////////////////// 


/*
THIS IS AN OVERLAODED OPERATOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: AN OSTREAM BY REFERENCE AND A SOCIAL MEDIA BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator<<(ostream& out, const social_media& sm)
{
	sm.display();
	return out;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE SOCIAL MEDIS DERIVED CLASS.
INPUT: A SOCIAL MEDIA POINTER BY REFERENCE.
OUTPUT: A BOOL
*/
bool social_media::operator ==(const social_media*& one) const
{
	if(strcmp(this->contact_type,one->contact_type)==0 && strcmp(this->contact_detail,one->contact_type)==0 && strcmp(this->username,one->username)==0)
	{
		return true;
	}
	return false;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: A SOCIAL MEDIA POINTER BY REFERENCE.
OUTPUT: A SOCIAL MEDIA POINTER
*/
social_media* social_media::operator =(const social_media*& one)
{
	if(this == one)
	{
		return this;
	}
	strcpy(this->contact_type,one->contact_type);
	strcpy(this->contact_detail,one->contact_detail);
	strcpy(this->username,one->username);
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: A SOCIAL MEDIA POINTER BY REFERENCE.
OUTPUT: A BOOL
*/
bool social_media::operator !=(const social_media*& one)
{
	if(this == one)
	{
		return false;
	}
	return true;
}
/////////////////////////////////////////////////////////////////////TV classes/////////////////////////////////////////////////////////////////////////////////



/*
THIS IS THE DEFUALT CONSTUCTOR FOR THE TV DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
tv::tv(): contact()
{
	contact_type = new char[100];
	contact_detail = new char[100];
	strcpy(contact_type,(char*)"tv");
	strcpy(contact_detail,(char*)"");
	channel = 0;
}



/*
THIS IS A NON DEFUALT CONSTRUCTOR FOR THE TV DERIVED CLASS.
INPUT: TWO CHAR POINTER BY REFERENCE AND AN INT.
OUTPUT: NONE
*/
tv::tv(char*& type, char*& detail, int chan): contact(type,detail)
{
	channel = chan;
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE TV DERIED CLASS.
INPUT: A TV POINTER BY REFERENCE
OUTPUT: NONE
*/
tv::tv(tv*&copy_to): contact((contact*&)copy_to)
{
	channel = copy_to->channel;
}



/*
THIS IS A DISPLAY FUNCTION FOR THE TV DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
void tv::display() const
{
	cout<<"Type: "<<contact_type<<endl;
	cout<<"Detail: "<<contact_detail<<endl;
	cout<<"Channel number: "<<channel<<endl;
}
/////////////////////////////////////////////////////////////////////OVERLOADED OPERATORS FOR TV CLASS///////////////////////////////////////////////////////////////////////////////// 



/*
THIS IS AN OVERLOADED OPERATOR FOR THE TV DERIVED CLASS.
INPUT: AN OSTREAM BY REFERENCE AND A TV BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator<<(ostream& out, const tv& t)
{
	t.display();
	return out;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE TV DERIVED CLASS.
INPUT: A TV POINTER BY REFERENCE.
OUTPUT: A BOOL
*/
bool tv::operator ==(const tv*& one) const
{
	if(strcmp(this->contact_type,one->contact_type)==0 && strcmp(this->contact_detail,one->contact_type)==0 && this->channel == one->channel)
	{
		return true;
	}
	return false;
}



/*
THIS IS A OVERLOADED OPERATOR FOR THE TV DERIVED CLASS.
INPUT: A TV POINTER BY REFERENCE.
OUPUT: A TV POINTER.
*/
tv* tv::operator =(const tv*& one)
{
	if(this == one)
	{
		return this;
	}
	strcpy(this->contact_type,one->contact_type);
	strcpy(this->contact_detail,one->contact_detail);
	this->channel = one->channel;
	return this;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR THE TV DERIVED CLASS.
INPUT: A TV POINTER BY REFERENCE.
OUTPUT: A BOOL
*/
bool tv::operator !=(const tv*& one)
{
	if(this == one)
	{
		return false;
	}
	return true;
}
