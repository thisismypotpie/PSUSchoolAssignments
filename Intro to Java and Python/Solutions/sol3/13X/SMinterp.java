import java.io.*;
import java.nio.file.*;
import java.util.*;

/*

Stack machine language interpreter

To compile this program, do
    javac SMinterp.java
This produces a JVM bytecode file SMinterp.class

To run the interpreter on a stack machine program Prog.sm, do
    java SMinterp Prog

To obtain debug output as the program runs, do
    java SMinterp Prog -d 

The interpreter uses stdin and stdout to execute READC, PRINTC, and PRINTI 
commands.  It sends debug output to stderr. To redirect stderr to a file,
you can do something like the following (in the bash shell):

    java SMinterp Prog -d 2> Prog.debug

*/

class SMinterp {
  public static void main(String argv[]) throws IOException {
    String name = argv[0];   // first command line argument

    // check for optional flags as second command line argument
    if (argv.length > 1 && argv[1].equals("-d"))
      debug = true;

    // read entire source code file into array of strings
    String[] code = Files.readAllLines(Paths.get(name + ".sm")).toArray(new String[0]);

    interp(code);
  }
    
  // Interpretation

  static boolean debug = false;        // debugging off by default

  final static int STACK_SIZE = 1024;  // arbitrary, but more than enough for most reasonable programs
  final static int[] stack = new int[STACK_SIZE];
  static int sp = -1;  // top of stack

  static void interp(String[] code) throws IOException {
    for (int ip = 0; ip < code.length;) 
      ip = step(code,ip);
    if (debug) {
      System.err.print("\t--DONE--\t");
	for (int j = 0; j <= sp; j++)
	  System.err.print(stack[j] + " ");
	System.err.println();
    }
  }

  // Execute a single step
  // NB Raises uncaught exception on most errors, including bad stack manipulations, bad integer params, IO errors, etc. 
  static int step(String[] code, int ip) throws IOException {
    String fields[] = code[ip].trim().split("\\h+");  // split code line into fields at horizontal whitespace
    int used = 1;                                     // track number of fields used when processing instruction (for debugging)
    int next_ip = ip+1;                               // default next instruction
    switch (fields[0]) {
    case "PUSH": {                                    // push integer value
      int p = Integer.parseInt(fields[1]);            // value to push (can be negative)
      used = 2;
      stack[++sp] = p;
      break;
    }
    case "POP":                                       // pop top of stack
      sp--;
      break;
    case "SWAP": {                                    // swap top of stack with an internal element
      int p = Integer.parseInt(fields[1]);            // index (from 0) into stack of element to swap with (NB SWAP 0 is a no-op.)
      used = 2;
      int t = stack[sp-p];
      stack[sp-p] = stack[sp];
      stack[sp] = t;
      break;
    }
    case "DUP": {                                     // duplicate an internal element
      int p = Integer.parseInt(fields[1]);            // index (from 0) into stack of element to duplicate
      used = 2;
      int t = stack[sp-p];
      stack[++sp] = t;
      break;
    }
    case "ADD":                                       // replace top two elements of stack with their sum
      stack[sp-1] = stack[sp-1] + stack[sp];
      sp--;
      break;
    case "NEG":                                       // negate top element
      stack[sp] = - stack[sp];
      break;
    case "MUL":                                       // replace top two elements with their product
      stack[sp-1] = stack[sp-1] * stack[sp];
      sp--;
      break;
    case "DIV":                                       // replace top two elements with their integer quotient
      stack[sp-1] = stack[sp-1] / stack[sp];          // notice that order of operands matters!
      sp--;
      break;
    case "LEQ":                                       // compare top two elements and replace them with corrsponding truth value
      stack[sp-1] = stack[sp-1] <= stack[sp] ? -1 : 0; 
      sp--;
      break;
    case "NOT":                                       // bitwise complement of top element
      stack[sp] = ~ stack[sp];
      break;
    case "AND":                                       // replace top two elements with their bitwise and
      stack[sp-1] = stack[sp-1] & stack[sp];
      sp--;
      break;                 
    case "READC":                                     // read a single character and push its ASCII code (gets -1 for EOF)
      stack[++sp] = System.in.read(); 
      break;  
    case "PRINTC":                                    // pop top of stack and print character with that ASCII code
      System.out.write((byte) stack[sp--]);
      System.out.flush();
      break;
    case "PRINTI":                                    // pop top of stack and print as an integer
      System.out.print(stack[sp--]);
      System.out.flush();
      break;
    case "BEGIN":                                     // pop top of stack; if zero, skip to corresponding END instruction
      if (stack[sp--] == 0)
	next_ip = matchingEnd(code,ip) + 1;
      break;
    case "END":                                       // jump back to corresponding BEGIN instruction
      next_ip = matchingBegin(code,ip);
      break;
    default:                                          // ignore all other lines
      used = 0;
    }
    if (debug) {
      if (used > 0) {
	System.err.print(ip+"\t" + fields[0] + "\t");
	if (used > 1) 
	  System.err.print(fields[1]);
	System.err.print("\t");
	for (int j = 0; j <= sp; j++)
	  System.err.print(stack[j] + " ");
	System.err.println();
      }
    }
    return next_ip;
  }

	  
  // Find the END matching the BEGIN at ip, skipping over nested BEGIN-END sequences
  static int matchingEnd(String[] code,int ip) {
    int nested = 0;
    while (true) {
      ip++;
      String fields[] = code[ip].trim().split("\\h+");
      switch (fields[0]) {
      case "BEGIN":
	nested++;
	break; 
      case "END":
	if (nested == 0)
	  return ip;
	else
	  nested--;
	break;
      default:
	break;
      }
    }
  }
  
  // Find the BEGIN matching the END at ip, skipping over nested BEGIN-END sequences.
  static int matchingBegin(String[] code, int ip) {
    int nested = 0;
    while (true) {
      ip--;
      String fields[] = code[ip].trim().split("\\h+");
      switch (fields[0]) {
      case "END":
	nested++;
	break;
      case "BEGIN":
	if (nested == 0)
	  return ip;
	else nested--;
	break; 
      default:
	break;
      }
    }
  }

}
