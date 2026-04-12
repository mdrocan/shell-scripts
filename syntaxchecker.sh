#!/bin/sh

scriptname=$0

shellcheck_exist() {
	type shellcheck >/dev/null 2>&1 || {
		echo >&2 "Error: shellcheck is not installed. Install with: brew install shellcheck"
		exit 1
	}
}

display_usage() {
	printf 'Usage: %s [PATH]\n' "$scriptname"
	echo "Lint all .sh files using shellcheck."
	echo ""
	echo "Arguments:"
	echo "  [none]    Lint all .sh files in the current directory"
	echo "  PATH      Lint all .sh files under the given path"
	echo "  -h        Show this help message"
	printf '\n'
}

shellcheck_exist

# Parameter validation
if [ $# -gt 1 ]; then
	echo "Error: Too many arguments." >&2
	display_usage
	exit 1
fi

case $1 in
"")
	find . -name "*.sh" -print0 | xargs -0 shellcheck
	;;
-h | --help)
	display_usage
	exit 0
	;;
*)
	if [ -e "$1" ]; then
		find "$1" -type f -name "*.sh" -print0 2>/dev/null | xargs -0 shellcheck
	else
		echo "Error: Path not found: $1" >&2
		display_usage
		exit 1
	fi
	;;
esac
