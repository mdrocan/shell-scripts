#!/bin/bash

scriptname=$0

display_usage () {
	echo "Usage: $scriptname 'file'"
	echo "'file' - File that needs to be re-written."
}


if [ $# -eq 0 ]; then
	echo "You need to define the file that should be fixed."
	display_usage
	exit 1
fi

if [ $# -gt 1 ]; then
	echo "Incorrect amount of arguments. Currently accepted arguments listed below."
	display_usage
	exit 1
fi

change () {
	if [ $# -eq 1 ]; then
		sed "s/ä/\\&auml;/g; s/ö/\\&ouml;/g; s/å/\\&aring;/g; s/Ä/\\&Auml;/g; s/Ö/\\&Ouml;/g; s/Å/\\&Aring;/g" "$1" > "$1"_changed; echo "Change done. Fixed file:" "$1"_changed
		exit 0
	fi
}

while :
do
	case $1 in
		-h)
display_usage
exit 0
;;
--help)
display_usage
exit 0
;;
*)
if [ -f "$1" ]; then
	change "$@"
else
	echo "$1" ": File not available."
	display_usage
	exit 1
fi
esac
done