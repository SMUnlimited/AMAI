@ECHO OFF
SET LOG=%~1
call MakeVERBase.bat 0 ROC
ECHO _____________________________
call ForwardsCompat.bat ROC
ECHO =============================
if not "%LOG%"=="0" (
    pause
)