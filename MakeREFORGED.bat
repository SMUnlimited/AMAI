@ECHO OFF
SET LOG=%~1
call MakeVERBase.bat 0 REFORGED
ECHO =============================
if not "%LOG%"=="0" SET LOG=1
if not "%LOG%"=="0" (
    ECHO Making AMAI finished
    pause
)
