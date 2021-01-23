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
using namespace std;



/*
   THIS IS A DEFAULT CONSTRUCTOR FOR THE TREE NODE CLASS.
INPUT: NONE
OUTPUT: NONE
 */
tree_node::tree_node()
{
	last_name = new char[100];
	strcpy(last_name,(char*)"");
	head = NULL;
	left = NULL;
	right = NULL;		
}



/*
   THIS IS A NON DEFUALT CONTRUCTOR FOR HE TREE NODE CLASS.
INPUT: A CHAR POINTER BY REFERENCE.
OUTPUT: NONE
 */
tree_node::tree_node(char*& last)
{
	last_name = new char[100];
	head=NULL;
	left=NULL;
	right=NULL;
	strcpy(last_name, last);
}



tree_node::tree_node(tree_node*& to_copy)
{
	last_name = new char[100];
	to_copy->get_last_name(last_name);
	if(to_copy->head)
	{
		head =	new person_node(to_copy->head); 
	}
	else
	{
		head = NULL;
	}
	if(to_copy->left)
	{
		left =  new tree_node(to_copy->left);
	}
	else
	{
		left = NULL;
	}
	if(to_copy->right)
	{
		right = new tree_node(to_copy->right); 
	}	
	else
	{
		right = NULL;
	}
/*	head = NULL;
	left = NULL;
	right= NULL;*/
}

/*
   THIS IS A COPY CONSTRUCTOR FOR THE TREE CLASS NODE.
INPUT: A PERSON POINTER BY REFERENCE.
OUTPUT: NONE
 */
tree_node::tree_node(person_node*& new_person)
{
	last_name = new char[100];
	new_person->get_last_name(last_name);
	head = new_person;
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
		delete head;
		temp = temp->next_node();
		head = temp;
	}
}



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
INPUT: A TRRE NODE POINTER BY REFERENCE.
OUTPUT: NONE
 */
void tree_node::get_head(person_node*& to_head)
{
	to_head = head;
}



/*
   THIS FUNCTON WILL GET THE LAST NAME CHAR POINTER IN A TREE NODE.
INPUT: CHAR POINTER BY REFERENCE.
OUTPUT: NONE
 */
void tree_node::get_last_name(char*& to_copy)
{
	to_copy = last_name;
}



/*
   THIS FUNCTION WILL ADD A PERSON NODE TO THE LINEAR LINKED LIST IN A TREE NODE.
INPUT: A PERSON NODE POINTER BY REFERENCE. 
OUTPUT: NONE
 */
void tree_node::add_to_list(person_node*& to_add)
{
	person_node* temp = head;
	head = to_add;
	head->set_next(temp);
	//	head->next = temp;
}



/*
   THIS WILL DELETE AN ENTIRE TREE.
INPUT: TREE NODE POINTER BY REFERENCE.
OUTPUT; NONE
 */
void tree::delete_tree(tree_node*& root) 
{
	if(!root)
	{
		return;
	}
	delete_tree(root->go_left());
	delete_tree(root->go_right());
	delete root;
	root=NULL;
}



/*
   THIS FUNCTION WILL ADD ALL DATA FROM AN EXTERNAL DATA FILE TO A TREE.
INPUT: CHAR POINTER
OUTPUT: NONE
 */
