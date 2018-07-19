#!/bin/bash

scriptname=$0

display_usage () {
	echo "Usage: $scriptname"
	echo "Analyzes all files with .sh filetype in the executed directory with shellcheck."
}

scripts="$(find . -name "*.sh")"
shellcheck $scripts
