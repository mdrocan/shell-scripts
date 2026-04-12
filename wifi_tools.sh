#!/bin/sh

scriptname=$0
wifi_interface="en0"
counter=0

display_usage() {
	echo "Usage: $scriptname [command] [options]"
	echo ""
	echo "Commands:"
	echo "  (no args)         : Show current Wi-Fi signal."
	echo "  signal            : Show current Wi-Fi signal metrics."
	echo "  signal <n>        : Repeat signal check n times (3s interval)."
	echo "  list              : List previously-connected Wi-Fi networks."
	echo "  reset             : Reset the Wi-Fi adapter."
	echo "  -h | --help       : Show this help."
	echo ""
}

show_wifi_signal() {
	echo "-------------"
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
	ip_addr=$(ipconfig getifaddr "$wifi_interface" 2>/dev/null)
	[ -n "$ip_addr" ] && echo "IP Address: $ip_addr"
	CHANNEL=$(echo "$section" | sed -n 's/^[[:space:]]*Channel: //p' | head -1)
	SIG_NOISE=$(echo "$section" | sed -n 's/^[[:space:]]*Signal \/ Noise: //p' | head -1)
	TX_RATE=$(echo "$section" | sed -n 's/^[[:space:]]*Transmit Rate: //p' | head -1)
	RSSI=$(echo "$SIG_NOISE" | awk -F' / ' '{print $1}' | awk '{print $1}')
	NOISE=$(echo "$SIG_NOISE" | awk -F' / ' '{print $2}' | awk '{print $1}')

	[ -n "$CHANNEL" ] && echo "Channel: $CHANNEL"
	[ -n "$RSSI" ] && echo "WiFi dBm: $RSSI"
	[ -n "$NOISE" ] && echo "Noise level: $NOISE"
	[ -n "$TX_RATE" ] && echo "Tx Rate: $TX_RATE"

	if [ -n "$RSSI" ] && [ -n "$NOISE" ]; then
		SNR=$((RSSI - NOISE))
	else
		SNR="N/A"
	fi
	echo "SNR value: $SNR"
}

list_wifi_networks() {
	echo "Previously-connected Wi-Fi Networks:"
	echo "------------------------------------"
	# Show networks this machine has connected to before (not redacted by macOS)
	networksetup -listpreferredwirelessnetworks "$wifi_interface"
}

check_wifi() {
	attempt=0
	max_attempts=30
	echo "----"
	while :; do
		wifi_status=$(networksetup -getairportnetwork "$1" 2>/dev/null)
		case "$wifi_status" in
		"Current Wi-Fi Network: "*)
			return 0
			;;
		esac
		attempt=$((attempt + 1))
		if [ "$attempt" -ge "$max_attempts" ]; then
			echo "Timed out waiting for Wi-Fi association on $1" >&2
			return 1
		fi
		sleep 2
	done
}

reset_wifi() {
	# Verify the interface exists before attempting reset.
	# check_wifi is not used here because it polls for active connectivity —
	# if Wi-Fi is broken, it would time out and prevent the reset entirely.
	if ! ifconfig "$wifi_interface" >/dev/null 2>&1; then
		echo "Error: Wi-Fi interface $wifi_interface not found." >&2
		exit 1
	fi
	echo "----"
	echo "Shutting down $wifi_interface"
	sudo ifconfig "$wifi_interface" down
	sleep 3
	echo "----"
	echo "Enabling $wifi_interface"
	sudo ifconfig "$wifi_interface" up
	sleep 3
	if ! check_wifi "$wifi_interface"; then
		exit 1
	fi
}

case $1 in
"")
	show_wifi_signal
	;;
signal)
	show_wifi_signal
	if [ -n "$2" ]; then
		if [ "$2" -gt 0 ] 2>/dev/null; then
			printf "\nRepeating (%s) times with 3 second interval.\n" "$2"
			while [ $counter -lt "$2" ]; do
				sleep 3
				show_wifi_signal
				counter=$((counter + 1))
			done
		else
			echo "Error: Invalid repeat count: $2" >&2
			display_usage
			exit 1
		fi
	fi
	;;
list)
	list_wifi_networks
	;;
reset)
	if [ $# -gt 1 ]; then
		echo "Error: 'reset' takes no arguments." >&2
		display_usage
		exit 1
	fi
	reset_wifi
	;;
-h | --help)
	display_usage
	exit 0
	;;
*)
	echo "Error: Unknown command '$1'" >&2
	display_usage
	exit 1
	;;
esac
