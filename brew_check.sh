#!/bin/sh

scriptname=$0

brew_exist () {
    type brew >/dev/null 2>&1 || { echo >&2 "Homebrew needed to utilize this program. Installation instruction: https://brew.sh/ "; exit 1; }
}

# preparation part
brew_exist
brew update
brew_outdated=$(brew outdated | wc -l)
brew_cask_outdated=$(brew outdated --cask --greedy | wc -l)

display_usage () {
    echo "\nUsage: $scriptname []"
    echo "[empty]: Check available updates (formulae and application)."
    echo "-i : Install updates (formulae and applications)."
    echo "-clean : Cleanup cache."
    echo "-h / --help : Help documentation (this doc).\n"
}

list_updates () {
    if [ "$brew_outdated" -eq 0 ] && [ "$brew_cask_outdated" -eq 0 ]
        then
            exit 0
        else
            if [ "$brew_outdated" -eq 0 ]
                then
                    echo "\nAvailable applications:"
                    brew outdated --cask --greedy
                    exit 0
                else
                    echo "\nAvailable formulae:"
                    brew outdated
                    if [ "$brew_cask_outdated" -ne 0 ]
                        then
                        echo "\nAvailable applications:"
                        brew outdated --cask --greedy
                        exit 0
                        else
                        exit 0
                        fi
                exit 0
                fi
        fi
}

#logical part
if [ $# -eq 0 ]; then
  list_updates
  exit 0
else
  if [ $# -eq 1 ]; then
    while :
    do
        case $1 in
            -clean)
                brew cleanup -s && rm -rf $(brew --cache)
                exit 0
                ;;
            -i)
                brew upgrade
                brew outdated --cask --greedy | cut -d = -f 1 | xargs -n1 brew upgrade --cask
                brew cleanup -s && rm -rf $(brew --cache)
                exit 0
                ;;
            -h)
                display_usage
                exit 0
                ;;
            --help)
                display_usage
                exit 0
                ;;
            *)
                echo "Incorrect parameter in use. Correct parameters given in the example below."
                display_usage
                exit 1
            esac
        done
    else
        echo "Incorrect amount of arguments. Currently accepted arguments listed below."
        display_usage
        exit 1
    fi
fi