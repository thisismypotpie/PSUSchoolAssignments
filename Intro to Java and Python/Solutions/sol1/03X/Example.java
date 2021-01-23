class Example {
  public static void main (String argv[]) {
    if (argv.length != 1)
      usage();
    int n = 0;
    try {
      n = Integer.parseInt(argv[0]);
    } catch (NumberFormatException e) {
      usage();
    }
    // here is one way
    for (int i = 1; i <= n; i++) {
      boolean print_num = true;
      if (i%3 == 0) {
	System.out.print("Flim");
	print_num = false;
      }
      if (i%5 == 0) {
	System.out.print("Flam");
	print_num = false;
      }
      if (print_num)
	System.out.print(i);
      System.out.println();
    }
  }

  private static void usage() {
    System.err.println("Usage: java Example bound");
    System.exit(1);
  }
}


