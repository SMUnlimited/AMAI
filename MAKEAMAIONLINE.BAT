SET LOG=0
@call MakeREFORGED %LOG%
@call MakeTFT %LOG%
rmdir /s /q "Scripts/REFORGED/elf2.ai"
rmdir /s /q "Scripts/REFORGED/human2.ai"
rmdir /s /q "Scripts/REFORGED/orc2.ai"
rmdir /s /q "Scripts/REFORGED/undead2.ai"
rmdir /s /q "Scripts/TFT/elf2.ai"
rmdir /s /q "Scripts/TFT/human2.ai"
rmdir /s /q "Scripts/TFT/orc2.ai"
rmdir /s /q "Scripts/TFT/undead2.ai"




; @ECHO OFF
; SET RESULTMAKEVER=0
; ECHO 开始编译 AMAI
; mkdir AMAI\
; ECHO _____________________________
; perl ejass.pl common.eai TFT VER:TFT > AMAI\common.ai
; ECHO 创建公共库
; pjass common.j AMAI\common.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; jassparser common.j AMAI\common.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; ECHO _____________________________
; perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > AMAI\elf.ai
; ECHO 创建暗夜AI脚本
; pjass common.j AMAI\common.ai AMAI\elf.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; jassparser common.j AMAI\common.ai AMAI\elf.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; ECHO _____________________________
; perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > AMAI\human.ai
; ECHO 创建人族AI脚本
; pjass common.j AMAI\common.ai AMAI\human.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; jassparser common.j AMAI\common.ai AMAI\human.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; ECHO _____________________________
; perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > AMAI\orc.ai
; ECHO 创建兽族AI脚本
; pjass common.j AMAI\common.ai AMAI\orc.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; jassparser common.j AMAI\common.ai AMAI\orc.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; ECHO _____________________________
; perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > AMAI\undead.ai
; ECHO 创建亡灵AI脚本
; pjass common.j AMAI\common.ai AMAI\undead.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; jassparser common.j AMAI\common.ai AMAI\undead.ai
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; ECHO _____________________________
; perl SplitBlizzardJ.pl
; perl ejass.pl Blizzard3.eai TFT VER:TFT > Blizzard3Gen.j
; perl ejass.pl Blizzard.eai TFT VER:TFT > AMAI\Blizzard.j
; ECHO 创建控制台（AMAI VS AMAI 模式）
; pjass common.j AMAI\Blizzard.j
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; jassparser common.j AMAI\Blizzard.j
; if "%errorlevel%"=="1" SET RESULTMAKEVER=1
; ECHO _____________________________
; if "%RESULTMAKEVER%"=="1" (
; ECHO 编译失败，附件不可用--请耐心等待新的在线编译附件
; echo 附件不可用--请勿安装并等待新的在线编译附件 > AMAI\脚本不可用.txt
; ) else (
; ECHO 编译成功，附件可用--请按教程安装
; echo 附件可用--请按教程安装...仅支持1.33+ > AMAI\脚本可用.txt
; )
