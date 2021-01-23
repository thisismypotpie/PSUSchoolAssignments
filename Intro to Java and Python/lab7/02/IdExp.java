class IdExp extends Exp {
    private String id;
  IdExp(String id) {this.id = id;}

  int eval(Env<Integer> env) throws Env.UndefinedId {
    return env.lookup(id);
  }
}

