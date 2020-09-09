#!/bin/sh

scriptname=$0

brew_exist () {
    type brew >/dev/null 2>&1 || { echo >&2 "Homebrew needed to utilize this program. Installation instruction: https://brew.sh/ "; exit 1; }
}

brew_exist
brew doctor
brew update

display_usage () {
    echo "Usage: $scriptname []"
    echo "[empty]: Check available updates."
    echo "-i : Install upgradable packages and casks."
    echo "-clean : Cleanup cache."
    echo "-h / --help : Help documentation."
    echo ""
}

brew_outdated=$(brew outdated | wc -l)

brew_cask_outdated=$(brew outdated --cask --greedy | wc -l)

list_updates () {
    if [ "$brew_outdated" -eq 0 ] && [ "$brew_cask_outdated" -eq 0 ]
        then
            exit 0
        else
            if [ "$brew_outdated" -eq 0 ]
                then
                    echo "Available apps:"
                    brew outdated --cask --greedy
                    exit 0
                else
                    echo "Available packages and apps:"
                    brew outdated
                    if [ "$brew_cask_outdated" -ne 0 ]
                        then
                        echo "Available apps:"
                        brew outdated --cask --greedy
                        exit 0
                        else
                        exit 0
                        fi
                exit 0
                fi
        fi
}

if [ $# -eq 0 ]; then
  list_updates
  exit 0
else
  if [ $# -eq 1 ]; then
    while :
    do
        case $1 in
            -clean)
                brew cleanup
                exit 0
                ;;
            -i)
                brew update --greedy
                brew upgrade
                brew outdated --cask --greedy | cut -d = -f 1 | xargs -n1 brew cask reinstall
                brew cleanup
                echo "Current state:"
                brew doctor
                exit 0
                ;;
            -h)
                echo ""
                display_usage
                exit 0
                ;;
            --help)
                echo ""
                display_usage
                exit 0
                ;;
            *)
                echo ""
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