@ECHO off
SET VER=REFORGED
SET COMMAND=1
SET COMMAND_STATE=常规控制台
SET SETMAP=1

:FunctionMenu
cls
ECHO. 请选择模式:
ECHO.
ECHO 1. 安装 AMAI (常规控制台) (默认)
ECHO 2. 安装 AMAI (VS暴雪AI控制台)
ECHO 3. 安装 AMAI (不安装控制台)
ECHO 4. 移除 AMAI 控制台
ECHO 5. 卸载 AMAI 及控制台
ECHO.
set /p choice=请输入并回车(1 ~ 5):

if "%choice%"=="1" (
  SET COMMAND=1
  SET COMMAND_STATE=常规控制台
)
if "%choice%"=="2" (
  SET COMMAND=2
  SET COMMAND_STATE=VS 暴雪AI 控制台
)
if "%choice%"=="3" (
  SET COMMAND=0
  SET COMMAND_STATE=不安装控制台
)
if "%choice%"=="4" (
  SET COMMAND=-1
  SET COMMAND_STATE=移除 AMAI 控制台
)
if "%choice%"=="5" (
  SET COMMAND=-2
  SET COMMAND_STATE=卸载 AMAI 及控制台
)

goto InstallMenu

:InstallMenu
cls
ECHO.
ECHO 模式: %COMMAND_STATE%
ECHO.
ECHO 请选择地图处理方式:
ECHO 1. 按文件夹批量处理 (默认)
ECHO 2. 逐张地图处理
ECHO.
set /p choice=请输入并回车(1 ~ 2):

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
ECHO 请选择魔兽3版本:
ECHO.
ECHO 1. 重制版 REFORGED (1.33+) (默认)
ECHO 2. 经典版-冰封王座  (1.24e+)
ECHO 3. 经典版-混乱之治  (1.24e ~ 1.31)
ECHO.
set /p choice=请输入并回车(1 ~ 3):

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
ECHO 魔兽3版本: %VER% , 控制台: %COMMAND_STATE% , 地图处理方式: 批量处理
ECHO.
ECHO 请输入地图文件夹路径
ECHO 例: C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=请输入并回车:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call InstallVERToMap !VER! "!%%~fF!" "%COMMAND%"
)
endlocal
goto EndScript

:InputMap
cls
ECHO.
ECHO 魔兽3版本: %VER% , 控制台: %COMMAND_STATE% , 地图处理方式: 逐张地图处理
ECHO.
ECHO 请输入地图文件夹路径及地图名(包括格式)
ECHO 例: C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=请输入并回车:

call InstallVERToMap %VER% "%filePath%" "%COMMAND%"
ECHO 若安装完成, 请关闭本窗口, 否则请点击任意键继续安装
pause
goto InputMap

:EndScript
pause

:UnInstallComMenu
if "%SETMAP%"=="1" (
  goto UnInstallComPath
) else (
  goto UnInstallComMap
)

:UnInstallComPath
cls
ECHO.
ECHO 移除AMAI控制台, 地图处理方式: 批量处理
ECHO.
ECHO 请输入地图文件夹路径
ECHO 例: C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=请输入并回车:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call UninstallCommander "!%%~fF!"
)
endlocal
goto EndUnScript

:UnInstallComMap
cls
ECHO.
ECHO 移除AMAI控制台, 地图处理方式: 逐张地图处理
ECHO.
ECHO 请输入地图文件夹路径及地图名(包括格式)
ECHO 例: C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=请输入并回车:

call UninstallCommander "%filePath%"
ECHO 若移除完成, 请关闭本窗口, 否则请点击任意键继续移除
pause
goto UnInstallComMap

:EndUnScript
pause

:UnInstallMenu
if "%SETMAP%"=="1" (
  goto UnInstallPath
) else (
  goto UnInstallMap
)

:UnInstallPath
cls
ECHO.
ECHO 卸载AMAI及控制台, 地图处理方式: 批量处理
ECHO.
ECHO 请输入地图文件夹路径
ECHO 例: C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=请输入并回车:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call Uninstall "!%%~fF!"
)
endlocal
goto EndUnScript

:UnInstallMap
cls
ECHO.
ECHO 卸载AMAI及控制台, 地图处理方式: 逐张地图处理
ECHO.
ECHO 请输入地图文件夹路径及地图名(包括格式)
ECHO 例: C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=请输入并回车:

call Uninstall "%filePath%"
ECHO 若卸载完成, 请关闭本窗口, 否则请点击任意键继续卸载
pause
goto UnInstallMap

:EndUnScript
pause