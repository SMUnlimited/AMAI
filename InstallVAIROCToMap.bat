if not exist %1 (
	ECHO %1 Cannot be found
	exit 1
)
MPQEditor htsize %1 64
AddToMPQ %1 Scripts\ROC\common.ai Scripts\common.ai Scripts\Blizzard.j Scripts\Blizzard.j
AddToMPQ %1 Scripts\ROC\elf.ai Scripts\elf.ai
AddToMPQ %1 Scripts\ROC\human.ai Scripts\human.ai
AddToMPQ %1 Scripts\ROC\orc.ai Scripts\orc.ai
AddToMPQ %1 Scripts\ROC\undead.ai Scripts\undead.ai
ECHO adding blizzard_entertainment scripts
AddToMPQ %1 Scripts\ROC\elf2.ai Scripts\elf2.ai
AddToMPQ %1 Scripts\ROC\human2.ai Scripts\human2.ai
AddToMPQ %1 Scripts\ROC\orc2.ai Scripts\orc2.ai
AddToMPQ %1 Scripts\ROC\undead2.ai Scripts\undead2.ai
ECHO Installed AMAI to Map %1
pause