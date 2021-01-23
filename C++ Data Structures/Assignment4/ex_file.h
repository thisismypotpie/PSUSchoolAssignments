/*
   Brandon Danielski
   11/3/2016
   CS 163
   Assignment 3
   This is the external .h file for my program.  It allows for the program to take data from an external data file and puts it into data in the format of the game ADT.
 */
#ifndef EX_FILE_H
#define EX_FILE_H
#include"tree.h"
class ex_file
{
	public:
		//ex_file();
		//~ex_file();
		bool load(tree& to_copy);//a function that loads information from the external data file to a hash table.
		bool append(tree& to_copy);//a function that saves changes to the data file.
		void insert_algorithm(game*& games,int num_of_games,tree& to_copy); //a wrapper function for the insert algorithm.		
	private:
		void rec_insert_algorithm(int level, int halfer,game*& games,bool*& has_been_stored,int* index_numbers,tree& to_copy,int num_of_games);// a recursive function that inserts an ordered list.

};
#endif
