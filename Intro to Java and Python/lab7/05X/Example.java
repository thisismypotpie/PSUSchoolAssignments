class Example {
  public static void main(String argv[]) {
    int low = Integer.parseInt(argv[0]);
    int high = Integer.parseInt(argv[1]);
    Range r = new Range(low,high);
    for (int i : r)
      for (int j : r)
	System.out.println(i + " " + j);
  }
}
