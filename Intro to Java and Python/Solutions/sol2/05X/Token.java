/** Tokens for the simple expression language. 
 */

enum Token {
  LPAR("("),
  RPAR(")"),
  PLUS("+"),
  MINUS("-"),
  TIMES("*"),
  DIVIDE("/"),
  TRUE("T"),
  FALSE("F"),
  AND("&"),
  OR("|"),
  NOT("~"),
  LEQ("<="),
  NUMBER("NUMBER"),
  EOF("end-of-input");

  final String rep;
    
  Token(String rep) {
    this.rep = rep;
  }
}


