class NegExp extends Exp {
  private Exp exp;
    NegExp (Exp exp) {this.exp = exp;}

  int eval() {
    return - exp.eval();
  }

  void emit() {
    exp.emit();
    System.out.println("NEG");
  }
}

