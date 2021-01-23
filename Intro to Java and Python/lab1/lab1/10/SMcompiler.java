import java.io.*;
import java.nio.file.*;
import java.util.*;

/*

Stack machine language compiler.

To compile this program, do
    javac SMcompiler.java
This produces a JVM bytecode file SMcompiler.class

To run the compiler on Prog.sm do
    java SMcompiler Prog
This produces a file Prog.java, which can then by compiled by
    javac Prog.java
which produces a JVM bytecode file Prog.class which can be run by
    java Prog

*/

class SMcompiler {
  public static void main(String argv[]) throws IOException {
    String name = argv[0];   // command line argument

    // read entire source code file into array of strings
    String[] code = Files.readAllLines(Paths.get(name + ".sm")).toArray(new String[0]);

    try (PrintStream out = new PrintStream(Files.newOutputStream(Paths.get(name + ".java")))) {
      compile(name,code,out);
    }
  }

  // Compilation 

  static int indent;
  static PrintStream emit_out;

  // NB Raises exceptions (at compilation time or runtime) for many errors, including bad stack manipulations, bad integer params, etc. 
  static void compile(String name, String[] code, PrintStream out) {
    indent = 0;
    emit_out = out;
    emit("import java.io.*;");
    emit("class " + name + "{");
    indent++;
    emit("public static void main (String argv[]) throws IOException {");
    indent++;
    emit("final int STACK_SIZE = 1024;");
    emit("final int[] stack = new int[STACK_SIZE];");
    emit("int sp = -1;"); 
    for (String c : code) {
      String fields[] = c.trim().split("\\h+");  // split code line into fields at horizontal whitespace
      switch (fields[0]) {
      case "PUSH": emit("stack[++sp] = %d;",Integer.parseInt(fields[1])); break;
      case "POP": emit("sp--;"); break;
      case "SWAP": emit("{int t = stack[sp-%d]; stack[sp-%<d] = stack[sp]; stack[sp] = t;}",Integer.parseInt(fields[1])); break;
      case "DUP": emit("{int t = stack[sp-%d]; stack[++sp] = t;}",Integer.parseInt(fields[1]));  break; 
      case "ADD": emit("stack[sp-1] = stack[sp-1] + stack[sp]; sp--;"); break;
      case "NEG": emit("stack[sp] = - stack[sp];"); break;
      case "MUL": emit("stack[sp-1] = stack[sp-1] * stack[sp]; sp--;");  break;
      case "DIV": emit("stack[sp-1] = stack[sp-1] / stack[sp]; sp--;"); break;
      case "LEQ": emit("stack[sp-1] = stack[sp-1] <= stack[sp] ? -1 : 0; sp--;"); break;
      case "NOT": emit("stack[sp] = ~ stack[sp];"); break;
      case "AND": emit("stack[sp-1] = stack[sp-1] & stack[sp]; sp--;"); break;
      case "READC": emit("stack[++sp] = System.in.read();"); break;
      case "PRINTI": emit("System.out.print(stack[sp--]); System.out.flush();"); break;
      case "PRINTC": emit("System.out.write((byte) stack[sp--]); System.out.flush();"); break;
      case "BEGIN": emit("while (stack[sp--] != 0) {"); indent++; break;
      case "END": indent--; emit("}"); break;
      default: // ignore 
      }
    }
    emit("}");
    indent--;
    emit("}");
    indent--;
  }

  static void emit(String s, Object... args) {
    for (int i = 0; i < indent*2; i++)
      emit_out.print(" ");
    emit_out.printf(s,args);
    emit_out.println();
  }
}
