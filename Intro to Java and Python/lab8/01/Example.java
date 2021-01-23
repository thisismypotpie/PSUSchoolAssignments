import java.util.*;
import java.util.function.*;

class IntList {
  int value;
  IntList next;
  IntList(int value, IntList next) {this.value = value; this.next = next;}

  static IntList generate(int low,int high,IntUnaryOperator f) {
    if (low < high)
      return new IntList(f.applyAsInt(low),generate(low+1,high,f));
    else
      return null;
  }

  static IntList map(IntList list,IntUnaryOperator f) {
    if (list != null)
      return new IntList(f.applyAsInt(list.value),map(list.next,f));
    else
      return null;
  }

  static void mapInPlace(IntList list,IntUnaryOperator f) {
    while (list != null) {
      list.value = f.applyAsInt(list.value);
      list = list.next;
    }
  }

  static void doAll(IntList list,IntConsumer f) {
    while (list != null) {
      f.accept(list.value);
      list = list.next;
    }
  }
}


class Example {

  public static void main (String argv[]) {
    int size = 10;
    IntList xs = IntList.generate(0,size,i -> i * 2);
    printList(xs);
    IntList ys = IntList.map(xs,i -> i/2);
    printList(xs);
    printList(ys);
    IntList.mapInPlace(xs,i -> i * 2);
    printList(xs);
    printList(ys);

    // using the composition method on IntUnaryOperator 
    IntUnaryOperator addOne = k -> k + 1;
    IntUnaryOperator triple = k -> k * 3;
    printList(IntList.map(ys,addOne));
    printList(IntList.map(ys,addOne.compose(triple)));
    printList(IntList.map(ys,addOne.compose(x -> x * 3)));
    // printList(immutMapList(xs,(i -> i + 1.compose(triple))));  // invoking a method directly on a lambda expression doesn't work
    printList(IntList.map(ys,((IntUnaryOperator) (i -> i + 1)).compose(triple)));  // explicit cast needed
  }

  static void printList(IntList list) {
    IntList.doAll(list,i -> System.out.print(i + " "));
    System.out.println();
  }

}      
