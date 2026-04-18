
# a simple 'makefile' is a list of 'targets'.
#     a 'target' looks like:
#         _name_ : _deps_
#             _recipe_
#     where:
#         '_name_' is the name of the target.
#         '_deps_' is a list of dependencies.
#         '_recipe_' is a script used to make the target.
#
# when 'make' is invoked with no arguments,
# it opens this file and makes the first target.
#
# to make a target named _T_:
#
#   1. make each target named by some dependency
#
#   2. decide if _T_ is out of date.
#      _T_ is considered out of date in the following cases:
#
#      - the file named _T_ does not exist
#
#      - _T_ is listed as a phony target
#        (see .PHONY at the bottom of this file)
#
#      - there is a dependency _D_ such that
#        the file _T_ is older than a file named _D_
#
#      - there is a dependency _D_ listed as a phony target
#
#   3. if _T_ is out of date,
#      run its recipe.
#
# you can do 'make <target>' to make a specific target.

# default target
all: o/diff

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
o/diff: \
	o/diff_hw_0_1 \
	o/diff_hw_0_2 \
	o/diff_hw_0_3
	touch $@

# nuke output dir
clean:
	rm -rf o

# targets always considered 'out of date'
.PHONY: all clean