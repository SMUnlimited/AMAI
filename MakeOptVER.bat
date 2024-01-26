@ECHO OFF
SET VER=%~1
SET RESULTOPTVER=0
ECHO Making AMAI Optimizing %VER%
perl Optimize.pl %VER%\common.j Scripts\%VER%\common.ai -l %VER%\Races.txt Scripts\%VER%\$2
perl Optimize.pl -b Scripts\Blizzard_%VER%.j
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\elf.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\human.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\orc.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\undead.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\Blizzard_%VER%.j
if "%errorlevel%"=="1" SET RESULTOPTVER=1
if "%RESULTOPTVER%"=="1" (
  ECHO Compilation AMAI Optimization %VER% error
  exit /b %RESULTOPTVER%
) else (
  ECHO Compilation AMAI Optimization %VER% finished
)