@ECHO OFF
SET LOG=%~1
call MakeVERBase.bat 1 REFORGED
ECHO =============================
if not "%LOG%"=="0" SET LOG=1
if not "%LOG%"=="0" (
    pause
)