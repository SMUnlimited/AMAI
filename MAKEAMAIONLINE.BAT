@ECHO OFF
ECHO Making AMAI
mkdir AMAI\
ECHO _____________________________
ECHO creating AMAI\common.ai
perl ejass.pl common.eai TFT VER:TFT > AMAI\common.ai
ECHO IGNORE jasshelper --scriptonly common.j AMAI\Blizzard.j AMAI\common.ai AMAI\common2.ai
ECHO AMAI\common.ai created
pjass common.j AMAI\common.ai
jassparser common.j AMAI\common.ai
ECHO _____________________________
ECHO creating AMAI\elf.ai
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > AMAI\elf.ai
ECHO AMAI\elf.ai created
pjass common.j AMAI\common.ai AMAI\elf.ai
jassparser common.j AMAI\common.ai AMAI\elf.ai
ECHO _____________________________
ECHO creating AMAI\human.ai
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > AMAI\human.ai
ECHO AMAI\human.ai created
pjass common.j AMAI\common.ai AMAI\human.ai
jassparser common.j AMAI\common.ai AMAI\human.ai
ECHO _____________________________
ECHO creating AMAI\orc.ai
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > AMAI\orc.ai
ECHO AMAI\orc.ai created
pjass common.j AMAI\common.ai AMAI\orc.ai
jassparser common.j AMAI\common.ai AMAI\orc.ai
ECHO _____________________________
ECHO creating AMAI\undead.ai
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > AMAI\undead.ai
ECHO AMAI\undead.ai created
pjass common.j AMAI\common.ai AMAI\undead.ai
jassparser common.j AMAI\common.ai AMAI\undead.ai
ECHO _____________________________
ECHO creating AMAI\Blizzard.j VSAI Flag set to %VSAI%
perl SplitBlizzardJ.pl
perl ejass.pl Blizzard3.eai TFT VER:TFT > Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > AMAI\Blizzard.j
ECHO AMAI\Blizzard.j created
pjass common.j AMAI\Blizzard.j
jassparser common.j AMAI\Blizzard.j
ECHO _____________________________
