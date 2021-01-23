import java.lang.*;

class Example {

  static class Item {
    boolean b;
    float d;
    Item(boolean b, float d) {this.b = b; this.d = d;}
  }

  static class Link {
    Item itm;
    Link next;
    Link(Item itm, Link next) {this.itm = itm; this.next = next;}
  }

  static float f(Link list) {
    float sum = 0;
    while (list != null) {
      sum += list.itm.b ? list.itm.d : 0.0;
      list = list.next;
    }
    return sum;
  }

  public static void main(String argv[]) {
    int n = Integer.parseInt(argv[0]);
    Link list = null;
    for (int i = 0; i <= n; i++) 
      list = new Link(new Item(i % 2 != 0,(float) Math.sqrt(i)),list);
    float s = f(list);
    System.out.println("sum = " + s);
  }
}
	
