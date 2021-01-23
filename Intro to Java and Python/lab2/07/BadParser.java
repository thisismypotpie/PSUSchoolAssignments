// THIS VERSION DOES NOT WORK!

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
    // input should be a single expression
    parseExpr();
    require(Token.EOF);
    // and we want to print its value
    emit("PRINTI");
    emit("PUSH 10");
    emit("PRINTC");
  }


  // primary : NUMBER
  //         | ( expr )

  private void parsePrimary() throws Failure {
    switch (lexer.token) {
    case NUMBER:
      emit("PUSH %s",lexer.lexeme);
      lexer.nextToken();
      return;
    case LPAR:
      lexer.nextToken();
      parseExpr();
      require(Token.RPAR);
      return;
    default: throw unexpectedToken();
    }
  }

  // factor : - factor
  //        : primary

  private void parseFactor() throws Failure {
    switch (lexer.token) {
    case MINUS:
      lexer.nextToken();
      parseFactor();
      emit("NEG");
      return;
    default:
      parsePrimary();
      return;
    }
  }

  // term : term * factor
  //      | term / factor
  //      | factor
  private void parseTerm() throws Failure {
    parseTerm();
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
    default:
      return;
    }
  }

  
  // expr    : expr + term
  //         | expr - term
  //         | term
  private void parseExpr() throws Failure {
    parseExpr();
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
