#!/bin/sh

scriptname=$0

hw=$(uname -m)
if [ "$hw" = x86_64 ]; then
    pip3=$(find "/usr/local/bin/" -iname pip3.11)
elif [ "$hw" = arm64 ]; then
    pip3=$(find "/opt/homebrew/opt/python@3.11/bin" -iname pip3.11)
else
    exit 1
fi
available_packages=$($pip3 list -o)

pip3_package_list() {
    if [ -z "$available_packages" ]; then
        echo "No updates."
    else
        $pip3 list -o
    fi
}

pip3_package_update() {
	$pip3 install --upgrade pip
	$pip3 list -o --no-cache-dir | sed 1,2d | awk '{print $1}'| xargs -n1 "$pip3" install -U
}

#help template
display_help () {
    printf '\nUsage: %s []\n' "$scriptname"
    echo "[empty]: Check for updates."
    echo "-i / --install: Install updates."
    echo "-l / --list: List installed pip packages."
    echo "-h / --help : Help documentation (this doc).\n"
}

if [ -z "$pip3" ]; then 
	echo "pip3 is unset";
	exit 1
fi

while [ $# -gt 1 ];
do
    echo "Incorrect amount of parameters in use. Correct parameters given in the example below."
    display_help
    exit 1
done

if [ $# -eq 0 ]; then
  pip3_package_list
  exit 0
else
  if [ $# -eq 1 ]; then
    while :
    do
        case $1 in
            -i | --install)
                pip3_package_update
                exit 0
                ;;
            -l | --list)
                $pip3 list
                echo "---"
                echo "Installed packages:"
                $pip3 list | cut -d " " -f 1 | sed 1,2d | xargs pip3 show
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
