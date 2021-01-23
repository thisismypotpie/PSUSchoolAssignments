/*
Brandon Danielski
11/3/2016
CS 163
Assignment 3
This is the external .h file for my program.  It allows for the program to take data from an external data file and puts it into data in the format of the game ADT.
*/
#ifndef EX_FILE_H
#define EX_FILE_H
#include"table.h"
class ex_file
{
public:
//ex_file();
//~ex_file();
bool load(table& to_copy);//a function that loads information from the external data file to a hash table.
bool append(table& to_copy);//a function that saves changes to the data file.
private:
};
#endif
