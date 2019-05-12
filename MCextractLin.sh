#!/bin/bash
title="Minecraft Resource/Texture Pack Extractor"
echo -e '\033]2;'$title'\007'
function jumpto
{
	label=$1
	cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
	eval "$cmd"
	exit
}
# This program is designed to allow unpacking of the default Minecraft resources/textures into a resource/texture pack.

echo -e "+---------------------------------------------------+"
echo -e "| Minecraft Resource/Texture Pack Extractor         |"
echo -e "| https://github.com/TheAlienDrew/MC-Pack-Extractor |"
echo -e "+---------------------------------------------------+"
echo -e "| Created by https://github.com/TheAlienDrew/       |"
echo -e "+---------------------------------------------------+"
echo -e "| * Only supports downloaded releases               |"
echo -e "+---------------------------------------------------+\n\n\n"

# No p7zip = Can't run
#----
#if not exist "%programfiles%\7-Zip\7z.exe" (
	echo -e "Unable to run because p7zip isn't installed."
	echo -e "p7zip can be installed by running 'apt install p7zip'"
	jumpto $endme
fi

# Get Minecraft version
echo -e "Enter the Minecraft version you want to extract from:"
read version
echo -e "\n"

# Version doesn't exist = Can't run
if [ ! -f ~/.minecraft/versions/$version/$version.jar ]; then
	echo -e "Unable to extract because that version isn't downloaded or doesn't exist."
	echo -e "Make sure to open the launcher and download the version you need to create a pack for."
	jumpto $endme
fi

# Determine pack extraction
#----
#if "%version%"=="1.0" goto oldtexturepack
#if "%version%"=="1.1" goto oldtexturepack
#if "%version%"=="1.2.1" goto oldtexturepack
#if "%version%"=="1.2.2" goto oldtexturepack
#if "%version%"=="1.2.3" goto oldtexturepack
#if "%version%"=="1.2.4" goto oldtexturepack
#if "%version%"=="1.2.5" goto oldtexturepack
#if "%version%"=="1.3.1" goto oldtexturepack
#if "%version%"=="1.3.2" goto oldtexturepack
#if "%version%"=="1.4.2" goto oldtexturepack
#if "%version%"=="1.4.4" goto oldtexturepack
#if "%version%"=="1.4.5" goto oldtexturepack
#if "%version%"=="1.4.6" goto oldtexturepack
#if "%version%"=="1.4.7" goto oldtexturepack
#if "%version%"=="1.5.1" goto texturepack
#if "%version%"=="1.5.2" goto texturepack
#if "%version%"=="1.6.1" goto oldresourcepack
#if "%version%"=="1.6.2" goto oldresourcepack
#if "%version%"=="1.6.4" goto oldresourcepack
#if "%version%"=="1.7.2" goto resourcepack
#if "%version%"=="1.7.3" goto resourcepack
#if "%version%"=="1.7.4" goto resourcepack
#if "%version%"=="1.7.5" goto resourcepack
#if "%version%"=="1.7.6" goto resourcepack
#if "%version%"=="1.7.7" goto resourcepack
#if "%version%"=="1.7.8" goto resourcepack
#if "%version%"=="1.7.9" goto resourcepack
#if "%version%"=="1.7.10" goto resourcepack
#if "%version%"=="1.8" goto resourcepack
#if "%version%"=="1.8.1" goto resourcepack
#if "%version%"=="1.8.2" goto resourcepack
#if "%version%"=="1.8.3" goto resourcepack
#if "%version%"=="1.8.4" goto resourcepack
#if "%version%"=="1.8.5" goto resourcepack
#if "%version%"=="1.8.6" goto resourcepack
#if "%version%"=="1.8.7" goto resourcepack
#if "%version%"=="1.8.8" goto resourcepack
#if "%version%"=="1.8.9" goto resourcepack
#if "%version%"=="1.9" goto resourcepack
#if "%version%"=="1.9.1" goto resourcepack
#if "%version%"=="1.9.2" goto resourcepack
#if "%version%"=="1.9.3" goto resourcepack
#if "%version%"=="1.9.4" goto resourcepack
#if "%version%"=="1.10" goto resourcepack
#if "%version%"=="1.10.1" goto resourcepack
#if "%version%"=="1.10.2" goto resourcepack
#if "%version%"=="1.11" goto resourcepack
#if "%version%"=="1.11.1" goto resourcepack
#if "%version%"=="1.11.2" goto resourcepack
#if "%version%"=="1.12" goto resourcepack
#if "%version%"=="1.12.2" goto resourcepack
#if "%version%"=="1.13" goto resourcepack
#if "%version%"=="1.13.1" goto resourcepack
#if "%version%"=="1.13.2" goto resourcepack
#if "%version%"=="1.14" goto resourcepack
#if "%version%"=="1.14.1" goto resourcepack
#----

# Extract the correct files from the choosen version

oldtexturepack:
#----
#echo Extracting %version% texture pack...
#"%programfiles%\7-Zip\7z.exe" x "%appdata%\.minecraft\versions\%version%\%version%.jar" -o%cd%\mctemp pack.png pack.txt particles.png terrain.png font.txt achievement armor art environment font gui item lang misc mob terrain title -r > nul
#----
jumpto $zip

texturepack:
#----
#echo Extracting %version% texture pack...
#"%programfiles%\7-Zip\7z.exe" x "%appdata%\.minecraft\versions\%version%\%version%.jar" -o%cd%\mctemp pack.png pack.txt particles.png font.txt achievement armor art environment font gui item lang misc mob textures title -r > nul
#----
jumpto $zip

oldresourcepack:
#----
#echo Extracting %version% resource pack...
#"%programfiles%\7-Zip\7z.exe" x "%appdata%\.minecraft\versions\%version%\%version%.jar" -o%cd%\mctemp pack.png pack.mcmeta font.txt assets\minecraft -r > nul
#----
jumpto $zip

resourcepack:
#----
#echo Extracting %version% resource pack...
#"%programfiles%\7-Zip\7z.exe" x "%appdata%\.minecraft\versions\%version%\%version%.jar" -o%cd%\mctemp pack.png pack.mcmeta assets\minecraft -r > nul
#----
jumpto $zip

# ZIP the files and delete mctemp
zip:
#----
echo -e "Done.\n\nPacking into zip file..."
#"%programfiles%\7-Zip\7z.exe" a %cd%\MC%version%.zip %cd%\mctemp\* > nul
echo -e "Done.\n\nCleaning up temporary files..."
#rmdir %cd%\mctemp /S /Q
echo -e "Done.\n"
#echo Resource/Texture pack located at %cd%\MC%version%.zip
#----
endme:
echo -e "\n"
read -p "Press [Enter] key to continue..." && exit
