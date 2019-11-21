#!/bin/sh

scriptname=$0
sniffer=$(find "/System/Library/PrivateFrameworks/" -type f -iname airport)
counter=0

display_usage () {
	echo "Usage: $scriptname [::digit::]"
	echo "digit: How many times the signal strength is re-tested."
}

show_connection () {
	date
	$sniffer -I \
	| awk 'BEGIN{FS="\n"} /channel|CtlRSSI|SSID:/ {print}' | sed -e 's/^[ \t]*//' \
	| sed -e 's/agrCtlRSSI/Wifi dBm/' | sed -e '/BSSID/d'
	echo "-------------"
}

signal_strength () {
	$sniffer -I \
	| awk 'BEGIN{FS="\n"} /agrCtlRSSI/ {print}' | sed -e 's/^[ \t]*//' \
	| sed -e 's/agrCtlRSSI/Wifi dBm/'
}

if [ $# -gt 1 ]; then
	echo "Incorrect amount of arguments.  Accepted arguments are listed below."
	display_usage
	exit 1
fi

if [ $# -eq 0 ]; then
	show_connection
	echo "Default amount of re-test loops: 5"
	while [ $counter -lt 5 ]; do
		signal_strength
		sleep 1
		counter=$((counter + 1))
	done
fi

if [ $# -eq 1 ]; then
	show_connection
	echo "Re-test loops: ""$1"""
	if [[ "$1" =~ ^[0-9]+$ ]]; then
		while [ $counter -lt "$1" ]; do
			signal_strength
			sleep 1
			counter=$((counter + 1))
		done
		exit 0
	else
		echo "Incorrect input."
		display_usage
		exit 1
	fi
fi
