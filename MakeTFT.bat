@ECHO OFF
@REM call TFT/Inherit.bat Manually call this when need to refresh TFT state.
SET SILENT=%~1
call MakeVERBase.bat TFT %SILENT%
call ForwardsCompat.bat TFT