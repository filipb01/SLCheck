#!/bin/bash

#shopt -s dotglob #pentru includerea fisierelor ascunse(cele ce incep cu '.')

follow=false #se permite analiza recursiva a link urilor sau nu

declare -A inodes #dictionar pentru inodes(coduri unice ale fisierelor)

vf_broken_link() {
	fileToCheck="$1"
	filename=$(basename "$fileToCheck")

	if [[ -L $fileToCheck ]]; then
		if [[ -e $fileToCheck ]]; then
			echo "$filename nu este broken!"
		else
			echo "$filename este broken!"
		fi
	fi
}
# s-a produs merge

verificari() {
	if [ -z "$1" ] || [ ! -d "$1" ]; then #se verifica primirea unui parametru
		echo "Va rugam sa introduceti un parametru"
		exit 1
	fi

	if [ -n "$2" ]; then #se verifica primirea celui de al doilea parametru
		case "$2" in

		"-follow-symlinks")
			follow=true
			;;
		*)
			echo "Al doilea parametru este invalid"
			exit 1
			;;
		esac
	fi
}

parcurgere() {
	local dir="$1"
	local inode_curent=$(stat -c %i "$dir") #selectam doar inode ul
	inodes["$inode_curent"]=1 #il marcam vizitat

	for item in "$dir"/*; do

		[ -e "$item" ] || [ -L "$item" ] || continue #daca e gol,continue

		vf_broken_link "$item" #functia lui matei

		if [ -d "$item" ]; then
			local target_inode=$(stat -L -c %i "$item") #inode pt directorul pe care vrem sa il accesam
                        if [ -z "${inodes[$target_inode]}" ]; then #daca nu a mai fost vizitat,continuam
				if [ -L "$item" ]; then
					if [ "$follow" = true ]; then
						parcurgere "$item"
					fi
				else
					parcurgere "$item"
				fi
			fi
		fi
	done
}

verificari "$1" "$2"
parcurgere "$1"
