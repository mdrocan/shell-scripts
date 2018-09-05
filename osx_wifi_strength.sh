#!/bin/bash

scriptname=$0

display_usage () {
	echo "Usage: $scriptname [::digit::]"
	echo "digit: Script executed this many times."
}

counter=0

test () {
	date
	/System/Library/PrivateFrameworks/Apple*.framework/Versions/Current/Resources/airport -I \
	| awk 'BEGIN{FS="\n"} /channel|CtlRSSI|SSID:/ {print}' | sed -e 's/^[ \t]*//' \
	| sed -e 's/agrCtlRSSI/Wifi dBm/' | sed -e '/BSSID/d'
	sleep 1
}

if [ $# -gt 1 ]; then
	echo "Incorrect amount of arguments. Currently accepted arguments listed below."
	display_usage
	exit 1
fi

if [ $# -eq 0 ]; then
	while true; do 
		printf "=====""\\n"
		test
	done
	exit 0
fi

if [ $# -eq 1 ]; then
	if [[ "$1" =~ ^[0-9]+$ ]]; then
		while [ $counter -lt "$1" ]; do
			printf "=====""\\n"
			test
			counter=$((counter + 1))
		done
		exit 0
	else
		echo "Incorrect input."
		display_usage
		exit 1
	fi
fi