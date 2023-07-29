@ECHO OFF
ECHO Making AMAI
ECHO _____________________________
ECHO creating \Scripts\ROC\common.ai
perl ejass.pl common.eai ROC VER:ROC > Scripts\ROC\common.ai
ECHO \Scripts\ROC\common.ai created
ECHO _____________________________
ECHO creating \Scripts\ROC\elf.ai
perl ejass.pl races.eai ROC VER:ROC ELF RACE:ELF > Scripts\ROC\elf.ai
ECHO \Scripts\ROC\elf.ai created
ECHO _____________________________
ECHO creating \Scripts\ROC\human.ai
perl ejass.pl races.eai ROC VER:ROC HUMAN RACE:HUMAN > Scripts\ROC\human.ai
ECHO \Scripts\ROC\human.ai created
ECHO _____________________________
ECHO creating \Scripts\ROC\orc.ai
perl ejass.pl races.eai ROC VER:ROC ORC RACE:ORC > Scripts\ROC\orc.ai
ECHO \Scripts\ROC\orc.ai created
ECHO _____________________________
ECHO creating \Scripts\ROC\undead.ai
perl ejass.pl races.eai ROC VER:ROC UNDEAD RACE:UNDEAD > Scripts\ROC\undead.ai
ECHO \Scripts\ROC\undead.ai created
ECHO _____________________________
ECHO creating \Scripts\Blizzard.j
perl ejass.pl Blizzard.eai ROC VER:ROC > Scripts\Blizzard.j
ECHO \Scripts\Blizzard.j created
ECHO _____________________________
ECHO Optimizing Scripts
perl Optimize.pl Scripts\ROC\common.ai -l ROC\Races.txt Scripts\ROC\$2
perl Optimize.pl -b Scripts\Blizzard.j
ECHO Optimizing finished
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai Scripts\ROC\elf.ai
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai Scripts\ROC\human.ai
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai Scripts\ROC\orc.ai
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai Scripts\ROC\undead.ai
ECHO _____________________________
pjass common.j Scripts\Blizzard.j
ECHO _____________________________
ECHO =============================
ECHO Making AMAI finished
pause