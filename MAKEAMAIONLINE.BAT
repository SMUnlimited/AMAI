@ECHO OFF
SET RESULTMAKEVER=0
ECHO 开始编译 AMAI
mkdir AMAI\
ECHO _____________________________
perl ejass.pl common.eai TFT VER:TFT > AMAI\common.ai
ECHO 公共库创建完成
pjass common.j AMAI\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser common.j AMAI\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > AMAI\elf.ai
ECHO 暗夜AI脚本创建完成
pjass common.j AMAI\common.ai AMAI\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser common.j AMAI\common.ai AMAI\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > AMAI\human.ai
ECHO 人族AI脚本创建完成
pjass common.j AMAI\common.ai AMAI\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser common.j AMAI\common.ai AMAI\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > AMAI\orc.ai
ECHO 兽族AI脚本创建完成
pjass common.j AMAI\common.ai AMAI\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser common.j AMAI\common.ai AMAI\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > AMAI\undead.ai
ECHO 亡灵AI脚本创建完成
pjass common.j AMAI\common.ai AMAI\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser common.j AMAI\common.ai AMAI\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
perl SplitBlizzardJ.pl
perl ejass.pl Blizzard3.eai TFT VER:TFT > Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > AMAI\Blizzard.j
ECHO 控制台（AMAI VS AMAI 模式）创建完成
pjass common.j AMAI\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser common.j AMAI\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
if "%RESULTMAKEVER%"=="1" (
ECHO fail
mkdir AMAI\附件不可用--请耐心等待新的在线编译附件
) else (
ECHO done
mkdir AMAI\附件可用--请按教程安装
)
