@ECHO OFF
SET MAKEALL=%~1
if not "%MAKEALL%"=="1" (
  SET MAKEALL=0
)
call MakeVERBase.bat 0 ROC %MAKEALL%
ECHO _____________________________
call ForwardsCompat.bat ROC
ECHO =============================
if "%RESULTMAKEVER%"=="1" (
  pause
)