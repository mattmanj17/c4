
# see notes/sh.md and notes/make.md for help!

ifndef INDIRECT
$(error do not invoke this makefile directly)
endif

.PHONY: all
all: hw.ok s.ok

DIFF_TOUCH := ../tools/diff-touch.sh
HW_C := ../hw.c
C4_C := ../c4.c

%.elf: ../%.c
	gcc --no-warnings --output=$@ $<

# interpreting 'hw.c' with 'c4' should print 'hello world',
# even through layers of self-interpretation.
hw0.txt: hw.elf
	./$+ > $@
hw1.txt: c4.elf $(HW_C)
	./$+ > $@
hw2.txt: c4.elf $(C4_C) $(HW_C)
	./$+ > $@
hw3.txt: c4.elf $(C4_C) $(C4_C) $(HW_C)
	./$+ > $@
hw_0_%.ok: $(DIFF_TOUCH) hw0.txt hw%.txt
	$+ $@
hw.ok: hw_0_1.ok hw_0_2.ok hw_0_3.ok
	touch $@

# c4 -s prints bytecode
# c4 -s should be deterministic
s_0.txt: c4.elf $(C4_C)
	./c4.elf -s $(C4_C) > $@
s_1.txt: c4.elf $(C4_C)
	./c4.elf -s $(C4_C) > $@
s.ok: $(DIFF_TOUCH) s_0.txt s_1.txt
	$+ $@
