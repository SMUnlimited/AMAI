@echo off
where perl
if "%errorlevel%"=="1" (
  echo Compilation AMAI Optimization %VER% error
  ECHO Please install Perl as a requirement to compile AMAI. Download : https://strawberryperl.com/
  exit /b 1
)
REM --- Retrieve the Perl version as a string (e.g., "5.30.0") ---
for /f "usebackq tokens=*" %%i in (`perl -e "printf '%%vd', $^V;"`) do (
    set PERLVERSION=%%i
)

if "%PERLVERSION%"=="" (
    echo Error: Perl not found. Please install Strawberry Perl 5.30 or later.
    exit /b 1
)

REM --- Remove a leading "v" if it exists (e.g., "v5.30.0" -> "5.30.0") ---
if "%PERLVERSION:~0,1%"=="v" (
    set PERLVERSION=%PERLVERSION:~1%
)

REM --- Parse the version string into major, minor, and patch numbers ---
for /f "tokens=1-3 delims=." %%a in ("%PERLVERSION%") do (
    set major=%%a
    set minor=%%b
    set patch=%%c
)

echo Detected Perl version: %major%.%minor%.%patch%

if %major% LSS 5 (
    echo Strawberry Perl 5.30 or newer is required. Found version: %PERLVERSION%.
    exit /b 1
)
if %major% EQU 5 (
    if %minor% LSS 30 (
        echo Strawberry Perl 5.30 or newer is required. Found version: %PERLVERSION%.
        exit /b 1
    )
)

echo Perl version is acceptable....