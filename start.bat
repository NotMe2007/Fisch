@echo off
REM Start the AutoHotkey script; if AutoHotkey is not installed, run the bundled installer.
cd /d "%~dp0"

REM Common locations to check for AutoHotkey executable
set "AHK_EXE=%ProgramFiles%\AutoHotkey\AutoHotkey.exe"
if not exist "%AHK_EXE%" (
	if defined ProgramW6432 if exist "%ProgramW6432%\AutoHotkey\AutoHotkey.exe" set "AHK_EXE=%ProgramW6432%\AutoHotkey\AutoHotkey.exe"
)
if not exist "%AHK_EXE%" (
	if defined ProgramFiles(x86) if exist "%ProgramFiles(x86)%\AutoHotkey\AutoHotkey.exe" set "AHK_EXE=%ProgramFiles(x86)%\AutoHotkey\AutoHotkey.exe"
)

REM If found, start the AHK script with the detected executable
if exist "%AHK_EXE%" (
	start "Fisch Script" "%AHK_EXE%" "%~dp0V12 - Feb 8th.ahk"
	exit /b 0
) else (
	REM If installer is bundled next to this script, run it; otherwise inform the user.
	if exist "%~dp0AutoHotkey_2.0.19_setup.exe" (
		start "" "%~dp0AutoHotkey_2.0.19_setup.exe"
		exit /b 0
	) else (
		echo AutoHotkey not found and installer not present in the script folder.
		echo Please install AutoHotkey (v2) or place AutoHotkey_2.0.19_setup.exe next to this script.
		pause
		exit /b 1
	)
)
