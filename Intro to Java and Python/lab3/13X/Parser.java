import java.io.*;

/** Simple recursive-descent parser for simple language of arithmetic expressions, returning AST
*/

class Parser {

  /** Class is parameterized by lexer.
   */
  Parser(Lexer lexer) {
    this.lexer = lexer;
  }

  private Lexer lexer;

  /** Public entry point to parser and AST generator
   */
  Exp parse() throws Failure {
    Exp exp;
    lexer.nextToken();  // get initial token in place
    // input should be a single expression
    exp = parseExpr();
    require(Token.EOF);
    return exp;
  }


  // primary : NUMBER
  //         | ( expr )

  private Exp parsePrimary() throws Failure {
    Exp exp;
    switch (lexer.token) {
    case NUMBER:
      exp = new NumExp(Integer.parseInt(lexer.lexeme));
      lexer.nextToken();
      exp.emit();
      return exp;
    case LPAR:
      lexer.nextToken();
      exp = parseExpr();
      require(Token.RPAR);
      return exp;
    default: throw unexpectedToken();
    }
  }

  // factor : - factor
  //        : primary
  private Exp parseFactor() throws Failure {
   //Exp exp = parseFactor();
      //Exp exp= parsePrimary();
     Exp exp = null;
    switch (lexer.token) {
    case MINUS:
      //exp.emit();
	//lexer.nextToken();
      exp = new NegExp(exp,parseTerm());
      exp.emit();
      lexer.nextToken();
      return exp;
    default:
      return parsePrimary();
      //throw unexpectedToken();
    }
  }

  // term : term  * factor
  //      | term / factor
  //      | factor
  // to avoid left-recursion, process this as
  // term : factor { (*|/) factor }
  private Exp parseTerm() throws Failure {
    Exp exp = parseFactor();
    while (true) {
      switch (lexer.token) {
      case TIMES:
	lexer.nextToken();
        exp = new MulExp(exp,parseTerm());
        exp.emit();
	break;
      case DIVIDE:
        lexer.nextToken();
        exp = new DivExp(exp,parseTerm());
        exp.emit();
	break;
      default:
	return exp;
      }
    }
  }

  // expr    : expr + term
  //         | expr - term
  //         | term
  // to avoid left-recursion, process this as
  // expr : term { (+|-) term }
  private Exp parseExpr() throws Failure {
    Exp exp = parseTerm();
    while (true) {
      switch(lexer.token) {
      case PLUS:
	lexer.nextToken();
	exp = new AddExp(exp,parseTerm());
        exp.emit();
	break;
      case MINUS:
	lexer.nextToken();
	exp = new SubExp(exp,parseTerm());
        exp.emit();
	break;
      default:
	return exp;
      }
    }
  }

  class Failure extends Exception {
    Failure(String text) {
      super(text);
    }
  }

  private Failure unexpectedToken() {
    return new Failure("Unexpected " + lexer.token.rep);
  }

  private void require(Token tok) throws Failure {
    if (lexer.token!=tok) {
      throw new Failure("Expected " + tok.rep + " but found " + lexer.token.rep);
    }
    lexer.nextToken();
  }

}
