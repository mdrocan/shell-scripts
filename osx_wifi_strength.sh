#!/bin/sh

scriptname=$0
sniffer=$(find "/System/Library/PrivateFrameworks/" -type f -iname airport)
counter=0

display_usage () {
	echo "Usage: $scriptname []"
	echo "digit: How many times the signal strength is re-tested."
	echo "-h / --help : Help documentation."
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
	echo "Incorrect amount of arguments. Accepted arguments are listed below."
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
	if [ "$1" -gt 0 ] 2>/dev/null; then
		echo "Re-test loops: ""$1"""
		while [ $counter -lt "$1" ]; do
			show_connection
			signal_strength
			sleep 1
			counter=$((counter + 1))
		done
		exit 0
	else
	while :
    do
        case $1 in
		-h)
            echo ""
            display_usage
            exit 0
            ;;
        --help)
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
