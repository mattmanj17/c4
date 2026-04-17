
.PHONY: all clean

OUT := out
CC := gcc
CFLAGS := -w

all: $(OUT)/diff.stamp

$(OUT):
	mkdir -p $@

$(OUT)/hello.elf: hello.c | $(OUT)
	$(CC) $(CFLAGS) -o $@ $<

$(OUT)/gcc_hello.txt: $(OUT)/hello.elf | $(OUT)
	$< > $@

$(OUT)/c4.elf: c4.c | $(OUT)
	$(CC) $(CFLAGS) -o $@ $<

$(OUT)/c4_hello.txt: $(OUT)/c4.elf hello.c | $(OUT)
	$^ > $@

$(OUT)/diff.stamp: $(OUT)/gcc_hello.txt $(OUT)/c4_hello.txt | $(OUT)
	diff --color=auto -u $^
	@touch $@

clean:
	rm -rf $(OUT)
