
.PHONY: all clean

all: diff.stamp

hello.elf: hello.c
	gcc -w -o $@ $<

gcc_hello.txt: hello.elf
	./hello.elf > $@

c4.elf: c4.c
	gcc -w -o $@ $<

c4_hello.txt: c4.elf hello.c
	./c4.elf hello.c > $@

diff.stamp: gcc_hello.txt c4_hello.txt
	diff --color=auto -u $^
	@touch $@

clean:
	rm -f hello.elf gcc_hello.txt c4.elf c4_hello.txt diff.stamp
