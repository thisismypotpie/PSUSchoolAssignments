/*
Brandon Danielski
CS202
1/16/2017
Assignment One
This is the .cpp for the streetcar class, the location class, and the pace class.  The pace and location class are children to the streetcar class.
*/

#include "streetcar.h"
#include <cstring>




/*
This is the default constructor for the streetcar location class
*/
streetcar_location::streetcar_location()
{
	direction = NULL;
	at_stop = NULL;
	closest_streetcar = 0;
}


/*
This is the default constructor for the streetcar class.
*/
streetcar::streetcar()
{
	online = false;
	char* name = NULL;
	int ID_number = 0;
}




/*
This is another constructor for the streetcar class.
*/
/*streetcar::streetcar() : streetcar_location
{

}*/




