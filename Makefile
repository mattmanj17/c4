
.PHONY: all clean

all: \
	o/diff_hw_0_1 \
	o/diff_hw_0_2 \
	o/diff_hw_0_3

# output dir
o:
	mkdir -p o

# executables
o/hw: hw.c | o
	gcc -w -o $@ $<
o/c4: c4.c | o
	gcc -w -o $@ $<

# should all print "hello world"
o/hw0: o/hw | o
	$< > $@
o/hw1: o/c4 hw.c | o
	$< hw.c > $@
o/hw2: o/c4 c4.c hw.c | o
	$< c4.c hw.c > $@
o/hw3: o/c4 c4.c hw.c | o
	$< c4.c c4.c hw.c > $@

# compare hw output
o/diff_hw_0_%: o/hw0 o/hw% | o
	diff -u $^
	touch $@

# nuke output dir
clean:
	rm -rf o
