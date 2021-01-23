class Driver {
  public static int eval(Exp exp) {
    int v = 0;
    try {
      v = exp.eval(Env.empty());
    } catch (Env.UndefinedId exn) {
      System.err.println("Eval failed: " + exn.getMessage());
    }
    return v;
  }

  public static void main(String argv[]) {
    Lexer lexer = new Lexer(System.in);
    Parser parser = new Parser(lexer);
    try {
      Exp exp = parser.parse();
      System.out.println(eval(exp));
    } catch (Parser.Failure exn) {
      System.err.println("Parse failed: " + exn.getMessage());
    }
  }
}
