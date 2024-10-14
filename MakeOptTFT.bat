@ECHO OFF
SET MAKEALL=%~1
if not "%MAKEALL%"=="1" (
  SET MAKEALL=0
)
@REM call TFT/Inherit.bat Manually call this when need to refresh TFT state.
ECHO _____________________________
call MakeVERBase.bat TFT %MAKEALL%
ECHO _____________________________
call ForwardsCompat.bat TFT
ECHO _____________________________
call MakeOptVER TFT %MAKEALL%
ECHO =============================
if "%RESULTMAKEVER%"=="1" (
  pause
)