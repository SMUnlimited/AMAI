@ECHO off
chcp 65001
SET VER=REFORGED
SET COMMAND=1
SET COMMAND_STATE=安装常规控制台

:VERMenu
cls
ECHO.
ECHO (1/4) 请选择魔兽3版本:
ECHO.
ECHO 1. 重制版 REFORGED (1.33+) (默认)
ECHO 2. 经典版-冰封王座 TFT (1.24e+)
ECHO 3. 经典版-混乱之治 ROC (1.24e ~ 1.31)
ECHO.
set /p choice=请输入(1 ~ 3):

if "%choice%"=="1" (
  set VER=REFORGED
)
if "%choice%"=="2" (
  set VER=TFT
)
if "%choice%"=="3" (
  set VER=ROC
)

goto ComMenu

:ComMenu
cls
ECHO.
ECHO 魔兽版本: %VER%
ECHO.
ECHO (2/4) 控制台选项:
ECHO 1. 安装常规控制台 (默认)
ECHO 2. 安装 VS AI 控制台 (VS 第三方 AI)
ECHO 3. 不安装控制台
ECHO.
set /p choice=请输入(1 ~ 3):

if "%choice%"=="1" (
  SET COMMAND=0
  SET COMMAND_STATE =安装常规控制台
)
if "%choice%"=="2" (
  SET COMMAND=1
  SET COMMAND_STATE =安装 VS AI 控制台
)
if "%choice%"=="3" (
  SET COMMAND=2
  SET COMMAND_STATE =不安装控制台
)

goto InstallMenu

:InstallMenu
cls
ECHO.
ECHO 魔兽版本: %VER% , 控制台: %COMMAND_STATE%
ECHO.
ECHO (3/4) 请选择安装方式:
ECHO. 1. 批量安装 (默认)
ECHO. 2. 逐张地图安装
ECHO.
set /p choice=请输入(1 ~ 2):

if "%choice%"=="1" (
  goto InputPath
)

if not "%choice%"=="1" (
  goto InputMap
)


:InputPath
cls
ECHO.
ECHO 魔兽版本: %VER% , 控制台: %COMMAND_STATE% , 安装方式: 批量安装
ECHO.
ECHO (4/4) 请输入地图文件夹路径.
ECHO 例: C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=请输入:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call InstallVERToMap !VER! "!%%~fF!" "!COMMAND!"
)
endlocal
goto EndScript

:InputMap
cls
ECHO.
ECHO 魔兽版本: %VER% , 控制台: %COMMAND_STATE% , 安装方式: 逐张地图安装
ECHO.
ECHO (4/4)请输入地图文件夹路径及地图名(包括格式)
ECHO 例: C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=请输入:

call InstallVERToMap %VER% "%filePath%" "%COMMAND%"
ECHO 若安装完成,请关闭本窗口,否则请点击任意键继续安装
pause
goto InputMap

:EndScript
pause