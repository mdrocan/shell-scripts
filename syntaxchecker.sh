#!/bin/sh

scriptname=$0

shellcheck_exist () {
    type shellcheck >/dev/null 2>&1 || { echo >&2 "You need to install shellcheck to use this script."; exit 1; }
}

display_usage () {
	echo "Usage: $scriptname"
	echo "Analyzes all .sh files in the current directory with shellcheck."
}

shellcheck_exist

if [ $# -eq 0 ]; then
	find . -name "*\.sh" -print0 | xargs -0 shellcheck
fi

if [ $# -eq 1 ]; then
	if [ -e "$1" ]; then
		find "$1" -type f -name "*\.sh" -print0 2>/dev/null | xargs -0 shellcheck
	else
	while :
    do
        case $1 in
		-h | --help)
            echo ""
            display_usage
            exit 0
            ;;
        *)
            echo ""
            echo "Incorrect parameter in use. Correct parameters given in the example below."
            display_usage
            exit 1
        esac
    done
	fi
fi