void tree::load_data_from_external_file(char* file_name)
{
	char* name = new char[1000];
	char* detail = new char[100];
	char* alt_name = new char[100];
	long phone_num=0;
	float radio_freq=0.0;
	int chan = 0;
	int size=1;
	int num_loaded =0;
	person* people = new person[size];
	ifstream datafile;
	datafile.open(file_name);
	if(datafile.is_open())
	{
		while(!datafile.eof())
		{
			person* new_person = new person();
			datafile.getline(name,100);
			*new_person+=name;
			datafile.getline(name,100);
			*new_person+=name;
			datafile.getline(name,100);
			while(strcmp(name,(char*)"//**//")!=0 && !datafile.eof())
			{
				if(strcmp(name,(char*)"phone")==0)
				{
					//					cout<<"New phone creation"<<endl;
					datafile.getline(detail,100);
					datafile>>phone_num;
					contact* new_contact = new phone(phone_num,name,detail);
					//					cout<<static_cast<phone&>(*new_contact)<<endl;
					*new_person+=(phone*&)new_contact;
					datafile.clear();
					datafile.ignore();
					//					cout<<new_contact<<endl;
				}
				else if(strcmp(name,(char*)"email")==0)
				{
					//					cout<<"New email creation"<<endl;
					datafile.getline(detail,100);
					datafile.getline(alt_name,100);
					contact* new_contact = new email(alt_name,name,detail);
					*new_person+=(email*&)new_contact;
					//					cout<<static_cast<email&>(*new_contact)<<endl;					
				}
				else if(strcmp(name,(char*)"radio")==0)
				{
					//					cout<<"New radio creation"<<endl;
					datafile.getline(detail,100);
					datafile.clear();
					datafile >> radio_freq;
					//					cout<<"Radio_freq: "<<radio_freq<<endl;
					contact* new_contact = new radio(radio_freq,name,detail);
					*new_person+=(radio*&)new_contact;
					datafile.clear();
					datafile.ignore();
					//					cout<<static_cast<radio&>(*new_contact)<<endl;
				}
				else if(strcmp(name,(char*)"social media")==0)
				{
					//					cout<<"New social media creation"<<endl;
					datafile.getline(detail,100);
					datafile.getline(alt_name,100);
					contact* new_contact = new social_media(alt_name,name,detail);
					*new_person+=(social_media*&)new_contact;
					//					cout<<static_cast<social_media&>(*new_contact)<<endl;
				}
				else if(strcmp(name,(char*)"television")==0)
				{
					//					cout<<"New television creation"<<endl;
					datafile.getline(detail,100);
					datafile>>chan;
					contact* new_contact = new television(chan,name,detail);
					*new_person+=(television*&)new_contact;
					datafile.clear();
					datafile.ignore();
					//					cout<<static_cast<television&>(*new_contact)<<endl;
				}
				else
				{
					cout<<"Error name is: "<<name<<endl;
					cout<<detail<<endl;
					/*					cout<<"There was an error in getting the data from the file, returning to main menu"<<endl;
										datafile.close();
										datafile.clear(ios_base::goodbit);
										return;*/
				}
				datafile.getline(name,100);

			}
			if(new_person->is_fully_populated() == true)
			{
				//				cout<<*new_person<<endl;
				//				cin.get();
				//				cout<<*new_person<<" is fully populated"<<endl;
				//				cin.get();
				if(num_loaded == size)
				{
					cout<<"Increasing array size from "<<size<<" to "<<size+1<<endl;
					person* new_people = new person[size+1];
					for(int i=0;i<size;i++)
					{
						//						new_people[i] = person(people[i]);
						new_people[i]= people[i];
						//	cout<<"Moving"<<endl<<people[i]<<"to"<<endl<< i<<endl;
					}
					if(people)
					{
						delete[] people;
					}
					people = new_people;
					++size;
				}
				//cout<<"Inserting"<<endl<<*new_person<<endl<<"into array index: "<<size-1<<endl;
				people[num_loaded] = new_person;
				cout<<"Displaysing all the people nodes: "<<endl;
				//				cout<<"New person added"<<endl;
				++num_loaded;	
				//add to tree here.
			}
		}
	}		
	else
	{
		cout<<"File containing data not found"<<endl;
	}
	for(int i=0; i<size;i++)
	{
		if(i>0)
		{
			cout<<"Root is currently..."<<endl;
			cout<<*root;
			cin.get();
		}
		this->insert(people[i]);
	}
	//	insert_algorithm(people,num_loaded,*this);
	datafile.close();
	datafile.clear(ios_base::goodbit);
	if(name)
	{
		delete[] name;
	}
	if(detail)
	{
		delete[] detail;
	}
	if(alt_name)
	{
		delete[] alt_name;
	}
	if(people)
	{
		delete[] people;
	}
}



/*
   THIS IS A WRAPPER FOR INSERTING A NODE INTO A TREE.
INPUT: A PERSON BY REFERENCE.
OUTPUT: NONE
 */
void tree::insert(person& new_person)
{
	char* new_last = new char[100];
	new_person.get_last_name(new_last);
	person_node* new_node = new person_node(new_person);			
	if(number_of_nodes==0)
	{
		tree_node* newer_node = new tree_node(new_node);
		cout<<"Tree node being inserted into root is: "<<endl;
		cout<<*newer_node<<endl;
		cin.get();
//		root =newer_node;
		root = new tree_node(newer_node);
//		this->set_root(newer_node);
		cout<<"Root in the function it was created in."<<endl;
		cout<<*root<<endl;	
		cin.get();
		++number_of_nodes;
	}
	else
	{
		cout<<"Going to rec insert."<<endl;
		rec_insert(this->root,new_node,new_last);
	}
	if(new_last)
	{
		delete[] new_last;
	}
}



