@echo off
setlocal
title Minecraft Pack Extractor
set "origindir=%cd%"
REM This program is designed to allow unpacking of the default Minecraft resources into a resource/texture pack.

echo +---------------------------------------------------+
echo ^| Minecraft Pack Extractor                          ^|
echo ^| https://github.com/TheAlienDrew/MC-Pack-Extractor ^|
echo +---------------------------------------------------+
echo ^| Created by https://github.com/TheAlienDrew/       ^|
echo +---------------------------------------------------+
echo ^| * Only supports downloaded releases               ^|
echo +---------------------------------------------------+ && echo. && echo. && echo.

REM Delete previous temporary folder(s) if needed
if exist "%tmp%\mctemp" rmdir "%tmp%\mctemp" /S /Q

REM No 7-Zip = Use system vbs commands
set /A use7z=1
if not exist "%programfiles%\7-Zip\7z.exe" (
	echo 7-Zip isn't installed, but you can install it by going to https://www.7-zip.org/download.html
	echo Would you like to use the system zip/unzip instead? && echo.
	echo Press [Ctrl]+[C] to exit or && pause
		REM CURRENTLY UNDER DEVELOPMENT
		goto endme
	echo.
	
	set /A use7z=0
)

REM Get Minecraft version
set "mcverdir=%appdata%\.minecraft\versions"
echo Enter the Minecraft version you want to extract from:
set /p version=
echo.

REM Version doesn't exist = Can't run
if not exist "%mcverdir%\%version%\%version%.jar" (
	echo Unable to extract because that version isn't downloaded or doesn't exist.
	echo Make sure to open the launcher and download the version you need to create a pack for.
	goto endme
)

REM Determine pack extraction
:versions
if "%version%"=="1.0" goto oldtexturepack
if "%version%"=="1.1" goto oldtexturepack
if "%version%"=="1.2.1" goto oldtexturepack
if "%version%"=="1.2.2" goto oldtexturepack
if "%version%"=="1.2.3" goto oldtexturepack
if "%version%"=="1.2.4" goto oldtexturepack
if "%version%"=="1.2.5" goto oldtexturepack
if "%version%"=="1.3.1" goto oldtexturepack
if "%version%"=="1.3.2" goto oldtexturepack
if "%version%"=="1.4.2" goto oldtexturepack
if "%version%"=="1.4.4" goto oldtexturepack
if "%version%"=="1.4.5" goto oldtexturepack
if "%version%"=="1.4.6" goto oldtexturepack
if "%version%"=="1.4.7" goto oldtexturepack
if "%version%"=="1.5.1" goto texturepack
if "%version%"=="1.5.2" goto texturepack
if "%version%"=="1.6.1" goto oldresourcepack
if "%version%"=="1.6.2" goto oldresourcepack
if "%version%"=="1.6.4" goto oldresourcepack
if "%version%"=="1.7.2" goto resourcepack
if "%version%"=="1.7.3" goto resourcepack
if "%version%"=="1.7.4" goto resourcepack
if "%version%"=="1.7.5" goto resourcepack
if "%version%"=="1.7.6" goto resourcepack
if "%version%"=="1.7.7" goto resourcepack
if "%version%"=="1.7.8" goto resourcepack
if "%version%"=="1.7.9" goto resourcepack
if "%version%"=="1.7.10" goto resourcepack
if "%version%"=="1.8" goto resourcepack
if "%version%"=="1.8.1" goto resourcepack
if "%version%"=="1.8.2" goto resourcepack
if "%version%"=="1.8.3" goto resourcepack
if "%version%"=="1.8.4" goto resourcepack
if "%version%"=="1.8.5" goto resourcepack
if "%version%"=="1.8.6" goto resourcepack
if "%version%"=="1.8.7" goto resourcepack
if "%version%"=="1.8.8" goto resourcepack
if "%version%"=="1.8.9" goto resourcepack
if "%version%"=="1.9" goto resourcepack
if "%version%"=="1.9.1" goto resourcepack
if "%version%"=="1.9.2" goto resourcepack
if "%version%"=="1.9.3" goto resourcepack
if "%version%"=="1.9.4" goto resourcepack
if "%version%"=="1.10" goto resourcepack
if "%version%"=="1.10.1" goto resourcepack
if "%version%"=="1.10.2" goto resourcepack
if "%version%"=="1.11" goto resourcepack
if "%version%"=="1.11.1" goto resourcepack
if "%version%"=="1.11.2" goto resourcepack
if "%version%"=="1.12" goto resourcepack
if "%version%"=="1.12.2" goto resourcepack
if "%version%"=="1.13" goto resourcepack
if "%version%"=="1.13.1" goto resourcepack
if "%version%"=="1.13.2" goto resourcepack
if "%version%"=="1.14" goto resourcepack
if "%version%"=="1.14.1" goto resourcepack
if "%version%"=="%version%" ( echo Sorry, snapshots, pre-releases, and modded releases are not supported. && goto endme )

REM Extract the correct files from the choosen version

:oldtexturepack:
echo Extracting %version% texture pack...
"%programfiles%\7-Zip\7z.exe" x "%mcverdir%\%version%\%version%.jar" -o"%tmp%\mctemp" pack.png pack.txt particles.png terrain.png font.txt achievement armor art environment font gui item lang misc mob terrain title -r > nul
goto zip

:texturepack:
echo Extracting %version% texture pack...
"%programfiles%\7-Zip\7z.exe" x "%mcverdir%\%version%\%version%.jar" -o"%tmp%\mctemp" pack.png pack.txt particles.png font.txt achievement armor art environment font gui item lang misc mob textures title -r > nul
goto zip

:oldresourcepack:
echo Extracting %version% resource pack...
"%programfiles%\7-Zip\7z.exe" x "%mcverdir%\%version%\%version%.jar" -o"%tmp%\mctemp" pack.png pack.mcmeta font.txt assets\minecraft -r > nul
goto zip

:resourcepack:
echo Extracting %version% resource pack...
"%programfiles%\7-Zip\7z.exe" x "%mcverdir%\%version%\%version%.jar" -o"%tmp%\mctemp" pack.png pack.mcmeta assets\minecraft -r > nul

REM ZIP the files and delete mctemp
:zip:
echo Done. && echo. && echo Packing into zip file...
"%programfiles%\7-Zip\7z.exe" a "%origindir%\MC%version%.zip" "%tmp%\mctemp\*" > nul
echo Done. && echo. && echo Cleaning up temporary files...
if exist "%tmp%\mctemp" rmdir "%tmp%\mctemp" /S /Q
echo Done. && echo.
echo Resource/Texture pack located at "%origindir%\MC%version%.zip"
:endme:
echo. && pause && exit
