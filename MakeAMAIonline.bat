@ECHO OFF
ECHO Making AMAI
ECHO _____________________________
ECHO creating \在线工作流-测试\common.ai
perl ejass.pl common.eai TFT VER:TFT > 在线工作流-测试\common.ai
ECHO IGNORE jasshelper --scriptonly common.j Scripts\Blizzard.j 在线工作流-测试\common.ai 在线工作流-测试\common2.ai
ECHO \在线工作流-测试\common.ai created
pjass common.j 在线工作流-测试\common.ai
jassparser common.j 在线工作流-测试\common.ai
ECHO _____________________________
ECHO creating \在线工作流-测试\elf.ai
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > 在线工作流-测试\elf.ai
ECHO \在线工作流-测试\elf.ai created
pjass common.j 在线工作流-测试\common.ai 在线工作流-测试\elf.ai
jassparser common.j 在线工作流-测试\common.ai 在线工作流-测试\elf.ai
ECHO _____________________________
ECHO creating \在线工作流-测试\human.ai
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > 在线工作流-测试\human.ai
ECHO \在线工作流-测试\human.ai created
pjass common.j 在线工作流-测试\common.ai 在线工作流-测试\human.ai
jassparser common.j 在线工作流-测试\common.ai 在线工作流-测试\human.ai
ECHO _____________________________
ECHO creating \在线工作流-测试\orc.ai
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > 在线工作流-测试\orc.ai
ECHO \在线工作流-测试\orc.ai created
pjass common.j 在线工作流-测试\common.ai 在线工作流-测试\orc.ai
jassparser common.j 在线工作流-测试\common.ai 在线工作流-测试\orc.ai
ECHO _____________________________
ECHO creating \在线工作流-测试\undead.ai
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > 在线工作流-测试\undead.ai
ECHO \在线工作流-测试\undead.ai created
pjass common.j 在线工作流-测试\common.ai 在线工作流-测试\undead.ai
jassparser common.j 在线工作流-测试\common.ai 在线工作流-测试\undead.ai
ECHO _____________________________
ECHO creating \在线工作流-测试\Blizzard.j
perl SplitBlizzardJ.pl
perl ejass.pl Blizzard3.eai TFT VER:TFT > Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > Scripts\Blizzard.j
ECHO \在线工作流-测试\Blizzard.j created
pjass common.j 在线工作流-测试\Blizzard.j
jassparser common.j 在线工作流-测试\Blizzard.j
ECHO _____________________________
del blizzard1.j
del blizzard2.j
del blizzard3.j
del blizzard4.j
del blizzard5.j
del blizzard6.j
ECHO _____________________________
