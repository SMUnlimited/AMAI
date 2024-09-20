@ECHO OFF
SET MAKEALL=%~1
if not "%MAKEALL%"=="1" (
  SET MAKEALL=0
)
call TFT/Inherit.bat
ECHO _____________________________
call MakeVERBase.bat TFT %MAKEALL%
ECHO _____________________________
call ForwardsCompat.bat TFT
ECHO =============================
if "%RESULTMAKEVER%"=="1" (
  pause
)