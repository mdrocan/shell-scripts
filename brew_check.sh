#!/bin/sh

scriptname=$0

brew_exist () {
    type brew >/dev/null 2>&1 || { echo >&2 "Homebrew needed to utilize this program. Installation instruction: https://brew.sh/ "; exit 1; }
}

display_usage () {
    echo "Usage: $scriptname []"
    echo " [empty]: Check available updates."
    echo "-i : Install upgradable packages and casks."
    echo "-clean : Cleanup cache."
    echo "-h / --help : Help documentation."
    echo ""
}

health_check () {
    brew doctor
}

cleanup () {
    brew cleanup
}

list_updates () {
 brew update
    if [[ $(brew outdated | wc -l) -eq 0 && $(brew cask outdated --greedy | wc -l) -eq 0 ]]
        then
            exit 0
        else
            if [[ $(brew outdated | wc -l) -eq 0 ]]
                then
                    echo "Available apps:"
                    brew cask outdated --greedy
                    exit 0
                else
                    echo "Available packages:"
                    brew outdated
                    if [[ $(brew cask outdated --greedy | wc -l) -ne 0 ]]
                        then
                        echo "Available apps:"
                        brew cask outdated --greedy
                        exit 0
                        else
                        exit 0
                        fi
                exit 0
                fi
        fi
}

brew_exist

if [ $# -eq 0 ]; then
  health_check
  list_updates
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
                echo "Current state:"
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
