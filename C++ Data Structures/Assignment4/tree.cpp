/*
Brandon Danielski
11/24/2016
CS 163
Assignment 4
This file have all of the functions for my binary search tree.  It stores all nodes in an alphabetical order.
*/
#include "tree.h"
#include <iostream>
#include <cstring>
using namespace std;



/*
A constructor for a tree.
INPUT: NONE
OUTPUT: NONE
*/
tree::tree()
{
	root = NULL;
	number_of_nodes = 0;
}



/*
A wrapper function for a tree destructor.
INPUT: NONE
OUTPUT: NONE
*/
tree::~tree()
{
	recursive_part_of_destructor( root);
}



/*
A wrapper function to remove a node of a tree.
INPUT: A char array that has the name of a game the user is looking for.
OUTPUT: A bool to return success or failure.
*/
bool tree:: remove(char*& name)
{
	if(!name)
	{
		return false;
	}
	//        node* found_node = new node;
	bool match_found = false;
	//	cout<<"Rec remove retireve about to begin"<<endl;
	//	rec_remove_retrieve( root, name, found_node);
	//	cout<<"Rec remove about to begin"<<endl;
	rec_remove(root, name, match_found);
	/*	if(found_node)
		{
		delete[] found_node;
		}*/
	if(match_found == true)
	{
		--number_of_nodes;
	}
	return match_found;
}



/*
This function removes a node from a tree.  This deletes a node depending on if the nodes has no children, one child, or two children.
INPUT: A node that the function is currently comparing, a char array that is the name of the game the user is searching for, and a bool that becomes true if a match game is found.
OUTPUT: A bool to report success or failure. 
*/
bool tree:: rec_remove(node*& root,char*& name, bool& match_found)
{
	if(!root)
	{
		//		cout<<"about to return from remove"<<endl;
		return true;
	}
	rec_remove(root->left,name,match_found);
	rec_remove(root->right,name,match_found);	
	node* temp = NULL;
	node* temp2 = NULL;
	char* node_name = new char[2000];
	root->data.copy_name(node_name);
	//	cout<<"Comparing "<<name<<" and "<<node_name<<endl;
	if(strcmp(node_name,name)==0)
	{
		//	cout<<"Match found"<<endl;

		match_found = true;
		if(!root->right && !root->left)
		{
//			cout<<"Leaf deletion triggered"<<endl;
			delete root;
			root = NULL;
//			cout<<"Delete finished"<<endl;
		}
		else if(root->right && !root->left)
		{
	//		cout<<"Node with only right children deletion triggered"<<endl;
			temp = root->right;
			delete root;
			root = temp;
			/*	if(temp)
				{
				delete temp;
				}*/
		}	
		else if(!root->right && root->left)
		{
	//		cout<<"Node with only left children deletion triggered."<<endl;
			temp = root->left;
			delete root;
			root = temp;
		}
		else
		{
	//		cout<<"Two children deletion triggered."<<endl;
			temp = root->right;
			if(!temp->left)
			{
	//			cout<<"No direct IOS."<<endl;
				//			root->data = temp->data;
				root->data.copy(temp->data);
				root->right = temp->right;
				delete temp;
			}
			else
			{
				while(temp->left)
				{
					temp2 = temp;
					temp = temp->left;	
				}
	//			cout<<"IOS found."<<endl;
				root->data.copy(temp->data);
				temp2->left = temp->right;
				delete temp;
				//			cout<<"Deletion complete"<<endl;

			}
		}

			if(node_name)
			{
				delete[] node_name;
			}
			return true;
	}	
			
			if(node_name)
			{
				delete[] node_name;
			}
			return false;

}




/*bool tree:: rec_remove_retrieve(node*& root, char*& name, node*& found_node)
{
	if(!root)
	{
		if(!found_node)
		{
			return false;
		}	
		else
		{		
			return true;
		}
	}
	rec_remove_retrieve(root->left,name,found_node);
	char* root_name = new char[2000];
	root->data.copy_name(root_name);
//		cout<<"Comparing: "<<name<<" and "<<root_name<<endl;
	if(strcmp(name,root_name)==0)
	{
		found_node = root;
		cout<<name<<" was found."<<endl;
		if(root_name)
		{
			delete[] root_name;
		}
		return true;
	}
	if(root_name)
	{
		delete[] root_name;
	}
	rec_remove_retrieve(root->right,name, found_node);
}*/



/*
This is a function that is a wrapper for inserting a node into the tree.
INPUT: A game to store.
OUTPUT: a bool to return success or failure.
*/
bool tree:: insert(game& to_store)
{
	return rec_insert(root,to_store);
}




