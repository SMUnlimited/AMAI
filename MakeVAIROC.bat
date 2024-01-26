@ECHO OFF
SET LOG=%~1
call MakeVERBase.bat 1 ROC
ECHO _____________________________
call ForwardsCompat.bat ROC
ECHO =============================
if not "%LOG%"=="0" (
    pause
)