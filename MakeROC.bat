@ECHO OFF
SET SILENT=%~1
call MakeVERBase.bat ROC %SILENT%
call ForwardsCompat.bat ROC