/*
   Brandon Danielski
   2/24/17
   CS 202 
   Assignment 3
   This is the .cpp file for the tree and tree node classes.
 */
#include"tree.h"
#include<cstring>
#include<fstream>
#include<cmath>
#include<iostream>
using namespace std;


//////////////////////////////////////////////////////////////////////////TREE NODE FUNCTIONS//////////////////////////////////////////////////////////////////////
/*
   THIS IS A DEFAULT CONSTRUCTOR FOR THE TREE NODE CLASS.
INPUT: NONE
OUTPUT: NONE
 */
tree_node::tree_node()
{
	last_name = NULL;
	head = NULL;
	left = NULL;
	right = NULL;		
}



/*
THIS IS A COPY CONSTRUCTOR FOR THE TREE NODE CLASS.
INPUT: A TREE NOE POINTER BY REFERNCE.
OUTPUT: NONE
*/
tree_node::tree_node(tree_node*& to_copy)
{
	last_name = new char[100];
	strcpy(last_name,to_copy->last_name);
	right = to_copy->right;
	left = to_copy->left;
	head = new person_node(to_copy->head);//come back and change this to not new if this causes problems.
}

/*tree_node::tree_node(char*& to_add)
  {
  last_name = new char[100];
  strcpy(last_name,to_add);
  right = NULL;
  left = NULL;
  }*/

/*
   THIS IS A COPY CONSTRUCTOR FOR THE TREE CLASS NODE.
INPUT: A PERSON POINTER BY REFERENCE.
OUTPUT: NONE
 */
tree_node::tree_node(person_node*& new_person)
{
	last_name = new char[100];
	strcpy(last_name,new_person->get_last_name());
	head = new person_node(new_person);
//	head = new_person;
	left = NULL;
	right = NULL;	

}



/*
   THIS IS A DESTRUCTOR FOR THE TREE NODE CLASS.
INPUT: NONE
OUTPUT: NONE
 */
tree_node::~tree_node()
{
	person_node* temp = NULL;
	if(last_name)
	{
		delete[] last_name;
	}
	while(head)
	{
		temp = head;
		if(head)
		{
			delete head;
		}	
		temp = temp->next_node();
		head = temp;
	}
}


/*
  THIS FUNCTION WILL HAVE THE TREE GO LEFT AT THE CURRENT NODE.
INPUT: TREE NODE POINTER BY REFERENCE.
OUTPUT: A BOOL
 */
tree_node*& tree_node::go_left()
{
	return this->left;
}



/*
   THIS FUNCTION WILL HAVE THE TREE GO RIGHT AT THE CURRENT NODE.
INPUT: TREE NODE POINTER BY REFERENCE.
OUTPUT: NONE 
 */
tree_node*& tree_node::go_right()
{
	return this->right;
}



/*
   THIS FUNCTION WILL GET THE HEAD NODE FOR A LINEAR LINKED LIST OF A TREE NODE.
INPUT: NONE
OUTPUT: A PERSON NODE BY REFERENCE.
 */
/*person_node*& tree_node::get_head()
  {
  return head;
  }*/



/*
   THIS FUNCTON WILL GET THE LAST NAME CHAR POINTER IN A TREE NODE.
INPUT: NONE
OUTPUT: CHAR POINTER BY REFERENCE.
 */
char*& tree_node::get_last_name()
{
	return last_name;
}



/*
   THIS FUNCTION WILL ADD A PERSON NODE TO THE LINEAR LINKED LIST IN A TREE NODE.
INPUT: A PERSON NODE POINTER BY REFERENCE. 
OUTPUT: NONE
 */
/*void tree_node::add_to_list(person_node*& to_add)
  {
  person_node* temp = head;
  head = to_add;
  head->set_next(temp);
//	head->next = temp;
}*/

void tree_node::display() const
{
	cout<<"Last name: "<<last_name<<endl;
	person_node* temp = head;
	while(temp)
	{
		cout<<*temp<<endl;
		temp = temp->next_node();

	}
}



