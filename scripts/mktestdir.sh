#!/bin/bash

testDirName="${1:-"testDir"}"
shift
depth="${1:-1}"
shift

if [ -d "../tests/$testDirName" ]; then
	rm -r "../tests/$testDirName"
fi

mkdir -p ../tests/$testDirName
dirPath=$(realpath "../tests/$testDirName")

sudo mkdir -p /mnt/tempRamDir
sudo mount -t tmpfs -o size=1m tmpfs /mnt/tempRamDir # se creeaza un director temporar pe ram in locatia standard (/mnt)
tempFilePath="/mnt/tempRamDir/temp.txt"
touch $tempFilePath

targetDir=$dirPath
for (( i=1; i<=depth; i++ )); do # se creeaza depth foldere cu:
	ln -s $tempFilePath "$targetDir/broken_link" #un broken link
	ln -s "$HOME" "$targetDir/home_link" # un link functional catre folderul home al utilizatorului
	
	echo "fisier normal" > "$targetDir/normal file with spaces in name.txt" # un fisier cu spatii in nume
	ln -s "$targetDir/normal file with spaces in name.txt" "$targetDir/link with spaces in name" # un link catre acesta
	
	ln -s "$targetDir/link_B" "$targetDir/link_A" # doua linkuri care arata unul la celalalt
	ln -s "$targetDir/link_A" "$targetDir/link_B"
	
	echo "fisier normal" > "$targetDir/normal_file.txt" # un fisier text
	ln -s "$targetDir/normal_file.txt" "$targetDir/link_to_normal_file" # un link catre acesta
	ln -s "$targetDir/link_to_normal_file" "$targetDir/link_to_link_to_normal_file" #un link catre acesta
	
	echo "fisier normal" > "$targetDir/normal_file2.txt" # un fisier text
	ln -s "$targetDir/normal_file2.txt" "$targetDir/link_to_normal_file2" # un link catre acesta
	ln -s "$targetDir/link_to_normal_file2" "$targetDir/link_to_link_to_normal_file2" #un link catre acesta
	rm "$targetDir/link_to_normal_file2" # stergem linkul din mijloc. acum lantul e rupt
	
	if (( i > 1 )); then
		ln -s "$targetDir/.." "$targetDir/link_to_previous_directory" # daca depth > 1, se creeaza in fiecare folder un link catre folderul precedent
	fi
	
	if (( i < depth )); then #aici se creeaza urmatorul folder
		mkdir -p "$targetDir/next_dir$i"
		targetDir="$targetDir/next_dir$i"
	fi
	
done

sudo umount /mnt/tempRamDir # se curata directorul temporar creat pe ram, astfel toate linkurile care arata catre el devin broken
