SET VER=%1
if "%~2" == "" (
	ECHO %2 Map cannot be found
	exit 1
)
MPQEditor htsize %2 64
MPQEditor a %2 Scripts\%VER%\*.ai Scripts
if "%~3" == "1" (
  ECHO Installed Commander to Map
  MPQEditor a %2 Scripts\Blizzard_%VER%.j Scripts\Blizzard.j
)
MPQEditor f %2
ECHO Installed %VER% AMAI to Map %2
pause