class Driver {
  /** A simple driver for our parser/lexer and stack code emission, using stdin and stdout
   */
  public static void emit(Exp exp) {
    try {
      exp.emit(Env.empty(),0);
      System.out.println("PRINTI");
      System.out.println("PUSH 10");
      System.out.println("PRINTC");
    } catch (Env.UndefinedId exn) {
      System.err.println("Emit failed: " + exn.getMessage());
    }
  }

  public static void main(String argv[]) {
    Lexer lexer = new Lexer(System.in);
    Parser parser = new Parser(lexer);
    try {
      Exp exp = parser.parse();
      emit(exp);
    } catch (Parser.Failure exn) {
      System.err.println("Parse failed: " + exn.getMessage());
    }
  }
}
