if not exist %1 (
	ECHO %1 Cannot be found
	exit 1
)
MPQEditor a %1 Scripts\Blizzard.j Scripts\Blizzard.j
MPQEditor f %1
ECHO Installed AMAI Commander to Map %1