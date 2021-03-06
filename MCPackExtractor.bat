REM This program is designed to allow unpacking of the default Minecraft resources into a resource/texture pack.
REM Copyright (C) 2020  Andrew Larson (thealiendrew@gmail.com)
REM
REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM (at your option) any later version.
REM
REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.
REM
REM You should have received a copy of the GNU General Public License
REM along with this program.  If not, see <https://www.gnu.org/licenses/>.
@echo off
title Minecraft Pack Extractor
set "useColor=1" && if [%1]==[0] set "useColor=0" && setlocal
set "origindir=%cd%"
set "tmpfolder=%tmp%\mcpackextractor"
set "tmpunzip=%tmpfolder%\unzip"
set "_7z=%programfiles%\7-Zip\7z.exe" && set "zipbat=%tmp%\zipjs.bat"

:main
if %useColor% equ 0 ( call :colorBanner "%tmp%" "%origindir%" ) else (
	echo. && echo +++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo +             Minecraft Pack Extractor              +
	echo +         Created by TheAlienDrew on GitHub         +
	echo +++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo + https://github.com/TheAlienDrew/MC-Pack-Extractor +
	echo +++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo +         Only supports downloaded releases         +
	echo +++++++++++++++++++++++++++++++++++++++++++++++++++++
)

REM Delete previous temporary folder if needed
if exist "%tmpfolder%" ( rmdir "%tmpfolder%" /S /Q && del "%tmpfolder%" >NUL 2>&1 )

REM No 7-Zip = Use internal batch file courtesy of npocmaka: https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/zipjs.bat
set /A use7z=0 && if not exist "%_7z%" set /A use7z=1
set "no7z=Would you like to use the built-in zip/unzip instead (Y/N)?"
if %use7z% neq 0 (
	echo.
	if "%os%"=="Windows_NT" ( echo 7-Zip isn't installed, but you can install it by going to "https://www.7-zip.org/download.html" ) else (
		echo Sorry, but %os% is not supported. && goto endme
	)
	echo.
	where choice >NUL 2>&1
	if errorlevel 1 (
		call :MsgBox "%no7z%" "VBYesNo+VBQuestion" "Continue?"
		if errorlevel 7 (
			echo|set/p"=%no7z% N"
			echo. && goto :EOF
		) else if errorlevel 6 (
			echo|set/p"=%no7z% Y"
			echo. && call :createZipBat
		)
	) else (
		choice /N /M "%no7z% "
		if errorlevel 2 ( goto :EOF ) else if errorlevel 1 ( call :createZipBat ) else goto :EOF
	)
	mkdir "%tmpfolder%" && mkdir "%tmpunzip%"
)
echo. && echo. && echo.

REM Get Minecraft version
set "mcverdir=%appdata%\.minecraft\versions"
REM echo Versions Installed:
REM dir "%mcverdir%" && echo.
:versionPrompt
set /p "version=Enter the version you want to extract from: " || goto versionPrompt
if [%version%]==[] goto versionPrompt
set "mcjardir=%mcverdir%\%version%\%version%.jar"
echo.

REM Version doesn't exist = Can't run
if not exist "%mcjardir%" (
	echo Unable to extract version "%version%" because it isn't downloaded or doesn't exist.
	echo Make sure to open the launcher and download the version you need to create a pack for.
	goto endme
)
REM zipbat needs a copy of the jar as a zip
set "mczipdir=%tmpfolder%\%version%.zip"
if %use7z% neq 0 copy "%mcjardir%" "%tmpfolder%\%version%.zip" /Y > nul

REM Determine pack extraction
:versions
set "mctp=Extracting files from texture pack  . . . . . . "
set "mcrp=Extracting files from resource pack . . . . . . "
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
if "%version%"=="1.14.2" goto resourcepack
if "%version%"=="1.14.3" goto resourcepack
if "%version%"=="1.14.4" goto resourcepack
if "%version%"=="%version%" ( echo Sorry, snapshots, pre-releases, and modded releases are not supported. && goto endme )

REM Extract the correct files from the choosen version
:oldtexturepack
echo|set/p"=%mctp%"
if %use7z% equ 0 (
	"%_7z%" x "%mcjardir%" -o"%tmpfolder%" pack.png pack.txt particles.png terrain.png font.txt achievement armor art environment font gui item lang misc mob terrain title -r > nul
) else (
	call %zipbat% unZipItem -source "%mczipdir%\pack.png" -destination "%tmpunzip%" && move /Y "%tmpunzip%\pack.png" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\pack.txt" -destination "%tmpunzip%" && move /Y "%tmpunzip%\pack.txt" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\particles.png" -destination "%tmpunzip%" && move /Y "%tmpunzip%\particles.png" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\terrain.png" -destination "%tmpunzip%" && move /Y "%tmpunzip%\terrain.png" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\font.txt" -destination "%tmpunzip%" && move /Y "%tmpunzip%\font.txt" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\achievement" -destination "%tmpunzip%" && move /Y "%tmpunzip%\achievement" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\armor" -destination "%tmpunzip%" && move /Y "%tmpunzip%\armor" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\art" -destination "%tmpunzip%" && move /Y "%tmpunzip%\art" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\environment" -destination "%tmpunzip%" && move /Y "%tmpunzip%\environment" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\font" -destination "%tmpunzip%" && move /Y "%tmpunzip%\font" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\gui" -destination "%tmpunzip%" && move /Y "%tmpunzip%\gui" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\item" -destination "%tmpunzip%" && move /Y "%tmpunzip%\item" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\lang" -destination "%tmpunzip%" && move /Y "%tmpunzip%\lang" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\misc" -destination "%tmpunzip%" && move /Y "%tmpunzip%\misc" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\mob" -destination "%tmpunzip%" && move /Y "%tmpunzip%\mob" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\terrain" -destination "%tmpunzip%" && move /Y "%tmpunzip%\terrain" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\title" -destination "%tmpunzip%" && move /Y "%tmpunzip%\title" "%tmpfolder%" > nul
)
goto zip
:texturepack
echo|set/p"=%mctp%"
if %use7z% equ 0 (
	"%_7z%" x "%mcjardir%" -o"%tmpfolder%" pack.png pack.txt particles.png font.txt achievement armor art environment font gui item lang misc mob textures title -r > nul
) else (
	call %zipbat% unZipItem -source "%mczipdir%\pack.png" -destination "%tmpunzip%" && move /Y "%tmpunzip%\pack.png" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\pack.txt" -destination "%tmpunzip%" && move /Y "%tmpunzip%\pack.txt" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\particles.png" -destination "%tmpunzip%" && move /Y "%tmpunzip%\particles.png" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\font.txt" -destination "%tmpunzip%" && move /Y "%tmpunzip%\font.txt" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\achievement" -destination "%tmpunzip%" && move /Y "%tmpunzip%\achievement" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\armor" -destination "%tmpunzip%" && move /Y "%tmpunzip%\armor" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\art" -destination "%tmpunzip%" && move /Y "%tmpunzip%\art" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\environment" -destination "%tmpunzip%" && move /Y "%tmpunzip%\environment" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\font" -destination "%tmpunzip%" && move /Y "%tmpunzip%\font" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\gui" -destination "%tmpunzip%" && move /Y "%tmpunzip%\gui" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\item" -destination "%tmpunzip%" && move /Y "%tmpunzip%\item" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\lang" -destination "%tmpunzip%" && move /Y "%tmpunzip%\lang" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\misc" -destination "%tmpunzip%" && move /Y "%tmpunzip%\misc" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\mob" -destination "%tmpunzip%" && move /Y "%tmpunzip%\mob" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\textures" -destination "%tmpunzip%" && move /Y "%tmpunzip%\textures" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\title" -destination "%tmpunzip%" && move /Y "%tmpunzip%\title" "%tmpfolder%" > nul
)
goto zip
:oldresourcepack
echo|set/p"=%mcrp%"
if %use7z% equ 0 (
	"%_7z%" x "%mcjardir%" -o"%tmpfolder%" pack.png pack.mcmeta font.txt assets\minecraft -r > nul
) else (
	call %zipbat% unZipItem -source "%mczipdir%\pack.png" -destination "%tmpunzip%" && move /Y "%tmpunzip%\pack.png" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\pack.mcmeta" -destination "%tmpunzip%" && move /Y "%tmpunzip%\pack.mcmeta" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\font.txt" -destination "%tmpunzip%" && move /Y "%tmpunzip%\font.txt" "%tmpfolder%" > nul
	mkdir "%tmpunzip%\assets" && call %zipbat% unZipItem -source "%mczipdir%\assets\minecraft" -destination "%tmpunzip%\assets"
	if exist "%tmpunzip%\assets\.mcassetsroot" del "%tmpunzip%\assets\.mcassetsroot"
	move /Y "%tmpunzip%\assets" "%tmpfolder%" > nul
)
goto zip
:resourcepack
echo|set/p"=%mcrp%"
if %use7z% equ 0 (
	"%_7z%" x "%mcjardir%" -o"%tmpfolder%" pack.png pack.mcmeta assets\minecraft -r > nul
) else (
	call %zipbat% unZipItem -source "%mczipdir%\pack.png" -destination "%tmpunzip%" && move /Y "%tmpunzip%\pack.png" "%tmpfolder%" > nul
	call %zipbat% unZipItem -source "%mczipdir%\pack.mcmeta" -destination "%tmpunzip%" && move /Y "%tmpunzip%\pack.mcmeta" "%tmpfolder%" > nul
	mkdir "%tmpunzip%\assets" && call %zipbat% unZipItem -source "%mczipdir%\assets\minecraft" -destination "%tmpunzip%\assets"
	if exist "%tmpunzip%\assets\.mcassetsroot" del "%tmpunzip%\assets\.mcassetsroot"
	move /Y "%tmpunzip%\assets" "%tmpfolder%" > nul
)

