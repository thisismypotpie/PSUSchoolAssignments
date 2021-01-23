import java.util.*;
import java.lang.Math;

public class Example {

  static class Item {
    boolean b;
    float d;
  }

  static class Link {
    Item itm;
    int index;
  }

  static float f(List<Link> list) {
    float sum =0;
    Link current = list.get(0);
    while(current.index+1 !=list.size())
    {
      sum += current.itm.b ? current.itm.d : 0.0;
      current = list.get(current.index+1);
    }
    return sum;
  }


    static public void main (String argv[]) {
    int n = Integer.parseInt(argv[0]);
    List<Link> list = new ArrayList<Link>();
    for (int i = 1; i <= n; i++)
    {
      Link newlink = new Link();
      newlink.itm = new Item();
      newlink.itm.b = (i%2 != 0);
      newlink.itm.d = (float)(Math.sqrt(i));
      newlink.index = i-1;
      list.add(newlink);
    }
    float s = f(list);
    System.out.println("sum= "+s);
  }


}
