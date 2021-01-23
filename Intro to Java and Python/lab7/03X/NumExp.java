class NumExp extends Exp {
  private int num;
  NumExp(int num) {this.num = num;}

     void emit(Env<Integer> env, int depth) {
       System.out.println("PUSH "+num);
    }

}

