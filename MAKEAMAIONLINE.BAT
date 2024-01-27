@ECHO OFF
SET RESULTMAKEVER=0
ECHO 编译 AMAI 重置版-冰封王座 AMAI VS AMAI
mkdir AMAI\
mkdir Scripts\
mkdir AMAI\REFORGED\
mkdir REFORGED\
ECHO _____________________________
ECHO 创建公共库
perl ejass.pl common.eai REFORGED VER:REFORGED > AMAI\REFORGED\common.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建暗夜脚本
perl ejass.pl races.eai REFORGED VER:REFORGED ELF RACE:ELF > AMAI\REFORGED\elf.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建人族脚本
perl ejass.pl races.eai REFORGED VER:REFORGED HUMAN RACE:HUMAN > AMAI\REFORGED\human.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建兽族脚本
perl ejass.pl races.eai REFORGED VER:REFORGED ORC RACE:ORC > AMAI\REFORGED\orc.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建亡灵脚本
perl ejass.pl races.eai REFORGED VER:REFORGED UNDEAD RACE:UNDEAD > AMAI\REFORGED\undead.ai
pjass REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser REFORGED\common.j AMAI\REFORGED\common.ai AMAI\REFORGED\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建控制台
perl SplitBlizzardJ.pl REFORGED
perl ejass.pl Blizzard3.eai REFORGED VER:REFORGED > REFORGED\tmp\Blizzard3Gen.j
perl ejass.pl Blizzard.eai REFORGED VER:REFORGED > AMAI\Blizzard_REFORGED.j
pjass REFORGED\common.j AMAI\Blizzard_REFORGED.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser REFORGED\common.j AMAI\Blizzard_REFORGED.j
ECHO _____________________________
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
if "%RESULTMAKEVER%"=="1" (
  ECHO 编译失败，附件重置版不可用--请耐心等待新的在线编译附件
  echo 附件重置版不可用--请勿安装并等待新的在线编译附件 > AMAI\重置版脚本不可用.txt
) else (
  ECHO 编译成功，附件重置版可用--请按教程安装
  echo 附件重置版可用--请按教程安装...仅支持1.33+ > AMAI\重置版脚本可用.txt
)
ECHO =============================
SET RESULTMAKEVER=0
ECHO 编译 AMAI 经典版-冰封王座 AMAI VS AMAI
mkdir AMAI\TFT\
mkdir TFT\
call TFT/Inherit.bat
ECHO _____________________________
ECHO 创建公共库
perl ejass.pl common.eai TFT VER:TFT > AMAI\TFT\common.ai
pjass TFT\common.j AMAI\TFT\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser TFT\common.j AMAI\TFT\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建暗夜脚本
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > AMAI\TFT\elf.ai
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser TFT\common.j AMAI\TFT\common.ai AMAI\TFT\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建人族脚本
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > AMAI\TFT\human.ai
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser TFT\common.j AMAI\TFT\common.ai AMAI\TFT\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建兽族脚本
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > AMAI\TFT\orc.ai
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser TFT\common.j AMAI\TFT\common.ai AMAI\TFT\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建亡灵脚本
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > AMAI\TFT\undead.ai
pjass TFT\common.j AMAI\TFT\common.ai AMAI\TFT\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser TFT\common.j AMAI\TFT\common.ai AMAI\TFT\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO 创建控制台
perl SplitBlizzardJ.pl TFT
perl ejass.pl Blizzard3.eai TFT VER:TFT > TFT\tmp\Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > AMAI\Blizzard_TFT.j
pjass TFT\common.j AMAI\Blizzard_TFT.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser TFT\common.j AMAI\Blizzard_TFT.j
ECHO _____________________________
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
if "%RESULTMAKEVER%"=="1" (
  ECHO 编译失败，附件经典版不可用--请耐心等待新的在线编译附件
  echo 附件经典版不可用--请勿安装并等待新的在线编译附件 > AMAI\经典版脚本不可用.txt
) else (
  ECHO 编译成功，附件经典版可用--请按教程安装
  echo 附件经典版可用--请按教程安装...仅支持1.33+ > AMAI\经典版脚本可用.txt
)
ECHO =============================
