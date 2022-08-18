@ECHO OFF
ECHO Making AMAI
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
ECHO _____________________________
ECHO creating \Scripts\ROC\human.ai
perl ejass.pl races.eai ROC VER:ROC HUMAN RACE:HUMAN > Scripts\ROC\human.ai
ECHO \Scripts\ROC\human.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\human.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\orc.ai
perl ejass.pl races.eai ROC VER:ROC ORC RACE:ORC > Scripts\ROC\orc.ai
ECHO \Scripts\ROC\orc.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\orc.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\undead.ai
perl ejass.pl races.eai ROC VER:ROC UNDEAD RACE:UNDEAD > Scripts\ROC\undead.ai
ECHO \Scripts\ROC\undead.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\undead.ai
ECHO _____________________________
ECHO creating \Scripts\Blizzard.j
perl ejass.pl Blizzard.eai ROC VER:ROC > Scripts\Blizzard.j
ECHO \Scripts\Blizzard.j created
pjass common.j Scripts\Blizzard.j
ECHO _____________________________
ECHO creating \Scripts\ROC\AMAI.mpq
copy empty.mpq Scripts\ROC\AMAI.mpq
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\common.ai Scripts\common.ai Scripts\Blizzard.j Scripts\Blizzard.j
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\elf.ai Scripts\elf.ai
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\human.ai Scripts\human.ai
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\orc.ai Scripts\orc.ai
AddToMPQ Scripts\ROC\AMAI.mpq Scripts\ROC\undead.ai Scripts\undead.ai
copy Scripts\ROC\AMAI.mpq Scripts\AMAI.mpq
ECHO \Scripts\ROC\AMAI.mpq created
ECHO =============================
ECHO Making AMAI finished
pause