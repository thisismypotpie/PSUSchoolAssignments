// Return (a) shortest path betweeen two nodes in an undirected graph.
// Can be used to play the "Kevin Bacon Game"
//
// Closely inspired by https://algs4.cs.princeton.edu/41graph/DegreesOfSeparation.java
//  Copyright © 2000–2017, Robert Sedgewick and Kevin Wayne. 


import java.io.FileReader;
import java.util.Scanner;

public class DOS {

  public static <V> void dos(Graph<V> g,V source,V target) {
    if (!g.hasVertex(source)) {
      System.out.println("Source " + source + " not in database");
      return;
    }
    if (!g.hasVertex(target)) {
      System.out.println("Target " + target + " not in database");
      return;
    }

    BreadthFirstPaths<V> bfs = new BreadthFirstPaths<V>(g,source);
    if (!bfs.hasPathTo(target)) {
      System.out.println("Source " + source + " and target " + target + " are not connected");
      return;
    }
    System.out.println("Degree of separation = " + bfs.distTo(target));
    System.out.println("Sample path:");
    for (V w : bfs.pathTo(target)) 
      System.out.println("\t" + w);
  }    
    

  public static void main(String argv[]) throws Exception {
    String filename = argv[0];
    String[] fields = filename.split("[.]");
    String graphname = fields[0];
    String graphkind = fields[1];
    if (graphkind.equals("ig")) {
      int source = Integer.parseInt(argv[1]);
      int target = Integer.parseInt(argv[2]);
      Graph<Integer> g = GraphUtils.readIntegerGraph(graphname);
      dos(g,source,target);
    } else if (graphkind.equals("sg")) {
      String delimiter = argv[1];
      String source = argv[2];
      String target = argv[3];
      Graph<String> g = GraphUtils.readStringGraph(graphname,delimiter);
      dos(g,source,target);
    }
  }


}    
    
