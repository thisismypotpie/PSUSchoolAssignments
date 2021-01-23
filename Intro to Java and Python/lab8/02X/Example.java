import java.util.*;
import java.util.function.*;

class T {
  T l;
  int v;
  T r;
  T(T l, int v,T r) {this.l = l;  this.v = v; this.r = r;}

  static final T empty = null;

  // 1. Replace the body of this function with an equivalent but purely functional version (no assignments allowed!)
  static boolean lookup(T t, int v) {

    if(t == null)
    {
      return false;
    }
    if(v < t.v)
    {
      return lookup(t.l,v);
    }
    else if(v > t.v)
    {
      return lookup(t.r,v);
    }
    return true;
  }

  static T insert(T t,int v) {
    if (t == null)
      return new T(null,v,null);
    else if (v < t.v)
      return new T(insert(t.l,v),t.v,t.r);
    else if (v > t.v)
      return new T(t.l,t.v,insert(t.r,v));
    else // v == t.v
      return t;
  }

  // 2. Fill in the body of this function. Your code must be purely functional (no assignments!)
  static T map(T t,IntUnaryOperator f) {
    if(t == null)
    {
      return null;
    }
    return new T(map(t.l,f),f.applyAsInt(t.v),map(t.r,f));
  }

  // 3. Fill in the body of this function.
  static void inorder(T t,IntConsumer f) {
    if(t == null)
    {
      return;
    }
    inorder(t.l,f);
    f.accept(t.v);
    inorder(t.r,f);
  }
}


class Example {
  public static void main(String argv[]) {

    // read tree elements from command line, keeping track of min and max
    T t = T.empty;
    int min=0;
    int max=-1;
    for (String s : argv) {
      int i = Integer.parseInt(s);
      min = Math.min(i,min);
      max = Math.max(i,max);
      t = T.insert(t,i);
    }


    // test membership on all values between min and max
    for (int i = min; i <= max; i++)
      if (T.lookup(t,i))
	System.out.print(i + " ");
    System.out.println();

    // print elements in inorder (i.e. sorted)
    // (should produce same output as above)
    T.inorder(t,x -> System.out.print(x + " "));
    System.out.println();

    // generate a new tree in which each element value is doubled
    T u = T.map(t, x -> x * 2);

    // print the new tree elements
    T.inorder(u,x -> System.out.print(x + " "));
    System.out.println();

    // make sure the original tree has not changed
    T.inorder(t,x -> System.out.print(x + " "));
    System.out.println();
  }
}
