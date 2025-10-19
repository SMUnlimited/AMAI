@ECHO OFF
SET VER=%~1
SET SILENT=%~2
SET RESULTOPTVER=0
ECHO Optimizing %VER% Scripts
call perlcheck.bat
if "%errorlevel%"=="1" SET RESULTOPTVER=1
if "%RESULTOPTVER%"=="1" (
  ECHO Compilation AMAI Optimization %VER% error
  ECHO Perl version check failed. Exiting. Download : https://strawberryperl.com/
  exit /b %RESULTOPTVER%
)
mkdir Scripts\OPT%VER%
mkdir Scripts\OPT%VER%\vsai
COPY Scripts\%VER%\common.ai Scripts\OPT%VER%\common.ai
COPY Scripts\%VER%\human.ai Scripts\OPT%VER%\human.ai
COPY Scripts\%VER%\orc.ai Scripts\OPT%VER%\orc.ai
COPY Scripts\%VER%\undead.ai Scripts\OPT%VER%\undead.ai
COPY Scripts\%VER%\elf.ai Scripts\OPT%VER%\elf.ai
COPY Scripts\%VER%\vsai\human2.ai Scripts\OPT%VER%\vsai\human2.ai
COPY Scripts\%VER%\vsai\orc2.ai Scripts\OPT%VER%\vsai\orc2.ai
COPY Scripts\%VER%\vsai\undead2.ai Scripts\OPT%VER%\vsai\undead2.ai
COPY Scripts\%VER%\vsai\elf2.ai Scripts\OPT%VER%\vsai\elf2.ai
COPY Scripts\%VER%\Blizzard.j Scripts\OPT%VER%\Blizzard.j
COPY Scripts\%VER%\vsai\Blizzard.j Scripts\OPT%VER%\vsai\Blizzard.j

ECHO _____________________________
ECHO Disable Debug

perl -i -pe"s#(call TraceN)#//$1#g" Scripts/OPT%VER%/common.ai
perl -i -pe"s#(call TraceN)#//$1#g" Scripts/OPT%VER%/Blizzard.j
perl -i -pe"s#(call TraceN)#//$1#g" Scripts/OPT%VER%/elf.ai
perl -i -pe"s#(call TraceN)#//$1#g" Scripts/OPT%VER%/human.ai
perl -i -pe"s#(call TraceN)#//$1#g" Scripts/OPT%VER%/orc.ai
perl -i -pe"s#(call TraceN)#//$1#g" Scripts/OPT%VER%/undead.ai
perl -i -pe"s#(call TraceN)#//$1#g" Scripts/OPT%VER%/vsai/Blizzard.j

perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/OPT%VER%/common.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/OPT%VER%/Blizzard.j
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/OPT%VER%/elf.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/OPT%VER%/human.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/OPT%VER%/orc.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/OPT%VER%/undead.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/OPT%VER%/vsai/Blizzard.j

perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/OPT%VER%/common.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/OPT%VER%/Blizzard.j
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/OPT%VER%/elf.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/OPT%VER%/human.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/OPT%VER%/orc.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/OPT%VER%/undead.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/OPT%VER%/vsai/Blizzard.j

perl -i -pe"s#(call Trace)#//$1#g" Scripts/OPT%VER%/common.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/OPT%VER%/Blizzard.j
perl -i -pe"s#(call Trace)#//$1#g" Scripts/OPT%VER%/elf.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/OPT%VER%/human.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/OPT%VER%/orc.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/OPT%VER%/undead.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/OPT%VER%/vsai/Blizzard.j

perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/OPT%VER%/common.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/OPT%VER%/Blizzard.j
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/OPT%VER%/elf.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/OPT%VER%/human.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/OPT%VER%/orc.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/OPT%VER%/undead.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/OPT%VER%/vsai/Blizzard.j

perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/OPT%VER%/common.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/OPT%VER%/Blizzard.j
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/OPT%VER%/elf.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/OPT%VER%/human.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/OPT%VER%/orc.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/OPT%VER%/undead.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/OPT%VER%/vsai/Blizzard.j

perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/OPT%VER%/common.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/OPT%VER%/Blizzard.j
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/OPT%VER%/elf.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/OPT%VER%/human.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/OPT%VER%/orc.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/OPT%VER%/undead.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/OPT%VER%/vsai/Blizzard.j
ECHO _____________________________
perl Optimize.pl %VER%\common.j Scripts\OPT%VER%\common.ai -l %VER%\Races.txt Scripts\OPT%VER%\$2 Scripts\OPT%VER%\vsai\$3
perl Optimize.pl -b Scripts\OPT%VER%\vsai\Blizzard.j
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
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\vsai\elf2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\vsai\elf2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\vsai\human2.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\vsai\human2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\vsai\orc2.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\vsai\orc2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\vsai\undead2.ai
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\common.ai Scripts\OPT%VER%\vsai\undead2.ai
if "%errorlevel%"=="1" SET RESULTMAKEVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\vsai\Blizzard.j
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\vsai\Blizzard.j
if "%errorlevel%"=="1" SET RESULTOPTVER=1
ECHO _____________________________
pjass %VER%\common.j Scripts\OPT%VER%\Blizzard.j
if "%errorlevel%"=="1" SET RESULTOPTVER=1
jassparser %VER%\common.j Scripts\OPT%VER%\Blizzard.j
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