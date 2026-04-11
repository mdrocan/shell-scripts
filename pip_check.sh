#!/bin/sh

scriptname=$0

hw=$(uname -m)
if command -v brew >/dev/null 2>&1; then
	brew_python_prefix=$(brew --prefix python 2>/dev/null)
	for candidate in "$brew_python_prefix/bin/pip3" "$brew_python_prefix/libexec/bin/pip3"; do
		if [ -x "$candidate" ]; then
			pip3=$candidate
			break
		fi
	done
fi

if [ -z "$pip3" ] && [ "$hw" = arm64 ]; then
	for candidate in /opt/homebrew/bin/pip3 /opt/homebrew/opt/python@*/libexec/bin/pip3 /opt/homebrew/opt/python@*/bin/pip3*; do
		if [ -x "$candidate" ]; then
			pip3=$candidate
			break
		fi
	done
elif [ -z "$pip3" ] && [ "$hw" = x86_64 ]; then
	for candidate in /usr/local/bin/pip3 /usr/local/opt/python@*/libexec/bin/pip3 /usr/local/opt/python@*/bin/pip3*; do
		if [ -x "$candidate" ]; then
			pip3=$candidate
			break
		fi
	done
elif [ -z "$pip3" ] && command -v pip3 >/dev/null 2>&1; then
	pip3=$(command -v pip3)
elif [ -z "$pip3" ]; then
	echo "Unsupported architecture: $hw" >&2
	exit 1
fi

pip3_package_list() {
	available_packages=$($pip3 list -o)
	if [ -z "$available_packages" ]; then
		echo "No updates."
	else
		echo "$available_packages"
	fi
}

pip3_package_update() {
	$pip3 install --upgrade pip
	$pip3 list -o --no-cache-dir | sed 1,2d | awk '{print $1}' | xargs -n1 "$pip3" install -U
}

#help template
display_help() {
	printf '\nUsage: %s []\n' "$scriptname"
	echo "[empty]: Check for updates."
	echo "-i / --install: Install updates."
	echo "-l / --list: List installed pip packages."
	printf -- '-h / --help : Help documentation (this doc).\n\n'
}

if [ -z "$pip3" ]; then
	echo "pip3 not found in Homebrew Python installation" >&2
	exit 1
fi

while [ $# -gt 1 ]; do
	echo "Incorrect amount of parameters in use. Correct parameters given in the example below."
	display_help
	exit 1
done

if [ $# -eq 0 ]; then
	pip3_package_list
	exit 0
else
	if [ $# -eq 1 ]; then
		while :; do
			case $1 in
			-i | --install)
				pip3_package_update
				exit 0
				;;
			-l | --list)
				$pip3 list
				echo "---"
				echo "Installed packages:"
				$pip3 list | cut -d " " -f 1 | sed 1,2d | xargs "$pip3" show
				exit 0
				;;
			-h | --help)
				display_help
				exit 0
				;;
			*)
				echo "Incorrect parameter in use. Correct parameters given in the example below."
				display_help
				exit 1
				;;
			esac
		done
	else
		echo "Incorrect amount of arguments. Currently accepted arguments listed below."
		display_help
		exit 1
	fi
fi
