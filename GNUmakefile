
# see the following for help!
# notes/sh.md
# notes/make.md
# notes/line_continuations.md

.PHONY: all clean
all: \
	o/diff_hw.ok \
	o/diff_c4_s_0_1.ok

clean:
	rm --recursive --force o

o:
	mkdir --parents o
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
o/c4_s_0.txt: o/c4.elf c4.c | o
	o/c4.elf -s c4.c > $@
o/c4_s_1.txt: o/c4.elf c4.c | o
	o/c4.elf -s c4.c > $@
o/diff_c4_s_0_1.ok: tools/diff-touch.sh o/c4_s_0.txt o/c4_s_1.txt | o
	$+ $@
