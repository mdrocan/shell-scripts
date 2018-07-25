#!/bin/bash

scriptname=$0

display_usage () {
	echo "Usage: $scriptname [-amount of rounds]"
	echo "-amount of rounds : Script executed so many times."
}

counter=0

functionality () {
	/System/Library/PrivateFrameworks/Apple*.framework/Versions/Current/Resources/airport -I \
	| awk 'BEGIN{FS="\n"} /channel|CtlRSSI|SSID:/ {print}' | sed -e "s/ //g" \
	| sed -e 's/agrCtlRSSI/Wifi dBm/' | sed -e '/BSSID/d'
	sleep 1
}

if [ $# -eq 0 ]; then
	while true; do 
	printf "=====""\\n"
	functionality
	done
	exit 0
else
	while [ $counter -lt "$1" ]; do
		printf "=====""\\n"
		functionality
		counter=$((counter + 1))
	done
	exit 0
fi
