class T {
  private int x;
  private T left;
  private T right;
  T (int x, T left, T right) {
    this.x = x; this.left = left; this.right = right;
  }

  int size () {
      return 1 + (left != null ? left.size() : 0)     // just a one character change from sum()!
               + (right != null ? right.size() : 0);
  }
}

class Example {
  public static void main (String argv[]) {
    T t = new T (1, new T(2, null, 
                             null), 
                    new T(4, null, 
                             new T(3, null, 
                                      null)));
    System.out.println ("size = " + t.size());
  }

}
    
