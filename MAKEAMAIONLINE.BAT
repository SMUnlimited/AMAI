@ECHO OFF
ECHO Making AMAI
ECHO _____________________________
ECHO creating \S\common.ai
perl ejass.pl common.eai TFT VER:TFT > S\common.ai
ECHO IGNORE jasshelper --scriptonly common.j S\Blizzard.j S\common.ai S\common2.ai
ECHO \S\common.ai created
pjass common.j S\common.ai
jassparser common.j S\common.ai
ECHO _____________________________
ECHO creating \S\elf.ai
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > S\elf.ai
ECHO \S\elf.ai created
pjass common.j S\common.ai S\elf.ai
jassparser common.j S\common.ai S\elf.ai
ECHO _____________________________
ECHO creating \S\human.ai
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > S\human.ai
ECHO \S\human.ai created
pjass common.j S\common.ai S\human.ai
jassparser common.j S\common.ai S\human.ai
ECHO _____________________________
ECHO creating \S\orc.ai
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > S\orc.ai
ECHO \S\orc.ai created
pjass common.j S\common.ai S\orc.ai
jassparser common.j S\common.ai S\orc.ai
ECHO _____________________________
ECHO creating \S\undead.ai
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > S\undead.ai
ECHO \S\undead.ai created
pjass common.j S\common.ai S\undead.ai
jassparser common.j S\common.ai S\undead.ai
ECHO _____________________________
ECHO creating \S\Blizzard.j VSAI Flag set to %VSAI%
perl SplitBlizzardJ.pl
perl ejass.pl Blizzard3.eai TFT VER:TFT > Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > S\Blizzard.j
ECHO \S\Blizzard.j created
pjass common.j S\Blizzard.j
jassparser common.j S\Blizzard.j
ECHO _____________________________
