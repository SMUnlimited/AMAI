@ECHO OFF
ECHO Making AMAI VS AI
ECHO NOTE: COMMANDER IS NOT SUPPORTED
ECHO _____________________________
ECHO creating \Scripts\ROC\common.ai
perl ejass.pl common.eai ROC VER:ROC > Scripts\ROC\common.ai
ECHO \Scripts\ROC\common.ai created
pjass common.j Scripts\ROC\common.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\elf.ai
perl ejass.pl races.eai ROC VER:ROC ELF RACE:ELF > Scripts\ROC\elf.ai
ECHO \Scripts\ROC\elf.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\elf.ai
pjass common.j Scripts\ROC\common.ai Scripts\ROC\elf2.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\human.ai
perl ejass.pl races.eai ROC VER:ROC HUMAN RACE:HUMAN > Scripts\ROC\human.ai
ECHO \Scripts\ROC\human.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\human.ai
pjass common.j Scripts\ROC\common.ai Scripts\ROC\human2.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\orc.ai
perl ejass.pl races.eai ROC VER:ROC ORC RACE:ORC > Scripts\ROC\orc.ai
ECHO \Scripts\ROC\orc.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\orc.ai
pjass common.j Scripts\ROC\common.ai Scripts\ROC\orc2.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\undead.ai
perl ejass.pl races.eai ROC VER:ROC UNDEAD RACE:UNDEAD > Scripts\ROC\undead.ai
ECHO \Scripts\ROC\undead.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\undead.ai
pjass common.j Scripts\ROC\common.ai Scripts\ROC\undead2.ai
ECHO _____________________________
ECHO creating \Scripts\Blizzard.j
perl ejass.pl BlizzardVAI.eai ROC VER:ROC > Scripts\Blizzard.j
ECHO \Scripts\Blizzard.j created
pjass common.j Scripts\Blizzard.j
ECHO _____________________________
ECHO creating \Scripts\ROC\AMAI.mpq
copy empty.mpq Scripts\ROC\AMAI.mpq
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\common.ai Scripts\common.ai Scripts\Blizzard.j Scripts\Blizzard.j
ECHO adding AMAI scripts
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\elf.ai Scripts\elf.ai
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\human.ai Scripts\human.ai
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\orc.ai Scripts\orc.ai
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\undead.ai Scripts\undead.ai
ECHO adding blizzard_entertainment scripts
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\elf2.ai Scripts\elf2.ai
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\human2.ai Scripts\human2.ai
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\orc2.ai Scripts\orc2.ai
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\undead2.ai Scripts\undead2.ai
copy Scripts\ROC\AMAI.mpq Scripts\AMAI.mpq
ECHO \Scripts\ROC\AMAI.mpq created
ECHO =============================
ECHO Making AMAI finished
pause