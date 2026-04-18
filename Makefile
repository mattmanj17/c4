
.PHONY: all clean

all: out/diff

out:
	mkdir -p out

out/hw.elf: hw.c | out
	gcc -w -o out/hw.elf hw.c

out/0.txt: out/hw.elf | out
	out/hw.elf > out/0.txt

out/c4.elf: c4.c | out
	gcc -w -o out/c4.elf c4.c 

out/1.txt: out/c4.elf hw.c | out
	out/c4.elf hw.c > out/1.txt

out/diff: out/0.txt out/1.txt | out
	diff --color=auto -u out/0.txt out/1.txt
	touch out/diff

clean:
	rm -rf out
