class LetExp extends Exp {
  private String x;
  private Exp d;
  private Exp e;
  LetExp(String x, Exp d, Exp e) {this.x = x; this.d = d; this.e = e;}
      void emit(Env<Integer> env, int depth) {
        System.out.println("Let");
      }
}

