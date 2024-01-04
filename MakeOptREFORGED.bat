@ECHO OFF
SET LOG=%~1
if not "%LOG%"=="0" SET LOG=1
call MakeOptVER REFORGED %LOG%