/*
THIS FUNCTION IS A WRAPPER THAT ADDS A PERSON NODE TO A TREE NODE LINKED LIST.
INPUT: A PERSON NODE POINTER BY REFERENCE.
OUTPUT: NONE
*/
void tree_node::add_to_list(person_node*& to_add)
{
	//in this function we can use relational operators to compare person nodes.
	//cout<<"Comparing "<<head->get_first_name()<<" and "<<to_add->get_first_name()<<endl;
	if(!head)
	{
		//cout<<"Head is NULL"<<endl;
		head= new person_node(to_add);
	}
//	else if(strcmp(head->get_first_name(),to_add->get_first_name())>=1)
	else if(head > to_add)
	{
		to_add->set_next(head);
		head = to_add;
	}
	else
	{
		//cout<<"Going to rec add to list."<<endl;
		rec_add_to_list(head->next_node(),to_add);
	}

}



/*
THIS FUNCTON ADDS ADDS A PERSON NODE TO A TREE NODE LINKED LIST.
INPUT: TWO PERSON NODE POINTERS BY REFERENCE.
OUTPUT: NONE
*/
void tree_node::rec_add_to_list(person_node*& current,person_node*& to_add)
{
	if(!current)
	{
//		cout<<"Addig to rear."<<endl;
		current = to_add;	
		return;
	}
//	cout<<"Comparing "<<current->get_first_name()<<" and "<<to_add->get_first_name()<<endl;
//	cout<<"Result is: "<<strcmp(current->get_first_name(),to_add->get_first_name())<<endl;
//	cin.get();
//	if(strcmp(current->get_first_name(),to_add->get_first_name())>=1)
	if( current < to_add)
	{
//		cout<<"Adding to middle."<<endl;
//		cin.get();
		to_add->set_next(current);
		//	to_add = current;		
		current = to_add;
		//cout<<"added"<<endl;
		return;
	}
	else
	{
//		cout<<"Going to next."<<endl;
		rec_add_to_list(current->next_node(),to_add);
//		rec_add_to_list(current+=current,to_add);
	}
}



/*
THIS FUNCTION RETURNS THE HEAD IN A TREE NODE.
INPUT: NONE
OUTPUT: A PERSON NODE POINTER BY REFERENCE.
*/	
person_node*& tree_node::get_head()
{
	return head;
}
//////////////////////////////////////////////////////////////////////////OVERLOADED OPERATOR FOR THE TREE NODE//////////////////////////////////////////////////////////////////////



/*
THIS IS AN OVERLOADED OPERATOR FOR THE TREE NODE CLASS.
INPUT: AN OSTREAM BY REFERENCE AND A TREE NODE BY REFERENCE.
OUTPUT: AN OSTREAM BY REFERENCE.
*/
ostream& operator<<(ostream& out,const  tree_node& tn)
{
	tn.display();
	return out;
}

//////////////////////////////////////////////////////////////////////////TREE FUNCTIONS//////////////////////////////////////////////////////////////////////


/*
   THIS IS THE DEFUALT CONSTUCTOR FOR THE TREE CLASS.
INPUT: NONE
OUTPUT: NONE
 */
tree::tree()
{
	root = NULL;
	number_of_nodes =0;
}



/*
   THIS IS THE DESTRUCTOR FOR THE TREE CLASS.
INPUT: NONE
OUTPUT: NONE
 */
tree::~tree()
{
	delete_tree(root);
	root = NULL;
}



/*
   THIS WILL DELETE AN ENTIRE TREE.
INPUT: TREE NODE POINTER BY REFERENCE.
OUTPUT; NONE
 */
void tree::delete_tree(tree_node*& current) 
{
	if(!current)
	{
		return;
	}
	delete_tree(current->go_left());
	delete_tree(current->go_right());
	delete current;
}





/*
   THIS IS A WRAPPER FOR INSERTING A NODE INTO A TREE.
INPUT: A PERSON BY REFERENCE.
OUTPUT: NONE
 */
