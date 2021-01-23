/*
Brandon Danielski
11/3/2016
CS 163
Assignment 3
This is my table that will store data from the external data file.  It will store then via random indx that can be retireved by the user at a later time.
*/
#ifndef TABLE_H
#define TABLE_H
#include"game.h"
//#include"linked_list.h"
struct node
{
node* next;
game data;
};
class table
{
public:
table();//Constructor for the table ADT.
~table();//Destructor for the table ADT.
int insert(game& to_store);//Inserts a node pointer into the list.
int hash_function(char*& key);//Hash function for the table.
bool display_all(int index);//display everything in the table in an unsorted order.
bool retrieve(game& copy_to,char*& key);//retrieves a game the user wants by game name.
bool remove(char*& key);//removes a game by game name.
int list_size();//returns the size of the hash table.
bool retrieve_for_ex_file(node*& copy_to,int pos);//special retrieve for ex file to append the data file.
bool retreive_platform(char* platform);//displays all games of a specific platform.
private:
node** hasher;
int MAX;
};

#endif
