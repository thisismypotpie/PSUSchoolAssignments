import java.util.*;


class Env<V> {
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
}      
  
