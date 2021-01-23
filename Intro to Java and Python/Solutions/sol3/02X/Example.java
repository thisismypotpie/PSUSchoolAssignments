/* Sample solution: */

class Example {
  
  // The function tests whether its argument is an odd number in the interval (0,1000].
  static boolean f(int i) {
    return i > 0 && i <= 1000 && (i%2 != 0);
  }

  public static void main(String argv[]) {
    int i = Integer.parseInt(argv[0]);
    boolean b = f(i);
    System.out.println(b);
  }
}


/* 

We can reach the solution above by making successive local simplifications.

First of all, the calculation of a is an example of a pattern shown in the lab notes:

    boolean a;
    if (i % 2 != 0)
      a = false;
    else
      a = true;

is just equivalent to

    boolean a = !(i%2 !=0) 

i.e.
 
    boolean a = (i%2 == 0)  // i is even

Similarly, the sub-expression

     if (i > 1000 || a == true)
        return false;
      else
        return true;

if equivalent to

      return !(i > 1000 || a == true)

or (using another pattern from the lab notes) is just

      return !(i > 1000 || a)

which, using a DeMorgan law, is equivalent to

      return (i <= 1000) && !a

Also

       return (a == false) ? true : false;

is just

       return (a == false);

which is just
      
       return !a;


Putting this together, we have that

      if (i <= 100)
        return (a == false) ? true : false;
      else if (i > 1000 || a == true)
        return false;
      else
        return true;
  
is equivalent to

      if (i <= 100) 
         return !a
      else
         return (i <= 1000) && !a
        
We can simplify this further by noting that, in general, 
if b is a pure expression (no side-effects) then

  if (b) 
    return e1;
  else
    return e2;

is equivalent to 

  return (b && e1) || (!b && e2);

(This transformation wasn't given in the lab notes, but it should
be easy to see what it is valid.)

Applying this to the fragment above, we get

      return ((i <= 100 && !a) || (i > 100 && ((i <= 1000) && !a)))

We can factor out the (!a), leaving

      return !a && (i <= 100 || (i > 100 && i <= 1000))

But this is just the same as

     return !a && (1 <= 1000) 

Plugging this into 

    if (i > 0) {
      if (i <= 100)
        return (a == false) ? true : false;
      else if (i > 1000 || a == true)
        return false;
      else
        return true;
    } else
      return false;


gives

    if (i > 0) 
      return !a && (i <= 1000) 
    else 
      return false

But using our new equivalence rule again gives us

    return ((i > 0) && (!a && (i <= 1000))) || (i <= 0 && false)

The right argument to || is always false, so this is just

    return (i > 0) && (!a && (i <= 1000))

So the whole function is just

    boolean a = (i%2 == 0);  // i is even
    return (i > 0) && (!a && (i <= 1000));

Plugging in the value of a and pushing the negation inside gives:

    return (i > 0) && ((i%2 != 0) && (i <= 1000));

Dropping unneceesary parentheses and reordering slightly gives:

    return i > 0 && i <= 1000 && i%2 != 0;

as claimed.

If we are worried about making mistakes in this long chain of rewrites, we can
try testing the result against the original code. Ordinarily it is not feasible
to test on all possible input values, but for a single 32-bit integer this only
takes a few seconds.  

  void test() {
    int i = Integer.MIN_VALUE;
    while (true) {
      boolean a = oldf(i);
      boolean b = newf(i);
      if (a != b)
	System.out.println(i + ":" + a + " " + b);
      if (i == Integer.MAX_VALUE)
	break;
      i++;
    }

If this test is silent, all is good.

PS Why can't the test loop be written in the more "obvious" way below?

     for (int i = Integer.MIN_VALUE; i <= Integer.MAX_VALUE; i++) {
       boolean a = oldf(i);
       boolean b = newf(i);
       if (a != b)
 	System.out.println(i + ":" + a + " " + b);
       }


*/



