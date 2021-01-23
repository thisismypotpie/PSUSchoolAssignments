import java.util.*;

class Range implements Iterable<Integer>{
  int low;
  int high;
  Range(int low, int high) {this.low = low; this.high = high;}
  public Iterator<Integer> iterator(){
    return new RangeIterator();
  }

  private class RangeIterator implements Iterator<Integer>{
  int at;
  RangeIterator(){at = low;}
  public boolean hasNext()
  {
    if(at > high)
    {
      return false;
    }
    else
    {
      return true;
    }
  }
  public Integer next()
  {
    int curr = at;
    at += 1;
    return curr;
  }
 }
}

