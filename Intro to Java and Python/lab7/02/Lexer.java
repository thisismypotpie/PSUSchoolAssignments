import java.io.*;

/** A lexical analyzer for arithmetic expressions over integer literals.
 */
class Lexer {
  
  /** Class is parameterized by input stream 
   */
  Lexer(InputStream in) {
    this.in = in;
    nextChar();  // get initial character in place
  }

  private InputStream in;  // the input stream
  private int c; // the current character 

  /** The current token, set by nextToken().
   */
  Token token;  

  /** Characters from the input that form the current token if it is NUMBER; 
      null otherwise.
   */
  String lexeme;  

  /** Read the next token, return the corresponding enum value, and set 
      the current token (and lexeme if a NUMBER).
   */
  void nextToken() {
    while (true) {
      // skip whitespace 
      while (Character.isWhitespace(c)) 
	nextChar();
      // dispatch on next character
      lexeme = null;
      switch (c) {
      case EOF :
	token = Token.EOF;
	return;
      case '(' :
	nextChar();
	token = Token.LPAR;
	return;
      case ')' :
	nextChar();
	token = Token.RPAR;
	return;
      case '+' :
	nextChar();
	token = Token.PLUS;
	return;
      case '-' :
	nextChar();
	// might be either a signed number or a '-' operator
	if (digits()) {
	  lexeme = "-" + lexeme;
	  token = Token.NUMBER;
	} else 
	  token = Token.MINUS;
	return;
      case '*' :
	nextChar();
	token = Token.TIMES;
	return;
      case '/' :
	nextChar();
	token = Token.DIVIDE;
	return;
      case '=' :
	nextChar();
	token = Token.EQ;
	return;
      default :
	if (digits()) {
	  token = Token.NUMBER;
	  return;
	} else if (letters()) {
	  if (lexeme.equals("in")) 
	    token = Token.IN;
	  else if (lexeme.equals("let"))
	    token = Token.LET;
	  else
	    token = Token.ID;
	  return;
	} else {	     
	  System.err.println("Ignoring illegal character: " + Character.toString(c));
	  nextChar();
	}
      }
    }
  }

  /** Try to read one or more consecutive digits, returning true (and setting lexeme) if successful. 
   */
  private boolean digits() {
    if (Character.isDigit((char)c)) {
      lexeme = Character.toString(c);
      nextChar();
      while (Character.isDigit((char)c))  {
        lexeme += Character.toString(c);
	nextChar();
      }
      return true;
    } else
      return false;
  }

  /** Try to read one or more consecutive letters, returning true (and setting lexeme) if successful. 
   */
  private boolean letters() {
    if (Character.isAlphabetic((char)c)) {
      lexeme = Character.toString(c);
      nextChar();
      while (Character.isAlphabetic((char)c))  {
        lexeme += Character.toString(c);
	nextChar();
      }
      return true;
    } else
      return false;
  }
    
  private final static int EOF = -1;

  /** Read the next character (possibly EOF) into variable c.
   */
  private void nextChar() {
    try {
      c = in.read();
    } catch (IOException exn) {
      System.err.println("Lexer exception reading input: " + exn);
      System.exit(1);
    }
  }
}

