/*
Brandon Danielski
CS202
1/16/2017
Assignment One
This is the main for the streetcar network.  It loads the information from the external data files into the graph so thre is not hard coded data from main. 
*/
#include "structures.h"
#include "app.h"
#include "stop.h"
#include "streetcar.h"
using namespace std;
int main()
{
graph the_map;
app the_app;
streetcar test;
the_map.load_line_files(((char*)"stopsForLineOne.txt"),((char*)"LineOneStreetCars.txt"));
the_map.load_line_files(((char*)"stopsForLoopOne.txt"),((char*)"LoopOneStreetCars.txt"));

return 0;
}
