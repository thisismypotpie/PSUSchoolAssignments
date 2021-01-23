/*
Brandon Danielski
2/24/2017
CS202
Assignment 3
This is the .cpp file for the entire contact hieratrchy.
*/
#include"contact.h"
#include<cstring>
#include<iostream>
#include<iomanip>
using namespace std;



/*
This is the defualt constructor for the contact base class.
INPUT: NONE
OUTPUT: NONE
*/
contact::contact()
{
	type_of_contact = new char[100];
	contact_detail = new char[100];
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE CONTACT BASE CLASS
INPUT: CONTACT POINTER PASSED BY REFERENCE
OUTPUT: NONE
*/
contact::contact(contact*& copy_from)
{
	type_of_contact = new char[100];
	contact_detail = new char[100];
	strcpy(type_of_contact,copy_from->type_of_contact);
	strcpy(contact_detail, copy_from->contact_detail);
}



/*
THIS IS A NON DEFAULT CONSTRUCTOR
INPUT: TWO CHAR POINTERS PASSED BY REFERNCE
OUTPUT: NONE
*/
contact::contact(char*& type, char*& detail)
{
	type_of_contact = new char[100];
	contact_detail = new char[100];
	strcpy(type_of_contact,type);
	strcpy(contact_detail,detail);
}



/*
THIS IS THE DESTRUCTOR FOR THE CONTACT BASE CLASS
INPUT: NONE
OUTPUT: NONE
*/
contact::~contact()
{
	if(type_of_contact)
	{
		delete[] type_of_contact;
	}
	if(contact_detail)
	{
		delete[] contact_detail;
	}
}



/*
THIS IS THE DEFAULT CONSTUCTOR FOR THE PHONE DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
phone::phone(): contact()
{
	phone_number = 0;
}



/*
THIS IS A NON DEFUALT CONSTRUCTOR FOR THE PHONE DERIVED CLASS.
INPUT: A LONG 
OUTPUT: NONE
*/
phone::phone(long number): contact()
{
	phone_number = number;
}



/*
THIS IS A NON DEFAULT CONSTRUCTOR FOR THE PHONE DERIVED CLASS.
INPUT: A LONG AND TWO CHAR POINTERS PASSED BY REFERENCE.
OUTPUT: NONE
*/
phone::phone(long number, char*& type, char*& detail):contact(type,detail)
{
	phone_number = number;
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE PHONE DERIVED CLASS.
INPUT: A PHONE POINTER PASSED BY REFERENCE.
OUTPUT: NONE
*/
phone::phone(phone*& copy_from):contact(copy_from->type_of_contact, copy_from->contact_detail)
{
	phone_number = copy_from->phone_number;
}



/*
THIS IS A DEFUALT CONSTRUCTOR FOR THE EMAIL DERIVED CLASS
INPUT: NONE
OUTPUT: NONE
*/
email::email(): contact()
{
	email_address = new char[100];
}



/*
THIS IS A NON DEFAULT CONSTRUCTOR FOR THE EMAL DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
email::email(char*& address): contact()
{
	email_address = new char[100];
	strcpy(email_address,address);
}



/*
THIS IS A NON DEFUALT CONSTRCUTOR FOR THE EMAIL DERIVED CLASS.
INPUT: THREE CHAR POINTERS PASSED BY REFERENCE.
OUTPUT: NONE
*/
email::email(char*& email, char*& type, char*& detail): contact(type, detail)
{
	email_address = new char[100];
	strcpy(email_address, email);
}



/*
THIS IS THE COPY CONSTRUCTOR FOR THE EMAIL DERIVED CLASS.
INPUT: AN EMAIL POINTER PASED BY REFERENCE.
OUTPUT: NONE
*/
email::email(email*& copy_from):contact(copy_from->type_of_contact, copy_from->contact_detail)

{
	email_address = new char[100];
	strcpy(email_address, copy_from->email_address);
}



/*
THIS IS THE DESTRUCTOR FOR THE EMAIL DERIVED CLASS.
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
THIS IS THE DEFAULT CONSTRUCTOR FOR THE RADIO DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
radio::radio():contact()
{
	radio_frequency = 0;
}



/*
THIS IS A NON DEFAULT CONSTRUCTOR FOR THE RADIO DERIVED CLASS.
INPUT: A FLOAT
OUTPUT: NONE
*/
radio::radio(float frequency):contact()
{
	radio_frequency = frequency;	
}



/*
THIS IS A NON DEFAULT CONSTUCTOR FOR THE RADIO DERIVED CLASS.
INPUT: A FLOAT AN TWO CHAR POINTERS PASSED BY REFERENCE.
OUTPUT: NONE
*/
radio::radio(float frequency, char*& type, char*& detail): contact(type, detail),radio_frequency(frequency)
{

}



/*
THIS IS A COPY CONSTRUCTOR FOR THE RADIO DERIVED CLASS.
INPUT: A RADIO POINTER PASSED BY REFERENCE.
OUTPUT: NONE
*/
radio::radio(radio*& copy_from):contact(copy_from->type_of_contact, copy_from->contact_detail), radio_frequency(copy_from->radio_frequency)
{
	
}



/*
THIS IS THE DEFUALT CONSTRUCTOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
social_media::social_media(): contact()
{
	account_name = new char[100];
}



/*
THIS IS THE THE NON DEFUALT CONSTRUCTOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: A CHAR POINTER PASSED BY REFERENCE.
OUTPUT: NONE
*/
social_media::social_media(char*& account): contact()
{
	account_name = new char[100];
	strcpy(account_name, account);
}



/*
THIS IS A NON DEFAULT CONTRUCTOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: THREE CHAR POINTERS PASSED BY REFERENCE.
OUTPUT: NONE
*/
social_media::social_media(char*& account, char*& type, char*& detail):contact(type, detail)
{
	account_name = new char[100];
	strcpy(account_name, account);
}



/*
THIS IS A COPY CONSTUCTOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: A SOCIAL MEDIA POINTER PASSED BY REFERENCE.
OUTPUT: NONE
*/
social_media::social_media(social_media*& copy_from): contact(copy_from->type_of_contact, copy_from->contact_detail)
{
	account_name = new char[100];
	strcpy(account_name, copy_from->account_name);	
}



/*
THIS IS THE DESTRUCTOR FOR THE SOCIAL MEDIA DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
social_media::~social_media()
{
	if(account_name)
	{
		delete[] account_name;
	}
}



/*
THIS IS THE DEFUALT CONSTRUCTOR FOR THE TELEVISION DERIVED CLASS.
INPUT: NONE
OUTPUT: NONE
*/
television::television():contact()
{
	channel_number = 0;	
}



/*
THIS IS A NON DEFAULT CONSTRUCTOR FOR THE TELEVISION DERIVED CLASS.
INPUT: AN INT
OUTPUT: NONE
*/
television::television(int channel): contact()
{
	channel_number = channel;
}



/*
THIS IS A NON DEFUALT CONSTRUTOR FOR THE TELEVISION DERIVED CLASS.
INPUT: AN INT AND TWO CHAR POINTERS PASSED BY REFERENCE.
OUTPUT: NONE
*/
television::television(int channel, char*& type, char*& detail): contact(type, detail)
{
	channel_number = channel;
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE TELEVISION DERIVED CLASS.
INPUT: A TELEVISION POINTE BY REFERENCE.
OUTPUT: NONE
*/
television::television( television*& copy_from):contact(copy_from->type_of_contact, copy_from->contact_detail)

{
	channel_number = copy_from->channel_number;	
}



/*
THIS FUNCTION COPIES THE CONTACT TYPE INTO THE PASSED CHAR POINTER.
INPUT: A CHAR POINTER BY REFERENCE.
OUTPUT: NONE
*/
void contact::get_type(char*& to_get)
{
	strcpy(to_get,type_of_contact);
}
/*ostream& operator <<(ostream& out, contact& c)
{
	
	if(strcmp(c.type_of_contact,(char*)"phone")==0)
	{
		out<<static_cast<phone&>(c)<<endl;
	}
	else if(strcmp(c.type_of_contact,(char*)"email")==0)
	{
		out<<static_cast<email&>(c)<<endl;
	}
	else if(strcmp(c.type_of_contact,(char*)"radio")==0)
	{
		out<<static_cast<radio&>(c)<<endl;
	}
	else if(strcmp(c.type_of_contact,(char*)"social media")==0)
	{
		out<<static_cast<social_media&>(c)<<endl;
	}
	else if(strcmp(c.type_of_contact,(char*)"television")==0)
	{
		out<<static_cast<television&>(c)<<endl;
	}
	else
	{
		cout<<"Could not display"<<endl;
	}
	return out;
}*/



/*
THIS IS THE OERLOADED OPERATOR FOR '<<' IN THE PHONE CLASS.
INPUT: AN OSTREAM AND A PHONE PASSED BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator <<(ostream& out, const phone& p)
{
	p.display();
	return out;
}



/*
THIS IS A DISPLAY FUNCTION FOR THE PHONE FUNCTION.
INPUT: NONE
OUTPUT: NONE
*/
void phone::display()const
{

	if(type_of_contact)
	{
		cout << "Type of contact: " << type_of_contact<<endl;
	}
	if(contact_detail)
	{
		cout << "Contact Detail: " << contact_detail<<endl;
	}
	cout <<"Phone number: "<<phone_number<<endl;
}



/*
THIS IS THE OVERLAODED OPERATOR FOR '<<' IN THE EMAL CLASS.
INPUT: AN OSTREAM AND AN EMAIL BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator <<(ostream& out, const email& e)
{
	e.display();
	return out;
}



/*
THIS IS A DISPLAY FUNCTION FOR THE EMAIL DERIVED FUNCTION.
INPUT: NONE
OUTPUT: NONE
*/
void email::display() const
{

	if(type_of_contact)
	{
		cout << "Type of contact: " << type_of_contact<<endl;
	}
	if(contact_detail)
	{
		cout << "Contact Detail: " << contact_detail<<endl;
	}
	if(email_address)
	{	
		cout << "Email Address: "<< email_address<<endl;
	}
}



/*
THIS IS THE OVERLOADED OPERATOR FOR '<<' IN THE RADIO CLASS.
INPUT: AN OSTREAM AND A RADIO BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator <<(ostream& out, const radio& r)
{
	r.display();
	return out;
}



/*
THIS IS A DISPLAY FUNCTION FOR THE RADIO CLASS.
INPUT: NONE
OUTPUT: NONE
*/
void radio::display() const
{

	if(type_of_contact)
	{
		cout << "Type of contact: " << type_of_contact<<endl;
	}
	if(contact_detail)
	{
		cout << "Contact Detail: " << contact_detail<<endl;
	}
		//cout<< "Frequency: "<<radio_frequency<<endl;
}



/*
THIS IS AN OVERLOADED OPERATOR FOR '<<' IN THE SOCIAL MEDIA CLASS.
INPUT: OSTREAM AND A SOCIAL MEDIA CLASS.
OUTPUT: OSTREAM BY REFERENCE.
*/
ostream& operator <<(ostream& out, const social_media& s)
{
	s.display();
	return out;
}



/*
THIS IS A DISPLAY FUNCTION FOR THE SOCIAL MEDIA CLASS.
INPUT: NONE
OUTPUT: NONE
*/
void social_media::display() const
{

	if(type_of_contact)
	{
		cout << "Type of contact: " << type_of_contact<<endl;
	}
	if(contact_detail)
	{
		cout << "Contact Detail: " << contact_detail<<endl;
	}
	if(account_name)
	{
		cout << "Username: "<< account_name<<endl;
	}
}



/*
THIS IS AN OVERLOADED OPERATOR FOR '<<' IN THE TELEVISION CLASS.
INPUT: OSTREAM BY REFERENCE AND TELEVISION BY REFERENCE.
OUTPUT: OSTERAM BY REFERENCE.
*/
ostream& operator <<(ostream& out, const television& t)
{
	t.display();
	return out;
}



/*
THIS IS A DISPLAY FUNCTION FOR THE TELEVISION CLASS.
INPUT: NONE
OUTPUT: NONE
*/
void television::display() const
{
	if(type_of_contact)
	{
		cout << "Type of contact: " << type_of_contact<<endl;
	}
	if(contact_detail)
	{
		cout << "Contact Detail: " << contact_detail<<endl;
	}
	cout << "Channel number: "<< channel_number<<endl;

}



/*
THIS IS AN OVERLOADED OPERATOR '=' FOR THE CONTACT BASE CLASS.
INPUT: CONTACT BY REFERENCE.
OUTPUT: CONTACT BY REFERENCE 
*/
contact& contact::operator=(const contact& c)
{
	strcpy(this->type_of_contact,c.type_of_contact);
	strcpy(this->contact_detail,c.contact_detail);
	return *this;
}



/*
THIS IS AN OVERLOADED OPERAOTR '=' FOR THE PHONE CLASS.
INPUT: PHONE BY REFERENCE.
OUPUT: PHONE BY REFERENCE.
*/
phone& phone::operator =(const phone& p)
{
	strcpy(this->type_of_contact,p.type_of_contact);
	strcpy(this->contact_detail,p.contact_detail);
	this->phone_number = p.phone_number;
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR '=' FOR THE EMAIL CLASS.
INPUT: EMAIL BY REFERENCE.
OUTPUT: EMAIL BY REFERENCE.
*/
email& email::operator =(const email& e)
{
	
	strcpy(this->type_of_contact,e.type_of_contact);
	strcpy(this->contact_detail,e.contact_detail);
	strcpy(this->email_address, e.email_address);
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR '=' FOR THE RADIO CLASS.
INPUT: RADIO BY REFERENCE.
OUPUT: RADIO BY REFERENCE.
*/
radio& radio::operator =(const radio& r)
{
	
	strcpy(this->type_of_contact,r.type_of_contact);
	strcpy(this->contact_detail,r.contact_detail);
	this->radio_frequency = r.radio_frequency;
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR '=' FOR THE SOIAL MEDIA CLASS.
INPUT: SOCIAL MEDIA CLASS BY REFERENCE.
OUTPUT: SOCIAL MEDIA CLASS BY REFERENCE.
*/
social_media& social_media::operator =(const social_media& s)
{
	
	strcpy(this->type_of_contact,s.type_of_contact);
	strcpy(this->contact_detail,s.contact_detail);
	strcpy(this->account_name,s.account_name);
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR '=' FOR THE TELEVISION CLASS;
INPUT: TELEVISION BY REFERENCE.
OUTPUT: TELEVISION BY REFERENCE.
*/
television& television::operator =(const television& t)
{
	
	strcpy(this->type_of_contact,t.type_of_contact);
	strcpy(this->contact_detail,t.contact_detail);
	this->channel_number = t.channel_number;
	return *this;
}



/*
THIS IS AN OVERLOADED OPERATOR '==' FOR THE CONTACT CLASS.
INPUT: CONTACT BY REFERENCE.
OUTPUT: CONTACT BY REFERENCE.
*/
bool contact::operator==(const contact& c) const
{
	if(strcmp(this->type_of_contact,c.type_of_contact)==0 && strcmp(this->contact_detail,c.contact_detail)==0)
	{
		return true;
	}
	else
	{
		return false;
	}
}



/*
THIS IS AN OVERLOADED OPERATOR '==' FOR THE PHONE CLASS.
INPUT: CONTACT BY REFERENCE.
OUTPUTl CONTACT BY REFERENCE.
*/
bool phone::operator==(const phone& c)const
{
	if(strcmp(this->type_of_contact,c.type_of_contact)==0 && strcmp(this->contact_detail,c.contact_detail)==0 && this->phone_number == c.phone_number)
	{
		return true;
	}
	else
	{
		return false;
	}
}



/*
THIS IS AN OVERLOADED OPERATOR '==' FOR THE EMAIL CLASS.
INPUT: EAMIL BY REFERENCE.
OUTPUT: EMAIL BY REFERENCE.
*/
bool email::operator==(const email& c) const
{
	if(strcmp(this->type_of_contact,c.type_of_contact)==0 && strcmp(this->contact_detail,c.contact_detail)==0 && strcmp(this->email_address,c.email_address)==0)
	{
		return true;
	}
	else
	{
		return false;
	}
}



/*
THIS IS AN OVERLOADED OPERATOR '==' FOR THE RADIO CLASS.
INPUT: RADIO BY REFERENCE.
OUPUT: RADIO BY REFERENCE.
*/
bool radio::operator==(const radio& c) const
{
	if(strcmp(this->type_of_contact,c.type_of_contact)==0 && strcmp(this->contact_detail,c.contact_detail)==0 && this->radio_frequency == c.radio_frequency)
	{
		return true;
	}
	else
	{
		return false;
	}
}



/*
THIS IS AN OERLOADED OPERATOR '==' FOR THE SOCIAL MEDIA CLASS.
INPUT: SOCIAL MEDIA BY REFERENCE.
OUTPUT: SOCIAL MEDIA BY REFERENCE.
*/
bool social_media::operator==(const social_media& c) const
{
	if(strcmp(this->type_of_contact,c.type_of_contact)==0 && strcmp(this->contact_detail,c.contact_detail)==0 && strcmp(this->account_name, c.account_name)==0)
	{
		return true;
	}
	else
	{
		return false;
	}
}



/*
THIS IS AN OVERLOADED OPERATOR '==' FOR THE TELEVISION CLASS.
INPUT: TELEVISION BY REFERENCE.
OUTPUT: TELEVISION BY REFERENCE.
*/
bool television::operator==(const television& c) const
{
	if(strcmp(this->type_of_contact,c.type_of_contact)==0 && strcmp(this->contact_detail,c.contact_detail)==0 && this->channel_number == c.channel_number)
	{
		return true;
	}
	else
	{
		return false;
	}
}
