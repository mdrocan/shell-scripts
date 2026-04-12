#!/bin/sh

scriptname=$0

ensure_docker_ready() {
	if ! command -v docker >/dev/null 2>&1; then
		echo "Error: Docker CLI is not installed or not in PATH." >&2
		exit 1
	fi
	if ! docker info >/dev/null 2>&1; then
		echo "Error: Docker daemon is not reachable. Start Docker and try again." >&2
		exit 1
	fi
}

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
		echo "CONTAINER ID NAME"
		docker ps --format '{{.ID}} {{.Names}}'
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
		if docker exec "$container_id" bash -lc 'exit 0' >/dev/null 2>&1; then
			docker exec -it "$container_id" bash
			exit 0
		fi
		if docker exec "$container_id" sh -c 'exit 0' >/dev/null 2>&1; then
			docker exec -it "$container_id" sh
			exit 0
		fi
		echo "Error: No supported shell found in container $container_id (tried bash, sh)." >&2
		exit 1
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
	ensure_docker_ready
	list_containers
	;;
stop)
	if [ $# -gt 2 ]; then
		echo "Error: 'stop' takes at most one option [-y]." >&2
		display_usage
		exit 1
	fi
	if [ $# -eq 2 ] && [ "$2" != "-y" ]; then
		echo "Error: Unknown option for 'stop': $2" >&2
		display_usage
		exit 1
	fi
	ensure_docker_ready
	stop_containers "$2"
	;;
connect)
	if [ $# -gt 2 ]; then
		echo "Error: 'connect' takes exactly one argument: <id>." >&2
		display_usage
		exit 1
	fi
	ensure_docker_ready
	connect_to_container "$2"
	;;
-h | --help)
	display_usage
	;;
*)
	echo "Error: Unknown command: $1" >&2
	display_usage
	exit 1
	;;
esac
