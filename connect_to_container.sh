#!/bin/sh

usage() {
	echo "Execute: ./connect_to_container.sh CONTAINER_ID"
}

container_id=$(docker ps --format '{{.ID}}' | awk -v id="$1" '$1 == id {print $1; exit}')

if [ $# -ne 1 ]; then
	echo ""
	echo "Invalid arguments."
	usage
	echo ""
	exit 1
else
	if [ -n "$container_id" ]; then
		echo ""
		docker exec -it "$container_id" su -
		exit 0
	else
		echo ""
		echo "Given CONTAINER_ID input is incorrect."
		echo "You used the following CONTAINER_ID: $1"
		echo "List containers with: $ docker ps"
		echo ""
		exit 1
	fi
fi
