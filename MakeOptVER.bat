@ECHO OFF
SET VER=%1
ECHO Optimizing Scripts
perl Optimize.pl %VER%\common.j Scripts\%VER%\common.ai -l %VER%\Races.txt Scripts\%VER%\$2
perl Optimize.pl -b Scripts\Blizzard.j
ECHO Optimizing finished
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\elf.ai
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\human.ai
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\orc.ai
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\undead.ai
ECHO _____________________________
pjass %VER%\common.j Scripts\Blizzard.j
ECHO =============================
ECHO Making AMAI finished
pause