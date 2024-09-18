@ECHO OFF
SET VER=%~1
SET MAKEALL=%~2
SET RESULTOPTVER=0
ECHO Making AMAI Optimizing %VER%
where perl
if "%errorlevel%"=="1" SET RESULTOPTVER=1
if "%RESULTOPTVER%"=="1" (
  ECHO Compilation AMAI Optimization %VER% error
  ECHO Please install Perl as a requirement to compile AMAI. Download : https://strawberryperl.com/
  exit /b %RESULTOPTVER%
)
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
copy /b/v/y "Scripts\Blizzard_%VER%.j" "Scripts\Blizzard.j"
ECHO copy \Scripts\Blizzard.j
if "%RESULTOPTVER%"=="1" (
  ECHO Compilation AMAI Optimization %VER% error
  if %MAKEALL% == 1 (
    SET RESULTMAKEVER=0
  )
  exit /b %RESULTOPTVER%
) else (
  ECHO Compilation AMAI Optimization %VER% finished
)
