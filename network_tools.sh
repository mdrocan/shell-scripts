#!/bin/sh

scriptname=$0
counter=0

display_usage() {
	echo "Usage: $scriptname [command] [options]"
	echo ""
	echo "Commands:"
	echo "  (no args)         : Show network adapters, IP addresses, and current Wi-Fi."
	echo "  wifi              : Show current Wi-Fi signal strength."
	echo "  wifi <n>          : Check signal strength n times (3s interval)."
	echo "  list              : List previously-connected Wi-Fi networks."
	echo "  reset en0         : Reset the en0 (Wi-Fi) adapter."
	echo "  -h | --help       : Show this help."
	echo ""
}

show_address() {
	computer_name=$(networksetup -getcomputername)
	echo "Computer: $computer_name"
	netservices=$(networksetup -listallnetworkservices | sed 1,1d)
	echo "$netservices" | while IFS= read -r service; do
		echo "${service}: $(networksetup -getinfo "${service}" | awk '/IP address:/ { gsub("[a-z]", ""); print $3 }' | sed 's/://g')"
	done
}

list_adapters() {
	echo "Available network services:"
	echo "--------------------------"
	networksetup -listnetworkserviceorder | grep 'Hardware Port' | awk -F "(, )|(: )|[)]" '{print $2 ":" $4}'
	echo "--------------------------"
	show_address
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
	networksetup -listpreferredwirelessnetworks en0
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

reset_adapter() {
	case "$1" in
	en0)
		if ! check_wifi "$1"; then
			exit 1
		fi
		echo "----"
		echo "Shutting down $1"
		sudo ifconfig "$1" down
		sleep 3
		show_address
		sleep 3
		echo "----"
		echo "Enabling $1"
		sudo ifconfig "$1" up
		sleep 3
		show_address
		if ! check_wifi "$1"; then
			exit 1
		fi
		;;
	*)
		echo "Unsupported interface: $1. Only en0 is currently supported."
		exit 1
		;;
	esac
}

if [ $# -eq 0 ]; then
	list_adapters
	wifi_raw=$(system_profiler SPAirPortDataType -detailLevel basic 2>/dev/null)
	wifi_name=$(echo "$wifi_raw" | awk '/Current Network Information:/{found=1; next} found{gsub(/^[[:space:]]+|:[[:space:]]*$/, ""); print; exit}')
	if [ -n "$wifi_name" ]; then
		echo "---------------------------"
		echo "Current Wi-Fi Network: $wifi_name"
		echo "---------------------------"
	fi
	echo ""
	exit 0
fi

case $1 in
wifi)
	printf "\nCurrent connection:\n"
	show_wifi_signal
	if [ -n "$2" ]; then
		if [ "$2" -gt 0 ] 2>/dev/null; then
			printf "\nTest loops (%s) with 3 seconds wait time.\n" "$2"
			while [ $counter -lt "$2" ]; do
				sleep 3
				show_wifi_signal
				counter=$((counter + 1))
			done
		else
			echo "Invalid option for wifi: $2"
			display_usage
			exit 1
		fi
	fi
	;;
list)
	list_wifi_networks
	;;
reset)
	if [ -z "$2" ]; then
		echo "Error: reset requires an interface name (e.g. en0)."
		display_usage
		exit 1
	fi
	reset_adapter "$2"
	;;
-h | --help)
	display_usage
	;;
*)
	echo "Unknown command: $1"
	display_usage
	exit 1
	;;
esac
