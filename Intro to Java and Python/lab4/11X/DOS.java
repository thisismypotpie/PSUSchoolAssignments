public class DOS {

  public static void main(String argv[]) throws Exception {
    String filename = argv[0];
    String[] fields = filename.split("[.]");
    if (fields[1].equals("ig")) {
      Graph<Integer> g = GraphUtils.readIntegerGraph(fields[0]);
      BreadthFirstPaths<Integer> checker = new BreadthFirstPaths<Integer>(g,Integer.parseInt(argv[1]));
    if(!checker.hasPathTo(Integer.parseInt(argv[2])))
	{
          System.out.println("These two verticies are not connected.");
	  return;
	}
    System.out.println("Vertex "+argv[1]+" has "+checker.distTo(Integer.parseInt(argv[2]))+ " degrees of seperation from vertex "+argv[2]+".");
    } else if (fields[1].equals("sg")) {
      Graph<String> g = GraphUtils.readStringGraph(fields[0],argv[1]);
      BreadthFirstPaths<String> checker = new BreadthFirstPaths<String>(g,argv[2]);
      if(!checker.hasPathTo(argv[3]))
      {
          System.out.println("These two verticies are not connected.");
	  return;
      }
    System.out.println("Vertex "+argv[2]+" has "+checker.distTo(argv[3])+ " degrees of seperation from vertex "+argv[3]+".");
    }

  }
}
