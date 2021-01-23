import java.util.*;

class  AdjSetGraph<V> implements Graph<V> {
  private Map<V,Set<V>> vertices;

  // complete the implementation by adding all the methods
  // defined in the Graph interface

  // (you may also wish to add private helper methods to perform
  //  tasks that are common to several public methods)

  // useful for debugging, once methods are implemented
  public AdjSetGraph()
  {
    vertices = new HashMap<V,Set<V>>();
  }
  public void addVertex(V v)
  {
    vertices.put(v,new HashSet<V>());
  }

  public Iterable<V> vertices()
  {
        ArrayList<V> verts = new ArrayList<V>();
	Set<V>keys = vertices.keySet();
        for(V Key: keys)
	{
	  verts.add(Key);
	}
	return verts;
  }

  public int vertexCount()
  {
	return vertices.size();
  }

  public boolean hasVertex(V v)
  {
  	if(vertices.get(v)!= null)
	{
	  return true;
	}
	return false;
  }

  public void addEdge(V v1,V v2)
  {
    System.out.println("Adding "+v2+" to "+v1);
    vertices.get(v1).add(v2);
  }

  public Iterable<V> neighbors(V v)
  {
	ArrayList<V> hi_there_neighbor = new ArrayList<V>();
	Set<V>keys = vertices.get(v);
        for(V Key: keys)
	{
	  hi_there_neighbor.add(Key);
	}
	return hi_there_neighbor;
  }

  public int degree(V v)
  {
	return vertices.get(v).size();
  }
  public String toString() {
    return GraphUtils.dumpGraph(this);
  }
}



