class AddExp extends Exp {
  private Exp left;
  private Exp right;
  AddExp (Exp left, Exp right) {this.left = left; this.right = right;}

  void emit(Env<Integer> env, int depth) {
      System.out.println("ADD");
    }
}

