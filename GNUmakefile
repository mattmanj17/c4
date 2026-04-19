
# lines starting with the character '#' are comments.
# they are just there to read.
# they are ignored, as if they were blank lines.

# the shell
#
# the shell is an (often interactive) program that runs commands.
#
# it reads a line of text, interprets it as a command, and runs it.
#
# for example, in a shell:
#     echo hello
# would print:
#     hello
#
# make invokes the shell to run commands specified in a makefile.

# a simple makefile is a list of targets.
#     a target looks like:
#         <name> : <deps>
#             <recipe>
#     where:
#         - <name> is the name of the target.
#
#         - <deps> is a list of dependencies.
#
#         - <recipe> is a list of shell commands used to make the target.
#            - NOTE that each line of the recipe must start
#              with a literal tab ('\t') character.
#            - ALSO NOTE that each recipe line is
#              usually run in a separate shell.
#
# when make is invoked with no arguments,
# it tries to make the first target in the
# default makefile in the current directory.
#
# with GNU make, the default makefile names are:
#   1. GNUmakefile
#   2. makefile
#   3. Makefile
# searched for in that order.
#
# to make a target named T:
#
#   1. for each dependency D,
#      if D names a target, make that target
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
#        the file named D exists,
#        and the file T is older than the file D
#
#      - a dependency D is listed as a phony target
#
#   3. if T is out of date,
#      run its recipe.
#
# you can do 'make <target>' to make a specific target.

# running recipe lines:
#
# each line of a recipe is passed to the shell.
#
# the shell splits the line into words.
#
# roughly speaking:
#   - each stretch of non-whitespace becomes a word
#   - the first word names the command to run
#   - the remaining words are arguments passed to that command
#
# this is only a rough model:
# quotes and backslashes can change how a line is split into words.
#
# for example, the command 'cat' (short for 'concatenate')
# takes file names as arguments, and tries to print each file in order.
#
# if there was a file named 'lines.txt' with the content
#
# - line 1
# - line 2
#
# 'cat lines.txt' would print
#
# - line 1
# - line 2
#
# and 'cat lines.txt lines.txt' would print
#
# - line 1
# - line 2
# - line 1
# - line 2
#
# running a recipe usually means running each of its lines in order.

# quoting
#
# in real shell syntax, spaces do not always split words.
#
# quotes let us put spaces (and other special characters) inside one word.
#
# two common kinds of quotes:
#
# - single quotes:   '...'
# - double quotes:   "..."
#
# both stop the shell from splitting a word at spaces.
#
# so:
#
#   echo hello world
#
# is three words:
#
# - echo
# - hello
# - world
#
# but:
#
#   echo "hello world"
#
# is two words:
#
# - echo
# - hello world
#
# inside '...', almost everything is treated literally.
# the only special character is the closing single quote,
# which ends the quoted text.
#
# for example:
#
#   echo '$HOME $HOME'
#
# prints:
#
# - $HOME $HOME
#
# inside "...", some characters still have special meaning.
#
# for example:
#
#   echo "$HOME $HOME"
#
# prints the value of the HOME variable twice,
# separated by a space.

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
