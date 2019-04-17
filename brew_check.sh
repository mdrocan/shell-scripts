#!/bin/bash

scriptname=$0

brew_exist () {
    type brew >/dev/null 2>&1 || { echo >&2 "Homebrew needed to utilize this program. Installation instruction: https://brew.sh/ "; exit 1; }
}

display_usage () {
    echo "Usage: $scriptname [-i]"
    echo "-i : Install upgradable packages and casks."
    echo "-clean : Cleanup cache."
    echo ""
}

health_check () {
    brew doctor
}

cleanup () {
    brew cleanup
}

brew_exist

if [ $# -eq 0 ]; then
  health_check
  brew update
  echo "Available packages:"
  brew outdated
  echo "----------"
  echo "Available apps:"
  brew cask outdated --greedy
  echo "----------"
  exit 0
else
  if [ $# -eq 1 ]; then
    while :
    do
        case $1 in
            -clean)
                cleanup
                exit 0
                ;;
            -i)
                health_check
                brew update --greedy
                brew upgrade
                brew cask outdated --greedy | cut -d = -f 1 | xargs -n1 brew cask reinstall
                cleanup
                health_check
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