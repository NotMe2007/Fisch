@echo off
REM Start the AutoHotkey script; if AutoHotkey is not installed, run the bundled installer.
cd /d "%~dp0"

REM Common locations to check for AutoHotkey executable
REM 1) Try to find AutoHotkey via PATH using 'where'
set "AHK_EXE="
for /f "delims=" %%I in ('where AutoHotkey.exe 2^>nul') do (
    set "AHK_EXE=%%~I"
    goto :foundAHK
)

REM 2) Search for any AutoHotkey*.exe under common install locations (handles AutoHotkey64/U64 names)
for %%D in (
    "%ProgramFiles%"
    "%ProgramW6432%"
    "%ProgramFiles(x86)%"
    "%LocalAppData%\Programs"
) do (
    if not "%%~D"=="" if exist "%%~D" (
        for /f "delims=" %%J in ('where /r "%%~D" AutoHotkey*.exe 2^>nul') do (
            set "AHK_EXE=%%~J"
            goto :foundAHK
        )
    )
)

REM 3) Check for local copies near the script: AutoHotkey64.exe / AutoHotkey32.exe or in submacros\
if exist "%~dp0AutoHotkey64.exe" set "AHK_EXE=%~dp0AutoHotkey64.exe"
if exist "%~dp0AutoHotkey32.exe" if "%AHK_EXE%"=="" set "AHK_EXE=%~dp0AutoHotkey32.exe"
if "%AHK_EXE%"=="" if exist "%~dp0submacros\" (
    for /f "delims=" %%K in ('where /r "%~dp0submacros" AutoHotkey*.exe 2^>nul') do (
        set "AHK_EXE=%%~K"
        goto :foundAHK
    )
)

REM 4) Also search the user profile for any AutoHotkey executables (handles portable copies in user folders)
if "%AHK_EXE%"=="" (
    for /f "delims=" %%U in ('where /r "%USERPROFILE%" AutoHotkey*.exe 2^>nul') do (
        set "AHK_EXE=%%~U"
        goto :foundAHK
    )
)

:foundAHK

REM If found, start the AHK script with the detected executable
if exist "%AHK_EXE%" (
    REM Launch the AutoHotkey executable elevated so the script runs with admin rights.
    REM This will trigger a UAC prompt; if the user accepts, the script runs as Administrator.
    powershell -NoProfile -Command "& { Start-Process -FilePath '%AHK_EXE%' -ArgumentList '%~dp0V12 - Feb 8th.ahk' -Verb RunAs }"
    exit /b 0
) else (
    REM If installer is bundled next to this script, run it; otherwise inform the user.
    if exist "%~dp0AutoHotkey_2.0.19_setup.exe" (
        start "" "%~dp0AutoHotkey_2.0.19_setup.exe"
        exit /b 0
    ) else (
        echo AutoHotkey not found and installer not present in the script folder.
    echo Please install AutoHotkey v2 or place AutoHotkey_2.0.19_setup.exe next to this script.
        pause
        exit /b 1
    )
)
