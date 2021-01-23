/*
Brandon Danielski
2/24/17
CS202
Assignment 3
This is ther .h file for the tree class of the program.
*/
#ifndef TREE_H
#define TREE_H
#include<iostream>
#include"person.h"
using namespace std;
class person;
class person_node;
class tree_node
{
public:
tree_node();//default constructor
tree_node(tree_node*& to_copy);//copy constructor
tree_node(person_node*&);//copy constuctor
tree_node*& go_left();//goes left for a node.
tree_node*& go_right();//goes right for a node.
~tree_node();//destructor
//void add_to_list(person_node*& to_add);//adds a node to the linear linked list stored in a node.
//person_node*& get_head();
char*& get_last_name();//returns last name
void display() const;//display function
void add_to_list(person_node*&);//adds to the LLL of a tree node.
person_node*& get_head();//returns hdead
friend ostream& operator <<(ostream&, const tree_node&);//overloaded operator
protected:
void rec_add_to_list(person_node*&,person_node*&);//adds to a list.
char* last_name;
person_node* head;
tree_node* left;
tree_node* right;
};

class tree
{
public:
tree();//defualt constructor
~tree();//destructor
void insert(person*&);//wrapper for insterint a node into a tree.
void search(char*&,char*&);//wrapper for searching
void add_data_from_file_to_tree(char*& filename);//adds data to a file
tree_node*& get_root();//returns root.
friend ostream& operator<<(ostream&, tree&);//overloaded operator
protected:
void rec_insert(tree_node*&,person_node*&);//inserts into the tree.
void delete_tree(tree_node*& root);//deletes an entire tree.
void rec_search(char*&,char*&,tree_node*&,bool);//inserts into LLL of tree node.
void display(tree_node*&)const;//displays tree.
tree_node* root;
int number_of_nodes;
};
#endif
