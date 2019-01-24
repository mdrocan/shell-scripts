#!/bin/bash

scriptname=$0

display_usage () {
	echo "Usage: $scriptname [-y]"
	echo "-y : Stop all running containers."
}

running_containers="$(docker ps -q)"

if [ $# -eq 0 ]; then
	echo ""
	echo "Currently running containers are:"
	docker ps | head -n1 | awk '{print $1" ID", "NAME"}'
	docker ps | tail -n +2 | awk '{print $1, $2}'
	echo ""
	exit 0
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
			-h)
			display_usage
			exit 0
			;;
			--help)
			display_usage
			exit 0
			;;
			-y)
			if [ -z "$(docker ps -q)" ]; then
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
