if not exist %1 (
	ECHO %1 Cannot be found
	exit 1
)
MPQEditor d %1 Scripts\Blizzard.j
MPQEditor f %1
ECHO Disabled AMAI Commander on Map %1