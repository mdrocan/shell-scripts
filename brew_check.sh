#!/bin/sh

scriptname=$0

brew_exist () {
    type brew >/dev/null 2>&1 || { echo >&2 "Homebrew needed to utilize this program. Installation instruction: https://brew.sh/ "; exit 1; }
}

#help template
display_usage () {
    printf '\nUsage: %s []\n' "$scriptname"
    echo "[empty]: Check available updates (formulae and application)."
    echo "-i : Install updates (formulae and applications)."
    echo "-clean : Cleanup cache."
    echo "-h / --help : Help documentation (this doc).\n"
}

# preparation part
brew_exist

#faster help section
while [ $# -eq 1 ];
do
  case "$1" in
    -h)
        display_usage
        exit 0
        ;;
    --help)
        display_usage
        exit 0
        ;;
    -clean)
        break
        ;;
    -i)
        break
        ;;
    *)
        echo "Incorrect parameter in use. Correct parameters given in the example below."
        display_usage
        exit 1
  esac
done

while [ $# -gt 1 ];
do
    echo "Incorrect amount of parameters in use. Correct parameters given in the example below."
    display_usage
    exit 1
done

#update and calculation
brew update
brew_outdated_amount=$(brew outdated | wc -l)
brew_cask_outdated_amount=$(brew outdated --cask --greedy | wc -l)

list_updates () {
    if [ "$brew_outdated_amount" -eq 0 ] && [ "$brew_cask_outdated_amount" -eq 0 ]
        then
            exit 0
        else
            if [ "$brew_outdated_amount" -eq 0 ]
                then
                    printf '\nAvailable applications:\n'
                    brew outdated --cask --greedy
                    exit 0
                else
                    printf '\nAvailable formulae:\n'
                    brew outdated
                    if [ "$brew_cask_outdated_amount" -ne 0 ]
                        then
                            printf '\nAvailable applications:\n'
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
                brew cleanup -s && rm -rf "$(brew --cache)"
                exit 0
                ;;
            -i)
                if [ "$brew_outdated_amount" -eq 0 ] && [ "$brew_cask_outdated_amount" -eq 0 ]
                    then
                        exit 0
                    else
                        if [ "$brew_outdated_amount" -gt 0 ]
                            then
                                brew upgrade
                            elif [ "$brew_cask_outdated_amount" -gt 0 ]
                            then
                                brew outdated --cask --greedy | cut -d = -f 1 | xargs -n1 brew upgrade --cask
                            else
                                echo "something wrong"
                                exit 1
                        fi
                    brew cleanup -s && rm -rf "$(brew --cache)"
                fi
                exit 0
                ;;
            *)
                echo "Incorrect parameter in use. Correct parameters given in the example below."
                display_usage
                exit 1
                ;;
            esac
        done
    else
        echo "Incorrect amount of arguments. Currently accepted arguments listed below."
        display_usage
        exit 1
    fi
fi