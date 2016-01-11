@rem Choose the Visual Studio tools to use
@echo off

SETLOCAL EnableDelayedExpansion
REM Part of :colorEcho. See link below
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

@rem Check command line arguments
IF "%1"=="" GOTO BAD_ARGS
SET version=%1

SET platform=bad
IF "%2"=="x64" SET platform=amd64
IF "%2"=="" SET platform=
IF "%2"=="x86" SET platform=

IF "%platform%"=="bad" GOTO BAD_ARGS

@rem Check Visual Studio version
SET display_version=%version%
IF "%version%"=="10" SET display_version=2010
IF "%version%"=="11" SET display_version=2012
IF "%version%"=="12" SET display_version=2013
IF "%version%"=="14" SET display_version=2015
IF "%version%"=="2010" SET version=10
IF "%version%"=="2012" SET version=11
IF "%version%"=="2013" SET version=12
IF "%version%"=="2015" SET version=14
IF "version"=="display_version" GOTO BAD_VERSION

SET dir="c:\program files (x86)\microsoft visual studio %version%.0"
SET vcvarsall=%dir%\vc\vcvarsall.bat %platform%
IF NOT EXIST %vcvarsall% GOTO NOT_INSTALLED

SET bits=32
IF "%platform%"=="amd64" SET bits=64

SET new_title=Visual Studio %display_version% (%bits% bits)
call :colorEcho 0A "Switching to %new_title%"
TITLE %new_title% Command Prompt
ENDLOCAL & SET vcvarsall=%vcvarsall%

%vcvarsall%
SET vcvarsall=
EXIT /B 0

:BAD_ARGS
ECHO Usage: CHOOSE_VS Version [x64]
ECHO.
ECHO Version is the Visual Studio version (for example 10, 2012, 2015, etc...) 
ECHO Specify x64 if you want to use the 64-bit tools.
EXIT /B 1

:BAD_VERSION
call :colorEcho 0C "Unsupported Visual Studio version, only 2010 (10), 2012(11), 2013(12) and 2015(14) are supported."
EXIT /B 1

:NOT_INSTALLED
call :colorEcho 0C "Visual Studio %display_version% does not seem to be installed."
echo Looked for it at %dir%
EXIT /B 1

@REM Taken from here: http://stackoverflow.com/a/21666354/871910
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i
echo.

