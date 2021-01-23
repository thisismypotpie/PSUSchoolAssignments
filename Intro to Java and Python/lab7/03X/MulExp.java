class MulExp extends Exp {
  private Exp left;
  private Exp right;
  MulExp (Exp left, Exp right) {this.left = left; this.right = right;}

      void emit(Env<Integer> env, int depth) {
        System.out.println("MUL");
      }
}

