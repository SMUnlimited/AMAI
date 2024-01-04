@ECHO OFF
SET VER=%~1
SET LOG=%~2
SET RESULTOPTVER=0
ECHO Optimizing Scripts
perl Optimize.pl %VER%\common.j Scripts\%VER%\common.ai -l %VER%\Races.txt Scripts\%VER%\$2
perl Optimize.pl -b Scripts\Blizzard_%VER%.j
ECHO Optimizing finished
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
if "%errorlevel%"=="1" SET RESULTOPTVER=1
if "%RESULTOPTVER%"=="1" (
  ECHO Optimization error
  exit /b %RESULTOPTVER%
)
if "%LOG%" == "1" (
  ECHO =============================
  ECHO Making AMAI Optimize finished
  pause
)