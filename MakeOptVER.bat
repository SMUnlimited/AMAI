@ECHO OFF
SET VER=%~1
SET SILENT=%~2
SET RESULTOPTVER=0
ECHO Optimizing %VER% Scripts
mkdir Scripts\OPT%VER%
COPY Scripts\%VER%\common.ai Scripts\OPT%VER%\common.ai
COPY Scripts\%VER%\human.ai Scripts\OPT%VER%\human.ai
COPY Scripts\%VER%\orc.ai Scripts\OPT%VER%\orc.ai
COPY Scripts\%VER%\undead.ai Scripts\OPT%VER%\undead.ai
COPY Scripts\%VER%\elf.ai Scripts\OPT%VER%\elf.ai
COPY Scripts\%VER%\human2.ai Scripts\OPT%VER%\human2.ai
COPY Scripts\%VER%\orc2.ai Scripts\OPT%VER%\orc2.ai
COPY Scripts\%VER%\undead2.ai Scripts\OPT%VER%\undead2.ai
COPY Scripts\%VER%\elf2.ai Scripts\OPT%VER%\elf2.ai
COPY Scripts\%VER%\Blizzard.j Scripts\OPT%VER%\Blizzard.j
COPY Scripts\%VER%\Blizzard_VSAI.j Scripts\OPT%VER%\Blizzard_VSAI.j
perl Optimize.pl %VER%\common.j Scripts\OPT%VER%\common.ai -l %VER%\Races.txt Scripts\OPT%VER%\$2 Scripts\OPT%VER%\$3
perl Optimize.pl -b Scripts\OPT%VER%\Blizzard_VSAI.j
perl Optimize.pl -b Scripts\OPT%VER%\Blizzard.j
ECHO Optimizing finished
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\elf.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\human.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\orc.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\undead.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\elf2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\elf2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\human2.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\human2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\orc2.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\orc2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\undead2.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\undead2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\Blizzard_VSAI.j
if "%errorlevel%"=="1" SET RESULTOPTVER=1
pjass %VER%\common.j Scripts\OPT%VER%\Blizzard.j
if "%errorlevel%"=="1" SET RESULTOPTVER=1
if "%RESULTOPTVER%"=="1" (
  ECHO Optimization %VER% error
  if "%SILENT%" neq "1" (
    pause
    ECHO Exiting
    exit /b %RESULTOPTVER%
  )
) else (
  ECHO Optimization %VER% successful
)