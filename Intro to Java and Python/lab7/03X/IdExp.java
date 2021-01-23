class IdExp extends Exp {
    private String id;
  IdExp(String id) {this.id = id;}
      void emit(Env<Integer> env, int depth) {
        System.out.println("ID");
      }
}

