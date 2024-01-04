@ECHO OFF
SET LOG=%~1
if not "%LOG%"=="0" SET LOG=2
call MakeVERBase.bat 0 REFORGED %LOG%
ECHO =============================