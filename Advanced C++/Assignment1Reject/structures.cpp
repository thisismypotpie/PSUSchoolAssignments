/*
Brandon Danielski
CS202
1/16/2017
Assignment One
This is the .cpp file for the misc. structures essential to the program.
*/
#include"structures.h"
#include<fstream>
#include<cstring>
#include<iostream>
using namespace std;



/*
This function will take the data from the data files and load them into the graph, loading up all trains and stops involved in the each loop or line.
INPUT: The names of the line and streetcar files.
OUTPUT: NONE 
*/
void graph::load_line_files(char* line_file_name, char* streetcar_file_name)
{
char* stop_name = new char[2000];
char* line_name = new char[2000];
char* direction = new char[2000];
char* online_line = new char[2000];
int ID = 0;
int stop_num = 0;
bool online = false;
ifstream datafile;
datafile.open(line_file_name);
if(datafile.is_open())
{
	datafile.getline(line_name,2000);
	cout<<"line name is now: "<<line_name<<endl;
	while(!datafile.eof())
	{
		datafile >> stop_num;
		cout<<"stop_num is now: "<< stop_num<<endl;
		datafile.ignore();
		datafile.getline(stop_name,2000);
		cout<<"stop name is now: "<<stop_name<<endl;
		datafile.getline(direction,2000);
		cout<<"Direction is now: "<<direction<<endl;
		datafile >> ID;
		cout<<"ID is now: "<< ID;
		cin.get();			
	}
}
datafile.close();
datafile.clear(ios_base::goodbit);
datafile.open(streetcar_file_name);
if(datafile.is_open())
{
	while(!datafile.eof())
	{
		datafile.getline(line_name,2000);
		cout <<"This train is named: "<<line_name<<endl;
		datafile >> ID;
		datafile.ignore();
		cout<<"ID is: "<<ID<<endl;
		datafile.getline(online_line,2000);
		cout<<"Online line is now: "<< online_line<<endl; 	
		if(strcmp(online_line,"online")==0)
		{
			online = true;
		}		
		else
		{
			online = false;
		}
		cout<<"online is now: "<<online<<endl;
		cin.get();
	}
}
if(stop_name)
{
	delete[] stop_name;
}
if(line_name)
{
	delete[] line_name;
}
if(direction)
{
	delete[] direction;
}
if(online_line)
{
	delete[] online_line;
}

//after each stop is created strcopy is into each node in the graph.
}