/*
   THIS FUNCTION WILL FIND INSERT A PERSON EITHER INTO A LIST IN AN EXISTING NODE OR MAKE A NEW NODE AND ADD MAKE THE PERSON HEAD.
INPUT: A TREE NODE POINTER BY REFERENCE, A PERSON NODE BY REFERENCE 
OUTPUT: NONE
 */
void tree::rec_insert(tree_node*& current, person_node*& to_add, char*& to_add_last_name)
{
	if(!current)//if the person node has not been stored in a tree node, create a new tree node and store it in the tree.
	{
		cout<<"Adding a new tree node"<<endl;
		tree_node* new_node = new tree_node(to_add);
		current = new_node;
		++number_of_nodes;
		cout<<"Displaying entire tree: "<<endl;
		cout<<*this;
		cout<<"Tree has finished displaying"<<endl;
		return;
	}
	char* node_last_name;
	current->get_last_name(node_last_name);
	cout<<"Comparing: "<<node_last_name<<" and "<<to_add_last_name<<endl;
	cin.get();
	if(strcmp(node_last_name,to_add_last_name)==0)//the person node is added to the list.
	{
		cout<<"Adding to list: "<<node_last_name<<endl;
		cin.get();
		current->add_to_list(to_add);		
		return;
	}
	else if(strcmp(node_last_name,to_add_last_name)>0)//go left
	{
		cout<<"Going left"<<endl;
		rec_insert(current->go_left(),to_add,to_add_last_name);

	}
	else if(strcmp(node_last_name,to_add_last_name)<0)//go right
	{
		cout<<"Going right"<<endl;
		rec_insert(current->go_right(),to_add,to_add_last_name);;
	}
	rec_insert(current,to_add,to_add_last_name);
}



/*
   THIS FUNCTION IS A WRAPPER FOR INSERTING NODE INTO A TREE IN A CERTAIN WAY.
INPUT: A PERSON POINTER BY REFERENCE, AN INT, A TREE BY REFERENCE.
OUTPUT: NONE
 */
void tree::insert_algorithm(person*& people, int num_of_people, tree& to_copy)
{
	bool* has_been_stored = new bool[num_of_people];
	int* index_numbers = new int [1];
	int halfer = num_of_people;
	int level =0;
	for(int i=0; i<num_of_people;i++)
	{
		*(has_been_stored+i)=false;
	}
	if(halfer%2==1)
	{
		halfer = (halfer+1)/2;
	}
	else
	{
		halfer = halfer/2;
	}
	rec_insert_algorithm(level,halfer,people,has_been_stored,index_numbers,to_copy,num_of_people);
	if(has_been_stored)
	{
		delete[] has_been_stored;
	}
	if(index_numbers)
	{
		delete[]index_numbers;
	}
}



/*
   THIS FUNCTION WILL INSTERT NODES INTO A TREE IN A BALACNED MANOR.  
INPUT: THREE INTS, A PERSON POINTER BY REFERENCE, AN INT POINTER, AND A BOOL POINTER BY REFERNECE.
OUPUT: NONE
 */
