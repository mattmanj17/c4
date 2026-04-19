
# lines starting with the character '#' are 'comments'.
# they are just there to read.
# they are treated as blank lines.

# a simple 'makefile' is a list of 'targets'.
#     a 'target' looks like:
#         name : deps
#             recipe
#     where:
#         - 'name' is the name of the target.
#         - 'deps' is a list of dependencies.
#         - 'recipe' is a script used to make the target.
#           NOTE that each line of the script must start
#           with a literal tab ('\t') character.
#
# when 'make' is invoked with no arguments,
# it opens this file and makes the first target.
#
# to make a target named T:
#
#   1. make each target named by some dependency
#
#   2. decide if T is out of date.
#      T is considered out of date in the following cases:
#
#      - the file named T does not exist
#
#      - T is listed as a phony target
#        (see .PHONY at the bottom of this file)
#
#      - there is a dependency D such that
#        the file T is older than a file named D
#
#      - there is a dependency D listed as a phony target
#
#   3. if T is out of date,
#      run its recipe.
#
# you can do 'make <target>' to make a specific target.

# recipe/script lines:
#
# the following is a useful oversimplification of how 'recipes' work.
#
# each line of a recipe/script is split into 'words'.
# that is, each chunk of text not containing 'whitespace' is its own 'word'.
# the first word is a 'command' to execute,
# and the remaining words are 'arguments' passed to that command.
#
# for example, the command 'cat' (short for 'conCATenate'):
# cat takes each argument passed to it, and tries
# to print the contents of the file named by each argument, in order.
#
# thus, "cat hw.c" would print:
#
# -#include <stdio.h>
# -
# -int main()
# -{
# -  printf("hello, world\n");
# -  return 0;
# -}
#
# and "cat hw.c hw.c" would print:
#
# -#include <stdio.h>
# -
# -int main()
# -{
# -  printf("hello, world\n");
# -  return 0;
# -}
# -#include <stdio.h>
# -
# -int main()
# -{
# -  printf("hello, world\n");
# -  return 0;
# -}
#
# 'running a script' means to run each of its lines in order.

# commands we depend on
#
# - "mkdir -p <arg>"
#    * create directory <arg>
#    * create missing parent directories as well
#
# - "gcc -w -o <out> <in>"
#    * compile the c file <in> to the command <out>
#    * ignore warnings
#
# - "diff --color=always -u <lhs> <rhs>"
#    * compare the files <lhs> and <rhs>
#    * do nothing if they are equal
#    * otherwise, fail and print a unified diff, with color
#
# - "touch <arg>"
#    * let F be 'the file named <arg>'
#    * if F does not exist, create it as an empty file
#    * set F's last-modified time to now
#
# - "printf '%s\n' <args...>"
#    * print each argument followed by a line break
#
# - "chmod +x <arg>"
#    * allows <arg> to be run directly
#    * used for shell scripts, so you can just do
#      "./foo.sh" instead of "sh ./foo.sh"
#
# - '<lhs> | <rhs>'
#    * a 'pipe'
#    * run <lhs> and <rhs>
#    * connect standard output of <lhs> to standard input of <rhs>
#    * this lets <rhs> read the text produced by <lhs>
#
# - 'awk <script>'
#    * read lines from standard input, one at a time
#    * for each input line, run the awk script <script>
#    * please document scripts inline
#
# - "rm -rf <arg>"
#    * remove the file or directory <arg>
#    * if <arg> is a directory, remove everything inside it recursively
#    * do not prompt for confirmation
#    * ignore nonexistent files and directories

# wildcards
#
# in the name/deps of a target, the character '%' has a special meaning.
# essentialy, you are allowed to have at most one % in the target name,
# and if you do, the names of dependencies may have % in them as well.
#
# the % in the target name matches arbitrary text, and that text is pasted
# into the dep names.
#
# for example, if you had a target
#
#    T_% : D_%
#        foo D_% > T_%
#
# any time you reference a target of the form 'T_*',
# it is as if you had a target named that, with % replaced with *.
#
# that is, if you referenced T_0 and T_1, it would be as if you had the rules
#
#    T_0 : D_0
#        foo D_0 > T_0
#
#    T_1 : D_1
#        foo D_1 > T_1

# order-only dependencies
#
# when you want to depend on merely the existence of a file, and not
# its time stamp, you list it after a '|' character in the dependencies
#
# that is, this target
#
#    T : a b | c
#        foo a b c > T
#
# has 'a' and 'b' as normal deps, but 'c' as an 'order-only' dependency

# 'automatic variables'
#
# there are some special bits of syntax used to reference target/dep
# names indirectly. the ones we use are:
#
#    - $@ : The file name of the target of the rule.
#
#    - $< : The name of the first dependency.
#
#    - $+ : The names of all the dependencies, with spaces between them.
#           (does not include order-only dependencies)

# 'output redirection' with '>'
#
# if you have a command that prints something,
# but you want to have that output to a file instead of just
# writing to the terminal, you can use '>' to redirect the output to a file
#
# that is:
#
#    if "cat a b" printed "a\nb\b" to the terminal,
#    you could instead do "cat a b > c" to save that
#    output to a file named 'c', instead.

