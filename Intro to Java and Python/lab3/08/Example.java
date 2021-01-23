abstract class T {
  abstract int sum();
}

class T0 extends T {
  private int x;
  T0 (int x) { this.x = x; }
  
  int sum() {
    return x;
  }
}

class T2 extends T {
  private int x;
  private T left;
  private T right;
  T2 (int x, T left, T right) { 
      this.x = x; this.left = left; this.right = right; }

  int sum() {
    return x + left.sum() + right.sum();
  }
}

class Example {
  public static void main (String argv[]) {
    T t = new T2(1, new T2(3, new T0(5), 
                              new T0(4)),
                    new T0(2));
    System.out.println ("sum = " + t.sum());
  }
}
    