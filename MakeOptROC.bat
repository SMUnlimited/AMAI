@ECHO OFF
SET LOG=%~1
call MakeOptVER ROC
ECHO =============================
if not "%LOG%"=="0" (
    pause
)