# line continuations
#
# the 'name : deps' part of a target definition (and each script line),
# must all be on one line (that is, contain no line breaks).
# this is a bit of a pain when you would end up with a very long line,
# so, there a feature where you can put a '\' at the end of a line to
# 'ignore' the line break. '\' must be the very last character on the line
# (no trailing whitespace).
#
# for example:
#
#    T : a\
#        b\
#        c
#        d
#
# ends up the same as
#
#    T : a b c
#        d

# default target.
# it has no recipe of its own.
# it just lists the targets to make 'by default'.
#
all: o/diff_hw o/diff_c4_s_0_1

# output directory
#
# this makefile puts all generated files in 'o/'.
# targets that write to this directory need to run _after_ we create it,
# so they have an order-only dependency on it ("| o").
#
# run 'make clean' to remove 'o/'.
#
o:
	mkdir -p o

# ".elf" files: custom commands built from .c files
# ".elf" stands for "Executable and Linkable Format"
#
# our custom commands are:
#
#   - hw.elf
#     * prints "hello, world"
#
#   - c4.elf <src> <args>
#     * interprets the c file <src> as if it were a compiled command
#     * passes <args> to the interpreted command
#
#   - c4.elf -s <src>
#     * compiles <src> to bytecode, and prints it
#
o/%.elf: %.c | o
	gcc -w -o $@ $<

# should all print 'hello world'
o/hw0: o/hw.elf | o
	$+ > $@
o/hw1: o/c4.elf hw.c | o
	$+ > $@
o/hw2: o/c4.elf c4.c hw.c | o
	$+ > $@
o/hw3: o/c4.elf c4.c c4.c hw.c | o
	$+ > $@

# helper script to truncate output to 30 lines
#
# - #!/bin/sh
# - awk 'NR<=30{print "# " $0} NR==31{print "..."; exit}'
#
# '#!/bin/sh' marks it as a 'shell script'
#
# * NR:
#     "Number of record", that is, line number
#
# * NR<=30:
#     "for each of the first 30 lines ..."
#
# * NR<=30{print "# " $0}:
#     "print leading lines (prefixed with "# "), up to 30"
#
# * NR==31:
#     "if line 31 exists ..."
#
# * NR==31{print "..."; exit}:
#     if line 31 exists, print "...",
#     then exit the script
#
# so the whole awk script prints up to 30 leading lines of the input,
# and prints "..." if there were more lines
#
# we wrap the script in '...' instead of "...",
# to prevent expansion of '$0' by the shell before passing to awk.
#
# NOTE that we must escape '\'' inside '...',
# so that the quoted text does not end early
#
# that is, to quote "a 'b' c" in single quotes, you write
#    'a '\''b'\'' c'
# the trick is that the 5 bits
#    'a ', \', 'b', \', ' c',
# get concatenated back together to "a 'b' c"
#
# ALSO NOTE that, we have to escape '$' here,
# as it is a meta character in make.
# that is, to put a '$' in a script line, we type '$$'
#
o/trunc_30.sh: | o
	printf '%s\n' \
		'#!/bin/sh' \
		'awk '\''NR<=30{print "# " $$0} NR==31{print "..."; exit}'\''' \
		> $@
	chmod +x $@

# helper script to invoke 'diff --color=always -u $1 $2',
# truncating output
#
# - #!/bin/sh
# - diff --color=always -u "$1" "$2" > tmp.txt
# - rc=$?
# - o/trunc_30.sh < tmp.txt
# - rm tmp.txt
# - exit "$rc"
#
# we capture the output of diff in a temporary file 'tmp.txt'
#
# we cache the return code of diff in a variable to return it
# after passing tmp.txt to trunc_30.sh
#
# we clean up tmp.txt, then forward along the return code
#
o/trunc_diff.sh: o/trunc_30.sh | o
	printf '%s\n' \
		'#!/bin/sh' \
		'diff --color=always -u "$$1" "$$2" > tmp.txt' \
		'rc=$$?' \
		'o/trunc_30.sh < tmp.txt' \
		'rm tmp.txt' \
		'exit "$$rc"' \
		> $@
	chmod +x $@

# check all hw outputs match
#
# note that 'diff' does not output a file,
# so we use 'touch $@' to produce a placeholder file,
# just to keep track of the time stamp of the last successful run.
#
o/diff_hw_0_%: o/trunc_diff.sh o/hw0 o/hw% | o
	$+
	touch $@
o/diff_hw: \
	o/diff_hw_0_1 \
	o/diff_hw_0_2 \
	o/diff_hw_0_3
	touch $@

# helper script to invoke 'c4.elf -s'
#
# - #!/bin/sh
# - o/c4.elf -s "$1"
#
# 'o/c4.elf -s "$1"' invokes c4.elf -s, passing along the first script argument
#
# so, 'o/c4_s.sh hw.c' would do 'o/c4.elf -s "hw.c"'
#
o/c4_s.sh: o/c4.elf | o
	printf '%s\n' '#!/bin/sh' 'o/c4.elf -s "$$1"' > $@
	chmod +x $@

# c4 -s should be deterministic
o/c4_s_0: o/c4_s.sh c4.c | o
	$+ > $@
o/c4_s_1: o/c4_s.sh c4.c | o
	$+ > $@
o/diff_c4_s_0_1: o/trunc_diff.sh o/c4_s_0 o/c4_s_1 | o
	$+
	touch $@

# remove o/
clean:
	rm -rf o

# targets always considered out of date.
# .PHONY has no recipe of its own.
# it is just magic for listing phony targets.
.PHONY: all clean
