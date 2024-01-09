@ECHO OFF
ECHO Making AMAI
ECHO _____________________________
ECHO creating .\download\common.ai
perl ejass.pl common.eai TFT VER:TFT > .\download\common.ai
ECHO IGNORE jasshelper --scriptonly common.j .\download\Blizzard.j .\download\common.ai .\download\common2.ai
ECHO .\download\common.ai created
pjass common.j .\download\common.ai
jassparser common.j .\download\common.ai
ECHO _____________________________
ECHO creating .\download\elf.ai
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > .\download\elf.ai
ECHO .\download\elf.ai created
pjass common.j .\download\common.ai .\download\elf.ai
jassparser common.j .\download\common.ai .\download\elf.ai
ECHO _____________________________
ECHO creating .\download\human.ai
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > .\download\human.ai
ECHO .\download\human.ai created
pjass common.j .\download\common.ai .\download\human.ai
jassparser common.j .\download\common.ai .\download\human.ai
ECHO _____________________________
ECHO creating .\download\orc.ai
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > .\download\orc.ai
ECHO .\download\orc.ai created
pjass common.j .\download\common.ai .\download\orc.ai
jassparser common.j .\download\common.ai .\download\orc.ai
ECHO _____________________________
ECHO creating .\download\undead.ai
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > .\download\undead.ai
ECHO .\download\undead.ai created
pjass common.j .\download\common.ai .\download\undead.ai
jassparser common.j .\download\common.ai .\download\undead.ai
ECHO _____________________________
ECHO creating .\download\Blizzard.j
perl SplitBlizzardJonline.pl
perl ejass.pl Blizzard3.eai TFT VER:TFT > .\back\Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > .\download\Blizzard.j
ECHO .\download\Blizzard.j created
pjass common.j .\download\Blizzard.j
jassparser common.j .\download\Blizzard.j
ECHO _____________________________
del .\back\blizzard1.j
del .\back\blizzard2.j
del .\back\blizzard3.j
del .\back\Blizzard3Gen.j
del .\back\blizzard4.j
del .\back\blizzard5.j
del .\back\blizzard6.j
ECHO _____________________________
