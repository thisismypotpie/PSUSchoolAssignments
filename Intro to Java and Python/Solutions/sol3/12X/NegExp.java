class NegExp extends Exp {
  private Exp exp;
    NegExp (Exp exp) {this.exp = exp;}

  int eval() {
    return - exp.eval();
  }
}

