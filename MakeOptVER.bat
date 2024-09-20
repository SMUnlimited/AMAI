@ECHO OFF
SET VER=%~1
SET MAKEALL=%~2
SET RESULTMAKEVER=0
ECHO Making AMAI Optimizing %VER%
where perl
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
if "%RESULTMAKEVER%"=="1" (
  ECHO Compilation AMAI Optimization %VER% error
  ECHO Please install Perl as a requirement to compile AMAI. Download : https://strawberryperl.com/
  exit /b %RESULTMAKEVER%
)
perl Optimize.pl %VER%\common.j Scripts\%VER%\common.ai -l %VER%\Races.txt Scripts\%VER%\$2
perl Optimize.pl -b Scripts\%VER%\Blizzard.j
perl Optimize.pl -b Scripts\%VER%\Blizzard_VSAI.j
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\elf.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\human.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\orc.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\undead.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\Blizzard.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\%VER%\Blizzard_VSAI.j
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
if "%RESULTMAKEVER%"=="1" (
  ECHO Compilation AMAI Optimization %VER% error
  if %MAKEALL% == 1 (
    SET RESULTMAKEVER=0
  )
  exit /b %RESULTMAKEVER%
) else (
  ECHO Compilation AMAI Optimization %VER% finished
)
