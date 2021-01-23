import java.util.*;

class  AdjSetGraph<V> implements Graph<V> {
  private Map<V,Set<V>> vertices;

  public AdjSetGraph() {
    vertices = new HashMap<V,Set<V>>();
  }

  public void addVertex(V v) {
    if (!vertices.containsKey(v))
      vertices.put(v,new HashSet<V>());
  }

  public boolean hasVertex(V v) {
    return vertices.containsKey(v);
  }

  public Iterable<V> vertices() {
    return vertices.keySet();
  }

  public int vertexCount() {
    return vertices.size();
  }


  private Set<V> getAdjs(V v) {
    Set<V> adjs = vertices.get(v);
    if (adjs == null)
      throw new IllegalArgumentException("vertex " + v + " is not in graph");
    return adjs;
  }

  public void addEdge(V v1,V v2) { 
    Set<V> adjs1 = getAdjs(v1);
    Set<V> adjs2 = getAdjs(v2);
    adjs1.add(v2);
    adjs2.add(v1);
  }

  public Iterable<V> neighbors(V v) {
    return getAdjs(v);
  }

  public int degree(V v) {
    return getAdjs(v).size();
  }

  // useful for debugging, once methods are implemented
  public String toString() {
    return GraphUtils.dumpGraph(this);
  }
}
  

	
