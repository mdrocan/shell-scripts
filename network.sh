#!/bin/sh

scriptname=$0
listener=$(find "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/" -type f -iname airport)

display_usage() {
	echo "Usage: $scriptname [user_input]"
	echo "$scriptname : Basic information from the current connection."
	echo "$scriptname list : Lists available Wifi networks with basic details."
	echo "$scriptname reset en0 : Reset en0 (Wifi) network adapter."
	echo "$scriptname -h | --help : This help document."
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

list_adapters() {
	echo "Available network services:"
	echo "--------------------------"
	networksetup -listnetworkserviceorder | grep 'Hardware Port' | awk -F "(, )|(: )|[)]" '{print $2 ":" $4}'
	echo "--------------------------"
	show_address
}

if [ $# -eq 0 ]; then
	list_adapters
	#displays current wifi network
	wifi_network=$(networksetup -getairportnetwork en0)
	case "$wifi_network" in
	"You are not associated with an AirPort network."*) ;;
	*)
		echo "---------------------------"
		echo "$wifi_network"
		echo "---------------------------"
		;;
	esac
	echo ""
	exit 0
fi

if [ $# -eq 1 ]; then
	while :; do
		case $1 in
		"list")
			if [ -z "$listener" ]; then
				echo "airport utility not found" >&2
				exit 1
			fi
			$listener -s
			exit 0
			;;
		-h | --help)
			display_usage
			exit 0
			;;
		*)
			echo "Incorrect input."
			display_usage
			exit 1
			;;
		esac
	done
fi

if [ $# -eq 2 ]; then
	while :; do
		if [ "$1" = "reset" ]; then
			while :; do
				case $2 in
				"en0")
					if ! check_wifi "$2"; then
						exit 1
					fi
					echo "----"
					echo "Shutting down" "$2"
					sudo ifconfig "$2" down
					sleep 3
					show_address
					sleep 3
					echo "----"
					echo "Enabling " "$2"
					sudo ifconfig "$2" up
					sleep 3
					show_address
					if ! check_wifi "$2"; then
						exit 1
					fi
					exit 0
					;;
				# not implemented:
				# "en1" )
				# "en2" )
				# "en3" )
				# "bridge0" )
				*)
					echo "You didn't give the correct interface (en0) to be reset."
					exit 1
					;;
				esac
			done
		else
			echo "You didn't give a \"reset\" as a first parameter, which is the only acceptable parameter with two parameters."
			exit 1
		fi
	done
fi
