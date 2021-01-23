#!/usr/ben/env python3

import sys
import os.path

def main():
  # region for checking input
  if len(sys.argv) < 2:
    print("Please enter the name of an input file.")
    exit(0)
  if ".input" not in sys.argv[1]:
    print("Please enter the name of an input file.")
    exit(0)
  #endregion

  #region for opening .input file
  csv = open(os.path.abspath(sys.argv[1]))
  num_of_items = int(csv.readline())#take first line to see how many items we have.
  index = 0 #index for while loop
  lines = csv.readlines()#take the rest of the lines in the file
  items = []#list to store individual item attributes, will be a list of lists.
  totals = 0# keep track of total purchase expense to find average later.
  #endregion

  #this loop will add a list to items for each item, listing its individual attributes.
  for i in lines:
    items.append(i.split(','))

  #iterate once for each item. I chose this since I will need the index in particular.
  while index != num_of_items:
    items[index][0] = int(items[index][0]) #convert quantity to int.
    items[index][4] = float(items[index][4]) #convert price to float.
    total =str(round(items[index][0] * items[index][4],2))#get total of price * quantity and round it to have only two decimal places. Results is saved as string.
    totals += float(total)# change string result back to float and add result to running total of all purchases.
    #print("TOTAL: "+str(totals))
    items[index].append(float(total))# add final price to individual item attribute.
    #print(items[index])
    #print("")
    index+=1#iterate index and repeat loop
  totals = str(round((totals / num_of_items)*1.5,2))# take the cumulative total of purcahes, find the average * 1.5 and round to nearest two decimal places, stored as steing.
  totals = float(totals)# take average * 1.5 and convert back to float.
  #print("AVERAGE: "+str(totals))
  index = 0#reset index to zero
  bargains = []#list of bargains to put into bargain file

  # loop that will check each item's total purchase price as well as conditions and color to see if the item is a bargain.
  while index != num_of_items:
    if (items[index][2].lower() == "superior" or items[index][3].lower() == "blue") and items[index][5] <= totals : # tests criteria of bargain, that being the price being less than totals (average of all purchases *1.5) and eithe having a blue color or a superior conditin.
      bargains.append(items[index][1])
    index += 1
  #region adding to bargains
  barg_file = open(sys.argv[1].split('.')[0] +".bargains",'w')
  for i in bargains:
    barg_file.write(i+"\n")
  #endegion

if __name__ == '__main__':
  main()
