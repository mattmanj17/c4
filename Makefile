
.PHONY: all clean

all: o/diff

o:
	mkdir -p o

o/hw: hw.c | o
	gcc -w -o o/hw hw.c

o/0: o/hw | o
	o/hw > o/0

o/c4: c4.c | o
	gcc -w -o o/c4 c4.c 

o/1: o/c4 hw.c | o
	o/c4 hw.c > o/1

o/diff: o/0 o/1 | o
	diff --color=auto -u o/0 o/1
	touch o/diff

clean:
	rm -rf o
