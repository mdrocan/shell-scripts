#! /bin/bash

pip3=$(find "/usr/local/bin/" -type f -iname pip3)
#pip3=$(find "/usr/local/Cellar/python/" -type f -iname pip3)

pip3_func() {
	$pip3 install --upgrade pip
	$pip3 list --outdated --format=freeze --no-cache-dir | cut -d = -f 1 | xargs -n1 "$pip3" install -U
}

if [ -z "$pip3" ]; then 
	echo "pip3 is unset";
	exit 1
else 
	pip3_func
	exit 0
fi