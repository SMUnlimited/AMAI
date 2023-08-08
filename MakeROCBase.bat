@ECHO OFF
ECHO Making AMAI
ECHO _____________________________
ECHO creating \Scripts\ROC\common.ai
perl ejass.pl common.eai ROC VER:ROC > Scripts\ROC\common.ai
ECHO IGNORE jasshelper --scriptonly common.j Scripts\Blizzard.j Scripts\ROC\common.ai Scripts\ROC\common2.ai
ECHO \Scripts\ROC\common.ai created
pjass common.j Scripts\ROC\common.ai
jassparser common.j Scripts\ROC\common.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\elf.ai
perl ejass.pl races.eai ROC VER:ROC ELF RACE:ELF > Scripts\ROC\elf.ai
ECHO \Scripts\ROC\elf.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\elf.ai
jassparser common.j Scripts\ROC\common.ai Scripts\ROC\elf.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\human.ai
perl ejass.pl races.eai ROC VER:ROC HUMAN RACE:HUMAN > Scripts\ROC\human.ai
ECHO \Scripts\ROC\human.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\human.ai
jassparser common.j Scripts\ROC\common.ai Scripts\ROC\human.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\orc.ai
perl ejass.pl races.eai ROC VER:ROC ORC RACE:ORC > Scripts\ROC\orc.ai
ECHO \Scripts\ROC\orc.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\orc.ai
jassparser common.j Scripts\ROC\common.ai Scripts\ROC\orc.ai
ECHO _____________________________
ECHO creating \Scripts\ROC\undead.ai
perl ejass.pl races.eai ROC VER:ROC UNDEAD RACE:UNDEAD > Scripts\ROC\undead.ai
ECHO \Scripts\ROC\undead.ai created
pjass common.j Scripts\ROC\common.ai Scripts\ROC\undead.ai
jassparser common.j Scripts\ROC\common.ai Scripts\ROC\undead.ai
ECHO _____________________________
ECHO creating \Scripts\Blizzard.j
perl ejass.pl Blizzard.eai ROC VER:ROC > Scripts\Blizzard.j
ECHO \Scripts\Blizzard.j created
pjass common.j Scripts\Blizzard.j
jassparser common.j Scripts\Blizzard.j
ECHO _____________________________