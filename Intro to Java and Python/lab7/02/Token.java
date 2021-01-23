/** Tokens for the simple expression language. 
 */

enum Token {
  LPAR("("),
  RPAR(")"),
  PLUS("+"),
  MINUS("-"),
  TIMES("*"),
  DIVIDE("/"),
  EQ("="), 
  NUMBER("NUMBER"),
  ID("ID"),
  LET("let"),
  IN("in"),
  EOF("end-of-input");

  final String rep;
    
  Token(String rep) {
    this.rep = rep;
  }
}


