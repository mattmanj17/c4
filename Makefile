
.PHONY: all clean

all: c4.elf hello.elf

hello.elf: hello.c
	gcc -w -o hello.elf hello.c

c4.elf: c4.c
	gcc -w -o c4.elf c4.c

clean:
	rm c4.elf