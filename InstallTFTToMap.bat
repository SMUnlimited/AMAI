if not exist %1 (
	ECHO %1 Cannot be found
	exit 1
)
MPQEditor htsize %1 64
MPQEditor a %1 Scripts\TFT\*.ai Scripts
MPQEditor f %1
ECHO Installed AMAI to Map %1
pause