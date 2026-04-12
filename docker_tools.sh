#!/bin/sh

scriptname=$0

display_usage() {
	echo "Usage: $scriptname <command> [options]"
	echo ""
	echo "Commands:"
	echo "  list              : List all running containers."
	echo "  stop [-y]         : Stop all running containers. Use -y to skip confirmation."
	echo "  connect <id>      : Connect to a running container by ID."
	echo "  -h | --help       : Show this help."
	echo ""
}

list_containers() {
	running_containers="$(docker ps -q)"
	if [ -z "$running_containers" ]; then
		echo "No running containers."
	else
		echo ""
		echo "Currently running containers:"
		docker ps | head -n1 | awk '{print $1" ID", "NAME"}'
		docker ps | tail -n +2 | awk '{print $1, $2}'
		echo ""
	fi
}

stop_containers() {
	running_containers="$(docker ps -q)"
	if [ -z "$running_containers" ]; then
		echo "No running containers."
		exit 0
	fi
	if [ "$1" = "-y" ]; then
		# shellcheck disable=SC2086
		docker stop $running_containers
		exit 0
	fi
	list_containers
	printf "Stop all running containers? [y/N]: "
	read -r answer
	case "$answer" in
	y | Y)
		# shellcheck disable=SC2086
		docker stop $running_containers
		;;
	*)
		echo "Aborted."
		;;
	esac
}

connect_to_container() {
	if [ -z "$1" ]; then
		echo "Error: connect requires a CONTAINER_ID."
		echo "Usage: $scriptname connect <id>"
		exit 1
	fi
	container_id=$(docker ps --format '{{.ID}}' | awk -v id="$1" '$1 == id {print $1; exit}')
	if [ -n "$container_id" ]; then
		echo ""
		docker exec -it "$container_id" su -
		exit 0
	else
		echo ""
		echo "Given CONTAINER_ID is incorrect: $1"
		echo "List containers with: $scriptname list"
		echo ""
		exit 1
	fi
}

if [ $# -eq 0 ]; then
	display_usage
	exit 0
fi

case $1 in
list)
	if [ $# -gt 1 ]; then
		echo "Error: 'list' takes no arguments." >&2
		display_usage
		exit 1
	fi
	list_containers
	;;
stop)
	if [ $# -gt 2 ]; then
		echo "Error: 'stop' takes at most one option [-y]." >&2
		display_usage
		exit 1
	fi
	stop_containers "$2"
	;;
connect)
	if [ $# -gt 2 ]; then
		echo "Error: 'connect' takes exactly one argument: <id>." >&2
		display_usage
		exit 1
	fi
	connect_to_container "$2"
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
