class MulExp extends Exp {
  private Exp left;
  private Exp right;
  MulExp (Exp left, Exp right) {this.left = left; this.right = right;}

  int eval() {
    return left.eval() * right.eval();
  }
}

