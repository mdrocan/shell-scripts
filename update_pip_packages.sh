#! /bin/bash

pip2=$(find "/usr/local/Cellar//python@2" -type f -iname pip2)
pip3=$(find "/usr/local/Cellar/" -type f -iname pip3)

pip2_func() {
	echo "Python2 - package check"
	$pip2 list --outdated --format=freeze | cut -d = -f 1 | xargs -n1 "$pip2" install -U
	echo "Python2 - packages checked/updated"
}

pip3_func() {
	echo "Python3 - package check"
	pip3 list --outdated --format=freeze --no-cache-dir | cut -d = -f 1 | xargs -n1 "pip3" install -U
	echo "Python3 - packages checked/updated"
}

if [ -z "$pip2" ]; then 
	echo "pip2 is unset";
	pip3_func
	exit 0
else 
	echo "Python2 and pip2 found from: '$pip2'";
	pip2_func
	echo "Python3 and pip3 found from: '$pip3'";
	pip3_func
	exit 0
fi
