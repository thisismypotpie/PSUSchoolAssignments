abstract class T {
}

class T0 extends T {
  int x;
  T0 (int x) { this.x = x; }
}

class T2 extends T {
  int x;
  T left;
  T right;
  T2 (int x, T left, T right) { 
    this.x = x; this.left = left; this.right = right; 
  }
}

class Example {
  public static void main (String argv[]) {
    T t = new T2(1, new T0(2), 
                    new T2(3, new T0(4), 
                              new T0(5)));

    System.out.println ("sum = " + sum(t));
  }

  static int sum (T t) {
    if (t instanceof T0) 
      return ((T0) t).x;
    else if (t instanceof T2) {
      T2 t2 = (T2) t;
      return t2.x + sum(t2.left) + sum(t2.right);
    } else
      throw new Error("impossible");
  }
}





