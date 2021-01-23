/*
Brandon Danielski
2/24/17
CS202
Assignment 3
This is ther .h file for the tree class of the program.
*/
#include"person.h"
#ifndef TREE_H
#define TREE_H
class person_node;
class person;
class tree_node
{
public:
tree_node();//default constructor
tree_node(tree_node*& to_copy);//copy constructor
tree_node(person_node*&);//non default constructor
tree_node(char*& last);//non default constructor
tree_node*& go_left();//goes left for a node.
tree_node*& go_right();//goes right for a node.
void get_head(person_node*& to_head);//gets the head of the tree linear linked list.
void get_last_name(char*& to_copy);//gets the last name stored in a node.
void add_to_list(person_node*& to_add);//adds a node to the linear linked list stored in a node.
tree_node& operator=(const tree_node&);//an overloaded operator for the = operator.
friend bool operator <(tree_node& one, tree_node& two);//an overloaded operator for the < operator.
friend bool operator <=(tree_node& one, tree_node& two);//an overloaded operator for the <= operator.
friend bool operator > (tree_node& one, tree_node& two);//an overloaded operator for the > operator.
friend bool operator >=(tree_node& one, tree_node& two);//an overloaded operator for the >= operator.
bool operator ==(tree_node& one);//an overloaded operator for the == operator.
void display();//display function.
friend ostream& operator <<(ostream&, tree_node&);//overlaoded operator for the << operator.
~tree_node();//destructor
protected:
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
void load_data_from_external_file(char* file_name);//loads data from file into the tree.
void insert(person&);//wrapper for insterint a node into a tree.
void add_new_tree_node(person_node*& to_add);//adds a new node to the tree.
void set_root(tree_node*&);//sets root to the passed node.
friend ostream& operator <<(ostream&, tree& );//overloaded operator for the << operator.
void display(tree_node*&);//displays everything in a tree.
void get_num();
void create_dummy();
void insert(tree_node*&);
protected:
void rec_insert(tree_node*&,person_node*&, char*&);// inserts a node to the tree.
void insert_algorithm(person*&,int,tree&);//inserts the people objects in a balaced fashion.
void rec_insert_algorithm(int,int,person*&,bool*&,int*,tree&,int);//inserts the peeople objects in a balacned fashion.
void rec_add_new_tree_node(person_node*& to_add, tree_node*& root);//adds a new tree node to a tree.
void delete_tree(tree_node*& root);//deletes an entire tree.
tree_node* root;
int number_of_nodes;
};
#endif
