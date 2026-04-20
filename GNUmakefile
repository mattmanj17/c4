
# default target
# it has no recipe of its own
# it just lists the targets to make by default
#
all: o/diff_hw.ok

# create output directory
# --parents : no error if existing, make parent directories as needed
o:
	mkdir --parents o

# compile executables
# --no-warnings : inhibit all warnings
# --output=<file> : place output into <file>
o/%.elf: %.c | o
	gcc --no-warnings --output=$@ $<

# should all print 'hello world'
o/hw0.txt: o/hw.elf | o
	$+ > $@
o/hw1.txt: o/c4.elf hw.c | o
	$+ > $@
o/hw2.txt: o/c4.elf c4.c hw.c | o
	$+ > $@
o/hw3.txt: o/c4.elf c4.c c4.c hw.c | o
	$+ > $@

# check that all hw outputs match
o/diff_hw_0_%.ok: tools/diff-touch.sh o/hw0.txt o/hw%.txt | o
	$+ $@
o/diff_hw.ok: \
	o/diff_hw_0_1.ok \
	o/diff_hw_0_2.ok \
	o/diff_hw_0_3.ok
	touch $@

# c4 -s should be deterministic
# :( currently fails...
o/c4_s_0.txt: o/c4.elf c4.c | o
	o/c4.elf -s c4.c > $@
o/c4_s_1.txt: o/c4.elf c4.c | o
	o/c4.elf -s c4.c > $@
o/diff_c4_s_0_1.ok: tools/diff-touch.sh o/c4_s_0.txt o/c4_s_1.txt | o
	$+ $@

# remove o/
# --recursive : remove directories and their contents recursively
# --force : ignore nonexistent files and arguments, never prompt
clean:
	rm --recursive --force o

# targets always considered out of date.
# .PHONY has no recipe of its own.
# it is just magic for listing phony targets.
.PHONY: all clean
