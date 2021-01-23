class Example {
  
  @FunctionalInterface
  interface Int2Int {
    int apply(int x);
  }
  
  static class Add42 implements Int2Int {
    public int apply(int z) { return z+42; }
  }

  static Int2Int add42 = w -> w + 42;

  static Int2Int adder(int x) {
    return z -> x + z;
  }

  static Int2Int compose(Int2Int f, Int2Int g) {
    return x -> f.apply(g.apply(x));
  }

  static void mapArray (int[] a, Int2Int f) {
    for (int i = 0; i < a.length; i++)
      a[i] = f.apply(a[i]);
  }

  static void printArray(int[] a) {
    for (int i:a) 
      System.out.print(i + " ");
    System.out.println();
  }

  public static void main(String argv[]) {
    int[] a = {0,1,2,3,4,5,6,7,8,9};
    printArray(a);
    mapArray(a,new Add42());
    printArray(a);
    mapArray(a,add42);
    printArray(a);
    mapArray(a,x -> x * 2);
    printArray(a);
    mapArray(a,adder(1)); 
    printArray(a);
    mapArray(a,compose(x -> x/2, x -> x - 1));
    printArray(a);
  }

}

