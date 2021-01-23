class Driver {
  /** A simple driver for the lexer, obtaining expression text from stdin and 
      printing a list of tokens to stdout.
   */
  public static void main(String argv[]) {
    Lexer lexer = new Lexer(System.in);
    lexer.nextToken(); // get initial token in place
    while (lexer.token != Token.EOF) {
      System.out.print(lexer.token.rep);
      if (lexer.lexeme != null)
	System.out.print(" " + lexer.lexeme);
      System.out.println();
      lexer.nextToken();
    }
  }
}
