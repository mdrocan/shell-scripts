#!/bin/sh

scriptname=$0
pip3=$(find "/usr/local/bin/" -iname pip3)

pip3_package_list() {
	$pip3 list
	echo "---"
	$pip3 list | cut -d " " -f 1 | sed 1,2d | xargs pip3 show
}

pip3_package_update() {
	$pip3 install --upgrade pip
	$pip3 list --outdated --format=freeze --no-cache-dir | cut -d = -f 1 | xargs -n1 "$pip3" install -U
}

#help template
display_help () {
    printf '\nUsage: %s []\n' "$scriptname"
    echo "[empty]: List installed pip packages."
    echo "-i : Install updates."
    echo "-h / --help : Help documentation (this doc).\n"
}

if [ -z "$pip3" ]; then 
	echo "pip3 is unset";
	exit 1
fi

while [ $# -gt 1 ];
do
    echo "Incorrect amount of parameters in use. Correct parameters given in the example below."
    display_usage
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
            -i)
                pip3_package_update
				exit 0
                ;;
		    -h)
        		display_help
        		exit 0
        		;;
    		--help)
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
        display_usage
        exit 1
    fi
fi