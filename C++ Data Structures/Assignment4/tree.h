/*
Brandon Danielski
11/24/2106
CS 163
Assignment 4
This .h file is for my tree ADT.  It stores games in alphetical order.  Most of the public functions are recusrive so the public functions are mostly wrapprs.
 */
#ifndef TREE_H
#define TREE_H
#include"game.h"

struct node
{
	node* left;
	node* right;
	game data;
};
class tree
{
	public:
		tree();//A constructor for a tree.
		~tree();//Destuctor for the tree.  Acts as a recursive wrapper for another functoin.
		bool insert(game& to_store);//Wrapper function for inserting a node into a tree.
		bool remove(char*& name);//Wrapper for removing a node from the tree.
		bool retrieve(char*& copy_to);//Wrapper to retrieve the name of a game.
		bool display_all();//Wrapper to display all games from a tree.
//                void append();
		bool find_range(char*& range);//Wrapper to find a range of games.
		int  appending_for_ex_file(game*& games);//Wrapper for a function that is needed to append to the external data file.
		void get_size_of_tree(int& size);//copies the size of the tree into an int passed by reference.
	private:
		node* root;
		int number_of_nodes;//The number of nodes in the tree.
		bool rec_insert(node*& current,game& to_store);//A function that inserts a new node in the corrent place of a tree.
		bool rec_retrieve(char*& copy_to,node*& root);//A function that searches for a game and then brings it displays it if found.
		bool rec_display_all(node*& root);// Traverses in order to display all games in alphabetical order.
		bool rec_remove(node*& to_edit, char*& name, bool& match_found);//Removed a game from the tree.
//		bool rec_remove_retrieve(node*& root, char*& name, node*& found_node);//retrieves a match for a game for retrieving.
                void recursive_part_of_destructor(node* root);//Destructor for a tree via post order traversal.
		bool rec_range(char*& range, node*& root);//Displays all games within a range of letters.
		void rec_appending_for_ex_file(node*& root,game*& games,int& at);//Creates a game array through which the games can be stored in an external data file.
};
#endif
