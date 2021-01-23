class LetExp extends Exp {
  private String x;
  private Exp d;
  private Exp e;
  LetExp(String x, Exp d, Exp e) {this.x = x; this.d = d; this.e = e;}

  int eval(Env<Integer> env)  throws Env.UndefinedId {
    int v = d.eval(env);
    return e.eval(env.extend(x,v));
  }
}