void tree::insert(person*& to_add)
{
	/*	if(root)
		{
		cout<<"Root is currently: "<<endl;
		cout<<*root<<endl;
		cin.get();
		}*/
	if(to_add->is_valid() == true)
	{
		//cout<<*to_add<<endl;
		person_node* new_node = new person_node(to_add);//may need to add a delete for this.
//		cout<<"inserting: "<<endl;
//		cout<<*new_node<<endl;
//		cin.get();
		if(!root || number_of_nodes ==0)
		{
			root = new tree_node(new_node);	
//			cout<<"Root stored"<<endl;
//			cout<<*root<<endl;
			++number_of_nodes;
		}
		else
		{
//			cout<<"Going to rec insert."<<endl;
			rec_insert(root,new_node);
		}
		delete new_node;
	}
}



/*
   THIS FUNCTION WILL FIND INSERT A PERSON EITHER INTO A LIST IN AN EXISTING NODE OR MAKE A NEW NODE AND ADD MAKE THE PERSON HEAD.
INPUT: A TREE NODE POINTER BY REFERENCE, A PERSON NODE BY REFERENCE 
OUTPUT: NONE
 */
void tree::rec_insert(tree_node*& current, person_node*& to_add)
{
	if(!current)
	{
		current = new tree_node(to_add);
		++number_of_nodes;
		return;
	}
//	cout<<"Comparing: "<<to_add->get_last_name()<<"and "<<current->get_last_name()<<endl;
	//cin.get();
	if(strcmp(to_add->get_last_name(),current->get_last_name())==0)
	{
//		cout<<"Adding to list: "<<current->get_last_name();
//		cin.get();
		person_node* new_node = new person_node(to_add);
		current->add_to_list(new_node);
//		cout<<"Added to the list"<<endl;
		return;
	}
	if(strcmp(to_add->get_last_name(),current->get_last_name())>0)
	{
//		cout<<"Going right."<<endl;
		rec_insert(current->go_right(),to_add);
	}
	else
	{
//		cout<<"Going left."<<endl;
		rec_insert(current->go_left(),to_add);
	}
}



/*
THIS FUNCTION WILL DISPLAY THE CONTENTS OF A TREE.
INPUT: TREE NODE POINTER BY REFERENCE.
OUTPUT: NONE
*/
void tree::display(tree_node*& current) const
{
	if(!current)
	{
		if(!root)
		{
			cout<<"This tree is empty"<<endl;
		}
		return;
	}	
	display(current->go_left());
	cout<<*current<<endl;
	display(current->go_right());	
}



/*
THIS FUNCTION IS A WRAPPER TO SEARHC FOR A PERSON IN THE TREE.
INPUT: TWO CHAR POINTERS BY REFERENCE.
OUTPUT: NONE
*/
void tree::search(char*& first, char*& last)
{
	return rec_search(first,last,root,false);
}



/*
THIS FUNCTION SEARCHES FOR A NAME IN A TREE.
INPUT: TWO CHAR POINTER BY REFERENCE, A BOOL, AND A TREE NODE POINTER BY REFERENCE.
OUTPUT: NONE
*/
void  tree::rec_search(char*& first,char*& last, tree_node*& current, bool results)
{
	if(!current)
	{
	//	cout<<"No matches found"<<endl;
		return;
	}	
	rec_search(first,last,current->go_left(),results);	
	if(strcmp(last,current->get_last_name())==0)
	{
		person_node*& temp = current->get_head();
		while(temp)
		{
			if(strcmp(temp->get_first_name(),first)==0)
			{
				results = true;
				cout<<"Results found: "<<endl;
				cout<<*temp<<endl;
				cout<<"Pres any key to continue."<<endl;
				cin.get();
			}
			if(!temp->next_node()&& results == false)
			{
				cout<<"No results found."<<endl;
				cout<<"Press any key to continue."<<endl;
				cin.get();
			}
			temp = temp->next_node();
		}
		return;
	}
	rec_search(first,last,current->go_right(),results);	
}



