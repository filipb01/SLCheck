#!/bin/bash

shopt -s dotglob #pentru includerea fisierelor ascunse(cele ce incep cu '.')
follow=false #se permite analiza recursiva a link urilor sau nu


vf_broken_link() {
	if [ -z "$1"  ]; then
		return
	fi
	echo "Verific $(basename "$1")"
}
#cod intermediar,va fi inlocuit

parcurgere() {
	local dir="$1"

	for item in "$dir"/*; do

		[ -e "$item" ] || [ -L "$item" ] || continue #daca e gol,continue

		vf_broken_link "$item" #functia lui matei

		if [ -d "$item" ]; then
			if [ -L "$item" ]; then
				if [ "$follow" = true ]; then
					parcurgere "$item"
				fi
			else
				parcurgere "$item"
			fi
		fi
	done
}

if [ -z "$1" ]; then #se verifica primirea unui parametru
	echo "Va rugam sa introduceti un parametru"
	exit 1
fi

if [ ! -d "$1" ]; then #se verifica validitatea parametrului
                echo "Introduceti un director valid"
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


parcurgere "$1"
