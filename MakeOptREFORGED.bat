@ECHO OFF
SET LOG=%~1
call MakeOptVER REFORGED
ECHO =============================
if not "%LOG%"=="0" SET LOG=1
if "%LOG%" == "1" (
    pause
)