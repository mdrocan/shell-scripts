#!/bin/sh

scriptname=$0

# Check if a virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
	echo "Error: No virtual environment is currently activated." >&2
	echo "" >&2
	echo "Please activate a virtual environment first:" >&2
	echo "  source /path/to/venv/bin/activate" >&2
	exit 1
fi

pip_cmd="$VIRTUAL_ENV/bin/pip"

if ! [ -x "$pip_cmd" ]; then
	echo "Error: pip not found at $pip_cmd" >&2
	exit 1
fi

pip_package_list() {
	available_packages=$($pip_cmd list -o)
	if [ -z "$available_packages" ]; then
		echo "No updates available."
	else
		echo "$available_packages"
	fi
}

pip_package_update() {
	$pip_cmd install --upgrade pip
	$pip_cmd list -o --no-cache-dir | sed 1,2d | awk '{print $1}' | xargs -n1 "$pip_cmd" install -U
}

display_help() {
	printf 'Usage: %s [OPTION]\n' "$scriptname"
	echo "Check and manage pip packages in the activated virtual environment."
	echo ""
	echo "Options:"
	echo "  [none]         Check for available updates"
	echo "  -i, --install  Install available updates"
	echo "  -l, --list     List all installed packages"
	echo "  -h, --help     Show this help message"
	printf '\n'
}

# Parameter validation
if [ $# -gt 1 ]; then
	echo "Error: Too many arguments." >&2
	display_help
	exit 1
fi

# Main logic
case $1 in
"")
	# No argument: check for updates
	pip_package_list
	exit 0
	;;
-i | --install)
	pip_package_update
	exit 0
	;;
-l | --list)
	$pip_cmd list
	echo "---"
	echo "Installed packages:"
	$pip_cmd list | cut -d " " -f 1 | sed 1,2d | xargs "$pip_cmd" show
	exit 0
	;;
-h | --help)
	display_help
	exit 0
	;;
*)
	echo "Error: Unknown option '$1'" >&2
	display_help
	exit 1
	;;
esac
