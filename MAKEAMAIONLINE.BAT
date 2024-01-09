@ECHO OFF
ECHO Making AMAI
ECHO _____________________________
ECHO creating \上传\common.ai
perl ejass.pl common.eai TFT VER:TFT > 上传\common.ai
ECHO IGNORE jasshelper --scriptonly common.j 上传\Blizzard.j 上传\common.ai 上传\common2.ai
ECHO \上传\common.ai created
pjass common.j 上传\common.ai
jassparser common.j 上传\common.ai
ECHO _____________________________
ECHO creating \上传\elf.ai
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > 上传\elf.ai
ECHO \上传\elf.ai created
pjass common.j 上传\common.ai 上传\elf.ai
jassparser common.j 上传\common.ai 上传\elf.ai
ECHO _____________________________
ECHO creating \上传\human.ai
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > 上传\human.ai
ECHO \上传\human.ai created
pjass common.j 上传\common.ai 上传\human.ai
jassparser common.j 上传\common.ai 上传\human.ai
ECHO _____________________________
ECHO creating \上传\orc.ai
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > 上传\orc.ai
ECHO \上传\orc.ai created
pjass common.j 上传\common.ai 上传\orc.ai
jassparser common.j 上传\common.ai 上传\orc.ai
ECHO _____________________________
ECHO creating \上传\undead.ai
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > 上传\undead.ai
ECHO \上传\undead.ai created
pjass common.j 上传\common.ai 上传\undead.ai
jassparser common.j 上传\common.ai 上传\undead.ai
ECHO _____________________________
ECHO creating \上传\Blizzard.j VSAI Flag set to %VSAI%
perl SplitBlizzardJ.pl
perl ejass.pl Blizzard3.eai TFT VER:TFT > Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > 上传\Blizzard.j
ECHO \上传\Blizzard.j created
pjass common.j 上传\Blizzard.j
jassparser common.j 上传\Blizzard.j
ECHO _____________________________
