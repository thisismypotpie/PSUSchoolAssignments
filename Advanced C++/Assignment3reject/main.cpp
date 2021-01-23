#include<iostream>
#include<cstring>
#include"app.h"
#include"tree.h"
#include"person.h"
#include"contact.h"
using namespace std;
int main()
{
tree the_tree;
app the_app;
the_app.first_greeting();
//the_tree.load_data_from_external_file((char*)"tree_data.txt");
//the_tree.load_data_from_external_file((char*)"test.txt");
//the_tree.get_num();
//cout<<the_tree;
the_app.main_menu(the_tree);
return 0;
}
