#!/usr/bin/env python3
#

import sys
import os
import shutil

def find(root,filename):
  found = []
  try:
    entries = os.scandir(root)
  except:
    print("This directory does not exist.")
    exit(0)
  for x in entries:
    if x.is_dir():
      found.extend(find(x,filename))
    if x.is_file() and x.name == filename:
      found.append(os.path.abspath(x))
  return found

def copy(found,new_dir):
  try:
    os.mkdir(new_dir)
  except:
    print("This directory already exists or the path does not exist for this directory.")
    exit(0)
  name_list = []
  for i in found:
    name_list.append(str(i).replace("/","_"))
    copy = shutil.copyfile(str(i),new_dir+"/"+name_list[len(name_list)-1])
def usage():
  print ('usage: ./find.py [--copy dirname] root file')

def main():
  if len(sys.argv) < 2: usage()
  if sys.argv[1] == '--copy':
     if len(sys.argv) < 5: usage()
     new_dir = sys.argv[2]
     root = sys.argv[3]
     filename = sys.argv[4]
     found = find(root,filename)
     for f in found:
       print(f)
     copy(found,new_dir)
  else:
     if len(sys.argv) < 3: usage()
     root = sys.argv[1]
     filename = sys.argv[2]
     found = find(root,filename)
     for f in found:
       print(f)

if __name__ == '__main__':
  main()
