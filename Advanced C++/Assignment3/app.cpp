/*
Brandon Danielski
2/24/2017
CS 202
Assignment 3
This is the .ccp for the app class of the program.
*/
#include "app.h"
#include <iostream>
using namespace std;



/*
This function will greet the user when the progam is started.
INPUT: NONE
OUTPUT: NONE
*/
void app::first_greeting()
{
	cout<<"Hello and welcome to the emergency braodcast contacting system."<<endl;
}



/*
This function is the main menu for the program, guiding the user through the program.
INPUT: A TREE PASSED BY REFERENCE
OUTPUT: NONE
*/
void app::main_menu(tree& main_tree)
{
	int user_input = 0;
	cout<<"Please choose from the following optons:"<<endl;
	cout<<"1. Display All Contacts "<<endl;
	cout<<"2. Add contact"<<endl;
	cout<<"3. Find Contact"<<endl;
	cout<<"4. Delete all contacts"<<endl;
	cout<<"5. Exit"<<endl;
	cin>>user_input;
	if(cin.fail()||user_input <0 || user_input >6)
	{
		cout<<"What you have entered is incorrect, please enter only a number corresponding to the options."<<endl;
		cin.clear();
		cin.ignore();
		return main_menu(main_tree);
	}
	if(user_input ==1)
	{
		cout<<main_tree<<endl;
		cout<<"Press any key to continue."<<endl;
		cin.get();
		return main_menu(main_tree);
	}
	else if(user_input ==2)
	{
		char* first = new char[100];
		char* last = new char[100];
		char* type = new char[100];
		char* detail = new char[100];
		contact** contacts = new contact*[3];
		contacts[0] = NULL;
		contacts[1] = NULL;
		contacts[2] = NULL;
		cout<<"What is the first name of the contact you would like to add?"<<endl;
		cin>>first;
		cout<<"What is the last name of the contact youw would like to add?"<<endl;
		cin>>last;
		for(int i=0; i<3;i++)
		{
			int user_input2 = 0;
			cout<<"What type of contact would you like to add for contact #"<<i+1<<" ?"<<endl;
			cout<<"1. Phone"<<endl;
			cout<<"2. Email"<<endl;
			cout<<"3. Radio"<<endl;
			cout<<"4. Social Media"<<endl;
			cout<<"5. Television"<<endl;
			cin >> user_input2;
			cin.clear();
			cin.ignore();
			if(cin.fail() || user_input2 > 5 || user_input2 < 1)
			{
				cout<<"What you have entered is incorrect, please enter a number between 1 and 5."<<endl;
				cout<<"Press any key to continue"<<endl;
				cin.clear();
				cin.ignore();
				--i;
			}	
			else if(user_input2 ==1)
			{
				long num =0;
				bool valid = false;
				type = (char*)"phone";	
				cout<<"What type of phone are you using?"<<endl;
				cin.getline(detail,100);
//				cout<<"You etered: "<<detail<<endl;
				while(valid == false)
				{
					cout<<"What is the phone number?"<<endl;
					cin.clear();
					cin.ignore();
					cin>>num;
					if(cin.fail())
					{
						cout<<"What you have entered if invalid, please enter only a phone number."<<endl;
						cin.clear();
						cin.ignore();
					}
					else
					{
						valid = true;
					}
				}
				contacts[i] = new phone(type,detail,num);	
				cin.clear();
				cin.ignore();
			}
			else if(user_input2 ==2)
			{
				type = (char*)"email";
				char* address = new char[100];
				cout<<"What is the purpose for this email address?"<<endl;
				cin.getline(detail,100);
				cout<<"What is the email address?"<<endl;
				cin.getline(address,100);
				contacts[i] = new email(type,detail,address);
				delete address;
			}
			else if(user_input2 ==3)
			{
				float freq =0.0;
				bool valid = false;
				type = (char*)"radio";
				cout<<"Is this FM or AM radio?"<<endl;
				cin.getline(detail,100);
				while(valid == false)
				{
					cout<<" What is the radio frequency?"<<endl;	
					cin>>freq;
					if(cin.fail())
					{
						cout<<"Please only enter a number."<<endl;
						cin.clear();
						cin.ignore();
					}
					else
					{
						valid = true;
					}
				}
				contacts[i] = new radio(type,detail,freq);
				
			}
			else if(user_input2 ==4)
			{
				type = (char*)"social media";
				char* name = new char[100];
				cout<<"Which webiste do you use?"<<endl;
				cin.getline(detail,100);
				cout<<"What is your username?"<<endl;
				cin.clear();
				cin.ignore();	
				cin.getline(name,100);
				contacts[i] = new social_media(type,detail,name);
				delete name;
				
			}
			else if(user_input2 ==5)
			{
				int chan = 0;
				bool valid = false;
				type = (char*)"tv";
				cout<<"What is the name of the tv channel?"<<endl;
				cin.getline(detail,100);
				while(valid == false)
				{
					cout<<"What is the channel number?"<<endl;
					cin >>chan;
					if(cin.fail())
					{
						cout<<"Please only enter a number."<<endl;
						cin.clear();
						cin.ignore();
					}
					else
					{
						valid = true;
					}

				}
				contacts[i] = new tv(type,detail,chan);
			}
			else
			{
				cout<<"What you have entered is incorrect"<<endl;
				--i;	
			}
			if(first && last && contacts[0] && contacts[1] && contacts[2])
			{
				person* new_p = new person(first,last,contacts[0],contacts[1],contacts[2]);
				main_tree.insert(new_p);
				cout<<* new_p<<endl;
				delete contacts[0];
				delete contacts[1];
				delete contacts[2];
				cout<<"This will be added to the contact tree, press any key to continue."<<endl;
				cin.get();
			}
		}
//		delete[] first;
//		delete[] last;
//		delete[] type;
//		delete[] detail;	
//		delete[] contacts;
		return main_menu(main_tree);
	}
	else if(user_input ==3)
	{
		if(!main_tree.get_root())
		{
			cout<<"This tree is empty."<<endl;
			return main_menu(main_tree);
		}
		char* first = new char[100];
		char* last = new char[100];
		cin.clear();
		cin.ignore();
		cout<<"DONT FORGET YOUR CAPITAL LETTERS!!!"<<endl; 
		cout<<"What is the first name you are searching for?"<<endl;
		cin.getline(first,100);
		cout<<"What is the last name you are searching for?"<<endl;
		cin.getline(last,100);
		main_tree.search(first,last);
		delete[] first;
		delete[] last;
		return main_menu(main_tree);
	}
	else if(user_input ==4)
	{
		if(main_tree.get_root())
		{
			main_tree.~tree();	
			cout<<"Tree has been deleted"<<endl;		
			cout<<"Press any key to continue."<<endl;
			cin.get();
		}
		else
		{
			cout<<"Tree is empty."<<endl;
			cout<<"Press any key to continue."<<endl;
			cin.get();
		}
		//main_tree.delete_tree(main_tree.get_root());
		return main_menu(main_tree);
	}
	else if(user_input ==5)
	{
		return;
	}
	else
	{
		cout<<"There was an error detecting your input, please try again."<<endl;
		cin.clear();
		cin.ignore();
		return main_menu(main_tree);
	}
}
