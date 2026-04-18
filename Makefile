
.PHONY: all clean

all: out/diff

out:
	mkdir -p out

out/hw: hw.c | out
	gcc -w -o out/hw hw.c

out/0: out/hw | out
	out/hw > out/0

out/c4: c4.c | out
	gcc -w -o out/c4 c4.c 

out/1: out/c4 hw.c | out
	out/c4 hw.c > out/1

out/diff: out/0 out/1 | out
	diff --color=auto -u out/0 out/1
	touch out/diff

clean:
	rm -rf out
