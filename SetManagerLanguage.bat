@echo off
setlocal enabledelayedexpansion


if "%~1"=="" (
    exit /b 1
)

set "TargetFilePath=Manager_language.txt"
set "FileContent=%~1"
set "TempFile=%TEMP%\temp_content_%RANDOM%.txt"
(
    set /p =%FileContent%<nul
) > "%TempFile%"
move /Y "%TempFile%" "%TargetFilePath%" >nul
if %ERRORLEVEL% neq 0 (
    del "%TempFile%"
    exit /b 1
)
start AMAIStrategyManager.pl
endlocal