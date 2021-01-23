#!/usr/bin/env python3

import sys
import os.path

# Fill in the missing routines, using the Java versions
# from lab4/08X and 10X as prototypes.
#

#creates a dictionary where the key is the vertex and the values of each key are neighbors.
def read_integer_graph(gname):
  graph_file = open(os.path.abspath(gname+".ig"))
  lines = graph_file.readlines()
  graph = dict()
  for x in lines:
   line = x.split()
   for y in range(len(line)):
     line[y] = int(line[y])
   if len(line)>1:
     if line[0] not in graph.keys():
       graph[line[0]] = [line[1]]
     else:
       graph[line[0]].append(line[1])
  return graph

#creates a dictionary where the key is the vertex and the values of each key are neighbors.
def read_string_graph(gname, thing):
  graph_file = open(os.path.abspath(gname+".sg"))
  lines = graph_file.readlines()
  graph = dict()
  for x in lines:
   line = x.split()
   if len(line)>1:
     if line[0] not in graph.keys():
       graph[line[0]] = [line[1]]
     else:
       graph[line[0]].append(line[1])
  return graph
def write_dot_graph(gname,g):
  for x in g:
    g[x].sort()
  dot_file = open( gname+".dot","w")
  dot_file.write("graph "+gname +"{"+"\n")
  for x in g:
    for y in g[x]:
      dot_file.write('"'+str(x)+'"'+" -- "+'"'+str(y)+'"'+"\n")
  dot_file.write("}")

def usage():
  print('usage: ./graph.py [ file.ig | file.sg sep ]')
  exit(0)

def main():
  if len(sys.argv) < 2: usage()
  f = sys.argv[1]
  gname,kind = os.path.splitext(f)
  if kind == '.ig':
    if len(sys.argv) != 2: usage()
    g = read_integer_graph(gname)
  elif kind == '.sg':
    if len(sys.argv) != 3: usage()
    g = read_string_graph(gname,sys.argv[2])
  else: usage()
  write_dot_graph(gname,g)

if __name__ == '__main__':
  main()
