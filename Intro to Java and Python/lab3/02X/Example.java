class Example {

 /* static boolean f(int i) {
    boolean a;
    if (i % 2 != 0)
      a = false;
    else
      a = true;
    if (i > 0) {
      if (i <= 100)
	return (a == false) ? true : false;
      else if (i > 1000 || a == true)
	return false;
      else
	return true;
    } else
      return false;
  }

  static boolean f(int i) {
    boolean a = false;
    if (i % 2 == 0 && i <= 1000)
      a = true;
    if (i > 0 && i<= 100) {
	return (a == false) ? true : false;
       }
    if (a == true)
	return false;
   else
	return true;
  }*/

  static boolean f(int i){
    if(i%2 !=0 && i > 0 && i <=1000)
      return true;
    else
      return false;
  }
  public static void main(String argv[]) {
    int i = Integer.parseInt(argv[0]);
    boolean b = f(i);
    System.out.println(b);
  }
}
