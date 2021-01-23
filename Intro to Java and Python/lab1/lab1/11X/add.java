import java.io.*;
class add{
  public static void main (String argv[]) throws IOException {
    final int STACK_SIZE = 1024;
    final int[] stack = new int[STACK_SIZE];
    int sp = -1;
    stack[++sp] = 1;
    stack[sp-1] = stack[sp-1] + stack[sp]; sp--;
    }
  }
