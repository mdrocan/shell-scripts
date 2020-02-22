#!/bin/sh

pip3=$(find "/usr/local/bin/" -iname pip3)

pip3_func() {
	$pip3 install --upgrade pip
	$pip3 list | cut -d " " -f 1 | sed 1,2d | xargs pip3 show
}

if [ -z "$pip3" ]; then 
	echo "pip3 is unset";
	exit 1
else 
	pip3_func
    exit 0
fi