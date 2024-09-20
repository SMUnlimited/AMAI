@ECHO OFF
SET MAKEALL=%~1
if not "%MAKEALL%"=="1" (
  SET MAKEALL=0
)
call MakeVERBase.bat ROC %MAKEALL%
ECHO _____________________________
call ForwardsCompat.bat ROC
ECHO _____________________________
call MakeOptVER ROC %MAKEALL%
ECHO =============================
if "%RESULTMAKEVER%"=="1" (
  pause
)