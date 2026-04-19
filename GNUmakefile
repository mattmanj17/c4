
# commands we depend on:
#
# - "gcc -w -o <out> <in>"
#    * build the command <out> from the c file <in>
#    * ignore warnings
#
# - "diff --color=always -u <lhs> <rhs>"
#    * compare the files <lhs> and <rhs>
#    * print nothing and succeed if they are equal
#    * otherwise, fail and print a unified diff, with color
#
# - "touch <arg>"
#    * let F be the file named <arg>
#    * if F does not exist, create it as an empty file
#    * set F's last-modified time to now
#
# - "printf '%s\n' <args...>"
#    * print each argument followed by a line break
#
# - "chmod +x <arg>"
#    * mark <arg> as executable
#    * used for shell scripts, so you can just do
#      "./foo.sh" instead of "sh ./foo.sh"
#
# - "awk <script>"
#    * read lines from standard input, one at a time
#    * use the awk script <script> to decide what to do for each line
#    * please document awk scripts inline

# default target
# it has no recipe of its own
# it just lists the targets to make by default
#
all: o/diff_hw.ok

# create output directory
# --parents : no error if existing, make parent directories as needed
o:
	mkdir --parents o

# compile executables
# --no-warnings : inhibit all warnings
# --output=<file> : place output into <file>
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

# helper script to truncate output to 30 lines
#
# - #!/bin/sh
# - awk 'NR<=30{print "# " $0} NR==31{print "..."; exit}'
#
# #!/bin/sh marks it as a shell script.
#
# in awk:
#
# * NR:
#     "number of record", that is, the current input line number
#
# * NR<=30:
#     "for each of the first 30 lines ..."
#
# * NR<=30{print "# " $0}:
#     print the first 30 lines, each prefixed with "# "
#     here, '$0' means "the whole current input line"
#
# * NR==31:
#     "if line 31 exists ..."
#
# * NR==31{print "..."; exit}:
#     if line 31 exists, print "...",
#     then stop immediately
#
# so the whole awk script prints up to the first 30 lines of the input,
# and prints "..." if there were more.
#
# we wrap the script in '...' instead of "...",
# so that the shell passes '$0' to awk literally,
# rather than expanding it first.
#
# to put a literal single quote inside text that is otherwise
# single-quoted for the shell, we have to break out of the quotes,
# insert the single quote, then start single-quoting again.
#
# that is, to quote:
#    a 'b' c
# we write:
#    'a '\''b'\'' c'
#
# the five pieces:
#    'a ', \', 'b', \', ' c'
# are concatenated by the shell back into:
#    a 'b' c
#
# NOTE:
# in a make recipe, '$' is already a special character.
# so, to put a literal '$' in the generated script,
# we write '$$' in the makefile.
#
o/trunc_30.sh: | o
	printf '%s\n' \
		'#!/bin/sh' \
		'awk '\''NR<=30{print "# " $$0} NR==31{print "..."; exit}'\''' \
		> $@
	chmod +x $@

# helper script to invoke 'diff --color=always -u $1 $2',
# truncating its output
#
# - #!/bin/sh
# - tmp=$(mktemp)
# - diff --color=always -u "$1" "$2" > "$tmp"
# - rc=$?
# - o/trunc_30.sh < "$tmp"
# - rm -f "$tmp"
# - exit "$rc"
#
# we capture the output of diff in a temporary file.
#
# we cache the return code of diff in a variable,
# so that we can return it after passing its output
# through o/trunc_30.sh.
#
# we then remove the temporary file,
# and forward along the original return code.
#
o/trunc_diff.sh: o/trunc_30.sh | o
	printf '%s\n' \
		'#!/bin/sh' \
		'tmp=$$(mktemp)' \
		'diff --color=always -u "$$1" "$$2" > "$$tmp"' \
		'rc=$$?' \
		'o/trunc_30.sh < "$$tmp"' \
		'rm -f "$$tmp"' \
		'exit "$$rc"' \
		> $@
	chmod +x $@

# check that all hw outputs match
#
# note that 'diff' does not produce an output file.
# so, we use 'touch $@' to create a placeholder file,
# whose timestamp records the last successful run.
#
o/diff_hw_0_%.ok: o/trunc_diff.sh o/hw0.txt o/hw%.txt | o
	$+
	touch $@
o/diff_hw.ok: \
	o/diff_hw_0_1.ok \
	o/diff_hw_0_2.ok \
	o/diff_hw_0_3.ok
	touch $@

# helper script to invoke 'c4.elf -s'
#
# - #!/bin/sh
# - o/c4.elf -s "$1"
#
# 'o/c4.elf -s "$1"' invokes c4.elf -s,
# passing along the first script argument.
#
# so, 'o/c4_s.sh hw.c' does:
#     o/c4.elf -s "hw.c"
#
o/c4_s.sh: o/c4.elf | o
	printf '%s\n' '#!/bin/sh' 'o/c4.elf -s "$$1"' > $@
	chmod +x $@

# c4 -s should be deterministic
# :( currently fails...
o/c4_s_0.txt: o/c4_s.sh c4.c | o
	$+ > $@
o/c4_s_1.txt: o/c4_s.sh c4.c | o
	$+ > $@
o/diff_c4_s_0_1.ok: o/trunc_diff.sh o/c4_s_0.txt o/c4_s_1.txt | o
	$+
	touch $@

# remove o/
# --recursive : remove directories and their contents recursively
# --force : ignore nonexistent files and arguments, never prompt
clean:
	rm --recursive --force o

# targets always considered out of date.
# .PHONY has no recipe of its own.
# it is just magic for listing phony targets.
.PHONY: all clean
