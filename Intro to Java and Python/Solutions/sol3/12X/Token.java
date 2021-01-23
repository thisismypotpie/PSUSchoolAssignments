/** Tokens for the simple expression language. 
 */

enum Token {
  LPAR("("),
  RPAR(")"),
  PLUS("+"),
  MINUS("-"),
  TIMES("*"),
  DIVIDE("/"),
  NUMBER("NUMBER"),
  EOF("end-of-input");

  final String rep;
    
  Token(String rep) {
    this.rep = rep;
  }
}


