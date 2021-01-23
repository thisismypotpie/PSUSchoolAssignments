/*
Brandon Danielski
3/1/2017
CS202
Assignment 3
This is the .h file for the contact base class and its five derived classes.
*/
#include<iostream>
#include<stdio.h>
#include<stdlib.h>
#ifndef CONTACT_H
#define CONTACT_H
using namespace std;
class contact
{
public:
contact();//defualt constructor
contact(char*& type, char*& detail);//non defualt constructor
contact(contact*&);//copy constructor
virtual ~contact();//destructor
char*& get_type();//gets the type of contact.
friend ostream& operator<<(ostream&, contact*&);//overlaoded operator
protected:
char* contact_type;
char* contact_detail;
};

class phone: public contact
{
public:
phone();//default constructor
phone(char*& type, char*& detail, long num);//non default constuctor
phone(phone*&);//copy constructor
void display() const;//display function
friend ostream& operator<<(ostream&, const phone&);//overlaoded operator
bool operator ==(const phone*&) const;//overlaoded operator
phone* operator =(const phone*&);//overlaoded operator
bool operator !=(const phone*&);//overlaoded operator
protected:
long phone_number;
};

class email: public contact
{
public:
email();//default constructor
email(char*&,char*&,char*&);//non default constructor
email(email*&);//copy constructor
void display() const;//display function
friend ostream& operator<<(ostream&, const email&);//overlaoded operator
bool operator ==(const email*&) const;//overlaoded operator
email* operator =(const email*&);//overlaoded operator
bool operator !=(const email*&);//overlaoded operator
~email();//destructor
protected:
char* email_address;
};

class radio: public contact
{
public:
radio();//default constructor
radio(char*&,char*&,float);//non default constructor
radio(radio*&);//copy constructor
void display() const;//display function
friend ostream& operator<<(ostream&, const radio&);//overlaoded operator
bool operator ==(const radio*&) const;//overlaoded operator
radio* operator =(const radio*&);//overlaoded operator
bool operator !=(const radio*&);//overlaoded operator
protected:
float frequency;

};

class social_media: public contact
{
public:
social_media();//default constructor
social_media(char*&,char*&,char*&);//non default constructor
social_media(social_media*&);//copy constructor
~social_media();//destructor
void display() const;//display function
friend ostream& operator<<(ostream&,const social_media&);//overlaoded operator
bool operator ==(const social_media*&) const;//overlaoded operator
social_media* operator =(const social_media*&);//overlaoded operator
bool operator !=(const social_media*&);//overlaoded operator
protected:
char* username;
};

class tv: public contact
{
public:
tv();//defualt constructor
tv(char*&,char*&,int);// non default constructor
tv(tv*&);//copy constructor
void display() const;//display functon
friend ostream& operator<<(ostream&,const tv&);//overlaoded operator
bool operator ==(const tv*&) const;//overlaoded operator
tv* operator =(const tv*&);//overlaoded operator
bool operator !=(const tv*&);//overlaoded operator
protected:
int channel;

};
#endif
