@ECHO off
chcp 65001
SET VER=REFORGED
SET COMMAND=1
SET COMMAND_STATE=Install Commander

:VERMenu
cls
ECHO.
ECHO (1/4) Please select War3 version:
ECHO.
ECHO 1. REFORGED (1.33+) (default)
ECHO 2. TFT (1.24e ~ 1.32.10)
ECHO 3. ROC (1.24e ~ 1.31)
ECHO.
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
ECHO.
ECHO War3 version: %VER%
ECHO.
ECHO (2/4) Installation Commander?:
ECHO 1. Install Commander (default)
ECHO 2. Install VS AI Commander
ECHO 3. Not Install Commander
ECHO.
set /p choice=Input(1 ~ 3):

if "%choice%"=="1" (
  SET COMMAND=0
  SET COMMAND_STATE=Install Commander
)
if "%choice%"=="2" (
  SET COMMAND=1
  SET COMMAND_STATE=Install VS AI Commander
)
if "%choice%"=="3" (
  SET COMMAND=2
  SET COMMAND_STATE=Not Install Commander
)

goto InstallMenu

:InstallMenu
cls
ECHO.
ECHO War3 version: %VER% , Commander: %COMMAND_STATE%
ECHO.
ECHO (3/4) Please choose the installation method:
ECHO. 1. Install to Map Folder (default)
ECHO. 2. Install to Single Map
ECHO.
set /p choice=Input(1 ~ 2):

if "%choice%"=="1" (
  goto InputPath
)

if not "%choice%"=="1" (
  goto InputMap
)

:InputPath
cls
ECHO.
ECHO War3 version: %VER% , Commander: %COMMAND_STATE% , Installation Method : Map Folder
ECHO.
ECHO (4/4) Please enter the complete path of the map folder.
ECHO e.g. C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=Input:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call InstallVERToMap !VER! "!%%~fF!" "!COMMAND!"
)
endlocal
goto EndScript

:InputMap
cls
ECHO.
ECHO War3 version: %VER% , Commander: %COMMAND_STATE% , Installation Method : Single Map
ECHO.
ECHO (4/4) Please enter the complete path of the map folder and map File Name (with Format).
ECHO e.g. C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=Input:

call InstallVERToMap %VER% "%filePath%" "%COMMAND%"
ECHO If the installation is complete, please close this window, else please click any key to continue installation.
pause
goto InputMap

:EndScript
pause
