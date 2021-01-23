import java.util.*;
import java.util.stream.*;

class Example {

  public static void main(String argv[]) {
    int a[] =
      Arrays.stream(argv)
      .mapToInt(s -> Integer.parseInt(s))
      .toArray();

    System.out.println("part a:");
    int m =
        Arrays.stream(a)
	.max()
        .getAsInt();
    System.out.println(m);

    System.out.println("part b:");
	Arrays.stream(a)
        .filter(y -> y % 3 == 1)
        .distinct()//removes dupicates
        .forEach(x -> System.out.println(x));

    System.out.println("part c:");
      Arrays.stream(a)
        .dropWhile(x -> x!=0)
        .skip(1)
        .takeWhile(x -> x!=0)
        .forEach(x -> System.out.println(x));
    System.out.println("part d:");
    Arrays.stream(a)
    .forEach((x)-> {for(int i=0; i < x;i++){System.out.println(x);}});

    System.out.println("part e:");
    //credit given to: https://www.baeldung.com/java-stream-last-element
    int last = Arrays.stream(a)
      .reduce((x,y) -> y)
      .orElse(0);
    System.out.println(last);

  }
}
