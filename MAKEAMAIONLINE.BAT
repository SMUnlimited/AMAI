@ECHO OFF
ECHO 编译 AMAI 冰封王座 AMAI VS AMAI
mkdir AMAI\
ECHO 编译重制版
SET RESULTMAKEREF=0
mkdir AMAI\REFORGED\
ECHO _____________________________
ECHO 创建公共库
perl ejass.pl common.eai REFORGED VER:REFORGED > AMAI\REFORGED\common.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建暗夜脚本
perl ejass.pl races.eai REFORGED VER:REFORGED ELF RACE:ELF > AMAI\REFORGED\elf.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建人族脚本
perl ejass.pl races.eai REFORGED VER:REFORGED HUMAN RACE:HUMAN > AMAI\REFORGED\human.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建兽族脚本
perl ejass.pl races.eai REFORGED VER:REFORGED ORC RACE:ORC > AMAI\REFORGED\orc.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建亡灵脚本
perl ejass.pl races.eai REFORGED VER:REFORGED UNDEAD RACE:UNDEAD > AMAI\REFORGED\undead.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
ECHO _____________________________
ECHO 创建控制台
perl SplitBlizzardJ.pl REFORGED 0
perl ejass.pl Blizzard3.eai REFORGED VER:REFORGED > REFORGED\tmp\Blizzard3Gen.j
perl ejass.pl Blizzard.eai REFORGED VER:REFORGED > AMAI\Blizzard_REFORGED.j
pjass REFORGED\common.j AMAI\Blizzard_REFORGED.j
if "%errorlevel%"=="1" SET RESULTMAKEREF=1
jassparser REFORGED\common.j AMAI\Blizzard_REFORGED.j
ECHO _____________________________
ECHO 优化代码以减小压缩包体积
perl Optimize.pl REFORGED\common.j AMAI\REFORGED\common.ai -l REFORGED\Races.txt AMAI\REFORGED\$2
perl Optimize.pl -b AMAI\Blizzard_REFORGED.j
pjass REFORGED\common.j AMAI\REFORGED\common.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\elf.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\human.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\orc.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\undead.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass REFORGED\common.j AMAI\Blizzard_REFORGED.j
if "%errorlevel%"=="1" SET RESULTOPTVER=1
ECHO 重制版编译完成，编译结果在日志最后输出
ECHO =============================
ECHO 编译经典版
SET RESULTMAKETFT=0
mkdir AMAI\TFT\
call TFT/Inherit.bat
ECHO _____________________________
ECHO 创建公共库
perl ejass.pl common.eai TFT VER:TFT > AMAI\TFT\common.ai
pjass TFT\common.j AMAI\TFT\common.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j AMAI\TFT\common.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建暗夜脚本
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > AMAI\TFT\elf.ai
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j AMAI\TFT\common.ai AMAI\TFT\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建人族脚本
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > AMAI\TFT\human.ai
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\human.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j AMAI\TFT\common.ai AMAI\TFT\human.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建兽族脚本
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > AMAI\TFT\orc.ai
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j AMAI\TFT\common.ai AMAI\TFT\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建亡灵脚本
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > AMAI\TFT\undead.ai
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j AMAI\TFT\common.ai AMAI\TFT\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO _____________________________
ECHO 创建控制台
perl SplitBlizzardJ.pl TFT 0
perl ejass.pl Blizzard3.eai TFT VER:TFT > TFT\tmp\Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > AMAI\Blizzard_TFT.j
pjass TFT\common.j AMAI\Blizzard_TFT.j
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
jassparser TFT\common.j AMAI\Blizzard_TFT.j
ECHO _____________________________
ECHO 优化代码以减小压缩包体积
perl Optimize.pl TFT\common.j AMAI\TFT\common.ai -l TFT\Races.txt AMAI\TFT\$2
perl Optimize.pl -b AMAI\Blizzard_TFT.j
pjass TFT\common.j AMAI\TFT\common.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\elf.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\human.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\orc.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\undead.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass TFT\common.j AMAI\Blizzard_TFT.j
if "%errorlevel%"=="1" SET RESULTMAKETFT=1
ECHO 经典版编译完成，编译结果在日志最后输出
ECHO =============================
ECHO 编译结果
ECHO _____________________________
if "%RESULTMAKEREF%"=="1" (
  ECHO 重制版编译失败，附件重制版不可用--请耐心等待新的在线编译附件
  echo 附件重制版不可用--请勿安装并等待新的在线编译附件 > AMAI\重制版脚本不可用.txt
) else (
  ECHO 重制版编译成功，重制版附件可用--请按教程安装
  echo 重制版附件可用--请按教程安装（为减少压缩包体积，代码已优化且失去阅读性）...仅支持1.33+，平衡性为战网最新正式版 > AMAI\重制版脚本可用.txt
)
ECHO _____________________________
if "%RESULTMAKETFT%"=="1" (
  ECHO 经典版编译失败，附件经典版不可用--请耐心等待新的在线编译附件
  echo 附件经典版不可用--请勿安装并等待新的在线编译附件 > AMAI\经典版脚本不可用.txt
) else (
  ECHO 经典版编译成功，经典版附件可用--请按教程安装
  echo 经典版附件可用--请按教程安装（为减少压缩包体积，代码已优化且失去阅读性）...支持冰封王座1.24e+，平衡性为1.24e > AMAI\经典版脚本可用.txt
)
ECHO =============================
