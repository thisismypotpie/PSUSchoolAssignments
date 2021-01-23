/*
Brandon Danielski
3/1/2017
CS202
Assignment 3
This is the .h file for the person and person node classes.
*/
#ifndef PERSON_H
#define PERSON_H
#include<iostream>
#include"contact.h"
using namespace std;
class person
{
public:
person();//default constructor
person(char* first, char* last,contact*&,contact*&,contact*&);//non default constructor
person(person*& to_copy);//a copy constructor
~person();//destructor
char*& get_first_name();//gets first name
char*& get_last_name();//gets last name
void display() const;//display function
bool is_valid();//checks for valid
friend ostream& operator <<(ostream&,person&);//overloaded operator
friend person operator +(const char*&,  person&);//overloaded operator +
friend person operator +( person&, const char*&);//overloaded operator +
friend person operator +(const contact&,  person&);// overloaded operator +
friend person operator +( person&, const contact&);//oveloaded operator +
person* operator += (const char*);//overloaded operator +=
person* operator += (phone*&);//overloaded operator +=
person* operator += (email*&);//overloaded operator +=
person* operator += (radio*&);//overloaded operator +=
person* operator += (social_media*&);//overloaded operator +=
person* operator += (tv*&);//overloaded operator +=
protected:
char* first_name;
char* last_name;
contact** emergency;
};

class person_node
{
public: 
person_node();//default constructor
person_node(person*&);//copy constructor
person_node(person_node*&);//cpy constructor
~person_node();//destructor
person*& get_data();//returns data data member.
char*& get_last_name();//returns last name of data
char*& get_first_name();//returns first name of data
void set_next(person_node*&);//sets the next pointer data member.
person_node*& next_node();//returns next person node.
friend ostream& operator <<(ostream&,person_node&);//overloaded operator
friend bool operator <(person_node&, person_node&);//overloaded operator
friend bool operator >(person_node&, person_node&);//overloaded operator
friend bool operator <=(person_node&, person_node&);//overloaded operator
friend bool operator >=(person_node&, person_node&);//overloaded operator
protected:
person* data;
person_node* next;
};
#endif
