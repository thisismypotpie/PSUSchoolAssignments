class Example {
  public static void main (String[] argv) {
    int x = 0;
    System.out.println((x=1) + (x=2));
    System.out.println(x);
  }
}
