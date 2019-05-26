#!/bin/bash
unameOut="$(uname -s)"
echo -e '\033]2;'Minecraft Pack Extractor'\007'
origindir=$PWD
tmpfolder="/tmp/mcpackextractor"
# This program is designed to allow unpacking of the default Minecraft resources into a resource/texture pack.

echo -e "+---------------------------------------------------+"
echo -e "| Minecraft Pack Extractor                          |"
echo -e "| https://github.com/TheAlienDrew/MC-Pack-Extractor |"
echo -e "+---------------------------------------------------+"
echo -e "| Created by https://github.com/TheAlienDrew/       |"
echo -e "+---------------------------------------------------+"
echo -e "| * Only supports downloaded releases               |"
echo -e "+---------------------------------------------------+\n\n\n"

# Delete previous temporary folder(s) if needed
if [ ! -f ${tmpfolder} ]; then rm -rf "$tmpfolder"; fi
Minor change to tmpfolder if statement in the beginning and end

# No p7zip = Use Info-Zip
use7z=true
if ! type "7z" > /dev/null 2>&1; then
	if [ $(echo ${unameOut} | grep Linux) ]; then
		echo -e "7-Zip isn't installed, but you can install it by running \"sudo apt install p7zip\""
	elif [ $(echo ${unameOut} | grep Darwin) ]; then
		echo -e "7-Zip isn't installed, but you can install it by running \"brew install p7zip\" (if you run Homebrew)"
	else
		echo -e "Sorry, but $machine is not supported."
		read -p "Press [Enter] key to continue..." && exit
	fi
	echo -e "Would you like to use the system zip/unzip instead?\n"
	read -p "Press [Ctrl]+[C] to exit or press [Enter] key to continue..."
	echo

	use7z=false
fi

# Get Minecraft version
mcverdir=$(echo ~/.minecraft/versions | grep mine)
if [ $(echo ${unameOut} | grep Darwin) ]; then
	mcverdir=$(echo ~/Library/Application Support/minecraft/versions | grep mine)
fi
echo -e "Enter the Minecraft version you want to extract from:"
read version
echo

# Version doesn't exist = Can't run
if [[ ! -f ${mcverdir}/${version}/${version}.jar ]]; then
	echo -e "Unable to extract because that version isn't downloaded or doesn't exist."
	echo -e "Make sure to open the launcher and download the version you need to create a pack for.\n"
	read -p "Press [Enter] key to continue..." && exit
fi

# Determine pack extraction and extract the correct files from the choosen version
case "$version" in
	("1.0" | "1.1" | "1.2.1" | "1.2.2" | "1.2.3" | "1.2.4" | "1.2.5" | "1.3.1" | "1.3.2" | "1.4.2" | "1.4.4" | "1.4.5" | "1.4.6" | "1.4.7")
		echo -e "Extracting $version texture pack..."
		if ($use7z); then
			7z x "$mcverdir/$version/$version.jar" -o"$tmpfolder" pack.png pack.txt particles.png terrain.png font.txt achievement armor art environment font gui item lang misc mob terrain title -r >/dev/null 2>&1
		else
			unzip -q "$mcverdir/$version/$version.jar" pack.png pack.txt particles.png terrain.png font.txt achievement/*.* armor/*.* art/*.* environment/*.* font/*.* gui/*.* item/*.* lang/*.* misc/*.* mob/*.* terrain/*.* title/*.* -d "$tmpfolder"
		fi ;;
	("1.5.1" | "1.5.2")
		echo -e "Extracting $version texture pack..."
		if ($use7z); then
			7z x "$mcverdir/$version/$version.jar" -o"$tmpfolder" pack.png pack.txt particles.png font.txt achievement armor art environment font gui item lang misc mob textures title -r >/dev/null 2>&1
		else
			unzip -q "$mcverdir/$version/$version.jar" pack.png pack.txt particles.png font.txt achievement/*.* armor/*.* art/*.* environment/*.* font/*.* gui/*.* item/*.* lang/*.* misc/*.* mob/*.* textures/*.* title/*.* -d "$tmpfolder"
		fi ;;
	("1.6.1" | "1.6.2" | "1.6.4")
		echo -e "Extracting $version resource pack..."
		if ($use7z); then
			7z x "$mcverdir/$version/$version.jar" -o"$tmpfolder" pack.png pack.mcmeta font.txt assets/minecraft -r >/dev/null 2>&1
		else
			unzip -q "$mcverdir/$version/$version.jar" pack.png pack.mcmeta font.txt assets/minecraft/*.* -d "$tmpfolder"
		fi ;;
	("1.7.2" | "1.7.3" | "1.7.4" | "1.7.5" | "1.7.6" | "1.7.7" | "1.7.8" | "1.7.9" | "1.7.10" | "1.8" | "1.8.1" | "1.8.2" | "1.8.3" | "1.8.4" | "1.8.5" | "1.8.6" | "1.8.7" | "1.8.8" | "1.8.9" | "1.9" | "1.9.1" | "1.9.2" | "1.9.3" | "1.9.4" | "1.10" | "1.10.1" | "1.10.2" | "1.11" | "1.11.1" | "1.11.2" | "1.12" | "1.12.2" | "1.13" | "1.13.1" | "1.13.2" | "1.14" | "1.14.1") 
		echo -e "Extracting $version resource pack..."
		if ($use7z); then
			7z x "$mcverdir/$version/$version.jar" -o"$tmpfolder" pack.png pack.mcmeta assets/minecraft -r >/dev/null 2>&1
		else
			unzip -q "$mcverdir/$version/$version.jar" pack.png pack.mcmeta assets/minecraft/*.* -d "$tmpfolder"
		fi ;;
	(*)
		echo "Sorry, snapshots, pre-releases, and modded releases are not supported." ;;
esac

# ZIP the files and delete tmpfolder
echo -e "Done.\n\nPacking into zip file..."
if ($use7z); then
	7z a "$origindir/MC$version.zip" "$tmpfolder/*" >/dev/null 2>&1
else
	cd "$tmpfolder" && zip -qr "$origindir/MC$version.zip" * && cd "$origindir"
fi
echo -e "Done.\n\nCleaning up temporary files..."
if [ ! -f ${tmpfolder} ]; then rm -rf "$tmpfolder"; fi
echo -e "Done.\n"
echo -e "Resource/Texture pack located at $origindir/MC$version.zip\n"
read -p "Press [Enter] key to continue..." && exit
