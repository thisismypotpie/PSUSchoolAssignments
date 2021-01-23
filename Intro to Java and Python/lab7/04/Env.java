import java.util.*;

class Env<V> implements Iterable<String> {
  static class UndefinedId extends Exception {
    UndefinedId(String id) {
      super("Undefined identifier " + id);
    }
  }
  private class Link {
    String id;
    V value;
    Link next;
    Link (String id, V value, Link next) {this.id = id; this.value = value; this.next = next;}
  }
  private Link head;
  private Env(Link head) { this.head = head; }
  static <V> Env<V> empty() {
    return new Env<V>(null);
  }
  Env<V> extend(String id, V v) {
    return new Env<V>(new Link(id,v,head));
  }
  V lookup(String id) throws UndefinedId {
    for (Link lnk = head; lnk != null; lnk = lnk.next)
      if (lnk.id.equals(id))
        return lnk.value;
    throw new UndefinedId(id);
  }
  public Iterator<String> iterator() {
    return new EnvIterator();
  }
  private class EnvIterator implements Iterator<String> {
    Link curr;
    EnvIterator() {curr = head;}
    public boolean hasNext() {
      return curr != null;
    }
    public String next() {
      if (curr != null) {
        String s = curr.id;
        curr = curr.next;
        return s;
      } else
        throw new NoSuchElementException();
    }
  }
}

