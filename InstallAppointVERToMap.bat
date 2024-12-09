@ECHO off
SET VER=REFORGED
SET COMMAND=1
SET COMMAND_STATE=�������̨
SET SETMAP=1

:FunctionMenu
cls
ECHO. ��ѡ��ģʽ:
ECHO.
ECHO 1. ��װ AMAI (�������̨) (Ĭ��)
ECHO 2. ��װ AMAI (VS��ѩAI����̨)
ECHO 3. ��װ AMAI (����װ����̨)
ECHO 4. �Ƴ� AMAI ����̨
ECHO 5. ж�� AMAI ������̨
ECHO.
set /p choice=�����벢�س�(1 ~ 5):

if "%choice%"=="1" (
  SET COMMAND=1
  SET COMMAND_STATE=�������̨
)
if "%choice%"=="2" (
  SET COMMAND=2
  SET COMMAND_STATE=VS ��ѩAI ����̨
)
if "%choice%"=="3" (
  SET COMMAND=0
  SET COMMAND_STATE=����װ����̨
)
if "%choice%"=="4" (
  SET COMMAND=-1
  SET COMMAND_STATE=�Ƴ� AMAI ����̨
)
if "%choice%"=="5" (
  SET COMMAND=-2
  SET COMMAND_STATE=ж�� AMAI ������̨
)

goto InstallMenu

:InstallMenu
cls
ECHO.
ECHO ģʽ: %COMMAND_STATE%
ECHO.
ECHO ��ѡ���ͼ����ʽ:
ECHO 1. ���ļ����������� (Ĭ��)
ECHO 2. ���ŵ�ͼ����
ECHO.
set /p choice=�����벢�س�(1 ~ 2):

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
ECHO ��ѡ��ħ��3�汾:
ECHO.
ECHO 1. ���ư� REFORGED (1.33+) (Ĭ��)
ECHO 2. �����-��������  (1.24e+)
ECHO 3. �����-����֮��  (1.24e ~ 1.31)
ECHO.
set /p choice=�����벢�س�(1 ~ 3):

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
ECHO ħ��3�汾: %VER% , ����̨: %COMMAND_STATE% , ��ͼ����ʽ: ��������
ECHO.
ECHO �������ͼ�ļ���·��
ECHO ��: C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=�����벢�س�:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call InstallVERToMap !VER! "!%%~fF!" "%COMMAND%"
)
endlocal
goto EndScript

:InputMap
cls
ECHO.
ECHO ħ��3�汾: %VER% , ����̨: %COMMAND_STATE% , ��ͼ����ʽ: ���ŵ�ͼ����
ECHO.
ECHO �������ͼ�ļ���·������ͼ��(������ʽ)
ECHO ��: C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=�����벢�س�:

call InstallVERToMap %VER% "%filePath%" "%COMMAND%"
ECHO ����װ���, ��رձ�����, �������������������װ
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
ECHO �Ƴ�AMAI����̨, ��ͼ����ʽ: ��������
ECHO.
ECHO �������ͼ�ļ���·��
ECHO ��: C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=�����벢�س�:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call UninstallCommander "!%%~fF!"
)
endlocal
goto EndUnScript

:UnInstallComMap
cls
ECHO.
ECHO �Ƴ�AMAI����̨, ��ͼ����ʽ: ���ŵ�ͼ����
ECHO.
ECHO �������ͼ�ļ���·������ͼ��(������ʽ)
ECHO ��: C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=�����벢�س�:

call UninstallCommander "%filePath%"
ECHO ���Ƴ����, ��رձ�����, ������������������Ƴ�
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
ECHO ж��AMAI������̨, ��ͼ����ʽ: ��������
ECHO.
ECHO �������ͼ�ļ���·��
ECHO ��: C:\Documents\Warcraft III\Maps
ECHO.
set /p searchPath=�����벢�س�:

setlocal enabledelayedexpansion
for %%F in ("%searchPath%\*.w3x" "%searchPath%\*.w3m") do (
  call Uninstall "!%%~fF!"
)
endlocal
goto EndUnScript

:UnInstallMap
cls
ECHO.
ECHO ж��AMAI������̨, ��ͼ����ʽ: ���ŵ�ͼ����
ECHO.
ECHO �������ͼ�ļ���·������ͼ��(������ʽ)
ECHO ��: C:\Documents\Warcraft III\Maps\Friends_v1.2.w3x
ECHO.
set /p filePath=�����벢�س�:

call Uninstall "%filePath%"
ECHO ��ж�����, ��رձ�����, �����������������ж��
pause
goto UnInstallMap

:EndUnScript
pause