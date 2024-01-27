@ECHO OFF
SET LOG=%~1
call TFT/Inherit.bat
ECHO _____________________________
call MakeVERBase.bat 0 TFT
ECHO _____________________________
call ForwardsCompat.bat TFT
ECHO =============================
if not "%LOG%"=="0" (
    pause
)