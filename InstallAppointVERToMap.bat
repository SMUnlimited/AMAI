@echo off
chcp 65001
SET VER=REFORGED
SET COMMAND=1

:VERMenu
cls
echo.
echo Please select war3 version:
echo 1. REFORGED (1.33+) (default)
echo 2. TFT (1.24e ~ 1.32.10)
echo 3. ROC (1.24e ~ 1.31)

echo.
set /p choice=Input(1 ~ 3):

if "%choice%"=="1" (
  set VER=REFORGED
)
if "%choice%"=="2" (
  set VER=TFT
)
if "%choice%"=="3" (
  set VER=ROC
)

goto comMenu

:comMenu
cls
echo.
echo Installation Commander?:
echo 1. Install Commander (default)
echo 2. Install VS AI Commander
echo 3. Not Install Commander
echo.
set /p choice=Input(1 ~ 3):

if "%choice%"=="1" (
  SET COMMAND=0
)
if "%choice%"=="2" (
  SET COMMAND=1
)
if "%choice%"=="3" (
  SET COMMAND=2
)

goto InstallMenu

:InstallMenu
cls
echo.
echo Please choose the installation method:
Echo. 1. Batch installation (default)
Echo. 2. Install a single map
echo.
set /p choice=Input(1 ~ 2):

if "%choice%"=="1" (
:InputPath
cls
echo.
ECHO Please enter the complete path of the map folder.
ECHO e.g. C:\Documents\Warcraft III\Maps
set /p searchPath=Input:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call InstallVERToMap !VER! "!%%~fF!" "!COMMAND!"
)
endlocal
pause
)
if not "%choice%"=="1" (
:InputMap
cls
echo.
ECHO Please enter the complete path of the map folder and map File Name (with Format).
ECHO e.g. C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
set /p filePath=Input:
ECHO %filePath%
  call InstallVERToMap %VER% "%filePath%" "%COMMAND%"
pause
goto InputMap
)
