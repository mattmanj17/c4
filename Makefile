
.PHONY: all clean

all: o/d01

# output dir
o:
	mkdir -p o

# executables
o/hw: hw.c | o
	gcc -w -o o/hw hw.c
o/c4: c4.c | o
	gcc -w -o o/c4 c4.c 

# should all print "hello world"
o/hw0: o/hw | o
	o/hw > o/hw0
o/hw1: o/c4 hw.c | o
	o/c4 hw.c > o/hw1
o/hw2: o/c4 c4.c hw.c | o
	o/c4 c4.c hw.c > o/hw2
o/hw3: o/c4 c4.c hw.c | o
	o/c4 c4.c c4.c hw.c > o/hw3

# compare hw output
o/d01: o/hw0 o/hw1 | o
	diff --color=auto -u o/hw0 o/hw1
	touch o/d01

clean:
	rm -rf o
