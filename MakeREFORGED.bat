@ECHO OFF
SET LOG=%~1
call MakeVERBase.bat 0 REFORGED
ECHO =============================
if not "%LOG%"=="0" (
    pause
)