/*
This function is called recursively called until a proper place is found for the node being entered.
INPUT: The current node for traversal and the game that is going to be stored.
OUTPUT: A bool to report success or failure.
*/
bool tree::rec_insert(node*& current,game& to_store)
{
	if(!current)
	{
		//		cout<<"adding node"<<endl;
		node* new_node = new node();
		++number_of_nodes;
		//		new_node->data = to_store;
		//                to_store.copy(new_node->data);
		new_node->data.copy(to_store);
		new_node->left = NULL;
		new_node->right = NULL;
		current = new_node;
//		new_node->data.display_game();
		return true;
	}

	char* root_name = new char[2000];
	char* add_name = new char[2000];
	//	char* temp_root = new char[2000];
	//	char* temp_add = new char[2000];
	//	int loop = 0;
	//	int at = 0;
	//	for(int i =0; i < 2000;i++)
	//	{
	//		*(root_name+i)=0;
	//		*(add_name+i)=0;
	//	}
	//	root->data.display_game();
	to_store.copy_name(add_name);
	current->data.copy_name(root_name);
	//	cout<<"About to compare: "<<root_name<<" and "<<add_name<<endl;

	if(strcmp(add_name,root_name)<0)
	{
//				cout<<"traversing left"<<endl;
		if(root_name)
		{
			delete[] root_name;
		}
		if(add_name)
		{
			delete[] add_name;
		}
		rec_insert(current->left,to_store);           
	}
	else
	{
		if(root_name)
		{
			delete[] root_name;
		}
		if(add_name)
		{
			delete[] add_name;
		}
//				cout<<"traversing right"<<endl;
		rec_insert(current->right,to_store); 
	}
	return true;
}




/*
A wrapper function to display all games in the tree.
INPUT: NONE
OUTPUT: A bool to report success or failure.
*/
bool tree:: display_all()
{
	return rec_display_all(root);
}




/*
This function displays all games recursively using in order traversal so all games are displayed in alphabetical order.
INPUT: The current node the function is on.
OUTPUT: A bool to return success or failure.
*/
bool tree:: rec_display_all(node*& root)
{
	if(!root)
	{
		return true;
	}
	rec_display_all(root->left);
	root->data.display_game();
	rec_display_all(root->right);
}



/*
A function that is a wrapper function to retrieve a game inputted by the user.
INPUT: The name of the game the user is looking for.
OUTPUT: a bool to report success or failure.
*/
bool tree::retrieve(char*& copy_to)
{
	return rec_retrieve(copy_to, root);
}

bool tree::rec_retrieve(char*& copy_to, node*& root)
{
	if(!root)
	{
		return false;
	}
	char* node_game_name = new char[2000];
	root->data.copy_name(node_game_name);
	if( strcmp(node_game_name,copy_to) ==0)
	{
		root->data.display_game();
		if(node_game_name)
		{
			delete[] node_game_name;
		}
		return true;
	}
	if(node_game_name)
	{
		delete[] node_game_name;
	}
	rec_retrieve(copy_to,root->left);
	rec_retrieve(copy_to,root->right);
}



/*
A function that takes a tree apart using post order traversal.
INPUT: The node the tree is on.
OUTPUT: NONE
*/
void tree::recursive_part_of_destructor(node* root)
{
	if(!root)
	{		
		return;
	}

	recursive_part_of_destructor(root->left);
	recursive_part_of_destructor(root->right);
	if(root)
	{
//		root->data.display_game();
//		cin.get();
		delete root;
	}
}



/*
A wrapper function to find a range of games.
INPUT: a char array with the range of letters to display.
OUTPUT: A bool to report success or failure.
*/
bool tree::find_range(char*& range)
{
	return rec_range(range, root);
}



/*
A function that will display a range of letters.
INPUT: a char array with the range of letters and the current node in the traversal.
OUTPUT: A bool to report success o failure.
*/
bool tree::rec_range(char*& range, node*& root)
{
	if(!root)
	{
		return true;
	}

	if((int(*(range)))==0 || (int(*(range+1)))==0)
	{
		return false;
	}
	char begin = *(range);
	char end =*(range+1);

	rec_range(range,root->left);
	char* game = new char[2000];	
	root->data.copy_name(game);
	if((int(*(game)))>=begin && (int(*(game)))<=end)
	{
		root->data.display_game();
	}
	if(game)
	{
		delete[] game;
	}
	rec_range(range,root->right);
}



/*
This is a wrapper function that will populate an array of games to write to the external data file.
INPUT: An empty array of games.
OUTPUT: An integer that is the size of the list.
*/
int tree::appending_for_ex_file(game*& games)
{
	int at =0;
	/*	node* temp =NULL;
		temp = root;
		while(temp->left)
		{
		temp=temp->left;
		}*/	
	//	temp->data.display_game();
	rec_appending_for_ex_file(root, games, at);
	return at;
}



/*
This function is a recursive function that will populate a passed in array of games for the external data file.
INPUT: The current node being copied, an array of games, and the curret number of games put into the list.
OUTPU: NONE
*/
void tree::rec_appending_for_ex_file(node*& root, game*& games,int& at)
{
	if(!root)
	{
		return;
	}
	rec_appending_for_ex_file(root->left, games,at);
	//	cout<<"About to store: "<<endl;
	//	root->data.display_game();
	//	cout<<"at: "<<at<<endl;

	games[at].copy(root->data);
	++at;
	rec_appending_for_ex_file(root->right, games,at);
}




/*
This function copies the number of nodes in the tree to a passed in integer type.
INPUT: An integer for the size of the tree to copy to.
OUTPUT: NONE
*/
void tree::get_size_of_tree(int& size)
{
	size = number_of_nodes;
}
