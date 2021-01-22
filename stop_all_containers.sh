#!/bin/sh

scriptname=$0

display_usage () {
	echo "Usage: $scriptname [-y]"
	echo "-y : Stop all running containers."
}

running_containers="$(docker ps -q)"

if [ $# -lt 1 ]; then
	if [ -z "$running_containers" ]; then
		echo "No running containers."
		exit 1
	else
		echo ""
		echo "Currently running containers are:"
		docker ps | head -n1 | awk '{print $1" ID", "NAME"}'
		docker ps | tail -n +2 | awk '{print $1, $2}'
		echo ""
		display_usage
		exit 0
	fi
fi

if [ $# -gt 1 ]; then
	echo "Incorrect amount of arguments. Currently accepted arguments listed below."
	display_usage
	exit 1
fi

if [ $# -eq 1 ]; then
	while :
	do
		case $1 in
			-h | --help)
			display_usage
			exit 0
			;;
			-y)
			if [ -z "$running_containers" ]; then
				echo "No running containers."
				exit 1
			else
				docker stop "$running_containers"
			exit 0
			fi
			;;
			*)
			echo "Incorrect input."
			display_usage
			exit 1
		esac
	done
fi