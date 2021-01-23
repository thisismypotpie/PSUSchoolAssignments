#include"game.h"
//#include"linked_list.h"
#include"ex_file.h"
#include"table.h"
#include"app.h"
#include<iostream>
using namespace std;

int main()
{
	//bool function_verify;
	int user_choice =-1;
	char* name = new char[2000];
	game gamer;
	table the_table;
	ex_file opener;
	app the_app;

	opener.load(the_table);
	the_app.first_greeting();
	while(user_choice = -1)
	{
		user_choice=the_app.main_menu();
		//cout<<"User choice is: "<<user_choice<<endl;
		if(user_choice == 1)//add a game
		{
			if(the_app.add_game(the_table)==false)
			{
				the_app.add_game_error();
			} 
			opener.append(the_table);
		}
		else if(user_choice == 2)//remove a game
		{
			if(the_app.remove_game(the_table)==false)
			{
				the_app.remove_game_error();
			}
		}
		else if(user_choice ==3)//search for a game
		{
			the_app.name_input_for_search(name);
			//function_verify=the_table.retrieve(gamer,name);
			if(the_table.retrieve(gamer,name) == false)
			{
				the_app.table_retrieve_error();
			}
		}

		else if(user_choice ==4)//view all games
		{
			//function_verify =the_table.display_all(0);
			if(the_table.display_all(0)== false)
			{
				the_app.table_display_all_error();
			}

		}
		else if(user_choice ==5)//view games by platform
		{
			if(the_app.search_by_platform(the_table)==false)
			{
				the_app.platform_search_error();
			}
		}
		else if(user_choice ==6)//exit
		{
			opener.append(the_table);
			if(name)
			{
				delete[] name;
			}
			return 0;
		}
		else
		{
			the_app.misc_error();
		}
		user_choice = -1;
	}
}
