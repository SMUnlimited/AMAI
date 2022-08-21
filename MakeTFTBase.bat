@ECHO OFF
SET VSAI=%1
ECHO Making AMAI
ECHO _____________________________
ECHO creating \Scripts\TFT\common.ai
perl ejass.pl common.eai TFT VER:TFT > Scripts\TFT\common.ai
ECHO IGNORE jasshelper --scriptonly common.j Scripts\Blizzard.j Scripts\TFT\common.ai Scripts\TFT\common2.ai
ECHO \Scripts\TFT\common.ai created
pjass common.j Scripts\TFT\common.ai
jassparser common.j Scripts\TFT\common.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\elf.ai
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > Scripts\TFT\elf.ai
ECHO \Scripts\TFT\elf.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
jassparser common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\human.ai
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > Scripts\TFT\human.ai
ECHO \Scripts\TFT\human.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
jassparser common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\orc.ai
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > Scripts\TFT\orc.ai
ECHO \Scripts\TFT\orc.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
jassparser common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\undead.ai
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > Scripts\TFT\undead.ai
ECHO \Scripts\TFT\undead.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
jassparser common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
ECHO _____________________________
ECHO creating \Scripts\Blizzard.j VSAI Flag set to %VSAI%
perl SplitBlizzardJ.pl
if %VSAI% == 1 perl ejass.pl Blizzard3VAI.eai TFT VER:TFT > Blizzard3Gen.j
if %VSAI% == 0 perl ejass.pl Blizzard3.eai TFT VER:TFT > Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > Scripts\Blizzard.j
ECHO \Scripts\Blizzard.j created
pjass common.j Scripts\Blizzard.j
jassparser common.j Scripts\Blizzard.j
ECHO _____________________________
