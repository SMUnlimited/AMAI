@ECHO OFF
SET LOG=%~1
if not "%LOG%"=="0" SET LOG=2
ECHO Making AMAI VS AI
call MakeVERBase.bat 1 REFORGED %LOG%
ECHO =============================