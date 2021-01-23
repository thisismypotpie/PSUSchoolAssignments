class Driver {
  /** A simple driver for our parser/lexer and stack code emission, using stdin and stdout
   */
  public static void main(String argv[]) {
    Lexer lexer = new Lexer(System.in);
    Parser parser = new Parser(lexer);
    try {
      Exp exp = parser.parse();
      exp.emit();
      System.out.println("PRINTI");
      System.out.println("PUSH 10");
      System.out.println("PRINTC");
    } catch (Parser.Failure exn) {
      System.err.println("Parse failed: " + exn.getMessage());
    }
  }
}
