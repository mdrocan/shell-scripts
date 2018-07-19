#!/bin/bash

scriptname=$0

shellcheck_exist () {
    type shellcheck >/dev/null 2>&1 || { echo >&2 "You need to install shellcheck to use this script."; exit 1; }
}

display_usage () {
	echo "Usage: $scriptname"
	echo "Analyzes all files with .sh filetype in the executed directory with shellcheck."
}

scripts="$(find . -name "*.sh")"
shellcheck_exist
shellcheck $scripts
