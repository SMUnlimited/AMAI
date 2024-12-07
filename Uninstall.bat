@ECHO OFF
if not exist %1 (
	ECHO %1 Cannot be found
	exit /b 1
)
MPQEditor d %1 Scripts\common.ai
MPQEditor d %1 Scripts\elf.ai
MPQEditor d %1 Scripts\human.ai
MPQEditor d %1 Scripts\orc.ai
MPQEditor d %1 Scripts\undead.ai
MPQEditor d %1 Scripts\elf2.ai
MPQEditor d %1 Scripts\human2.ai
MPQEditor d %1 Scripts\orc2.ai
MPQEditor d %1 Scripts\undead2.ai
MPQEditor f %1
ECHO Uninstalled AMAI on Map %1