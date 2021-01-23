class Driver {
  /** A simple driver for our parser/lexer, using using stdin and stdout.
   */
  public static void main(String argv[]) {
    Lexer lexer = new Lexer(System.in);
    Parser parser = new Parser(lexer,System.out);
    try {
      parser.parse();
    } catch (Parser.Failure exn) {
      System.err.println("Parse failed: " + exn.getMessage());
    }
  }
}
