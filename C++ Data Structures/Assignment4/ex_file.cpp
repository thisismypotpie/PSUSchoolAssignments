/*:
   Brndon Danielski
   11/16/2016
   CS 163
   Assignment 4
   This cpp file has two function the both read and write to an exernal data file for keepinig of games to be stored in the hash table.
 */
#include<fstream>
#include"ex_file.h"
#include"game.h"
#include<iostream>
#include<cstring>
#include<cctype>
#include<cmath>
using namespace std;

/*
   This it the default constructor for the ex_file piece of the program.
INPUT: NONE
OUTPUT: NONE
 */
/*ex_file::ex_file()
  {

  }*/


/*
   This is the destuctor for the ex_file.
INPUT: NONE
OUTPUT: NONE
 */
/*ex_file::~ex_file()
  {

  }*/



/*
   This function loads the data from the external text file and then puts what was found into the hash table.
INPUT: A hash table with which to copy.
OUTPUT: a bool to report success or failure.
 */
bool ex_file::load(tree& to_copy)
{
	ifstream datafile;
	char* game_name = new char[2000];
	char* description = new char[2000];
	char* game_type = new char[2000];
	char* platform = new char[2000];
	char* stars =new char[2000];
	char* rec = new char[2000]; 
	int num_loaded = 0;
	int size = 1;
	game* games = new game[size]; 
	datafile.open("games_data.txt");
	if(datafile.is_open())
	{
		while(!datafile.eof())
		{
			//cout<<"Starting loop"<<endl;
			datafile.getline(game_name,2000);
			/*	if(*(game_name + strlen(game_name)-1)==13)
				{
			 *(game_name + strlen(game_name)-1)=0;
			 }*/
			for(int i=0;i<strlen(game_name);i++)
			{
				*(game_name+i)=toupper(*(game_name+i));
			}
			//cout<<game_name<<endl;
			//cin.clear();
			datafile.getline(description,2000);
			//cin.clear();
			datafile.getline(game_type,2000);
			//cin.clear();
			datafile.getline(platform,2000);
			for(int i=0;i<strlen(platform);i++)
			{
				*(platform+i)=toupper(*(platform + i));
			}
			//cin.clear();
			datafile.getline(stars,2000);
			//cout<<"Stars: "<<stars<<endl;
			//cin.clear();
			datafile.getline(rec,2000);
			game new_game(game_name,description,game_type,platform,stars,rec);
			//new_game.display_game();
			//load for table.
			if(strlen(game_name)!=0)
			{
				if(num_loaded == size)
				{
//					cout<<" larger array creation triggered."<<endl;
					game* new_games = new game[size+50];
					for(int i=0;i<size;i++)
					{
						new_games[i].copy(games[i]);	
					}	
					if(games)
					{	
//						cout<<"Deleting games"<<endl;
						delete[] games;
					}
					games = new_games;
					size=+ 50;
				}
				games[num_loaded].copy(new_game);
				++num_loaded;
				/*				cout<<"Inserting: "<<game_name<<endl;
											
								to_copy.insert(new_game); 
								num_loaded++;*/

			}
			//new_game.display_game();
			//cin.clear();
		}
	}
/*	for(int i=0;i<num_loaded;i++)
	{
		to_copy.insert(*(games+i));
	}*/
	insert_algorithm(games,num_loaded,to_copy);
	cout<<num_loaded<<" games loaded"<<endl;
	datafile.close();
	datafile.clear(ios_base::goodbit);
	if(game_name)
	{
		delete[] game_name;
		game_name=NULL;
	}
	if(description)
	{
		delete[] description;
		description=NULL;
	}
	if(game_type)
	{
		delete[]game_type;
		game_type;
	}
	if(platform)
	{
		delete[] platform;
		platform=NULL;
	}
	if(stars)
	{
		delete[] stars;
		stars=NULL;
	}
	if(rec)
	{
		delete[] rec;
		rec=NULL;
	}
	if(games)
	{
		delete[] games;
	}
}



/*
   This function writes to the data file and overwrites the file whenever the user exits the program.
INPUT: a table used to append to the data file.
OUTPUT: a bool to report success or failure.
 */