REM ZIP the files and delete temporary files
:zip
echo Done && echo|set/p"=Compressing files into zip file . . . . . . . . "
if %use7z% equ 0 (
	"%_7z%" a "%origindir%\MC%version%.zip" "%tmpfolder%\*" > nul
) else (
	if exist "%tmpunzip%" rmdir "%tmpunzip%" /S /Q
	if exist "%mczipdir%" del "%mczipdir%"
	call %zipbat% zipDirItems -source "%tmpfolder%" -destination "%origindir%\MC%version%.zip"
)
echo Done && echo|set/p"=Cleaning up temporary files . . . . . . . . . . "
if exist "%tmpfolder%" rmdir "%tmpfolder%" /S /Q
if exist "%zipbat%" del "%zipbat%"
echo Done && echo.
echo Resource/Texture pack located at "%origindir%\MC%version%.zip"
:endme
echo. && pause && goto :EOF
:mainEnd



REM Colored version of my banner
:colorBanner tempdir origindir
cd "%~1"
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a")
<nul set /p=""
echo. &
call :Colorize 01 "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo. &
call :Colorize 01 "+"
call :Colorize 0f "             Minecraft Pack Extractor"
call :Colorize 01 "              +"
echo. &
call :Colorize 01 "+"
call :Colorize 08 "         Created by"
call :Colorize 0a " TheAlienDrew"
call :Colorize 08 " on"
call :Colorize 05 " GitHub"
call :Colorize 01 "         +"
echo. &
call :Colorize 01 "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo. &
call :Colorize 01 "+"
call :Colorize 0b " https"
echo|set/p"=://"
call :Colorize 0b "github"
echo|set/p"=."
call :Colorize 0b "com"
echo|set/p"=/"
call :Colorize 0b "TheAlienDrew"
echo|set/p"=/"
call :Colorize 0b "MC-Pack-Extractor"
call :Colorize 01 " +"
echo. &
call :Colorize 01 "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo. &
call :Colorize 01 "+"
call :Colorize 04 "         Only supports downloaded releases"
call :Colorize 01 "         +"
echo. &
call :Colorize 01 "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo.
cd "%~2"
exit /B

REM Required for colored text
:Colorize
<nul set /p "=%DEL%" > "%~2"
findstr /v /a:%1 /R "+" "%~2" nul
del "%~2" > nul
goto :eof

REM .vbs needed for choice prompt if choice command doesn't exist
:MsgBox prompt type title
setlocal enableextensions
set "tmpmsgbox=%tmp%\tmpmsgbox.vbs"
>"%tmpmsgbox%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tmpmsgbox%"
set "exitCode=%errorlevel%" & del "%tmpmsgbox%" >nul 2>nul
endlocal & exit /b %exitCode%

