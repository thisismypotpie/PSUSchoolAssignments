class NumExp extends Exp {
  private int num;
  NumExp(int num) {this.num = num;}

  int eval() {
    return num;
  }
}

