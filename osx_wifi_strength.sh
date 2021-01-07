#!/bin/sh

scriptname=$0
listener=$(find "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/" -type f -iname airport)
counter=0

display_usage () {
	echo "Usage: $scriptname []"
	echo "[empty]: Check connection signal, will be tested 10 times. Default loop 3 seconds."
	echo "::digit:: How many times the signal strength is tested. Default loop 3 seconds."
	echo "-test: Looping forever (for connection testing purpose). Default loop 3 seconds."
	echo "-h or --help: Help documentation."
    echo ""
}

show_connection () {
	echo "-------------"
	date "+Time: %H:%M:%S"
	$listener -I \
	| awk 'BEGIN{FS="\n"} /channel|CtlRSSI|CtlNoise|lastTxRate|SSID:/ {print}' | sed -e 's/^[ \t]*//' \
	-e 's/agrCtlRSSI/Wifi dBm/g' -e 's/lastTxRate/Tx Rate/g' -e 's/agrCtlNoise/Noise level/g' -e '/BSSID/d'
	SNR=$($listener -I | awk 'BEGIN{FS="\n"} /CtlRSSI|CtlNoise/ {print}' | awk '{print $NF}' | awk 'NR==1{SNR = $0; next} { SNR -= $0} END {print SNR}')
	echo "SNR value: ""$SNR"
}

if [ $# -gt 1 ]; then
	echo "Incorrect amount of arguments. Accepted arguments are listed below."
	display_usage
	exit 1
fi

if [ $# -eq 0 ]; then
	printf "\nCurrent connection:\n"
	show_connection
	printf "\nTest loops (10), with 3 seconds wait time:\n"
	while [ $counter -lt 10 ]; do
	  sleep 3
	  show_connection
	  counter=$((counter + 1))
	done
fi

if [ $# -eq 1 ]; then
	if [ "$1" -gt 0 ] 2>/dev/null; then
		printf "\nCurrent connection:\n"
		show_connection
		printf "\nTest loops (%s) with 3 seconds wait time.\n" "$1"
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