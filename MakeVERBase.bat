@ECHO OFF
SET VER=%~1
SET SILENT=%~2
SET RESULTMAKEVER=0
call perlcheck.bat
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
if "%RESULTMAKEVER%"=="1" (
  ECHO Compilation AMAI Optimization %VER% error
  ECHO Perl version check failed. Exiting. Download : https://strawberryperl.com/
  exit /b %RESULTMAKEVER%
)
mkdir Scripts\
mkdir Scripts\%VER%\
ECHO _____________________________
ECHO creating \Scripts\%VER%\common.ai
perl ejass.pl common.eai %VER% VER:%VER% > Scripts\%VER%\common.ai
ECHO IGNORE jasshelper --scriptonly common.j Scripts\%VER%\Blizzard.j Scripts\%VER%\vsai\Blizzard.j Scripts\%VER%\common.ai Scripts\%VER%\common2.ai
ECHO \Scripts\%VER%\common.ai created
pjass %VER%\common.j Scripts\%VER%\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\%VER%\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO creating \Scripts\%VER%\elf.ai
perl ejass.pl races.eai %VER% VER:%VER% ELF RACE:ELF > Scripts\%VER%\elf.ai
ECHO \Scripts\%VER%\elf.ai created
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO creating \Scripts\%VER%\human.ai
perl ejass.pl races.eai %VER% VER:%VER% HUMAN RACE:HUMAN > Scripts\%VER%\human.ai
ECHO \Scripts\%VER%\human.ai created
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO creating \Scripts\%VER%\orc.ai
perl ejass.pl races.eai %VER% VER:%VER% ORC RACE:ORC > Scripts\%VER%\orc.ai
ECHO \Scripts\%VER%\orc.ai created
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
ECHO creating \Scripts\%VER%\undead.ai
perl ejass.pl races.eai %VER% VER:%VER% UNDEAD RACE:UNDEAD > Scripts\%VER%\undead.ai
ECHO \Scripts\%VER%\undead.ai created
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
perl SplitBlizzardJ.pl %VER%
ECHO _____________________________
ECHO creating \Scripts\%VER%\vsai\Blizzard.j
perl ejass.pl Blizzard3VAI.eai %VER% VER:%VER% > %VER%\tmp\Blizzard3Gen.j
perl ejass.pl Blizzard.eai %VER% VER:%VER% > Scripts\%VER%\vsai\Blizzard.j
pjass %VER%\common.j Scripts\%VER%\vsai\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\%VER%\vsai\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO \Scripts\%VER%\vsai\Blizzard.j created
ECHO _____________________________
ECHO creating \Scripts\%VER%\Blizzard.j
perl ejass.pl Blizzard3.eai %VER% VER:%VER% > %VER%\tmp\Blizzard3Gen.j
perl ejass.pl Blizzard.eai %VER% VER:%VER% > Scripts\%VER%\Blizzard.j
pjass %VER%\common.j Scripts\%VER%\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\%VER%\Blizzard.j
ECHO \Scripts\%VER%\Blizzard.j created
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
rmdir /s /q "%VER%/tmp"
if "%RESULTMAKEVER%"=="1" (
  ECHO Compilation AMAI %VER% error
  if "%SILENT%" neq "1" (
    pause
    ECHO Exiting
    exit /b %RESULTMAKEVER%
  )
) else (
  ECHO Making AMAI %VER% finish
)
