/*
Brandon Danielski
2/24/2017
CS202
Assignment 3
This is the .h file for the person and person node classes.
*/
#include"contact.h"
#include<iostream>
using namespace std;
#ifndef PERSON_H
#define PERSON_H
class person
{
public:
person();//default constuctor
person(char*& first, char*& last);//non default contructor
person(char*& first, char*& last, contact*& c_one, contact*& c_two, contact*& c_three);//non default constructor
person(person*& copy_from);//copy constructor
friend ostream& operator <<(ostream&, person&);//overloaded operator <<
void display();//display function
friend person operator +(const char*&,  person&);//overloaded operator +
friend person operator +( person&, const char*&);//overloaded operator +
friend person operator +(const contact&,  person&);// overloaded operator +
friend person operator +( person&, const contact&);//oveloaded operator +
person& operator += (const char*);//overloaded operator +=
person& operator += (phone*&);//overloaded operator +=
person& operator += (email*&);//overloaded operator +=
person& operator += (radio*&);//overloaded operator +=
person& operator += (social_media*&);//overloaded operator +=
person& operator += (television*&);//overloaded operator +=
person& operator =( const person&); //overloaded operator =
bool operator ==(const person&);//overlaoded operator ==
bool is_fully_populated();//checks to see if all pieces of a person class are fully populated.
void get_last_name(char*&);//gets lst name for a person.
~person();//destructor
protected:
char* first_name;
char* last_name;
contact** emergency;
};

class person_node
{
public:
person_node();//defualt constructor
person_node(person&);//copy constructor
person_node(person_node*&);
person_node*& next_node();//gets the next node in the list.
person_node& operator =(const person_node&);//overloaded operator =
friend ostream& operator<<(ostream& ,const person_node&);//overloaded operator <<
void get_last_name(char*&);//gets the last name of a person node.
void set_next(person_node*& to_add);//sets the next pointer for a node
~person_node();//destructor
bool operator ==(const person_node&);//overloaded operator ==
protected:
person_node* next;
person* data;
};
#endif