bool ex_file::append(tree& to_copy)
{
	ofstream datafile;
	node* temp = NULL;
	int num_of_nodes = 0;
	char* name = new char[2000];
	char* desc = new char[2000];
	char* type = new char[2000];
	char* plat = new char[2000];
	char* star = new char[2000];
	char* recc = new char[2000];
	int size =0;
	to_copy.get_size_of_tree(num_of_nodes);
//	cout<<"Numbe of nodes for append: "<<num_of_nodes<<endl;
	game* games = new game[num_of_nodes];
	datafile.open("games_data.txt");
	if(datafile.is_open())
	{		
		to_copy.appending_for_ex_file(games);
		for(int i=0;i<num_of_nodes;i++)
		{
			games[i].get_data(name,desc,type,plat,star,recc);
			datafile<<name<<endl;
			datafile<<desc<<endl;
			datafile<<type<<endl;
			datafile<<plat<<endl;
			datafile<<star<<endl;	
			datafile<<recc<<endl;
		}
		datafile.close();
		datafile.clear(ios_base::goodbit);

		if(name)
		{
			delete[] name;
		}
		if(desc)
		{
			delete[] desc;
		}
		if(type)
		{
			delete[] type;
		}
		if(plat)
		{
			delete[] plat;
		}
		if(star)
		{
			delete[] star;
		}
		if(recc)
		{
			delete[] recc;
		}
		if(games)
		{
			delete[] games;//check where game is getting populated to make sure you are deleting correctly.
		}
		return true;
	}
	else
	{
		return false;
	}
}




/*
This function will prepare the rogram for an insert algorithm that is executed recursively.
INPUT: An array of games, an integet that is the ammount of games added to the game array, and a tree to insert the game array to.
OUTPUT: NONE 
*/
void ex_file::insert_algorithm(game*& games, int num_of_games,tree& to_copy)
{	
	//	int* storage_order = new int[num_of_games];
	bool* has_been_stored = new bool[num_of_games];	
	int*  index_numbers = new int [1];//This will bring the numbers from the previous level to insert later
	int halfer = num_of_games;
	int level =0;
	for(int i =0; i<num_of_games;i++)
	{
		*(has_been_stored+i)=false;
		//		*(storage_order+i)=0;		
	}
	if(halfer%2==1)
	{
		halfer = (halfer+1)/2;
	}
	else
	{
		halfer = halfer/2;
	}
//	cout<<"About to go into rec_insert_algorithm with halfer being: "<<halfer<<endl;
	rec_insert_algorithm(level,halfer,games,has_been_stored,index_numbers,to_copy,num_of_games);
	if(has_been_stored)
	{
		delete[] has_been_stored;
	}
	if(index_numbers)
	{
//		delete[]index_numbers;
	}
}





