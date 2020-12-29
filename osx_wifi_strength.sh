#!/bin/sh

scriptname=$0
listener=$(find "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/" -type f -iname airport)
counter=0

display_usage () {
	echo "Usage: $scriptname []"
	echo "[empty]: Check connection signal, tested 10 times."
	echo "::digit:: How many times the signal strength is tested."
	echo "-h or --help: Help documentation."
    echo ""
}

show_connection () {
	date
	echo "Current connection:"
	$listener -I \
	| awk 'BEGIN{FS="\n"} /channel|CtlRSSI|CtlNoise|lastTxRate|SSID:/ {print}' | sed -e 's/^[ \t]*//' \
	| sed -e 's/agrCtlRSSI/Wifi dBm/g' -e 's/lastTxRate/Tx Rate/g' -e 's/agrCtlNoise/Noise level/g' | sed -e '/BSSID/d'
	echo "-------------"
}

signal_strength () {
	$listener -I \
	| awk 'BEGIN{FS="\n"} /agrCtlRSSI|CtlNoise|lastTxRate:/ {print}' | sed -e 's/^[ \t]*//' \
	| sed -e 's/agrCtlRSSI/Wifi dBm/g' -e 's/lastTxRate/Tx Rate/g' -e 's/agrCtlNoise/Noise level/g'
}

if [ $# -gt 1 ]; then
	echo "Incorrect amount of arguments. Accepted arguments are listed below."
	display_usage
	exit 1
fi

if [ $# -eq 0 ]; then
	show_connection
	echo "Connection quality, 10 test loops:"
	while [ $counter -lt 10 ]; do
		signal_strength
		echo "-------------"
		sleep 1
		counter=$((counter + 1))
	done
fi

if [ $# -eq 1 ]; then
	if [ "$1" -gt 0 ] 2>/dev/null; then
		show_connection
		echo "Re-test loops: ""$1"""
		while [ $counter -lt "$1" ]; do
			signal_strength
			echo "-------------"
			sleep 1
			counter=$((counter + 1))
		done
		exit 0
	else
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
            echo "Incorrect parameter in use. Correct parameters given in the example below."
            display_usage
            exit 1
        esac
    done
	fi
fi