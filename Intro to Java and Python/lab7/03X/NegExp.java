/*class NegExp extends Exp {
  private Exp exp;
    NegExp (Exp exp) {this.exp = exp;}
}*/

   /*class NegExp extends Exp {
     private Exp left;
     private Exp right;
     NegExp (Exp left, Exp right) {this.left = left; this.right = right;}*/

class NegExp extends Exp {
  private Exp exp;
    NegExp (Exp exp) {this.exp = exp;}
     void emit(Env<Integer> env, int depth) {
      System.out.println("NEG");
    }
  }

