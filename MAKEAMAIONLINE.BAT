@ECHO OFF
ECHO 开始编译 AMAI
mkdir AMAI\
ECHO _____________________________
ECHO 创建公共库 AMAI\common.ai
perl ejass.pl common.eai TFT VER:TFT > AMAI\common.ai
ECHO AMAI\common.ai 创建完成
pjass common.j AMAI\common.ai
jassparser common.j AMAI\common.ai
ECHO _____________________________
ECHO 创建暗夜AI脚本 AMAI\elf.ai
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > AMAI\elf.ai
ECHO AMAI\elf.ai 创建完成
pjass common.j AMAI\common.ai AMAI\elf.ai
jassparser common.j AMAI\common.ai AMAI\elf.ai
ECHO _____________________________
ECHO 创建人族AI脚本 AMAI\human.ai
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > AMAI\human.ai
ECHO AMAI\human.ai 创建完成
pjass common.j AMAI\common.ai AMAI\human.ai
jassparser common.j AMAI\common.ai AMAI\human.ai
ECHO _____________________________
ECHO 创建兽族AI脚本 AMAI\orc.ai
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > AMAI\orc.ai
ECHO AMAI\orc.ai 创建完成
pjass common.j AMAI\common.ai AMAI\orc.ai
jassparser common.j AMAI\common.ai AMAI\orc.ai
ECHO _____________________________
ECHO 创建亡灵AI脚本 AMAI\undead.ai
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > AMAI\undead.ai
ECHO AMAI\undead.ai 创建完成
pjass common.j AMAI\common.ai AMAI\undead.ai
jassparser common.j AMAI\common.ai AMAI\undead.ai
ECHO _____________________________
ECHO 创建控制台 AMAI\Blizzard.j - AMAI VS AMAI 模式
perl SplitBlizzardJ.pl
perl ejass.pl Blizzard3.eai TFT VER:TFT > Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > AMAI\Blizzard.j
ECHO AMAI\Blizzard.j 创建完成
pjass common.j AMAI\Blizzard.j
jassparser common.j AMAI\Blizzard.j
ECHO _____________________________
ECHO 编译完成
