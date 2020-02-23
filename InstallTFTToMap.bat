if not exist %1 (
	ECHO %1 Cannot be found
	exit 1
)
MPQEditor htsize %1 64
AddToMPQ %1 Scripts\TFT\common.ai Scripts\common.ai Scripts\Blizzard.j Scripts\Blizzard.j
AddToMPQ %1 Scripts\TFT\elf.ai Scripts\elf.ai
AddToMPQ %1 Scripts\TFT\human.ai Scripts\human.ai
AddToMPQ %1 Scripts\TFT\orc.ai Scripts\orc.ai
AddToMPQ %1 Scripts\TFT\undead.ai Scripts\undead.ai
ECHO Installed AMAI to Map %1
pause