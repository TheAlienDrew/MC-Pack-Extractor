#!/bin/bash
echo -e '\033]2;'Minecraft Pack Extractor'\007'
useColor=1 && if [ "$1" = "0" ]; then useColor=0; fi
origindir=$PWD
tmpfolder="/tmp/mcpackextractor"
version=""
os="$(uname -s)" && pause="Press any key to continue . . . "
# This program is designed to allow unpacking of the default Minecraft resources into a resource/texture pack.

main() {
	if ! [ "${useColor}" = "1" ]; then colorBanner; else
		echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "+             Minecraft Pack Extractor              +"
		echo -e "+         Created by TheAlienDrew on GitHub         +"
		echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "+ https://github.com/TheAlienDrew/MC-Pack-Extractor +"
		echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo -e "+         Only supports downloaded releases         +"
		echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
	fi

	# Delete previous temporary folder if needed
	if [ ! -f ${tmpfolder} ]; then rm -rf "$tmpfolder"; fi

	# No 7-Zip = Use Info-Zip
	use7z=true
	if ! type "7z" > /dev/null 2>&1; then use7z=false; fi
	if ! ($use7z); then
		echo
		if [ $(echo ${os} | grep Linux) ]; then
			echo -e "7-Zip isn't installed, but you can install it by running \"sudo apt install p7zip\""
		elif [ $(echo ${os} | grep Darwin) ]; then
			echo -e "7-Zip isn't installed, but you can install it by running \"brew install p7zip\" (if you run Homebrew)"
		else
			echo -e "Sorry, but $os is not supported."
			read -n 1 -s -r -p "$pause" && echo && echo && exit
		fi
		echo
		read -n 1 -s -r -p "Would you like to use the system's zip/unzip instead (Y/N)? " choice
		while ! { [ "$choice" = "Y" ] || [ "$choice" = "y" ] || [ "$choice" = "N" ] || [ "$choice" = "n" ]; }; do
			read -n 1 -s -r choice
		done
		if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
			printf "Y"
		else 
			printf "N\n\n" && exit
		fi
		echo
	fi
	echo -e "\n\n"

	# Get Minecraft version
	mcverdir=$(echo ~/.minecraft/versions | grep mine) && if [ $(echo ${os} | grep Darwin) ]; then mcverdir=$(echo ~/Library/Application Support/minecraft/versions | grep mine); fi
	# echo -e "Versions Installed:"
	# ls "$mcverdir" && echo
	while [[ $version = "" ]]; do
		while read -e -p "`echo`Enter the version you want to extract from: " version && [ -z ${version} ]; do :; done; if [[ $version = "" ]]; then echo; fi
	done
	mcjardir="$mcverdir/$version/$version.jar"
	echo

	# Version doesn't exist = Can't run
	if [[ ! -f ${mcverdir}/${version}/${version}.jar ]]; then
		echo -e "Unable to extract version \"$version\" because it isn't downloaded or doesn't exist."
		echo -e "Make sure to open the launcher and download the version you need to create a pack for.\n"
		read -n 1 -s -r -p "$pause" && echo && echo && exit
	fi

	# Determine pack extraction and extract the correct files from the choosen version
	mctp="Extracting files from texture pack  . . . . . . "
	mcrp="Extracting files from resource pack . . . . . . "
	case "$version" in
		("1.0" | "1.1" | "1.2.1" | "1.2.2" | "1.2.3" | "1.2.4" | "1.2.5" | "1.3.1" | "1.3.2" | "1.4.2" | "1.4.4" | "1.4.5" | "1.4.6" | "1.4.7")
			printf "$mctp"
			if ($use7z); then
				7z x "$mcjardir" -o"$tmpfolder" pack.png pack.txt particles.png terrain.png font.txt achievement armor art environment font gui item lang misc mob terrain title -r >/dev/null 2>&1
			else
				unzip -q "$mcjardir" pack.png pack.txt particles.png terrain.png font.txt achievement/*.* armor/*.* art/*.* environment/*.* font/*.* gui/*.* item/*.* lang/*.* misc/*.* mob/*.* terrain/*.* title/*.* -d "$tmpfolder"
			fi ;;
		("1.5.1" | "1.5.2")
			printf "$mctp"
			if ($use7z); then
				7z x "$mcjardir" -o"$tmpfolder" pack.png pack.txt particles.png font.txt achievement armor art environment font gui item lang misc mob textures title -r >/dev/null 2>&1
			else
				unzip -q "$mcjardir" pack.png pack.txt particles.png font.txt achievement/*.* armor/*.* art/*.* environment/*.* font/*.* gui/*.* item/*.* lang/*.* misc/*.* mob/*.* textures/*.* title/*.* -d "$tmpfolder"
			fi ;;
		("1.6.1" | "1.6.2" | "1.6.4")
			printf "$mcrp"
			if ($use7z); then
				7z x "$mcjardir" -o"$tmpfolder" pack.png pack.mcmeta font.txt assets/minecraft -r >/dev/null 2>&1
			else
				unzip -q "$mcjardir" pack.png pack.mcmeta font.txt assets/minecraft/*.* -d "$tmpfolder"
			fi ;;
		("1.7.2" | "1.7.3" | "1.7.4" | "1.7.5" | "1.7.6" | "1.7.7" | "1.7.8" | "1.7.9" | "1.7.10" | "1.8" | "1.8.1" | "1.8.2" | "1.8.3" | "1.8.4" | "1.8.5" | "1.8.6" | "1.8.7" | "1.8.8" | "1.8.9" | "1.9" | "1.9.1" | "1.9.2" | "1.9.3" | "1.9.4" | "1.10" | "1.10.1" | "1.10.2" | "1.11" | "1.11.1" | "1.11.2" | "1.12" | "1.12.2" | "1.13" | "1.13.1" | "1.13.2" | "1.14" | "1.14.1" | "1.14.2")
			printf "$mcrp"
			if ($use7z); then
				7z x "$mcjardir" -o"$tmpfolder" pack.png pack.mcmeta assets/minecraft -r >/dev/null 2>&1
			else
				unzip -q "$mcjardir" pack.png pack.mcmeta assets/minecraft/*.* -d "$tmpfolder"
			fi ;;
		(*)
			echo "Sorry, snapshots, pre-releases, and modded releases are not supported." && read -n 1 -s -r -p "$pause" && echo && echo && exit;;
	esac

	# ZIP the files and delete temporary files
	printf "Done\nCompressing files into zip file . . . . . . . . "
	if ($use7z); then
		7z a "$origindir/MC$version.zip" "$tmpfolder/*" >/dev/null 2>&1
	else
		cd "$tmpfolder" && zip -qr "$origindir/MC$version.zip" * && cd "$origindir"
	fi
	printf "Done\nCleaning up temporary files . . . . . . . . . . "
	if [ ! -f ${tmpfolder} ]; then rm -rf "$tmpfolder"; fi
	printf "Done\n\n"
	echo -e "Resource/Texture pack located at \"$origindir/MC$version.zip\"\n"
	read -n 1 -s -r -p "$pause" && echo && echo && exit
}



colorBanner() {
	reset_text='\e[0m' && lighten='\e[1m' && white='\e[37m' && black='\e[30m' && cyan='\e[36m' && magenta='\e[35m' && blue='\e[34m' && green='\e[32m' && red='\e[31m'
	echo -e "${blue}+++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "+             ${lighten}${white}Minecraft Pack Extractor              ${reset_text}${blue}+"
	echo -e "+         ${lighten}${black}Created by ${green}TheAlienDrew ${black}on ${reset_text}${magenta}GitHub         ${blue}+"
	echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "+ ${lighten}${cyan}https${white}://${cyan}github${white}.${cyan}com${white}/${cyan}TheAlienDrew${white}/${cyan}MC-Pack-Extractor ${reset_text}${blue}+"
	echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo -e "+         ${red}Only supports downloaded releases         ${blue}+"
	echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++${reset_text}"
}

main "$@"