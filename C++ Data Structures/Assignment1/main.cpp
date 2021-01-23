// this is my main.  i have some hard coded examples to add to my list. There are three and they are immedietely added to the list on run.  Main runs on a series of loops tht allow the user to traverse different menus.  The hinge on user input being reset on the end of each execution.The only way to exit the program is to press 4 on the main menu which activates the destructor of the list and then reutrns in main which terminates the program.
#include<iostream>
#include"linkedlist.h"
#include"app.h"
using namespace std;
int main()
{
app userApp;
list subList;
tutor tutor1(((char*)"math"),10,((char*)"online"),((char*)"http:/help.com"),((char*)"-"),((char*) "-"),((char*)"An online site to help students with all of their math realted questions and homework. "));
tutor tutor2(((char*)"english"),2,((char*)"on campus"),((char*)"FAB 88"),((char*)"M,TH"),((char*) "1-5"),((char*) "We teach kids who cant talk good to talk more better.  Look at our killer ratings."));
tutor tutor3(((char*)"Archecture"),6,((char*)"online"),((char*)"http://building.com"),((char*)"-"),((char*) "-"),((char*)"Helping builders build building skill for  building buildings, nuff said."));
tutor tutor4(((char*)"Science"),9,((char*)"on campus"),((char*)"Science  Building 1"),((char*)"W"),((char*)"1-12"),((char*)"Ray gun building workshop.  Also free donuts, not experimental."));
subList.addNode(tutor1);
subList.addNode(tutor2);
subList.addNode(tutor3);
subList.addNode(tutor4);


userApp.intro();
while(userApp.getUserInputForSelections()==-1)
{
userApp.menuOne();
if(userApp.getUserInputForSelections() == 1)
{
 subList.showAllNodes();
 userApp.menuForViewingList();
 if(userApp.getUserInputForSelections() == 1)
 { 
  if(userApp.checkNum(userApp.choosingAnItem(),subList.getLength())==true )
 {
   subList.traversetoNode(userApp.getUserInputForSelections());
   userApp.menuForViewingItemOnList();
   if(userApp.getUserInputForSelections() == 1)
    {
     subList.changeRating(userApp.changeRating());
    } 
 }
 
   userApp.setUserInputForSelections(-1);
 } 
 else if(userApp.getUserInputForSelections() == 2)
 {
   subList.displayHighRatedNodes();
   userApp.setUserInputForSelections(-1); 
 }
 else if(userApp.getUserInputForSelections() == 3)
{
  userApp.setUserInputForSelections(-1);
}
}
else if(userApp.getUserInputForSelections() == 2)
{
 cout<<"I'm sorry but the function that deletes the lowest rated tutors has not been finished"<<endl;
 userApp.setUserInputForSelections(-1);
  subList.deleteLowRatedNodes();  
  userApp.setUserInputForSelections(-1);

}
else if(userApp.getUserInputForSelections() == 3)
{
   tutor newTutor;
  userApp.addTutorInfo(newTutor);
  subList.addNode(newTutor);
  userApp.setUserInputForSelections(-1);
}
else if(userApp.getUserInputForSelections() == 4)
{
 subList.~list();
 return 0;
}
else
{
userApp.MenuError();
}
}
}

