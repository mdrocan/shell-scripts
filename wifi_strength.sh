#!/bin/sh

scriptname=$0
counter=0

display_usage() {
	echo "Usage: $scriptname []"
	echo "[empty]: Check connection signal"
	echo "::digit:: How many times the signal strength is tested. Default loop 3 seconds."
	echo "-test: Looping forever (for connection testing purpose). Default loop 3 seconds."
	echo "-h or --help: Help documentation."
	echo ""
}

show_connection() {
	echo "-------------"

	# Pure shell fallback for modern macOS where airport is removed.
	# It is reliable but slower than the old airport output.
	wifi_raw=$(system_profiler SPAirPortDataType -detailLevel basic 2>/dev/null)
	section=$(echo "$wifi_raw" | awk '
		/Current Network Information:/ { found=1; next }
		found && /Other Local Wi-Fi Networks:/ { exit }
		found { print }
	')

	if [ -z "$section" ]; then
		echo "No WiFi connection detected."
		return
	fi

	date "+Time: %H:%M:%S"
	CHANNEL=$(echo "$section" | sed -n 's/^[[:space:]]*Channel: //p' | head -1)
	SIG_NOISE=$(echo "$section" | sed -n 's/^[[:space:]]*Signal \/ Noise: //p' | head -1)
	TX_RATE=$(echo "$section" | sed -n 's/^[[:space:]]*Transmit Rate: //p' | head -1)
	RSSI=$(echo "$SIG_NOISE" | awk -F' / ' '{print $1}' | awk '{print $1}')
	NOISE=$(echo "$SIG_NOISE" | awk -F' / ' '{print $2}' | awk '{print $1}')

	[ -n "$CHANNEL" ] && echo "channel: $CHANNEL"
	[ -n "$RSSI" ] && echo "Wifi dBm: $RSSI"
	[ -n "$NOISE" ] && echo "Noise level: $NOISE"
	[ -n "$TX_RATE" ] && echo "Tx Rate: $TX_RATE"

	if [ -n "$RSSI" ] && [ -n "$NOISE" ]; then
		SNR=$((RSSI - NOISE))
	else
		SNR="N/A"
	fi
	echo "SNR value: $SNR"
}

if [ $# -gt 1 ]; then
	echo "Incorrect amount of arguments. Accepted arguments are listed below."
	display_usage
	exit 1
fi

if [ $# -eq 0 ]; then
	printf "\nCurrent connection:\n"
	show_connection
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
		while :; do
			case $1 in
			-test)
				printf "\nCurrent connection:\n"
				while :; do
					show_connection
					sleep 3
				done
				exit 0
				;;
			-h | --help)
				display_usage
				exit 0
				;;
			*)
				echo "Incorrect parameter in use. Correct parameters given in the example below."
				display_usage
				exit 1
				;;
			esac
		done
	fi
fi
