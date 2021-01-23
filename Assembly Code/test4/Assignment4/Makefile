.PHONY: clean
CFLAGS= -ansi -pedantic -O0 -Wall -fgcse

all: hw4 hw4m4 hw4m8

hw4: hw4.o mult.o
	gcc -g -o hw4 $(CFLAGS) hw4.o mult.o

hw4m4: hw4.o mult4.o
	gcc -g -o hw4m4 $(CFLAGS) hw4.o mult4.o

hw4m8: hw4.o mult8.o
	gcc -g -o hw4m8 $(CFLAGS) hw4.o mult8.o

hw4.o: hw4.c
	gcc -c -g -o hw4.o $(CFLAGS) hw4.c

mult.o: mult.c
	gcc -c -g -o mult.o $(CFLAGS) mult.c

mult4.o: mult4.c
	gcc -c -g -o mult4.o $(CFLAGS) mult4.c

mult8.o: mult8.c
	gcc -c -g -o mult8.o $(CFLAGS) mult8.c

clean:
	rm -f *.o hw4