/*
This function is a recursiviely called function that inserts an array of games.  This algorithm is meant for a sorted list.  It inserts the half size of the game array and inserts that position an then call the half of the half and add that half to the original half size so the 1/4 size and 3/4 size get inserted.  It then calls recursively the function until the a full level cannot be completed.  In the last call, all of the games that were not inserted are inserted.
INPUT: The current level being added, the current half of the list that is being inserted, an array of games, a bool array that lets the program know if an element has or has not been inserted, an int array that holds the inserted element numbers of the last level, a tree to insert to, and the number of games in the game array.
OUTPUT: NONE
*/
void ex_file::rec_insert_algorithm(int level, int halfer,game*& games,bool*& has_been_stored,int* index_numbers,tree& to_copy,int num_of_games)
{
	if(halfer ==2)
	{
//		cout<<"Halfer is now two"<<endl;
		
		for(int i=0;i<num_of_games-1;i++)
		{
			if(*(has_been_stored+i)==false)
			{
//				cout<<"Storing at: "<<i<<endl;cin.get();
				to_copy.insert(*(games+i));
				has_been_stored[i]= true;
			}
		}
		if(index_numbers)
		{
			delete[] index_numbers;//added a new delete.
		}
		return;
	}
//	cout<<"New loop, halfer is now: "<<halfer<<endl;
//	cout<<"Now at level: "<<level<<endl;
	int number_of_nodes_on_this_level =pow(2,level);//make index numbers this big.
	int last_level_numbers_size =pow(2,(level-1));//make last level numbers this big.
	int last_level_numbers[last_level_numbers_size];
	int nodes_inserted_on_this_level = 0;
//	cout<< "Last_level_number is now size :"<<last_level_numbers_size<<endl;
//	cout<< "Number of nodes on this level will be: "<<number_of_nodes_on_this_level<<endl;cin.get();
	
	if(level==0)
	{
//		cout<<"Level is zero, root will be here"<<endl;
//		cout<<"Inserting number: "<< halfer <<endl;cin.get();
		
		to_copy.insert(*(games+halfer-1));
		*(has_been_stored+halfer-1)=true;
		index_numbers[0]=halfer;
	}
	else
	{
		for(int i=0;i<last_level_numbers_size;i++)
		{
//			cout<<index_numbers[i]<<" is being stored in last_level_numbers index :"<<i<<endl;cin.get();
			
			last_level_numbers[i]=index_numbers[i];//stores all of the numbers from the last level into a temporary array. This will be used to make new numbers for the next level.
		}	
		int* new_index = new int[number_of_nodes_on_this_level];
		if(index_numbers)
		{
		//	cout<<"Deleting index numbers"<<endl;
			delete[] index_numbers;
		}	
		index_numbers = new_index;//This makes sure that index number is as large as the number of nodes on the current level.
		for(int i =0;i<last_level_numbers_size;i++)//does an insert once.  Odds will be adding to the halfer and evens will be subracting from the halfer.
		{
		//	cout<<last_level_numbers[i]+halfer<<" will be stored"<<endl;
		//	cout<<last_level_numbers[i]-halfer<<" will be stored"<<endl;cin.get();
			
			if(last_level_numbers[i]+halfer > num_of_games-1&& has_been_stored[num_of_games-1]==false)
			{
		//		cout<<"Overflow about to be handled"<<endl;	
				
				to_copy.insert(games[num_of_games-1]);
				has_been_stored[num_of_games-1]= true;
		//		cout<<"1. "<<num_of_games-1<<" about to be stored at "<<i+nodes_inserted_on_this_level<<endl;cin.get();
				index_numbers[i+nodes_inserted_on_this_level]=num_of_games-1;
//				++nodes_inserted_on_this_level;
			}
			else
			{
				if(has_been_stored[last_level_numbers[i]+halfer-1]==false)
				{
		//			cout<<"Storing: "<<last_level_numbers[i]+halfer<<". Index array "<<last_level_numbers[i]+halfer-1;
					
					to_copy.insert(games[last_level_numbers[i]+halfer-1]);	
					has_been_stored[last_level_numbers[i]+halfer-1]=true;
		//			cout<<"2. "<<last_level_numbers[i]+halfer<<" about to be stored at "<<i+nodes_inserted_on_this_level<<endl;cin.get();
					index_numbers[i+nodes_inserted_on_this_level]=last_level_numbers[i]+halfer;
//					++nodes_inserted_on_this_level;
				}
		/*		else
				{
					cout<<"Node skipped, already added"<<endl;
				}*/
			}
			++nodes_inserted_on_this_level;
			if(last_level_numbers[i]-halfer <= 0 && has_been_stored[0]==false)
			{
//				cout<<"Underflow about to be handled"<<endl;
						
				to_copy.insert(games[0]);
				has_been_stored[0]=true;
//				cout<<" 3. " <<" about to be stored at "<<i+nodes_inserted_on_this_level<<endl;cin.get();
				index_numbers[i+nodes_inserted_on_this_level]=1;
//				++nodes_inserted_on_this_level;
			}
			else
			{
				if(has_been_stored[last_level_numbers[i]-halfer-1]==false)
				{
//					cout<<"Storing: "<<last_level_numbers[i]-halfer<<". Index array "<<last_level_numbers[i]-halfer-1;
					
					to_copy.insert(games[last_level_numbers[i]-halfer-1]);
					has_been_stored[last_level_numbers[i]-halfer-1]=true;
//					cout<<"4. "<<last_level_numbers[i]-halfer<<" about to be stored at "<<i+nodes_inserted_on_this_level<<endl;cin.get();
					index_numbers[i+nodes_inserted_on_this_level]=last_level_numbers[i]-halfer;
//					++nodes_inserted_on_this_level;
				}
			/*	else
				{		
					cout<<"Node skipped, already added"<<endl;
				}*/
			}
		}
	}
	if(halfer%2==1)
	{
		halfer = (halfer+1)/2;
	}
	else
	{
		halfer = halfer/2;
	}
	rec_insert_algorithm(++level,halfer,games,has_been_stored,index_numbers,to_copy,num_of_games);

}
