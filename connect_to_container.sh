#!/bin/bash

usage () {
	echo "Execute: ./connect_to_container.sh CONTAINER_ID"
}

counter=$(docker ps | grep "$1" -c)
wanted_container=$(docker ps | grep "$1" | cut -d: -f1 | awk '{print $1}')

if [ $# -ne 1 ]; then
	echo ""
	echo "Invalid arguments."
	usage
	echo ""
	exit 1
else
	if [ "$counter" -ge "1" ]; then
		if [ "$wanted_container" = "$1" ]; then
			echo ""
			docker exec -it "$1" su -
			exit 0
		else
			echo ""
			echo "Given CONTAINER_ID input has most likely a typo."
			echo "The correct CONTAINER_ID could be: $wanted_container"
			echo "You gave the following CONTAINER_ID: $1"
			echo "List running containers with: $ docker ps"
			echo ""
			exit 1
		fi
	else
		echo ""
		echo "Given CONTAINER_ID input is incorrect."
		echo "You used the following CONTAINER_ID: $1"
		echo "List containers with: $ docker ps"
		echo ""
		exit 1
	fi
fi