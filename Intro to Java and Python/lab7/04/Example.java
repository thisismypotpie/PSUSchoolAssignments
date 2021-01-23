class Example {
  public static void main(String[] argv) throws Env.UndefinedId {
    Env<Integer> e = Env.<Integer>empty().extend("a",1).extend("b",2).extend("a",0).extend("c",1);
    for (String s : e) 
      System.out.println (s + "=" + e.lookup(s));
  }
}
