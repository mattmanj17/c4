
.PHONY: all clean

all: gcc_hello.txt c4_hello.txt

hello.elf: hello.c
	gcc -w -o hello.elf hello.c

gcc_hello.txt: hello.elf
	./hello.elf > gcc_hello.txt

c4.elf: c4.c
	gcc -w -o c4.elf c4.c

c4_hello.txt: c4.elf hello.c
	./c4.elf hello.c > c4_hello.txt

clean:
	rm hello.elf
	rm gcc_hello.txt
	rm c4.elf
	rm c4_hello.txt
