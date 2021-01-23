
#include <stdio.h>

typedef
unsigned char
digit ;

// x is an array of digits

int input_decimal_integer(digit *x)
// return -1 if illegal, else put digits
// in the array x[] with x[0] containing
// the least significant digit and
// return the number of digits
{
  char v[100] ;
  int n ;
  scanf("%s",v) ;
  n = 0 ;
  while (v[n] != '\0') {
    if (v[n] < '0') return -1 ;
    if (v[n] > '9') return -1 ;
    n++ ;
  }

  int m = 0 ;
  n-- ;
  while (n >= 0) {
    x[m++] = v[n--] - '0' ;
    // makes ascii character an 8-bit value suitable for arithmetic
  }

  return m ;
}


int print_decimal_integer(digit *x, int n)
{
  int i ;
  for (i = n-1 ; i >= 0 ; i--) {
    printf("%c",x[i]+'0') ;
  }
}



int add (digit *res,
	 digit *a, int m,
	 digit *b, int n)
{
  // 'a' and 'b' are my numbers to add
  // 'm' and 'n' are the respective lengths of 'a' and 'b'

  int i,max ;

  // i is the length of the sum`1

  digit ad,bd,sum,carry ;

  if (m > n) { max = m ; } else { max = n ; }
  carry = 0;

  for (i = 0 ; i < max ; i++) {
    if (i >= m) { ad = 0 ; } else { ad = a[i] ; }
    if (i >= n) { bd = 0 ; } else { bd = b[i] ; }

    sum = ad + bd + carry ;
    // what is the biggest sum can be?

    if (sum >= 10) {
      sum = sum - 10 ;
      carry = 1 ;
    } else {
      carry = 0 ;
    }

    res[i] = sum ;
  }

  if (carry == 1) {
    res[i] = carry ;
    i++ ;
  }

  return i ;
}

int multiply (digit *res, digit *a, int m, digit *b, int n)
{
  digit carry,sum;
  digit operand[100];
  int res_length;
  int op_length;
  res_length= 0;
  op_length = 0;
  carry = 0;
  int i,j,k;
  i=0;
  j=0;
  k=0;
  int decimal_places;
  decimal_places = 0;

  for(i = 0; i < m ; i++)
  {
    for(k=0; k < decimal_places;k++)
      {
        operand[k] = 0;
      }
    for(j = 0; j < n; j++)
    {
        sum = a[i]*b[j]+carry;
        if(sum < 10)
	{
	  carry = 0;
	}
	else if(sum >=10 && sum < 20)
	{
	  carry =1 ;
	  sum = sum -10;
	}
	else if(sum >=20 && sum < 30)
	{
	  carry = 2;
	  sum = sum -20;
	}
	else if(sum >=30 && sum< 40)
	{
	  carry = 3;
	  sum = sum -30;
	}
	else if(sum >=40 && sum < 50)
	{
	  carry = 4;
	  sum = sum -40;
	}
	else if(sum >=50 && sum < 60)
	{
	  carry = 5;
	  sum = sum -50;
	}
	else if(sum >=60 && sum < 70)
	{
	  carry = 6;
	  sum = sum -60;
	}
	else if(sum >=70 && sum < 80)
	{
	  carry = 7;
	  sum = sum -70;
	}
	else if(sum >=80 && sum < 90)
	{
	  carry = 8;
	  sum = sum -80;
	}
        operand[j+decimal_places] = sum;
        op_length ++;
    }

      if (carry  > 0)
      {
        operand[j+decimal_places] = carry ;
        carry = 0;
        op_length++;
      }
      decimal_places ++;
      res_length = add (res,res,res_length,operand,op_length);
      op_length = decimal_places;

  }
  return res_length;
}

int main()
{
  digit x[100], y[100], z[100] ;
  int xlen, ylen, zlen ;

  xlen = input_decimal_integer(x) ;
  printf("x = ") ; print_decimal_integer(x,xlen) ;  printf("\n") ;


  ylen = input_decimal_integer(y) ;
  printf("y = ") ; print_decimal_integer(y,ylen) ;  printf("\n") ;

//  zlen = add(z,   x,xlen,    y,ylen) ;
  zlen = multiply(z,x,xlen,y,ylen);

  printf("z = ") ; print_decimal_integer(z,zlen) ;  printf("\n") ;


}
