@ECHO OFF
SET LOG=%~1
if not "%LOG%"=="0" SET LOG=1
ECHO Making AMAI VS AI
call MakeVERBase.bat 1 ROC %LOG%
call ForwardsCompat.bat ROC %LOG%
ECHO =============================