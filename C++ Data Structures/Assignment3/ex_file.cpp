/*
Brndon Danielski
11/3/2016
CS 163
Assignment 3
This cpp file has two function the both read and write to an exernal data file for keepinig of games to be stored in the hash table.
*/
#include<fstream>
#include"ex_file.h"
#include"game.h"
#include<iostream>
#include<cstring>
#include<cctype>
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
bool ex_file::load(table& to_copy)
{
ifstream datafile;
int num_loaded = 0;
char* game_name = new char[2000];
char* description = new char[2000];
char* game_type = new char[2000];
char* platform = new char[2000];
char* stars =new char[2000];;
char* rec = new char[2000]; 
datafile.open("games_data.txt");
if(datafile.is_open())
{
while(!datafile.eof())
{
//cout<<"Starting loop"<<endl;
datafile.getline(game_name,2000);
if(*(game_name + strlen(game_name)-1)==13)
{
*(game_name + strlen(game_name)-1)=0;
}
for(int i=0;i<strlen(game_name);i++)
{
  *(game_name+i)=tolower(*(game_name+i));
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
//load for table.
if(strlen(game_name)!=0)
{
to_copy.insert(new_game);
num_loaded++;
}
//new_game.display_game();
//cin.clear();
}
}
cout<<num_loaded<<" items loaded"<<endl;
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
}



/*
This function writes to the data file and overwrites the file whenever the user exits the program.
INPUT: a table used to append to the data file.
OUTPUT: a bool to report success or failure.
*/
bool ex_file::append(table& to_copy)
{
ofstream datafile;
node* temp = NULL;
char* name = new char[2000];
char* desc = new char[2000];
char* type = new char[2000];
char* plat = new char[2000];
char* star = new char[2000];
char* recc = new char[2000];
datafile.open("games_data.txt");
if(datafile.is_open())
{
for(int i=0; i<to_copy.list_size();i++)
{ 
 to_copy.retrieve_for_ex_file(temp,i);
 if(temp)
 {
 //  cout<<i<<" exists"<<endl;
   
   while(temp)
   {
//    cout<<"Loop start"<<endl;
    temp->data.get_data(name,desc,type,plat,star,recc);
    datafile<<name<<endl;
    datafile<<desc<<endl;
    datafile<<type<<endl;
    datafile<<plat<<endl;
    datafile<<star<<endl;
    datafile<<recc<<endl;
    temp = temp->next;
   }
 }
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
return true;
}
else
{
return false;
}
}