REM Need to create an external batch file for handling zip files
:createZipBat
echo @if (@X)==(@Y) @end /* JScript comment> "%zipbat%"
echo 	@echo off>> "%zipbat%"
echo.>> "%zipbat%"
echo 	rem :: the first argument is the script name as it will be used for proper help message>> "%zipbat%"
echo 	cscript //E:JScript //nologo "%%~f0" "%%~nx0" %%*>> "%zipbat%"
echo.>> "%zipbat%"
echo 	exit /b %%errorlevel%%>> "%zipbat%"
echo.>> "%zipbat%"
echo @if (@X)==(@Y) @end JScript comment */>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo /*>> "%zipbat%"
echo Compression/uncompression command-line tool that uses Shell.Application and WSH/Jscript ->> "%zipbat%"
echo http://msdn.microsoft.com/en-us/library/windows/desktop/bb774085(v=vs.85).aspx>> "%zipbat%"
echo.>> "%zipbat%"
echo Some resources That I've used:>> "%zipbat%"
echo http://www.robvanderwoude.com/vbstech_files_zip.php>> "%zipbat%"
echo https://code.google.com/p/jsxt/source/browse/trunk/js/win32/ZipFile.js?r=161>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo UPDATE *17-03-15*>> "%zipbat%"
echo.>> "%zipbat%"
echo Devnullius Plussed noticed a bug in ZipDirItems  and ZipItem functions (now fixed)>> "%zipbat%"
echo And also following issues (at the moment not handled by the script):>> "%zipbat%"
echo - if there's not enough space on the system drive (usually C:\) the script could produce various errors , most often the script halts.>> "%zipbat%"
echo - Folders and files that contain unicode symbols cannot be handled by Shell.Application object.>> "%zipbat%"
echo.>> "%zipbat%"
echo UPDATE *24-03-15*>> "%zipbat%"
echo.>> "%zipbat%"
echo Error messages are caught in waitforcount method and if shuch pops-up the script is stopped.>> "%zipbat%"
echo As I don't know hoe to check the content of the pop-up the exact reason for the failure is not given>> "%zipbat%"
echo but only the possible reasons.>> "%zipbat%"
echo.>> "%zipbat%"
echo UPDATE *22-02-16*>> "%zipbat%"
echo.>> "%zipbat%"
echo Javid Pack(https://github.com/JavidPack) has found two bugs in zipItem command and in ZipItem function.Now fixed.>> "%zipbat%"
echo.>> "%zipbat%"
echo ------>> "%zipbat%"
echo It's possible to be ported for C#,Powershell and JScript.net so I'm planning to do it at some time.>> "%zipbat%"
echo.>> "%zipbat%"
echo For sure there's a lot of room for improvements and optimization and I'm absolutely sure there are some bugs>> "%zipbat%"
echo as the script is big enough to not have.>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo !!!>> "%zipbat%"
echo For suggestions contact me at - npocmaka@gmail.com>> "%zipbat%"
echo !!!>> "%zipbat%"
echo.>> "%zipbat%"
echo */>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo //   CONSTANTS>> "%zipbat%"
echo.>> "%zipbat%"
echo // TODO - Shell.Application and Scripting.FileSystemObject objects could be set as global variables to avoid theit creation>> "%zipbat%"
echo // in every method.>> "%zipbat%"
echo.>> "%zipbat%"
echo //empty zip character sequense>> "%zipbat%"
echo var ZIP_DATA= "PK" + String.fromCharCode(5) + String.fromCharCode(6) + "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";>> "%zipbat%"
echo.>> "%zipbat%"
echo var SLEEP_INTERVAL=200;>> "%zipbat%"
echo.>> "%zipbat%"
echo //copy option(s) used by Shell.Application.CopyHere/MoveHere>> "%zipbat%"
echo var NO_PROGRESS_BAR=4;>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo //oprions used for zip/unzip>> "%zipbat%"
echo var force=true;>> "%zipbat%"
echo var move=false;>> "%zipbat%"
echo.>> "%zipbat%"
echo //option used for listing content of archive>> "%zipbat%"
echo var flat=false;>> "%zipbat%"
echo.>> "%zipbat%"
echo var source="";>> "%zipbat%"
echo var destination="";>> "%zipbat%"
echo.>> "%zipbat%"
echo var ARGS = WScript.Arguments;>> "%zipbat%"
echo var scriptName=ARGS.Item(0);>> "%zipbat%"
echo.>> "%zipbat%"
echo //>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo.>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo //   ADODB.Stream extensions>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! this.ADODB ) {>> "%zipbat%"
echo 	var ADODB = {};>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! ADODB.Stream ) {>> "%zipbat%"
echo 	ADODB.Stream = {};>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo // writes a binary data to a file>> "%zipbat%"
echo if ( ! ADODB.Stream.writeFile ) {>> "%zipbat%"
echo 	ADODB.Stream.writeFile = function(filename, bindata)>> "%zipbat%"
echo 	{>> "%zipbat%"
echo         var stream = new ActiveXObject("ADODB.Stream");>> "%zipbat%"
echo         stream.Type = 2;>> "%zipbat%"
echo         stream.Mode = 3;>> "%zipbat%"
echo         stream.Charset ="ASCII";>> "%zipbat%"
echo         stream.Open();>> "%zipbat%"
echo         stream.Position = 0;>> "%zipbat%"
echo         stream.WriteText(bindata);>> "%zipbat%"
echo         stream.SaveToFile(filename, 2);>> "%zipbat%"
echo         stream.Close();>> "%zipbat%"
echo 		return true;>> "%zipbat%"
echo 	};>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo //>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo.>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo //   common>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! this.Common ) {>> "%zipbat%"
echo 	var Common = {};>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Common.WaitForCount ) {>> "%zipbat%"
echo 	Common.WaitForCount = function(folderObject,targetCount,countFunction){>> "%zipbat%"
echo 		var shell = new ActiveXObject("Wscript.Shell");>> "%zipbat%"
echo 		while (countFunction(folderObject) ^< targetCount ){>> "%zipbat%"
echo 			WScript.Sleep(SLEEP_INTERVAL);>> "%zipbat%"
echo 			//checks if a pop-up with error message appears while zipping>> "%zipbat%"
echo 			//at the moment I have no idea how to read the pop-up content>> "%zipbat%"
echo 			// to give the exact reason for failing>> "%zipbat%"
echo 			if (shell.AppActivate("Compressed (zipped) Folders Error")) {>> "%zipbat%"
echo 				WScript.Echo("Error While zipping");>> "%zipbat%"
echo 				WScript.Echo("");>> "%zipbat%"
echo 				WScript.Echo("Possible reasons:");>> "%zipbat%"
echo 				WScript.Echo(" -source contains filename(s) with unicode characters");>> "%zipbat%"
echo 				WScript.Echo(" -produces zip exceeds 8gb size (or 2,5 gb for XP and 2003)");>> "%zipbat%"
echo 				WScript.Echo(" -not enough space on system drive (usually C:\\)");>> "%zipbat%"
echo 				WScript.Quit(432);>> "%zipbat%"
echo 			}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Common.getParent ) {>> "%zipbat%"
echo 	Common.getParent = function(path){>> "%zipbat%"
echo 		var splitted=path.split("\\");>> "%zipbat%"
echo 		var result="";>> "%zipbat%"
echo 		for (var s=0;s^<splitted.length-1;s++){>> "%zipbat%"
echo 			if (s==0) {>> "%zipbat%"
echo 				result=splitted[s];>> "%zipbat%"
echo 			} else {>> "%zipbat%"
echo 				result=result+"\\"+splitted[s];>> "%zipbat%"
echo 			}>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		return result;>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Common.getName ) {>> "%zipbat%"
echo 	Common.getName = function(path){>> "%zipbat%"
echo 		var splitted=path.split("\\");>> "%zipbat%"
echo 		return splitted[splitted.length-1];>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo //file system object has a problem to create a folder with slashes at the end>> "%zipbat%"
echo if ( ! Common.stripTrailingSlash ) {>> "%zipbat%"
echo 	Common.stripTrailingSlash = function(path){>> "%zipbat%"
echo 		while (path.substr(path.length - 1,path.length) == '\\') {>> "%zipbat%"
echo 			path=path.substr(0, path.length - 1);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		return path;>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo //>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo.>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo //   Scripting.FileSystemObject extensions>> "%zipbat%"
echo.>> "%zipbat%"
echo if (! this.Scripting) {>> "%zipbat%"
echo 	var Scripting={};>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if (! Scripting.FileSystemObject) {>> "%zipbat%"
echo 	Scripting.FileSystemObject={};>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Scripting.FileSystemObject.DeleteItem ) {>> "%zipbat%"
echo 	Scripting.FileSystemObject.DeleteItem = function (item)>> "%zipbat%"
echo 	{>> "%zipbat%"
echo 		var FSOObj= new ActiveXObject("Scripting.FileSystemObject");>> "%zipbat%"
echo 		if (FSOObj.FileExists(item)){>> "%zipbat%"
echo 			FSOObj.DeleteFile(item);>> "%zipbat%"
echo 			return true;>> "%zipbat%"
echo 		} else if (FSOObj.FolderExists(item) ) {>> "%zipbat%"
echo 			FSOObj.DeleteFolder(Common.stripTrailingSlash(item));>> "%zipbat%"
echo 			return true;>> "%zipbat%"
echo 		} else {>> "%zipbat%"
echo 			return false;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Scripting.FileSystemObject.ExistsFile ) {>> "%zipbat%"
echo 	Scripting.FileSystemObject.ExistsFile = function (path)>> "%zipbat%"
echo 	{>> "%zipbat%"
echo 		var FSOObj= new ActiveXObject("Scripting.FileSystemObject");>> "%zipbat%"
echo 		return FSOObj.FileExists(path);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo if ( !Scripting.FileSystemObject.ExistsFolder ) {>> "%zipbat%"
echo 	Scripting.FileSystemObject.ExistsFolder = function (path){>> "%zipbat%"
echo 	var FSOObj= new ActiveXObject("Scripting.FileSystemObject");>> "%zipbat%"
echo 		return FSOObj.FolderExists(path);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Scripting.FileSystemObject.isFolder ) {>> "%zipbat%"
echo 	Scripting.FileSystemObject.isFolder = function (path){>> "%zipbat%"
echo 	var FSOObj= new ActiveXObject("Scripting.FileSystemObject");>> "%zipbat%"
echo 		return FSOObj.FolderExists(path);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Scripting.FileSystemObject.isEmptyFolder ) {>> "%zipbat%"
echo 	Scripting.FileSystemObject.isEmptyFolder = function (path){>> "%zipbat%"
echo 	var FSOObj= new ActiveXObject("Scripting.FileSystemObject");>> "%zipbat%"
echo 		if(FSOObj.FileExists(path)){>> "%zipbat%"
echo 			return false;>> "%zipbat%"
echo 		}else if (FSOObj.FolderExists(path)){>> "%zipbat%"
echo 			var folderObj=FSOObj.GetFolder(path);>> "%zipbat%"
echo 			if ((folderObj.Files.Count+folderObj.SubFolders.Count)==0){>> "%zipbat%"
echo 				return true;>> "%zipbat%"
echo 			}>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		return false;>> "%zipbat%"
echo 	}>> "%zipbat%"
echo.>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Scripting.FileSystemObject.CreateFolder) {>> "%zipbat%"
echo 	Scripting.FileSystemObject.CreateFolder = function (path){>> "%zipbat%"
echo 		var FSOObj= new ActiveXObject("Scripting.FileSystemObject");>> "%zipbat%"
echo 		FSOObj.CreateFolder(path);>> "%zipbat%"
echo 		return FSOObj.FolderExists(path);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Scripting.FileSystemObject.ExistsItem) {>> "%zipbat%"
echo 	Scripting.FileSystemObject.ExistsItem = function (path){>> "%zipbat%"
echo 		var FSOObj= new ActiveXObject("Scripting.FileSystemObject");>> "%zipbat%"
echo 		return FSOObj.FolderExists(path)^|^|FSOObj.FileExists(path);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Scripting.FileSystemObject.getFullPath) {>> "%zipbat%"
echo 	Scripting.FileSystemObject.getFullPath = function (path){>> "%zipbat%"
echo 		var FSOObj= new ActiveXObject("Scripting.FileSystemObject");>> "%zipbat%"
echo         return FSOObj.GetAbsolutePathName(path);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo //>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo.>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo //   Shell.Application extensions>> "%zipbat%"
echo if ( ! this.Shell ) {>> "%zipbat%"
echo 	var Shell = {};>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if (! Shell.Application ) {>> "%zipbat%"
echo 	Shell.Application={};>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Shell.Application.ExistsFolder ) {>> "%zipbat%"
echo 	Shell.Application.ExistsFolder = function(path){>> "%zipbat%"
echo 		var ShellObj=new ActiveXObject("Shell.Application");>> "%zipbat%"
echo 		var targetObject = new Object;>> "%zipbat%"
echo 		var targetObject=ShellObj.NameSpace(path);>> "%zipbat%"
echo 		if (typeof targetObject === 'undefined' ^|^| targetObject == null ){>> "%zipbat%"
echo 			return false;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		return true;>> "%zipbat%"
echo.>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Shell.Application.ExistsSubItem ) {>> "%zipbat%"
echo 	Shell.Application.ExistsSubItem = function(path){>> "%zipbat%"
echo 		var ShellObj=new ActiveXObject("Shell.Application");>> "%zipbat%"
echo 		var targetObject = new Object;>> "%zipbat%"
echo 		var targetObject=ShellObj.NameSpace(Common.getParent(path));>> "%zipbat%"
echo 		if (typeof targetObject === 'undefined' ^|^| targetObject == null ){>> "%zipbat%"
echo 			return false;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		var subItem=targetObject.ParseName(Common.getName(path));>> "%zipbat%"
echo 		if(subItem === 'undefined' ^|^| subItem == null ){>> "%zipbat%"
echo 			return false;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		return true;>> "%zipbat%"
echo.>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Shell.Application.ItemCounterL1 ) {>> "%zipbat%"
echo 	Shell.Application.ItemCounterL1 = function(path){>> "%zipbat%"
echo 		var ShellObj=new ActiveXObject("Shell.Application");>> "%zipbat%"
echo 		var targetObject = new Object;>> "%zipbat%"
echo 		var targetObject=ShellObj.NameSpace(path);>> "%zipbat%"
echo 		if (targetObject != null ){>> "%zipbat%"
echo 			return targetObject.Items().Count;>> "%zipbat%"
echo 		} else {>> "%zipbat%"
echo 			return 0;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo // shell application item.size returns the size of uncompressed state of the file.>> "%zipbat%"
echo if ( ! Shell.Application.getSize ) {>> "%zipbat%"
echo 	Shell.Application.getSize = function(path){>> "%zipbat%"
echo 		var ShellObj=new ActiveXObject("Shell.Application");>> "%zipbat%"
echo 		var targetObject = new Object;>> "%zipbat%"
echo 		var targetObject=ShellObj.NameSpace(path);>> "%zipbat%"
echo 		if (! Shell.Application.ExistsFolder (path)){>> "%zipbat%"
echo 			WScript.Echo(path + "does not exists or the file is incorrect type.Be sure you are using full path to the file");>> "%zipbat%"
echo 			return 0;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		if (typeof size === 'undefined'){>> "%zipbat%"
echo 			var size=0;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		if (targetObject != null ){>> "%zipbat%"
echo.>> "%zipbat%"
echo 			for (var i=0; i^<targetObject.Items().Count;i++){>> "%zipbat%"
echo 				if(!targetObject.Items().Item(i).IsFolder){>> "%zipbat%"
echo 					size=size+targetObject.Items().Item(i).Size;>> "%zipbat%"
echo 				} else if (targetObject.Items().Item(i).Count!=0){>> "%zipbat%"
echo 					size=size+Shell.Application.getSize(targetObject.Items().Item(i).Path);>> "%zipbat%"
echo 				}>> "%zipbat%"
echo 			}>> "%zipbat%"
echo 		} else {>> "%zipbat%"
echo 			return 0;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		return size;>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo if ( ! Shell.Application.TakeAction ) {>> "%zipbat%"
echo 	Shell.Application.TakeAction = function(destination,item, move ,option){>> "%zipbat%"
echo 		if(typeof destination != 'undefined' ^&^& move){>> "%zipbat%"
echo 			destination.MoveHere(item,option);>> "%zipbat%"
echo 		} else if(typeof destination != 'undefined') {>> "%zipbat%"
echo 			destination.CopyHere(item,option);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo //ProcessItem and  ProcessSubItems can be used both for zipping and unzipping>> "%zipbat%"
echo // When an item is zipped another process is ran and the control is released>> "%zipbat%"
echo // but when the script stops also the copying to the zipped file stops.>> "%zipbat%"
echo // Though the zipping is transactional so a zipped files will be visible only after the zipping is done>> "%zipbat%"
echo // and we can rely on items count when zip operation is performed.>> "%zipbat%"
echo // Also is impossible to compress an empty folders.>> "%zipbat%"
echo // So when it comes to zipping two additional checks are added - for empty folders and for count of items at the>> "%zipbat%"
echo // destination.>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Shell.Application.ProcessItem ) {>> "%zipbat%"
echo 	Shell.Application.ProcessItem = function(toProcess, destination  , move ,isZipping,option){>> "%zipbat%"
echo 		var ShellObj=new ActiveXObject("Shell.Application");>> "%zipbat%"
echo 		destinationObj=ShellObj.NameSpace(destination);>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (destinationObj!= null ){>> "%zipbat%"
echo 			if (isZipping ^&^& Scripting.FileSystemObject.isEmptyFolder(toProcess)) {>> "%zipbat%"
echo 				WScript.Echo(toProcess +" is an empty folder and will be not processed");>> "%zipbat%"
echo 				return;>> "%zipbat%"
echo 			}>> "%zipbat%"
echo 			Shell.Application.TakeAction(destinationObj,toProcess, move ,option);>> "%zipbat%"
echo 			var destinationCount=Shell.Application.ItemCounterL1(destination);>> "%zipbat%"
echo 			var final_destination=destination + "\\" + Common.getName(toProcess);>> "%zipbat%"
echo.>> "%zipbat%"
echo 			if (isZipping ^&^& !Shell.Application.ExistsSubItem(final_destination)) {>> "%zipbat%"
echo 				Common.WaitForCount(destination>> "%zipbat%"
echo 					,destinationCount+1,Shell.Application.ItemCounterL1);>> "%zipbat%"
echo 			} else if (isZipping ^&^& Shell.Application.ExistsSubItem(final_destination)){>> "%zipbat%"
echo 				WScript.Echo(final_destination + " already exists and task cannot be completed");>> "%zipbat%"
echo 				return;>> "%zipbat%"
echo 			}>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Shell.Application.ProcessSubItems ) {>> "%zipbat%"
echo 	Shell.Application.ProcessSubItems = function(toProcess, destination  , move ,isZipping ,option){>> "%zipbat%"
echo 		var ShellObj=new ActiveXObject("Shell.Application");>> "%zipbat%"
echo 		var destinationObj=ShellObj.NameSpace(destination);>> "%zipbat%"
echo 		var toItemsToProcess=new Object;>> "%zipbat%"
echo 		toItemsToProcess=ShellObj.NameSpace(toProcess).Items();>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (destinationObj!= null ){>> "%zipbat%"
echo.>> "%zipbat%"
echo 			for (var i=0;i^<toItemsToProcess.Count;i++) {>> "%zipbat%"
echo.>> "%zipbat%"
echo 				if (isZipping ^&^& Scripting.FileSystemObject.isEmptyFolder(toItemsToProcess.Item(i).Path)){>> "%zipbat%"
echo.>> "%zipbat%"
echo 					WScript.Echo("");>> "%zipbat%"
echo 					WScript.Echo(toItemsToProcess.Item(i).Path + " is empty and will be not processed");>> "%zipbat%"
echo 					WScript.Echo("");>> "%zipbat%"
echo.>> "%zipbat%"
echo 				} else {>> "%zipbat%"
echo 					Shell.Application.TakeAction(destinationObj,toItemsToProcess.Item(i),move,option);>> "%zipbat%"
echo 					var destinationCount=Shell.Application.ItemCounterL1(destination);>> "%zipbat%"
echo 					if (isZipping) {>> "%zipbat%"
echo 						Common.WaitForCount(destination,destinationCount+1,Shell.Application.ItemCounterL1);>> "%zipbat%"
echo 					}>> "%zipbat%"
echo 				}>> "%zipbat%"
echo 			}>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! Shell.Application.ListItems ) {>> "%zipbat%"
echo 	Shell.Application.ListItems = function(parrentObject){>> "%zipbat%"
echo 		var ShellObj=new ActiveXObject("Shell.Application");>> "%zipbat%"
echo 		var targetObject = new Object;>> "%zipbat%"
echo 		var targetObject=ShellObj.NameSpace(parrentObject);>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (! Shell.Application.ExistsFolder (parrentObject)){>> "%zipbat%"
echo 			WScript.Echo(parrentObject + "does not exists or the file is incorrect type.Be sure the full path the path is used");>> "%zipbat%"
echo 			return;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		if (typeof initialSCount == 'undefined') {>> "%zipbat%"
echo 			initialSCount=(parrentObject.split("\\").length-1);>> "%zipbat%"
echo 			WScript.Echo(parrentObject);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		var spaces=function(path){>> "%zipbat%"
echo 			var SCount=(path.split("\\").length-1)-initialSCount;>> "%zipbat%"
echo 			var s="";>> "%zipbat%"
echo 			for (var i=0;i^<=SCount;i++) {>> "%zipbat%"
echo 				s=" "+s;>> "%zipbat%"
echo 			}>> "%zipbat%"
echo 			return s;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		var printP = function (item,end){>> "%zipbat%"
echo 			if (flat) {>> "%zipbat%"
echo 				WScript.Echo(targetObject.Items().Item(i).Path+end);>> "%zipbat%"
echo 			}else{>> "%zipbat%"
echo 				WScript.Echo( spaces(targetObject.Items().Item(i).Path)+targetObject.Items().Item(i).Name+end);>> "%zipbat%"
echo 			}>> "%zipbat%"
echo 		}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (targetObject != null ){>> "%zipbat%"
echo 			var folderPath="";>> "%zipbat%"
echo.>> "%zipbat%"
echo 				for (var i=0; i^<targetObject.Items().Count;i++) {>> "%zipbat%"
echo 					if(targetObject.Items().Item(i).IsFolder ^&^& targetObject.Items().Item(i).Count==0 ){>> "%zipbat%"
echo 						printP(targetObject.Items().Item(i),"\\");>> "%zipbat%"
echo 					} else if (targetObject.Items().Item(i).IsFolder){>> "%zipbat%"
echo 						folderPath=parrentObject+"\\"+targetObject.Items().Item(i).Name;>> "%zipbat%"
echo 						printP(targetObject.Items().Item(i),"\\")>> "%zipbat%"
echo 						Shell.Application.ListItems(folderPath);					>> "%zipbat%"
echo.>> "%zipbat%"
echo 					} else {>> "%zipbat%"
echo 						printP(targetObject.Items().Item(i),"")>> "%zipbat%"
echo.>> "%zipbat%"
echo 					}>> "%zipbat%"
echo 				}>> "%zipbat%"
echo.>> "%zipbat%"
echo 			}>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo //>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo //     ZIP Utils>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! this.ZIPUtils ) {>> "%zipbat%"
echo 	var ZIPUtils = {};>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! this.ZIPUtils.ZipItem) {>> "%zipbat%"
echo 	ZIPUtils.ZipItem = function(source, destination ) {>> "%zipbat%"
echo 		if (!Scripting.FileSystemObject.ExistsItem(source)) {>> "%zipbat%"
echo 			WScript.Echo("");>> "%zipbat%"
echo 			WScript.Echo("file " + source +" does not exist");>> "%zipbat%"
echo 			WScript.Quit(2);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (Scripting.FileSystemObject.ExistsFile(destination) ^&^& force ) {>> "%zipbat%"
echo 			Scripting.FileSystemObject.DeleteItem(destination);>> "%zipbat%"
echo 			ADODB.Stream.writeFile(destination,ZIP_DATA);>> "%zipbat%"
echo 		} else if (!Scripting.FileSystemObject.ExistsFile(destination)) {>> "%zipbat%"
echo 			ADODB.Stream.writeFile(destination,ZIP_DATA);>> "%zipbat%"
echo 		} else {>> "%zipbat%"
echo 			WScript.Echo("Destination "+destination+" already exists.Operation will be aborted");>> "%zipbat%"
echo 			WScript.Quit(15);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		source=Scripting.FileSystemObject.getFullPath(source);>> "%zipbat%"
echo 		destination=Scripting.FileSystemObject.getFullPath(destination);>> "%zipbat%"
echo.>> "%zipbat%"
echo 		Shell.Application.ProcessItem(source,destination,move,true ,NO_PROGRESS_BAR);>> "%zipbat%"
echo.>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! this.ZIPUtils.ZipDirItems) {>> "%zipbat%"
echo 	ZIPUtils.ZipDirItems = function(source, destination ) {>> "%zipbat%"
echo 		if (!Scripting.FileSystemObject.ExistsFolder(source)) {>> "%zipbat%"
echo 			WScript.Echo();>> "%zipbat%"
echo 			WScript.Echo("file " + source +" does not exist");>> "%zipbat%"
echo 			WScript.Quit(2);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		if (Scripting.FileSystemObject.ExistsFile(destination) ^&^& force ) {>> "%zipbat%"
echo 			Scripting.FileSystemObject.DeleteItem(destination);>> "%zipbat%"
echo 			ADODB.Stream.writeFile(destination,ZIP_DATA);>> "%zipbat%"
echo 		} else if (!Scripting.FileSystemObject.ExistsFile(destination)) {>> "%zipbat%"
echo 			ADODB.Stream.writeFile(destination,ZIP_DATA);>> "%zipbat%"
echo 		} else {>> "%zipbat%"
echo 			WScript.Echo("Destination "+destination+" already exists.Operation will be aborted");>> "%zipbat%"
echo 			WScript.Quit(15);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		source=Scripting.FileSystemObject.getFullPath(source);>> "%zipbat%"
echo 		destination=Scripting.FileSystemObject.getFullPath(destination);>> "%zipbat%"
echo.>> "%zipbat%"
echo 		Shell.Application.ProcessSubItems(source, destination, move ,true,NO_PROGRESS_BAR);>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (move){>> "%zipbat%"
echo 			Scripting.FileSystemObject.DeleteItem(source);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! this.ZIPUtils.Unzip) {>> "%zipbat%"
echo 	ZIPUtils.Unzip = function(source, destination ) {>> "%zipbat%"
echo 		if(!Shell.Application.ExistsFolder(source) ){>> "%zipbat%"
echo 			WScript.Echo("Either the target does not exist or is not a correct type");>> "%zipbat%"
echo 			return;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (Scripting.FileSystemObject.ExistsItem(destination) ^&^& force ) {>> "%zipbat%"
echo 			Scripting.FileSystemObject.DeleteItem(destination);>> "%zipbat%"
echo 		} else if (Scripting.FileSystemObject.ExistsItem(destination)){>> "%zipbat%"
echo 			WScript.Echo("Destination " + destination + " already exists");>> "%zipbat%"
echo 			return;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		Scripting.FileSystemObject.CreateFolder(destination);>> "%zipbat%"
echo 		source=Scripting.FileSystemObject.getFullPath(source);>> "%zipbat%"
echo 		destination=Scripting.FileSystemObject.getFullPath(destination);>> "%zipbat%"
echo 		Shell.Application.ProcessSubItems(source, destination, move ,false,NO_PROGRESS_BAR);>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (move){>> "%zipbat%"
echo 			Scripting.FileSystemObject.DeleteItem(source);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo     }	>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! this.ZIPUtils.AddToZip) {>> "%zipbat%"
echo 	ZIPUtils.AddToZip = function(source, destination ) {>> "%zipbat%"
echo 		if(!Shell.Application.ExistsFolder(destination)) {>> "%zipbat%"
echo 			WScript.Echo(destination +" is not valid path to/within zip.Be sure you are not using relative paths");>> "%zipbat%"
echo 			Wscript.Exit("101");>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		if(!Scripting.FileSystemObject.ExistsItem(source)){>> "%zipbat%"
echo 			WScript.Echo(source +" does not exist");>> "%zipbat%"
echo 			Wscript.Exit("102");>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		source=Scripting.FileSystemObject.getFullPath(source);>> "%zipbat%"
echo 		Shell.Application.ProcessItem(source,destination,move,true ,NO_PROGRESS_BAR);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! this.ZIPUtils.UnzipItem) {>> "%zipbat%"
echo 	ZIPUtils.UnzipItem = function(source, destination ) {>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if(!Shell.Application.ExistsSubItem(source)){>> "%zipbat%"
echo 			WScript.Echo(source + ":Either the target does not exist or is not a correct type");>> "%zipbat%"
echo 			return;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (Scripting.FileSystemObject.ExistsItem(destination) ^&^& force ) {>> "%zipbat%"
echo 			Scripting.FileSystemObject.DeleteItem(destination);>> "%zipbat%"
echo 		} else if (Scripting.FileSystemObject.ExistsItem(destination)){>> "%zipbat%"
echo 			WScript.Echo(destination+" - Destination already exists");>> "%zipbat%"
echo 			return;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo.>> "%zipbat%"
echo 		Scripting.FileSystemObject.CreateFolder(destination);>> "%zipbat%"
echo 		destination=Scripting.FileSystemObject.getFullPath(destination);>> "%zipbat%"
echo 		Shell.Application.ProcessItem(source, destination, move ,false,NO_PROGRESS_BAR);>> "%zipbat%"
echo.>> "%zipbat%"
echo     }	>> "%zipbat%"
echo }>> "%zipbat%"
echo if ( ! this.ZIPUtils.getSize) {>> "%zipbat%"
echo 	ZIPUtils.getSize = function(path) {>> "%zipbat%"
echo 		// first getting a full path to the file is attempted>> "%zipbat%"
echo 		// as it's required by shell.application>> "%zipbat%"
echo 		// otherwise is assumed that a file within a zip>> "%zipbat%"
echo 		// is aimed>> "%zipbat%"
echo.>> "%zipbat%"
echo 		//TODO - find full path even if the path points to internal for the>> "%zipbat%"
echo 		// zip directory>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (Scripting.FileSystemObject.ExistsFile(path)){>> "%zipbat%"
echo 			path=Scripting.FileSystemObject.getFullPath(path);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		WScript.Echo(Shell.Application.getSize(path));>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo if ( ! this.ZIPUtils.list) {>> "%zipbat%"
echo 	ZIPUtils.list = function(path) {>> "%zipbat%"
echo 		// first getting a full path to the file is attempted>> "%zipbat%"
echo 		// as it's required by shell.application>> "%zipbat%"
echo 		// otherwise is assumed that a file within a zip>> "%zipbat%"
echo 		// is aimed>> "%zipbat%"
echo.>> "%zipbat%"
echo 		//TODO - find full path even if the path points to internal for the>> "%zipbat%"
echo 		// zip directory>> "%zipbat%"
echo.>> "%zipbat%"
echo 		// TODO - optional printing of each file uncompressed size>> "%zipbat%"
echo.>> "%zipbat%"
echo 		if (Scripting.FileSystemObject.ExistsFile(path)){>> "%zipbat%"
echo 			path=Scripting.FileSystemObject.getFullPath(path);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		Shell.Application.ListItems(path);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo //>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo.>> "%zipbat%"
echo /////////////////////////////////////>> "%zipbat%"
echo //   parsing'n'running>> "%zipbat%"
echo function printHelp(){>> "%zipbat%"
echo.>> "%zipbat%"
echo 	WScript.Echo( scriptName + " list -source zipFile [-flat yes|no]");>> "%zipbat%"
echo 	WScript.Echo( "		list the content of a zip file");>> "%zipbat%"
echo 	WScript.Echo( "	zipFile - absolute path to the zip file");>> "%zipbat%"
echo 	WScript.Echo( "			could be also a directory or a directory inside a zip file or");>> "%zipbat%"
echo 	WScript.Echo( "			or a .cab file or an .iso file");>> "%zipbat%"
echo 	WScript.Echo( "	-flat - indicates if the structure of the zip will be printed as tree");>> "%zipbat%"
echo 	WScript.Echo( "			or with absolute paths (-flat yes).Default is yes.");>> "%zipbat%"
echo 	WScript.Echo( "Example:");>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " list -source C:\\myZip.zip -flat no" );>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " list -source C:\\myZip.zip\\inZipDir -flat yes" );>> "%zipbat%"
echo.>> "%zipbat%"
echo 	WScript.Echo( scriptName + " getSize -source zipFile");>> "%zipbat%"
echo 	WScript.Echo( "		prints uncompressed size of the zipped file in bytes");>> "%zipbat%"
echo 	WScript.Echo( "	zipFile - absolute path to the zip file");>> "%zipbat%"
echo 	WScript.Echo( "			could be also a directory or a directory inside a zip file or");>> "%zipbat%"
echo 	WScript.Echo( "			or a .cab file or an .iso file");>> "%zipbat%"
echo 	WScript.Echo( "Example:");>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " getSize -source C:\\myZip.zip" );>> "%zipbat%"
echo.>> "%zipbat%"
echo 	WScript.Echo( scriptName + " zipDirItems -source source_dir -destination destination.zip [-force yes|no] [-keep yes|no]");>> "%zipbat%"
echo 	WScript.Echo( "		zips the content of given folder without the folder itself ");>> "%zipbat%"
echo 	WScript.Echo( "	source_dir - path to directory which content will be compressed");>> "%zipbat%"
echo 	WScript.Echo( "		Empty folders in the source directory will be ignored");>> "%zipbat%"
echo 	WScript.Echo( "	destination.zip - path/name  of the zip file that will be created");>> "%zipbat%"
echo 	WScript.Echo( "	-force - indicates if the destination will be overwritten if already exists.");>> "%zipbat%"
echo 	WScript.Echo( "		default is yes");>> "%zipbat%"
echo 	WScript.Echo( "	-keep - indicates if the source content will be moved or just copied/kept.");>> "%zipbat%"
echo 	WScript.Echo( "		default is yes");>> "%zipbat%"
echo 	WScript.Echo( "Example:");>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " zipDirItems -source C:\\myDir\\ -destination C:\\MyZip.zip -keep yes -force no" );>> "%zipbat%"
echo.>> "%zipbat%"
echo 	WScript.Echo( scriptName + " zipItem -source item -destination destination.zip [-force yes|no] [-keep yes|no]");>> "%zipbat%"
echo 	WScript.Echo( "		zips file or directory to a destination.zip file ");>> "%zipbat%"
echo 	WScript.Echo( "	item - path to file or directory which content will be compressed");>> "%zipbat%"
echo 	WScript.Echo( "		If points to an empty folder it will be ignored");>> "%zipbat%"
echo 	WScript.Echo( "		If points to a folder it also will be included in the zip file alike zipdiritems command");>> "%zipbat%"
echo 	WScript.Echo( "		Eventually zipping a folder in this way will be faster as it does not process every element one by one");>> "%zipbat%"
echo 	WScript.Echo( "	destination.zip - path/name  of the zip file that will be created");>> "%zipbat%"
echo 	WScript.Echo( "	-force - indicates if the destination will be overwritten if already exists.");>> "%zipbat%"
echo 	WScript.Echo( "		default is yes");>> "%zipbat%"
echo 	WScript.Echo( "	-keep - indicates if the source content will be moved or just copied/kept.");>> "%zipbat%"
echo 	WScript.Echo( "		default is yes");>> "%zipbat%"
echo 	WScript.Echo( "Example:");>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " zipItem -source C:\\myDir\\myFile.txt -destination C:\\MyZip.zip -keep yes -force no" );>> "%zipbat%"
echo.>> "%zipbat%"
echo 	WScript.Echo( scriptName + " unzip -source source.zip -destination destination_dir [-force yes|no] [-keep yes|no]");>> "%zipbat%"
echo 	WScript.Echo( "		unzips the content of a zip file to a given directory ");>> "%zipbat%"
echo 	WScript.Echo( "	source - path to the zip file that will be expanded");>> "%zipbat%"
echo 	WScript.Echo( "		Eventually .iso , .cab or even an ordinary directory can be used as a source");>> "%zipbat%"
echo 	WScript.Echo( "	destination_dir - path to directory where unzipped items will be stored");>> "%zipbat%"
echo 	WScript.Echo( "	-force - indicates if the destination will be overwritten if already exists.");>> "%zipbat%"
echo 	WScript.Echo( "		default is yes");>> "%zipbat%"
echo 	WScript.Echo( "	-keep - indicates if the source content will be moved or just copied/kept.");>> "%zipbat%"
echo 	WScript.Echo( "		default is yes");>> "%zipbat%"
echo 	WScript.Echo( "Example:");>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " unzip -source C:\\myDir\\myZip.zip -destination C:\\MyDir -keep no -force no" );>> "%zipbat%"
echo.>> "%zipbat%"
echo 	WScript.Echo( scriptName + " unZipItem -source source.zip -destination destination_dir [-force yes|no] [-keep yes|no]");>> "%zipbat%"
echo 	WScript.Echo( "		unzips  a single within a given zip file to a destination directory");>> "%zipbat%"
echo 	WScript.Echo( "	source - path to the file/folcer within a zip  that will be expanded");>> "%zipbat%"
echo 	WScript.Echo( "		Eventually .iso , .cab or even an ordinary directory can be used as a source");>> "%zipbat%"
echo 	WScript.Echo( "	destination_dir - path to directory where unzipped item will be stored");>> "%zipbat%"
echo 	WScript.Echo( "	-force - indicates if the destination directory will be overwritten if already exists.");>> "%zipbat%"
echo 	WScript.Echo( "		default is yes");>> "%zipbat%"
echo 	WScript.Echo( "	-keep - indicates if the source content will be moved or just copied/kept.");>> "%zipbat%"
echo 	WScript.Echo( "		default is yes");>> "%zipbat%"
echo 	WScript.Echo( "Example:");>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " unZipItem -source C:\\myDir\\myZip.zip\\InzipDir\\InzipFile -destination C:\\OtherDir -keep no -force yes" );>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " unZipItem -source C:\\myDir\\myZip.zip\\InzipDir -destination C:\\OtherDir " );>> "%zipbat%"
echo.>> "%zipbat%"
echo 	WScript.Echo( scriptName + " addToZip -source sourceItem -destination destination.zip  [-keep yes|no]");>> "%zipbat%"
echo 	WScript.Echo( "		adds file or folder to already exist zip file");>> "%zipbat%"
echo 	WScript.Echo( "	source - path to the item that will be processed");>> "%zipbat%"
echo 	WScript.Echo( "	destination_zip - path to the zip where the item will be added");>> "%zipbat%"
echo 	WScript.Echo( "	-keep - indicates if the source content will be moved or just copied/kept.");>> "%zipbat%"
echo 	WScript.Echo( "		default is yes");>> "%zipbat%"
echo 	WScript.Echo( "Example:");>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " addToZip -source C:\\some_file -destination C:\\myDir\\myZip.zip\\InzipDir -keep no " );>> "%zipbat%"
echo 	WScript.Echo( "	" + scriptName + " addToZip -source  C:\\some_file -destination C:\\myDir\\myZip.zip " );>> "%zipbat%"
echo.>> "%zipbat%"
echo 	WScript.Echo( "	by Vasil \"npocmaka\" Arnaudov - npocmaka@gmail.com" );>> "%zipbat%"
echo 	WScript.Echo( "	ver 0.1.2 " );>> "%zipbat%"
echo 	WScript.Echo( "	latest version could be found here https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/zipjs.bat" );>> "%zipbat%"
echo.>> "%zipbat%"
echo.>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo function parseArguments(){>> "%zipbat%"
echo 	if (WScript.Arguments.Length==1 ^|^| WScript.Arguments.Length==2 ^|^| ARGS.Item(1).toLowerCase() == "-help" ^|^|  ARGS.Item(1).toLowerCase() == "-h" ) {>> "%zipbat%"
echo 		printHelp();>> "%zipbat%"
echo 		WScript.Quit(0);>> "%zipbat%"
echo    }>> "%zipbat%"
echo.>> "%zipbat%"
echo    //all arguments are key-value pairs plus one for script name and action taken - need to be even number>> "%zipbat%"
echo 	if (WScript.Arguments.Length %% 2 == 1 ) {>> "%zipbat%"
echo 		WScript.Echo("Illegal arguments ");>> "%zipbat%"
echo 		printHelp();>> "%zipbat%"
echo 		WScript.Quit(1);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo.>> "%zipbat%"
echo 	//ARGS>> "%zipbat%"
echo 	for(var arg = 2 ; arg^<ARGS.Length-1;arg=arg+2) {>> "%zipbat%"
echo 		if (ARGS.Item(arg) == "-source") {>> "%zipbat%"
echo 			source = ARGS.Item(arg +1);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		if (ARGS.Item(arg) == "-destination") {>> "%zipbat%"
echo 			destination = ARGS.Item(arg +1);>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		if (ARGS.Item(arg).toLowerCase() == "-keep" ^&^& ARGS.Item(arg +1).toLowerCase() == "no") {>> "%zipbat%"
echo 			move=true;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		if (ARGS.Item(arg).toLowerCase() == "-force" ^&^& ARGS.Item(arg +1).toLowerCase() == "no") {>> "%zipbat%"
echo 			force=false;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 		if (ARGS.Item(arg).toLowerCase() == "-flat" ^&^& ARGS.Item(arg +1).toLowerCase() == "yes") {>> "%zipbat%"
echo 			flat=true;>> "%zipbat%"
echo 		}>> "%zipbat%"
echo 	}>> "%zipbat%"
echo.>> "%zipbat%"
echo 	if (source == ""){>> "%zipbat%"
echo 		WScript.Echo("Source not given");>> "%zipbat%"
echo 		printHelp();>> "%zipbat%"
echo 		WScript.Quit(59);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo.>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo var checkDestination=function(){>> "%zipbat%"
echo 	if (destination == ""){>> "%zipbat%"
echo 		WScript.Echo("Destination not given");>> "%zipbat%"
echo 		printHelp();>> "%zipbat%"
echo 		WScript.Quit(65);>> "%zipbat%"
echo 	}>> "%zipbat%"
echo }>> "%zipbat%"
echo.>> "%zipbat%"
echo var main=function(){>> "%zipbat%"
echo 	parseArguments();>> "%zipbat%"
echo 	switch (ARGS.Item(1).toLowerCase()) {>> "%zipbat%"
echo 	case "list":>> "%zipbat%"
echo 		ZIPUtils.list(source);>> "%zipbat%"
echo 		break;>> "%zipbat%"
echo 	case "getsize":>> "%zipbat%"
echo 		ZIPUtils.getSize(source);>> "%zipbat%"
echo 		break;>> "%zipbat%"
echo 	case "zipdiritems":>> "%zipbat%"
echo 		checkDestination();>> "%zipbat%"
echo 		ZIPUtils.ZipDirItems(source,destination);>> "%zipbat%"
echo 		break;>> "%zipbat%"
echo 	case "zipitem":>> "%zipbat%"
echo 		checkDestination();>> "%zipbat%"
echo 		ZIPUtils.ZipItem(source,destination);>> "%zipbat%"
echo 		break;>> "%zipbat%"
echo 	case "unzip":>> "%zipbat%"
echo 		checkDestination();>> "%zipbat%"
echo 		ZIPUtils.Unzip(source,destination);>> "%zipbat%"
echo 		break;>> "%zipbat%"
echo 	case "unzipitem":>> "%zipbat%"
echo 		checkDestination();>> "%zipbat%"
echo 		ZIPUtils.UnzipItem(source,destination);>> "%zipbat%"
echo 		break;>> "%zipbat%"
echo 	case "addtozip":>> "%zipbat%"
echo 		checkDestination();>> "%zipbat%"
echo 		ZIPUtils.AddToZip(source,destination);>> "%zipbat%"
echo 		break;>> "%zipbat%"
echo 	default:>> "%zipbat%"
echo 		WScript.Echo("No valid switch has been passed");>> "%zipbat%"
echo 		printHelp();>> "%zipbat%"
echo.>> "%zipbat%"
echo 	}>> "%zipbat%"
echo.>> "%zipbat%"
echo }>> "%zipbat%"
echo main();>> "%zipbat%"
echo //>> "%zipbat%"
echo //////////////////////////////////////>> "%zipbat%"
echo.>> "%zipbat%"
exit /B
