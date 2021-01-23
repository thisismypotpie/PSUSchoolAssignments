class NegExp extends Exp {
  private Exp left;
  private Exp right;
  NegExp (Exp left, Exp right) {this.left = left; this.right = right;}

  int eval() {
    return -1*left.eval() + -1*right.eval();
  }
  void emit() {
    System.out.println("NEG");
  }
}
