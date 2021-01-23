Assignment Four Summary
After testing the loop unrolling classes for several matricies I have conlcuded that in smaller matricies unrolling by 
a factor of eight is effecienct however for larger matrices unrolling by a factor of four is the most effecient algorithm.
We have created graphs for a 12x12, 20x20, and 30x30 matrix and have discovered that while unrolled by factor eight was
the most effecient for the 12x12 matrix, the other two matricies found the most effeciency in unrolling by a factor of
four.  In all cases, both were more effecienct than not using loop unrolling.  From this we know it is important to limit
unrolling to its most effecient factor and that a larger unrolling factor does not coorilate with a more effecient program.