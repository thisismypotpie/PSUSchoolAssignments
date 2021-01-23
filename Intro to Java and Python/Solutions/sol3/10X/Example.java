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
  T2 (int x, T left, T right) { this.x = x; this.left = left; this.right = right; }

  int sum() {
    return x + left.sum() + right.sum();
  }
}

class T3 extends T {
  private int x;
  private int y;
  private T left;
  private T middle;
  private T right;
  T3 (int x, int y, T left, T middle, T right) {
    this.x = x; this.y = y; this.left = left; this.middle = middle; this.right = right;
  }

  int sum() {
    return x + y + left.sum() + middle.sum() + right.sum();
  }
}


class Example {
  public static void main (String argv[]) {
    T t = new T3(1, 4, new T0(2), 
                       new T2(3, new T0(6), 
                                 new T0(5)),
                       new T2(7, new T0(9), 
                                 new T0(8)));
    System.out.println ("sum = " + t.sum());
  }

}
    