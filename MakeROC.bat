@ECHO OFF
SET LOG=%~1
if not "%LOG%"=="0" SET LOG=1
call MakeVERBase.bat 0 ROC %LOG%
call ForwardsCompat.bat ROC %LOG%
ECHO =============================