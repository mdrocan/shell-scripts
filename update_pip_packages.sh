#!/bin/sh

pip3=$(find "/usr/local/bin/" -iname pip3)

pip_str="Requirement already up-to-date:"

pip3_package_update() {
	$pip3 list --outdated --format=freeze --no-cache-dir | cut -d = -f 1 | xargs -n1 "$pip3" install -U
}

pip3_update() {
	if [ "$($pip3 install --upgrade pip)" = "$pip_str" ];
		then
			pip3_package_update
			exit 0
		else
			pip3_package_update
			exit 0
		fi
}

if [ -z "$pip3" ]; then 
	echo "pip3 is unset";
	exit 1
else 
	pip3_update
	exit 0
fi