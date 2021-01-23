/*
Brandon Danielski
2/24/2017
CS202
Assignment 3
This is the .h file for the entire hierarchy of the contact base class.
*/
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
using namespace std;
#ifndef CONTACT_H
#define CONTACT_H
class contact
{
public:
contact();//defualt constructor
contact(contact*& copy_from);//non-defualt contructor
contact(char*& type, char*& detail);//non-default constructor
virtual ~contact();//destructor
//friend ostream& operator <<(ostream&, contact&);
contact& operator =(const contact&);//operator overload '='
bool operator ==(const contact&) const;//operator overload '=='
void get_type(char*& to_get);//gets the contact type of contact.
protected:
char* type_of_contact;
char* contact_detail;
};

class phone: public contact
{
public:
phone();//default contructor
phone(long number);// non-defualt contructor
phone(long number, char*& type, char*& detail);//non-defualt constuctor
phone(phone*& copy_from);//copy constructor
friend ostream& operator<<(ostream&, const phone&);//operator overload <<
phone& operator =(const phone&);//operator overload =
bool operator ==(const phone&) const;//operator overload ==
void display()const;//display function
protected:
long phone_number;
};

class email: public contact
{
public:
email();//defualt constructor
email(char*& address);//non-defualt constructor
email(char*& email, char*& type, char*& detail);//non-defualt constructor
email(email*& copy_from);//copy constructor
friend ostream& operator <<(ostream&, const email&);//operator overload <<
email& operator =(const email&);//operator overload =
bool operator ==(const email&) const;//operator overload ==
void display()const;//display function
~email();//destructor
protected:
char* email_address;
};

class radio: public contact
{
public:
radio();//default constructor
radio(float frequency);//non-defualt contructor
radio(float frequency, char*& type, char*& detail);//non default constructor
radio(radio*& copy_from);//copy constructor
friend ostream& operator <<(ostream&, const radio&);//operator overload <<
radio& operator =(const radio&);//operator overload =
bool operator ==(const radio&) const;//operator overload ==
void display() const;//display functon.
protected:
float radio_frequency;
};

class social_media: public contact
{
public:
social_media();//default constructor
social_media(char*& account);//non default constructor
social_media(char*& account, char*& type, char*& detail);//non defualt constructor
social_media(social_media*& copy_from);//copy constructor
friend ostream& operator <<(ostream&, const social_media&);//operator overload <<
social_media& operator =(const social_media&);//operator overload =
bool operator ==(const social_media&) const;//operator overload ==
void display() const;//display functon
~social_media(); //destructor
protected:
char* account_name;
};

class television: public contact
{
public:
television();//defualt constructor
television(int channel);//non default constructor
television(int channel, char*& type, char*& detail);//non default constructor
television(television*& copy_from);//copy constructor
friend ostream& operator <<(ostream&, const television&);//operator overload <<
television& operator =(const television&);//operator overload =
bool operator ==(const television&) const;//operator overload ==
void display() const;//display function
protected:
int channel_number;
};
#endif
