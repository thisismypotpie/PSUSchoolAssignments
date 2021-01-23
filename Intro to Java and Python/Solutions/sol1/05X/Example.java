import java.io.*;
import java.nio.file.*;
import java.util.*;

class Example {
  public static void main (String argv[]) throws IOException {
    int[] is = readIntArray(argv[0]);
    int b = Integer.parseInt(argv[1]);
    int min = Integer.parseInt(argv[2]);
    int s = Integer.parseInt(argv[3]);
    int max = min + b * s - 1;
    int[] bs = new int[b];
    int lows = 0;
    int highs = 0;
    for (int i : is) {
      if (i < min)
        lows++;
      else if (i > max)
        highs++;
      else {
        int j = (i-min)/s;
        bs[j]++;
      }
    }
    System.out.println("x < " + min + ": " + lows);
    for (int j = 0; j < b; j++) 
      System.out.println((min+s*j) + " <= x < " + (min+s*(j+1)) + ": " + bs[j]);
    System.out.println("x >= " + (max+1) + ": " + highs);
  }
  
  private static int[] readIntArray(String filename) throws IOException {
    try (BufferedReader f = Files.newBufferedReader(Paths.get(filename));
	 Scanner sc = new Scanner(f)) {
      int n = sc.nextInt();
      int[] is = new int[n];
      for (int i = 0; i < n; i++)
	is[i] = sc.nextInt();
      return is;
    }
  }
}




