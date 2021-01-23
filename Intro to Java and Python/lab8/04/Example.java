import java.util.*;
import java.util.stream.*;

class Example {

  public static void main(String argv[]) {
    IntStream.range(0,10)                          // generate stream of numbers 0 to 9
      .forEach(x -> System.out.print(x + " "));  // print each one
    System.out.println();

    int a[] = {1,3,5,5,7,3,8,9,8};
    int sum =
      Arrays.stream(a)         // generate stream from array
      .map(x -> x*x)           // square each number
      .filter(y -> y % 2 == 0) // keep only even numbers
      .sum();                  // add up
    System.out.println(sum);

    int c = 
      IntStream.iterate(1,x -> 2 * x + 3)   // generate the infinite stream 1, 5, 13, 29, ...
      .takeWhile(x -> x <= 100)             // cut stream off after values exceed 100
      .reduce(1, (x,y) -> x*y);             // compute product 
    System.out.println(c);

  }

}
