#!/bin/bash

vf_broken_link() 
{
	fileToCheck="$1"
	filename=$(basename $fileToCheck)
	
	if [[ -L $fileToCheck ]]; then
		if [[ -e $fileToCheck ]]; then
			echo "$filename nu este broken!"
		else
			echo "$filename este broken!"
		fi
		
	else echo "$filename nu este link!"
		
	fi
}

parcurgere() {
}

if [ -z "$1" ]; then
	echo "Va rugam introduceti un parametru"
	exit 1
fi

parcurgere "$1"
