
# see notes/sh.md and notes/make.md for help!

.PHONY: all clean

all: .gunk
	$(MAKE) -C .gunk -f ../all.mk INDIRECT=1

.gunk:
	mkdir --parents $@

clean:
	rm --recursive --force .gunk