void tree::rec_insert_algorithm(int level,int halfer, person*& people,bool*& has_been_stored, int* index_numbers,tree& to_copy, int num_of_people)
{
	if(halfer ==2)
	{
		for(int i=0;i<num_of_people-1;i++)
		{
			if(*(has_been_stored+i)==false)
			{
				to_copy.insert(*(people+i));
				has_been_stored[i]=true;
			}
		}
	}
	int number_of_nodes_on_this_level =pow(2,level);
	int last_level_numbers_size =pow(2,level-1);
	int last_level_numbers[last_level_numbers_size];
	int nodes_inserted_on_this_level =0;
	if(level==0)
	{
		to_copy.insert(*(people+halfer-1));
		*(has_been_stored+halfer-1)=true;
		index_numbers[0]=halfer;
	}
	else
	{
		for(int i=0;i<last_level_numbers_size;i++)
		{
			last_level_numbers[i]=index_numbers[i];
		}
		int* new_index = new int[number_of_nodes_on_this_level];
		if(index_numbers)
		{
			delete[] index_numbers;
		}
		index_numbers = new_index;
		for(int i=0;i<last_level_numbers_size;i++)
		{
			if(last_level_numbers[i]+halfer >num_of_people-1&& has_been_stored[num_of_people-1]==false)
			{
				to_copy.insert(people[num_of_people-1]);
				has_been_stored[num_of_people-1]=true;
				index_numbers[i+nodes_inserted_on_this_level]=num_of_people-1;
			}
			else
			{
				if(has_been_stored[last_level_numbers[i]+halfer-1]==false)
				{
					to_copy.insert(people[last_level_numbers[i]+halfer-1]);
					has_been_stored[last_level_numbers[i]+halfer-1]=true;
					index_numbers[i+nodes_inserted_on_this_level]=last_level_numbers[i]+halfer;
				}
			}
			++nodes_inserted_on_this_level;
			if(last_level_numbers[i]-halfer <=0 && has_been_stored[0]==false)
			{
				to_copy.insert(people[0]);
				has_been_stored[0]=true;
				index_numbers[i+nodes_inserted_on_this_level]=1;
			}
			else
			{
				if(has_been_stored[last_level_numbers[i]-halfer-1]==false)
				{
					to_copy.insert(people[last_level_numbers[i]-halfer-1]);
					has_been_stored[last_level_numbers[i]-halfer-1]=true;
					index_numbers[i+nodes_inserted_on_this_level]=last_level_numbers[i]-halfer;
				}
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
	rec_insert_algorithm(++level,halfer,people,has_been_stored,index_numbers,to_copy,num_of_people);
}



/*
   THIS FUNRCITON WILL CREATE AND ADD A NEW TREE NODE TO A TREE.
INPUT: A PERSON POINTER BY REFERENCE.
OUTPUT: NONE
 */
void tree::add_new_tree_node(person_node*& to_add)
{
	if(number_of_nodes ==0)
	{
		//		cout<<"About to add: "<<endl;
		//		cout<<*to_add;
		cout<<"Adding a root"<<endl;
		tree_node* new_node = new tree_node(to_add);
//		cout<<"in add new tree node, new node is: "<<endl;
//		cout<<* new_node<<endl;
		root = new_node;
//		cout<<"in add new tree node, root is: "<<endl;
//		cout<<*root<<endl;
//		cin.get();
		++number_of_nodes;
		cout<<"Number of nodes: "<<number_of_nodes<<endl;
		return;
	}
	else
	{
		cout<<" Adding a new tree node."<<endl;
		cout<<"Before adding a new tree node, root is: "<<*root<<endl;
		rec_add_new_tree_node(to_add, root);
	}
}



/*
   THIS FUNCTION WILL ADD A NEW TREE NODE TO A TREE.
INPUT: A PERSON NODE POINTER BY REFERENCE AND  TREE NODE POINTER BY REFERENCE.
OUTPUT: NONE
 */
void tree::rec_add_new_tree_node(person_node*& to_add, tree_node*& current)
{
	if(!current)
	{
		cout<<"Creating new  tree node"<<endl;
		tree_node* new_node = new tree_node(to_add);
		current = new_node;
		++number_of_nodes;
		cout<<"Number of nodes: "<<number_of_nodes<<endl;
		return;
	}
	char* temp_person_last;// = new char[100];
	char* temp_root_last;// = new char[100];
	current->get_last_name(temp_root_last);
	to_add->get_last_name(temp_person_last);
	cout<<"Comparing "<<temp_root_last<<" and "<<temp_person_last<<endl;
	if(strcmp(temp_root_last,temp_person_last)<=0)
	{
		rec_add_new_tree_node(to_add,current->go_right());
	}
	else
	{
		rec_add_new_tree_node(to_add,current->go_left());
	}
}




/*
   THIS IS AN OVERLOADED OPERATOR FOR = OPERATOR FOR THE TREE NODE.
INPUT: A TREE NODE BY REFERENCE.
OUTPUT: TREE NODE BY REFERENCE.
 */
tree_node& tree_node::operator=(const tree_node& to_copy)
{
	strcpy(this->last_name,to_copy.last_name);
	this->head = to_copy.head;
	this->left = to_copy.left;
	this->right = to_copy.right;
	return *this;
}



/*
   THIS IS AN OVERLOADED OPERATOR FOR == OPERATOR FOR THE TREE NODE.
INPUT: TREE NODE BY REFERENCE.
OUTPUT: A BOOL
 */
bool tree_node::operator==(tree_node& one)
{
	if(strcmp(one.last_name,this->last_name)==0 )
	{
		return true;
	}
	else
	{
		return false;
	}
}



/*
   THIS IS AN OVERLOADED OPERATOR FOR < OPERATOR FOR THE TREE NODE.
INPUT: TWO TREE NODES BY REFERENCE.
OUTPUT: A BOOL
 */
bool operator<(tree_node& one, tree_node& two)
{
	if(!one.last_name || !two.last_name)
	{
		cout<<"Cannot compare, one or both compares are null."<<endl;
		return false;
	}
	if(strcmp(one.last_name,two.last_name)<=-1)
	{
		return true;
	}	
	else
	{
		return false;
	}
}



/*
   THIS IS AN OVERLOADED OPERATOR FOR > OPERATOR FOR THE TREE NODE.
INPUT: TWO TREE NODES BY REFERENCE.
OUTPUT: A BOOL
 */
bool operator>(tree_node& one, tree_node& two)
{
	if(!one.last_name || !two.last_name)
	{
		cout<<"Cannot compare, one or both compares are null."<<endl;
		return false;
	}
	if(strcmp(one.last_name,two.last_name)>=1)
	{
		return true;
	}	
	else
	{
		return false;
	}
}




/*
   THIS IS AN OVERLOADED OPERATOR FOR <= OPERATOR FOR THE TREE NODE.
INPUT: TWO TREE NODES BY REFERENCE.
OUTPUT: A BOOL
 */
bool operator<=(tree_node& one, tree_node& two)
{
	if(!one.last_name || !two.last_name)
	{
		cout<<"Cannot compare, one or both compares are null."<<endl;
		return false;
	}
	if(strcmp(one.last_name,two.last_name)<=0)
	{
		return true;
	}	
	else
	{
		return false;
	}
}




/*
   THIS IS AN OVERLOADED OPERATOR FOR >= OPERATOR FOR THE TREE NODE.
INPUT: TWO TREE NODES BY REFERENCE.
OUTPUT: A BOOL
 */
bool operator>=(tree_node& one, tree_node& two)
{
	if(!one.last_name || !two.last_name)
	{
		cout<<"Cannot compare, one or both compares are null."<<endl;
		return false;
	}
	if(strcmp(one.last_name,two.last_name)>=0)
	{
		return true;
	}	
	else
	{
		return false;
	}
}




/*
THIS IS AN OVERLOADED OPERATOR FOR THE << OPERATOR IN THE TREE FUNCTION.
INPUT: AN OSTREAM BY REFERENCE AND A TREE BY REFERENCE.
OUTPUT: OSTREAM BY REFERENCE.
*/
ostream& operator <<(ostream& out, tree& t)
{
	t.display(t.root);
	return out;	
}



/*
THIS WILL DISPLAY EVERYTHING IN A TREE.
INPUT: A TREE NODE BY REFERENCE.
OUTPUT: NONE
*/
void tree::display(tree_node*& current)
{
	if(!current)
	{
		cout<<"Root is null"<<endl;
		return;
	}
	display(current->go_left());
	cout<<*current<<endl;
	display(current->go_right());
}

void tree_node::display()
{
	if(!head)
	{
		cout<<" This tree node is empty."<<endl;
		return;
	}
	if(strlen(last_name)==0)
	{
		cout<<"This tree node has no last name"<<endl;
		return;
	}
	cout<<"===================================="<<endl;
	cout<<"Last name for this node is: "<<last_name<<endl;
	person_node* temp = head;
	while(temp)
	{
		cout<<*temp<<endl;
		temp = temp->next_node();
	}
	cout<<"===================================="<<endl;
	
}

ostream& operator <<(ostream& out, tree_node& t)
{
	t.display();
	return out;
}


void tree:: set_root(tree_node*& to_add)
{
	if(root)
	{
		delete root;
	}
//	cout<<"to add in set root is: "<<endl;
//	cout<<*to_add; 
//	cin.get();
	root = new tree_node(*to_add);
}

void tree::get_num()
{
	cout<<number_of_nodes<<endl;
}

