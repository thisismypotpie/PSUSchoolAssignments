/*
Brandon Danielski
3/1/2017
CS 202
Assignment 3
This is the main.cpp file for this assingmnet.
*/
#include"tree.h"
#include"contact.h"
#include"person.h"
#include "app.h"
#include<iostream>
using namespace std;
int main()
{
tree new_tree;
app the_app;
char* filename =(char*)"tree_data.txt";
new_tree.add_data_from_file_to_tree(filename);
the_app.main_menu(new_tree);
return 0;
/*tree new_tree;
char* a = (char*)"A";
char* b = (char*)"B";
char* c = (char*)"C";
char* d = (char*)"D";
char* e = (char*)"E";
char* f = (char*)"F";
char* g = (char*)"G";
new_tree.insert(d);
new_tree.insert(b);
new_tree.insert(f);
new_tree.insert(c);
new_tree.insert(a);
new_tree.insert(e);
new_tree.insert(g);

char* search1 = (char*)"H";
char* search2 = (char*)"D";
new_tree.search(search1);
new_tree.search(search2);
cout<<new_tree;*/

/*person* p1 = new person();
char* person1 =(char*)"first name here.";
char* person2 =(char*)"last name here.";
person* p2 = new person(person1,person2);
person* p3 = new person(p2);
cout<<*p2<<endl;
cout<<*p3<<endl;

person_node* pn1 = new person_node();
person_node* pn2 = new person_node(p3);
cout<<*pn2<<endl;
cout<<*pn2->get_data()<<endl;


delete p1;
delete p2;
delete p3;
delete pn1;
delete pn2;*/
/*
char* one = (char*)"one";
char* two = (char*)"two";
contact* new_c = new contact(one,two);
contact* newer_c = new contact(new_c);
cout<<newer_c->get_type()<<endl;

char* three = (char*)"phone";
char* four = (char*)"four";
long phone_num = 7073321688;
contact* newer_p=new phone(three,four,phone_num);
contact* newest_p = new phone((phone*&)newer_p);
cout<<"phone cout"<<endl;
cout<<newer_p<<endl;
cout<<newest_p<<endl;

char* five =(char*)"email";
char* six =(char*)"six";
char* address=(char*)"thisismypotpie@gmai.com";
contact* new_e = new email(five,six,address);
contact* newer_e=new email((email*&)new_e);
cout<<new_e<<endl;
cout<<newer_e<<endl;

char* seven =(char*)"radio";
char* eight =(char*)"eight";
float freq = 32.1;
contact* new_r = new radio(seven,eight,freq);
contact* newer_r = new radio((radio*&)new_r);
cout<<new_r<<endl;
cout<<newer_r<<endl;

char* nine=(char*)"social media";
char* ten=(char*)"ten";
char* username=(char*)"thisismypotpie";
contact* new_sm = new social_media(nine,ten,username);
contact* newer_sm =new social_media((social_media*&)new_sm);
cout<<new_sm<<endl;
cout<<newer_sm<<endl;

char* eleven=(char*)"tv";
char* twelve=(char*)"twelve";
int channel = 57;
contact* new_t = new tv(eleven,twelve,channel);
contact* newer_t = new tv((tv*&)new_t);
cout<<new_t<<endl;
cout<<newer_t<<endl;

char* first = (char*)"Brandon";
char* last = (char*)"Danielski";
person* me = new person(first,last,newer_p,new_e,new_r);

char*first2 =(char*)"Erin";
char*last2 =(char*)"Danielski";
person* her = new person(first2,last2,new_sm,new_t,newest_p);

char* first3 =(char*)"Daniel";
char* last3 =(char*)"Danielski";
person* him = new person(first3,last3,newer_e,newer_r,newer_sm);

char*first4 = (char*)"Abbey";
char*last4 = (char*)"Danielski";
person* her2 = new person(first4,last4,newest_p,newer_p,newer_r);

person_node* me_pn = new person_node(me);
person_node* her_pn = new person_node(her);
person_node* him_pn = new person_node(him);
person_node* her2_pn = new person_node(her2);
cout<<*me<<endl;
cout<<*her<<endl;
cout<<*him<<endl;
cout<<* her2<<endl;

cout<<*me_pn<<endl;
cout<<*her_pn<<endl;
cout<<*him_pn<<endl;
cout<<*her2<<endl;

tree the_tree;
the_tree.insert(me);
the_tree.insert(her);
the_tree.insert(him);
the_tree.insert(her2);

cout<<"Displaying the tree"<<endl;
cin.get();
cout<<the_tree<<endl;
delete new_c;
delete newer_c;
delete newer_p;
delete newest_p;
delete new_e;
delete newer_e;
delete new_r;
delete newer_r;
delete new_sm;
delete newer_sm;
delete new_t;
delete newer_t;
delete me;
delete her;
delete him;
delete her2;
delete me_pn;
delete her_pn;
delete him_pn;
delete her2_pn;*/
}

