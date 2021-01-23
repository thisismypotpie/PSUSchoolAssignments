import java.io.*;

/** Simple recursive-descent parser for simple language of arithmetic expressions, generating SM code as output
*/

class Parser {
  
  /** Class is parameterized by lexer and output streams. 
   */
  Parser(Lexer lexer, PrintStream out) {
    this.lexer = lexer; this.out = out;
  }

  private Lexer lexer; 
  private PrintStream out;

  /** Public entry point to parser and SM generator. 
   */
  void parse() throws Failure {
    lexer.nextToken();  // get initial token in place
    // input should be a single extended expression
    parseLexpr();
    require(Token.EOF);
    // and we want to print its value
    emit("PRINTI");
    emit("PUSH 10");
    emit("PRINTC");
  }


  // primary : NUMBER
  //         : T
  //         : F
  //         | ( expr )
  private void parsePrimary() throws Failure {
    switch (lexer.token) {
    case NUMBER:
      emit("PUSH %s",lexer.lexeme);
      lexer.nextToken();
      return;
    case TRUE:
      emit("PUSH %d",-1);
      lexer.nextToken();
      return;
    case FALSE:
      emit("PUSH %d",0);
      lexer.nextToken();
      return;
    case LPAR:
      lexer.nextToken();
      parseLexpr();
      require(Token.RPAR);
      return;
    default: throw unexpectedToken();
    }
  }

  // factor : - factor
  //        : ~ factor
  //        : primary
  private void parseFactor() throws Failure {
    switch (lexer.token) {
    case MINUS:
      lexer.nextToken();
      parseFactor();
      emit("NEG");
      return;
    case NOT:
      lexer.nextToken();
      parseFactor();
      emit("NOT");
      return;
    default:
      parsePrimary();
      return;
    }
  }

  // term : term * factor
  //      | term / factor
  //      | term & factor
  //      | factor
  // to avoid left-recursion, process this as
  // term : factor { (*|/|&) factor }
  private void parseTerm() throws Failure {
    parseFactor();
    while (true) {
      switch (lexer.token) {
      case TIMES: 
	lexer.nextToken();
	parseFactor();
	emit("MUL");
	break;
      case DIVIDE:
	lexer.nextToken();
	parseFactor();
	emit("DIV");
	break;
      case AND:
	lexer.nextToken();
	parseFactor();
	emit("AND");
	break;
      default:
	return;
      }
    }
  }
  
  // expr    : expr + term
  //         | expr - term
  //         | expr '|' term
  //         | term
  // to avoid left-recursion, process this as
  // expr : term { (+|-|'|') term }
  private void parseExpr() throws Failure {
    parseTerm();
    while (true) {
      switch(lexer.token) {
      case PLUS:
	lexer.nextToken();
	parseTerm();
	emit("ADD");
	break;
      case MINUS:
	lexer.nextToken();
	parseTerm();
	emit("NEG");
	emit("ADD");
	break;
      case OR:
	lexer.nextToken();
	parseTerm();
	emit("NOT");
	emit("SWAP %d",1);
	emit ("NOT");
	emit("AND");
	emit("NOT");
	break;
      default:
	return;
      }
    }
  }


  // lexpr   : expr <= expr
  //         | expr 
  private void parseLexpr() throws Failure {
    parseExpr();
    switch(lexer.token) {
    case LEQ: 
      lexer.nextToken();
      parseExpr();
      emit("LEQ");
      return;
    default:
      return;
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

  private void emit(String s, Object... args) {
    out.printf(s,args);
    out.println();
  }
}    
