#!/bin/bash

scriptname=$0

display_usage () {
	echo "Usage: $scriptname"
	echo "Calculates the cotainers."
}

amount_of_images="$(docker images | tail -n +2 | awk 'END{print NR}')"

if [ $# -ne 0 ]; then
	echo ""
	echo "Invalid arguments given. No arguments accepted."
	display_usage
	echo ""
	exit 1
fi

if [[ "$amount_of_images" -eq 0 ]]; then
	exit 0
fi

GB="$(docker images | tail -n +2 | awk '{print $7}' | awk '/GB/ {size += $1} END {print size}')"
MB2GB="$(docker images | tail -n +2 | awk '{print $7}' | awk '/MB/ {size += $1} END {print size/1024}')"

echo "Container images in total:" "$amount_of_images"

if [ -z "$GB" ]; then
	echo "Used space: ""$MB2GB"" GB"
	exit 0
else
	sum=$(echo "$GB" + "$MB2GB" | bc)
	echo "Used space: ""$sum"" GB"
	exit 0
fi