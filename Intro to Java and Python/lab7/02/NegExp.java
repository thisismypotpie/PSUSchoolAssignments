class NegExp extends Exp {
  private Exp exp;
    NegExp (Exp exp) {this.exp = exp;}

  int eval(Env<Integer> env)  throws Env.UndefinedId {
    return - exp.eval(env);
  }
}

