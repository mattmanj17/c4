
.PHONY: all clean

all: out/diff

out:
	mkdir -p out

out/hello.elf: hello.c | out
	gcc -w -o out/hello.elf hello.c

out/0.txt: out/hello.elf | out
	out/hello.elf > out/0.txt

out/c4.elf: c4.c | out
	gcc -w -o out/c4.elf c4.c 

out/1.txt: out/c4.elf hello.c | out
	out/c4.elf hello.c > out/1.txt

out/diff: out/0.txt out/1.txt | out
	diff --color=auto -u out/0.txt out/1.txt
	touch out/diff

clean:
	rm -rf out
