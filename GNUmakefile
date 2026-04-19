
# commands we depend on:
#
# - "mkdir -p <arg>"
#    * create the directory <arg>
#    * create missing parent directories as well
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
# - "<lhs> | <rhs>"
#    * a pipe
#    * run <lhs> and <rhs> as a pipeline
#    * connect standard output of <lhs> to standard input of <rhs>
#    * this lets <rhs> read the text produced by <lhs>
#
# - "<lhs> > <rhs>"
#    * output redirection
#    * run <lhs>
#    * send its standard output to the file <rhs>
#      instead of to the terminal
#    * if <rhs> already exists, overwrite it
#
# - "<lhs> < <rhs>"
#    * input redirection
#    * run <lhs>
#    * give it the contents of the file <rhs> as standard input
#      instead of reading from the terminal
#
# - "awk <script>"
#    * read lines from standard input, one at a time
#    * use the awk script <script> to decide what to do for each line
#    * please document awk scripts inline
#
# - "rm -rf <arg>"
#    * remove the file or directory <arg>
#    * if <arg> is a directory, remove everything inside it recursively
#    * do not prompt for confirmation
#    * ignore nonexistent files and directories

# order-only dependencies
#
# sometimes, you want to make sure a dependency is made first,
# but you do not want its timestamp alone to make the target out of date.
#
# to do that, you list it after a '|' character in the dependency list.
#
# for example, this target:
#
#    T : a b | c
#        foo a b c > T
#
# has 'a' and 'b' as normal dependencies,
# but 'c' as an order-only dependency
#
# so, make must make 'c' before making 'T', if needed,
# but a newer timestamp on 'c' does not by itself force 'T' to rebuild.

# automatic variables
#
# there are some special bits of syntax used to refer to target
# and dependency names indirectly. the ones used here are:
#
#    - $@ : the file name of the target of the rule
#
#    - $< : the file name of the first dependency
#
#    - $+ : the file names of all the dependencies,
#           separated by spaces, preserving duplicates
#           order-only dependencies are not included

# pattern rules
#
# in a target or dependency name,
# the character '%' can have a special meaning.
#
# the % in the target name matches some arbitrary text,
# and that same text is substituted into the dependency names.
#
# for example:
#
#    T_% : D_%
#        foo $< > $@
#
# says how to make targets of the form 'T_<text>'
# from matching dependencies of the form 'D_<text>'.
#
# so, if make wants to build 'T_0',
# it treats '%' as matching '0'.
# this behaves like:
#
#    T_0 : D_0
#        foo D_0 > T_0
#
# and if make wants to build 'T_1',
# it treats '%' as matching '1'.
# this behaves like:
#
#    T_1 : D_1
#        foo D_1 > T_1

# line continuations
#
# sometimes, a target definition or recipe line would be too long
# to write comfortably on one physical line.
#
# in that case, you can end a line with '\' to continue it
# onto the next line.
#
# the '\' and the following line break are treated as if they were not there.
# so, this lets one logical line be written across multiple physical lines.
#
# IMPORTANT:
# the '\' must be the last character on the line.
# trailing whitespace after '\' can break this.
#
# for example:
#
#    T : a \
#        b \
#        c
#
# is treated the same as:
#
#    T : a b c

# default target
# it has no recipe of its own
# it just lists the targets to make by default
#
all: o/diff_hw.ok

# output directory
#
# this makefile puts all generated files in 'o/'.
# targets that write to this directory must run after we create it,
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
clean:
	rm -rf o

# targets always considered out of date.
# .PHONY has no recipe of its own.
# it is just magic for listing phony targets.
.PHONY: all clean
