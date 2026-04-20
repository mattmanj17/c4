#!/bin/sh
# see notes/sh.md for help!

# exit on first failed command.
set -e

# help message
show_help() {
	printf 'usage: %s <lhs> <rhs> <stamp>\n' "${0}"
	printf '    diff <lhs> and <rhs>; if they are equal, touch <stamp>\n'
}

# user asked for help
if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
	show_help
	exit 0
fi

# check argument count
if [ "${#}" -ne 3 ]; then
	show_help >&2
	exit 2
fi

# mktemp : create a temporary file,
# safely, and print its name.
#
# ${tmp} holds the file name.
#
tmp="$(mktemp)"

# remove ${tmp} on exit.
trap 'rm --force "${tmp}"' EXIT

# write colored, unified diff to ${tmp},
# and capture error status.
#
# status == 0 : files are the same
# status == 1 : files are different
# otherwise   : error
#
if diff --color=always --unified "${1}" "${2}" > "${tmp}"; then
	status=0
else
	status=${?}
fi

# report error, or print diff
if [ "${status}" -ne 0 ] && [ "${status}" -ne 1 ]; then
	# report error
	printf '%s\n' "diff failed with status ${status}" >&2
else
	# print truncated diff.
	#
	# if the files are the same,
	# we expect ${tmp} to be empty.
	#
	awk -v few=30 '

		# print first "few" lines, prepended with "# ".
		NR <= few {
			print "# " $0;
		}

		# if there are more than "a few" lines,
		# print a trailing "...", and exit.
		NR == few + 1 {
			print "...";
			exit 0;
		}

	' < "${tmp}"

	# update timestamp if files are the same.
	# otherwise show a red message.
	if [ "${status}" -eq 0 ]; then
		touch "${3}"
	else
		printf '\033[31m"%s" and "%s" differ!\033[0m\n' "${1}" "${2}" >&2
	fi
fi

# forward status
exit "${status}"
