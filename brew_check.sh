#!/bin/sh

scriptname=$0

# Verify Homebrew is available
if ! command -v brew >/dev/null 2>&1; then
	echo "Error: Homebrew is required. Install it from https://brew.sh/" >&2
	exit 1
fi

display_usage() {
	printf '\nUsage: %s [OPTION]\n' "$scriptname"
	echo "Check and manage Homebrew updates."
	echo ""
	echo "Options:"
	echo "  [none]         Check for available updates"
	echo "  -i, --install  Install available updates"
	echo "  -clean         Clean Homebrew cache"
	echo "  -h, --help     Show this help message"
	printf '\n'
}

# Parameter validation
if [ $# -gt 1 ]; then
	echo "Error: Too many arguments." >&2
	display_usage
	exit 1
fi

# Handle options that don't require fetching update data
case $1 in
-h | --help)
	display_usage
	exit 0
	;;
-clean)
	brew cleanup -s && rm -rf "$(brew --cache)"
	exit 0
	;;
"" | -i | --install)
	# These require fresh package data — continue below
	;;
*)
	echo "Error: Unknown option '$1'" >&2
	display_usage
	exit 1
	;;
esac

# Fetch latest package data.
# Note: brew update syncs the local formula registry before checking for outdated
# packages. Without it, 'brew outdated' would report stale data. This is intentional
# — even a check-only run needs current data to be accurate.
brew update

brew_formula_outdated=$(brew outdated --formula)
brew_cask_outdated=$(brew outdated --cask --greedy)

if [ -n "$brew_formula_outdated" ]; then
	brew_formula_outdated_amount=$(printf '%s\n' "$brew_formula_outdated" | wc -l)
else
	brew_formula_outdated_amount=0
fi

if [ -n "$brew_cask_outdated" ]; then
	brew_cask_outdated_amount=$(printf '%s\n' "$brew_cask_outdated" | wc -l)
else
	brew_cask_outdated_amount=0
fi

list_updates() {
	if [ "$brew_formula_outdated_amount" -eq 0 ] && [ "$brew_cask_outdated_amount" -eq 0 ]; then
		echo "No updates available."
		return
	fi
	if [ "$brew_formula_outdated_amount" -ne 0 ]; then
		printf '\nAvailable formulae:\n'
		echo "$brew_formula_outdated"
	fi
	if [ "$brew_cask_outdated_amount" -ne 0 ]; then
		printf '\nAvailable applications:\n'
		echo "$brew_cask_outdated"
	fi
}

# Main logic
case $1 in
"")
	list_updates
	;;
-i | --install)
	if [ "$brew_formula_outdated_amount" -eq 0 ] && [ "$brew_cask_outdated_amount" -eq 0 ]; then
		echo "No updates available."
	else
		if [ "$brew_formula_outdated_amount" -ne 0 ]; then
			brew upgrade --formula
		fi
		if [ "$brew_cask_outdated_amount" -ne 0 ]; then
			printf '%s\n' "$brew_cask_outdated" | awk '{print $1}' | xargs -n1 brew upgrade --cask
		fi
	fi
	brew cleanup -s && rm -rf "$(brew --cache)"
	;;
esac
