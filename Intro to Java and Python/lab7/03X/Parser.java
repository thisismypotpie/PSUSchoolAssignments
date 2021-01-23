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
      return exp;
    case ID:
      exp = new IdExp(lexer.lexeme);
      lexer.nextToken();
      return exp;
    case LET:
      lexer.nextToken();
      String id = lexer.lexeme;  // grab what we expect to be ID lexeme
      require(Token.ID);
      require(Token.EQ);
      Exp def = parseExpr();
      require(Token.IN);
      Exp body  = parseExpr();
      exp = new LetExp(id,def,body);
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
    switch (lexer.token) {
    case MINUS:
      lexer.nextToken();
      return new NegExp(parseFactor());
    default:
      return parsePrimary();
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
	exp = new MulExp(exp,parseFactor());
	break;
      case DIVIDE:
	lexer.nextToken();
	exp = new DivExp(exp,parseFactor());
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
	break;
      case MINUS:
	lexer.nextToken();
	exp = new SubExp(exp,parseTerm());
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
