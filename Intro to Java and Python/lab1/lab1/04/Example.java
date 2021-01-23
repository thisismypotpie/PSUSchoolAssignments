import java.io.*;
import java.nio.file.*;
import java.util.*;

class Example {
  public static void main (String argv[]) throws IOException {
    int[] is = readIntArray(argv[0]);
    double mean = mean(is);
    double variance = variance(is,mean);
    double stdev = Math.sqrt(variance);
    System.out.println("mean = " + mean + " variance = " + variance + " stdev = " + stdev);
  }

  private static double mean(int[] is) {
    double sum = 0.0;
    for (int i : is)
      sum += i; // implicit coercion from int to double
    return sum/is.length;
  }

  private static double variance(int[] is, double mean) {
    double sumsqdiff = 0.0;
    for (int i : is)
      sumsqdiff += Math.pow(i-mean,2); // implicit coercion from int to double
    return sumsqdiff/is.length;
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


