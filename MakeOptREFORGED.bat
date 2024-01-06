@ECHO OFF
SET LOG=%~1
call MakeOptVER REFORGED
ECHO =============================
if not "%LOG%"=="0" (
    pause
)