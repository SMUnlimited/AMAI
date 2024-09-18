@ECHO OFF
SET VSAI=%~1
SET VER=%~2
SET MAKEALL=%~3
SET RESULTMAKEVER=0
if %VSAI% == 1 (
ECHO Making AMAI %VER% VS AI
)
if %VSAI% == 0 (
ECHO Making AMAI %VER%
)
where perl
if "%errorlevel%"=="1" SET RESULTOPTVER=1
if "%RESULTOPTVER%"=="1" (
  ECHO Compilation AMAI Optimization %VER% error
  ECHO Please install Perl as a requirement to compile AMAI. Download : https://strawberryperl.com/
  exit /b %RESULTOPTVER%
)
mkdir Scripts\
mkdir Scripts\%VER%\
ECHO _____________________________
ECHO creating \Scripts\%VER%\common.ai
perl ejass.pl common.eai %VER% VER:%VER% > Scripts\%VER%\common.ai
ECHO IGNORE jasshelper --scriptonly common.j Scripts\Blizzard.j Scripts\%VER%\common.ai Scripts\%VER%\common2.ai
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
perl SplitBlizzardJ.pl %VER% %VSAI%
if %VSAI% == 1 (
ECHO creating \Scripts\Blizzard_%VER%.j  AMAI VS AI Flag set to: ON
perl ejass.pl Blizzard3VAI.eai %VER% VER:%VER% > %VER%\tmp\Blizzard3Gen.j
)
if %VSAI% == 0 (
ECHO creating \Scripts\Blizzard_%VER%.j  AMAI VS AI Flag set to: OFF
perl ejass.pl Blizzard3.eai %VER% VER:%VER% > %VER%\tmp\Blizzard3Gen.j
)
perl ejass.pl Blizzard.eai %VER% VER:%VER% > Scripts\Blizzard_%VER%.j
ECHO \Scripts\Blizzard_%VER%.j created
pjass %VER%\common.j Scripts\Blizzard_%VER%.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\Blizzard_%VER%.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
copy /b/v/y "Scripts\Blizzard_%VER%.j" "Scripts\Blizzard.j"
ECHO copy \Scripts\Blizzard.j
rmdir /s /q "%VER%/tmp"
if "%RESULTMAKEVER%"=="1" (
  if %VSAI% == 1 (
    ECHO Compilation AMAI %VER% VS AI error
  )
  if %VSAI% == 0 (
    ECHO Compilation AMAI %VER% error
  )
  if %MAKEALL% == 1 (
    SET RESULTMAKEVER=0
  )
  exit /b %RESULTOPTVER%
) else (
  if %VSAI% == 1 (
    ECHO Making AMAI %VER% VS AI finish
  )
  if %VSAI% == 0 (
    ECHO Making AMAI %VER% finish
  )
)
