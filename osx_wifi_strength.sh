#!/bin/sh

scriptname=$0
listener=$(find "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/" -type f -iname airport)
counter=0

display_usage () {
	echo "Usage: $scriptname []"
	echo "[empty]: Check connection signal, will be tested 10 times."
	echo "::digit:: How many times the signal strength is tested."
	eccho "-test: Looping forever (for connection testing purpose)."
	echo "-h or --help: Help documentation."
    echo ""
}

show_connection () {
	echo "-------------"
	$listener -I \
	| awk 'BEGIN{FS="\n"} /channel|CtlRSSI|CtlNoise|lastTxRate|SSID:/ {print}' | sed -e 's/^[ \t]*//' \
	-e 's/agrCtlRSSI/Wifi dBm/g' -e 's/lastTxRate/Tx Rate/g' -e 's/agrCtlNoise/Noise level/g' -e '/BSSID/d'
}

if [ $# -gt 1 ]; then
	echo "Incorrect amount of arguments. Accepted arguments are listed below."
	display_usage
	exit 1
fi

if [ $# -eq 0 ]; then
    date
	printf "\nCurrent connection:\n"
	show_connection
	printf "\n10 test loops:\n"
	while [ $counter -lt 10 ]; do
	  sleep 3
	  show_connection
	  counter=$((counter + 1))
	done
fi

if [ $# -eq 1 ]; then
	if [ "$1" -gt 0 ] 2>/dev/null; then
		date
		printf "\nCurrent connection:\n"
		show_connection
		printf "\nRe-test loops:%s\n" "$1"
		while [ $counter -lt "$1" ]; do
		  sleep 3
		  show_connection
		  counter=$((counter + 1))
		done
		exit 0
	else
	while :
    do
        case $1 in
		-test)
		  date
		  printf "\nCurrent connection:\n"
		  while :
		  do
			show_connection
			sleep 3
		  done
		  exit 0
		  ;;
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