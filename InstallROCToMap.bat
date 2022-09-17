if not exist %1 (
	ECHO %1 Cannot be found
	exit 1
)
MPQEditor htsize %1 64
MPQEditor a %1 Scripts\ROC\*.ai Scripts
MPQEditor a %1 Scripts\Blizzard.j Scripts\Blizzard.j
MPQEditor f %1
ECHO Installed AMAI to Map %1
pause