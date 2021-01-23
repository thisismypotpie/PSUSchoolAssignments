/*
   Brandon Danielski
   11/16/2016
   CS 163
   Assignment 4
   This is the main function for the program.  It controls all sequences that happen in the program.

 */
#include"game.h"
#include"ex_file.h"
#include"tree.h"
#include"app.h"
#include<iostream>
using namespace std;

int main()
{
	//bool function_verify;
	int user_choice =-1;
	char* name = new char[2000];
	game gamer;
	tree the_tree;
	ex_file opener;
	app the_app;
/*		  game game1("STARWARSGALAXYATWAR","DESC FOR GAME 1","REAL TIME STRATEGY","PC","5 of 5 stars","rec for game 1");
		  game game2("BIOSHOCK","desc for game 2","first person shooter","XBOX,PC", "4 of 5 stars","rec for game 2");
		  game game3("MINECRAFT","desc for game 3","sand box game","PC","5 of 5 stars","rec for game 3");
		  game game4("DEUSEX","","","","","");
		  game game5("WORLDOFWARCRAFT","","","","","");
		  game game6("BIOSHOCK2","","","","","");
		  game game7("STARCRAFT","","","","","");
		  game game8("CASTLECRASHER","","","","","");
		  game game9("DOTA2","","","","","");
		  game game0("FALLOUT4","","","","","");
		  game game10("ZOOLANDERTHEGAME","","","","","");
		  game game11("YESMANGAME","","","","","");
		game*games = new game[12];
		games[0]=game2;
		games[1]=game6;
		games[2]=game8;
		games[3]=game4;
		games[4]=game9;
		games[5]=game0;
		games[6]=game3;
		games[7]=game7;
		games[8]=game1;
		games[9]=game5;
		games[10]=game11;
		games[11]=game10;
			opener.insert_algorithm(games,12,the_tree);*/
/*		  the_tree.insert(game1);
		  the_tree.insert(game2);
		  the_tree.insert(game3);
		  the_tree.insert(game4);
		  the_tree.insert(game5);
		  the_tree.insert(game6);
		  the_tree.insert(game7);
		  the_tree.insert(game8);
		  the_tree.insert(game9);
		  the_tree.insert(game0);
		  the_tree.insert(game1);
		  the_tree.insert(game10);
		  the_tree.insert(game11);*/
	opener.load(the_tree);
	the_app.first_greeting();
	while(user_choice = -1)
	{
		user_choice=the_app.main_menu();
		//cout<<"User choice is: "<<user_choice<<endl;
		if(user_choice == 1)//add a game
		{
			if(the_app.add_game(the_tree)== true)
			{
				the_app.game_found();	
			}
			else
			{
				the_app.add_game_error();
			}
		}
		else if(user_choice == 2)//remove a game
		{
			if(the_app.remove_game(the_tree)==true)
			{
				the_app.game_removed();
			}	
			else
			{
				the_app.remove_game_error();
			}
		}
		else if(user_choice ==3)//search for a game
		{
			if(the_app.name_input_for_search(name)==false)
			{
				the_app.enter_name_error();
			}
			else
			{
				if(the_tree.retrieve(name)==false)
				{
					the_app.table_retrieve_error();
				}
			}
		}

		else if(user_choice ==4)//view all games
		{
			if(the_tree.display_all()==false)
			{
				the_app.table_display_all_error();
			}
		}
		else if(user_choice ==5)//view range of games
		{
			if(the_app.search_by_range(name)==false)
			{
				the_app.range_error();	
			}
			else
			{
				if(the_tree.find_range(name)==false)
				{
					the_app.range_error();
				}
			}	
		}
		else if(user_choice ==6)//exit
		{
			opener.append(the_tree);
			if(name)
			{
				delete[] name;
			}
			return 0;
		}
		else
		{
			the_app.misc_error();
			cin.clear();
		}
		user_choice = -1;
	}
}
