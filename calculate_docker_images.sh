#!/bin/sh

scriptname=$0

amount_of_images="$(docker images | tail -n +2 | awk 'END{print NR}')"
GB="$(docker images | tail -n +2 | awk '{print $7}' | awk '/GB/ {size += $1} END {print size}')"
MB="$(docker images | tail -n +2 | awk '{print $7}' | awk '/MB/ {size += $1} END {print size}')"
MB2GB="$(docker images | tail -n +2 | awk '{print $7}' | awk '/MB/ {size += $1} END {print size/1024}')"

display_usage () {
	echo "Calculates the space used by containers."
	echo "Usage: $scriptname"
	echo "-h or --help for usage example."
	}

if [ $# -gt 1 ]; then
	echo ""
	echo "User error."
	echo "Incorrect amount of parameters in use."
	echo ""
	display_usage
	echo ""
	exit 1
fi

if [ $# -eq 0 ]; then
	while :
	do
	 if [ "$amount_of_images" -eq 0 ]; then
		echo "Couldn't find any docker images."
		exit 0
	 fi

	echo "Container images in total:" "$amount_of_images"
	if [ -z "$GB" ]; then
		if [ "$MB2GB" = "0.*" ]; then
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
	done
fi

if [ $# -eq 1 ]; then
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
            echo ""
			display_usage
            exit 1
        esac
    done
else
	echo ""
    echo "Incorrect parameter in use. Correct parameters given in the example below."
    display_usage
    exit 1
fi