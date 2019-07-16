#!/bin/bash

scriptname=$0

amount_of_images="$(docker images | tail -n +2 | awk 'END{print NR}')"
GB="$(docker images | tail -n +2 | awk '{print $7}' | awk '/GB/ {size += $1} END {print size}')"
MB="$(docker images | tail -n +2 | awk '{print $7}' | awk '/MB/ {size += $1} END {print size}')"
MB2GB="$(docker images | tail -n +2 | awk '{print $7}' | awk '/MB/ {size += $1} END {print size/1024}')"

display_usage () {
	echo "Calculates the space used by containers."
	echo "Usage: $scriptname"
	}

if [ $# -ne 0 ]; then
	echo ""
	echo "User error. Arguments are not accepted."
	echo ""
	display_usage
	echo ""
	exit 1
fi

if [[ "$amount_of_images" -eq 0 ]]; then
	echo "Couldn't find any docker images."
	exit 0
fi

echo "Container images in total:" "$amount_of_images"
if [ -z "$GB" ]; then
	if [[ "$MB2GB" = 0.* ]]; then
		echo "Used space: ""$MB"" MB"
	 	exit 0
	else
		echo "Used space: ""$MB2GB"" GB"
		exit 0
	fi
else
	sum=$(echo "$GB" + "$MB2GB" | bc)
	echo "Used space: ""$sum"" GB"
	exit 0
fi