/*
THIS FUNCTION WILL TAKE DATA FROM A DATA FILE AND ADD IT TO A TREE.
INPUT: A CHAR POINTER BY REFERENCE.
OUTPUT: NONE
*/
void tree::add_data_from_file_to_tree(char*& filename)
{
	char*first_name = new char[100];
	char*last_name = new char[100];
	char*type=new char[100];
	char* detail = new char[100];
	char* address = new char[100];
	char* username = new char[100];
	char* extra = new char[100];
	long phone_num =0;
	float freq = 0.0;
	int chan = 0;
	int size =1;
	int num_loaded = 0;
	person** people = new person*[size];
	people[0]=NULL;
	contact** contacts = new contact* [3];
	contacts[0]= NULL;
	contacts[1]= NULL;
	contacts[2]= NULL;
	ifstream datafile;

	datafile.open(filename);
	if(datafile.is_open())
	{
		while(!datafile.eof())
		{
			datafile.getline(first_name,100);
			datafile.getline(last_name,100);
			for(int i=0; i<3;i++)
			{
				datafile.getline(type,100);
				datafile.getline(detail,100);
				if(strcmp(type,(char*)"phone")==0)
				{
					datafile>>phone_num;
					datafile.clear();
					datafile.ignore();				
					contacts[i] = new phone(type,detail,phone_num);
				}
				else if(strcmp(type,(char*)"email")==0)
				{
					datafile.getline(address,100);	
					contacts[i] = new email(type,detail,address);
				}
				else if(strcmp(type,(char*)"radio")==0)
				{
					datafile>>freq;
					datafile.clear();
					datafile.ignore();	
					contacts[i] = new radio(type,detail,freq);
				}
				else if(strcmp(type,(char*)"social media")==0)
				{
					datafile.getline(username,100);	
					contacts[i] = new social_media(type,detail,username);
				}
				else if(strcmp(type,(char*)"tv")==0)
				{
					datafile>>chan;
					datafile.clear();
					datafile.ignore();
					contacts[i] = new tv(type,detail,chan);
				}
				else
				{
					datafile.getline(extra,100);
					contacts[i] = new contact(type,detail);
				}
			}
			if(strlen(first_name)!=0 &&strlen(last_name)!=0)
			{

				if(num_loaded ==size)
				{							
					person** new_people = new person*[size+1];
					for(int i=0; i<size;i++)
					{
						new_people[i] = new person(people[i]);		
						delete people[i];
					}
					delete[] people;
					people = new_people;
					people[size] = new person(first_name,last_name,contacts[0],contacts[1],contacts[2]);
			//		cout<<"Inserting: "<<endl<<*people[size];
			//		cin.get();
					++size;
				}
				else
				{

					people[size-1] = new person(first_name,last_name,contacts[0],contacts[1],contacts[2]);
			//		cout<<"Inserting: "<<endl<<*people[size-1];
			//		cin.get();
				}
				for(int i=0;i<3;i++)
				{
					if(contacts[i])
					{
						delete contacts[i];
						contacts[i] = NULL;
					}
				}	
				++num_loaded;
			}			
		}	
	}
	datafile.close();
	datafile.clear(ios_base::goodbit);	
	for(int i=0;i<size;i++)
	{
	//	cout<<"Storing in element: "<<i<<endl;
	//	cout<<*people[i]<<endl;
		insert(people[i]);
	//	cin.get();
	}
//	insert_algorithm(people,num_loaded);
//	cout<<"Done inserting"<<endl;
	delete[] first_name;
	delete[] last_name;
	delete[] type;
	delete[] detail;
	delete[] address;
	delete[] username;
	delete[] extra;
	for(int i=0;i<3;i++)
	{
		if(contacts[i])
		{
			delete contacts[i];
			contacts[i] = NULL;
		}
	}	
	for(int i=0; i< size;i++)
	{
		delete people[i];
	}
	delete[] people;
	delete[] contacts;


}



/*
THIS FUNCTION RETURNS THE ROOT OF A TREE.
INPUT: NONE
OUTPUT: A TREE NODE POINTER BY REFERENCE.
*/
tree_node*&  tree::get_root()
{
	return root;
}
//////////////////////////////////////////////////////////////////////////OVERLOADED OPERATORS FOR THE TREE CLASS//////////////////////////////////////////////////////////////////////
/*
THIS IS AN OVERLOADED OPERATOR FOR THE TREE CLASS.
INPUT: AN OSTREAM BY REFERENCE AND A TRE BY REFERENCE.
OUTPUT: AN STREAM BY REFERENCE.
*/
ostream& operator<<(ostream& out, tree& t)
{
	t.display(t.root);
	return out;
}
