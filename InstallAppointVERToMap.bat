@ECHO off
SET VER=REFORGED
SET COMMAND=1
SET COMMAND_STATE=Convention Commander
SET SETMAP=1

:FunctionMenu
cls
ECHO. Please select Mode:
ECHO.
ECHO 1. Install AMAI (Convention Commander) (default)
ECHO 2. Install AMAI (VS VanillaAI Commander)
ECHO 3. Install AMAI (No Commander)
ECHO 4. Remove AMAI Commander
ECHO 5. Remove AMAI Script and Commander
ECHO.
set /p choice=Input and Enter(1 ~ 5):

if "%choice%"=="1" (
  SET COMMAND=1
  SET COMMAND_STATE=Convention Commander
)
if "%choice%"=="2" (
  SET COMMAND=2
  SET COMMAND_STATE=VS VanillaAI Commander
)
if "%choice%"=="3" (
  SET COMMAND=0
  SET COMMAND_STATE=No Commander
)
if "%choice%"=="4" (
  SET COMMAND=-1
  SET COMMAND_STATE=Remove AMAI AMAI Commander
)
if "%choice%"=="5" (
  SET COMMAND=-2
  SET COMMAND_STATE=Remove AMAI AMAI Script and Commander
)

goto InstallMenu

:InstallMenu
cls
ECHO.
ECHO Mode: %COMMAND_STATE%
ECHO.
ECHO Please choose Map process Method:
ECHO 1. Batch process by Folder (default)
ECHO 2. Each process by Map
ECHO.
set /p choice=Input and Enter(1 ~ 2):

if "%choice%"=="1" (
  if "%COMMAND%"=="-1" (
    goto UnInstallComMenu
  ) else if "%COMMAND%"=="-2" (
    goto UnInstallMenu
  ) else (
    goto VERMenu
  )
)

if not "%choice%"=="1" (
  set SETMAP=0
  if "%COMMAND%"=="-1" (
    goto UnInstallComMenu
  ) else if "%COMMAND%"=="-2" (
    goto UnInstallMenu
  ) else (
    goto VERMenu
  )
)

:VERMenu
cls
ECHO.
ECHO Please select War3 version:
ECHO.
ECHO 1. REFORGED (1.33+) (default)
ECHO 2. TFT      (1.24e+)
ECHO 3. ROC      (1.24e ~ 1.31)
ECHO.
set /p choice=Input and Enter(1 ~ 3):

if "%choice%"=="1" (
  set VER=REFORGED
)
if "%choice%"=="2" (
  set VER=TFT
)
if "%choice%"=="3" (
  set VER=ROC
)
if "%SETMAP%"=="1" (
  goto InputPath
) else (
  goto InputMap
)

:InputPath
cls
ECHO.
ECHO War3 version: %VER% , Commander: %COMMAND_STATE% , Map process Method: Batch process by Folder
ECHO.
ECHO Please enter the complete path of the map folder.
ECHO e.g. C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=Input and Enter:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call InstallVERToMap !VER! "!%%~fF!" "%COMMAND%"
)
endlocal
goto EndScript

:InputMap
cls
ECHO.
ECHO War3 version: %VER% , Commander: %COMMAND_STATE% , Map process Method: Each process by Map
ECHO.
ECHO Please enter the complete path of the map folder. and map File Name (with Format).
ECHO e.g. C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=Input and Enter:

call InstallVERToMap %VER% "%filePath%" "%COMMAND%"
ECHO If the installation is complete, please close this window, else please click any key to continue installation.
pause
goto InputMap

:UnInstallComMenu
if "%SETMAP%"=="1" (
  goto UnInstallComPath
) else (
  goto UnInstallComMap
)

:UnInstallComPath
cls
ECHO.
ECHO RemoveAMAICommander, Map process Method: Batch process by Folder
ECHO.
ECHO Please enter the complete path of the map folder.
ECHO e.g. C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=Input and Enter:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call UninstallCommander "!%%~fF!"
)
endlocal
goto EndScript

:UnInstallComMap
cls
ECHO.
ECHO RemoveAMAICommander, Map process Method: Each process by Map
ECHO.
ECHO Please enter the complete path of the map folder. and map File Name (with Format).
ECHO e.g. C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=Input and Enter:

call UninstallCommander "%filePath%"
ECHO If the Remove is complete, please close this window, else please click any key to continue Remove.
pause
goto UnInstallComMap

:UnInstallMenu
if "%SETMAP%"=="1" (
  goto UnInstallPath
) else (
  goto UnInstallMap
)

:UnInstallPath
cls
ECHO.
ECHO Remove AMAI Script and Commander, Map process Method: Batch process by Folder
ECHO.
ECHO Please enter the complete path of the map folder.
ECHO e.g. C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=Input and Enter:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call Uninstall "!%%~fF!"
)
endlocal
goto EndScript

:UnInstallMap
cls
ECHO.
ECHO Remove AMAI Script and Commander, Map process Method: Each process by Map
ECHO.
ECHO Please enter the complete path of the map folder. and map File Name (with Format).
ECHO e.g. C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=Input and Enter:

call Uninstall "%filePath%"
ECHO If the Remove is complete, please close this window, else please click any key to continue Remove.
pause
goto UnInstallMap

:EndScript
pause
