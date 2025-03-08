@ECHO OFF
SET DisableROC=0
SET DisableTFT=0
SET DisableREFORGED=0
SET Disable=0
ECHO Disable Debug

perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/ROC/common.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/ROC/Blizzard.j
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/ROC/elf.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/ROC/human.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/ROC/orc.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/ROC/undead.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/ROC/vsai/Blizzard.j

perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/ROC/common.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/ROC/Blizzard.j
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/ROC/elf.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/ROC/human.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/ROC/orc.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/ROC/undead.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/ROC/vsai/Blizzard.j

perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/common.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/Blizzard.j
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/elf.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/human.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/orc.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/undead.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/vsai/Blizzard.j

perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/ROC/common.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/ROC/Blizzard.j
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/ROC/elf.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/ROC/human.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/ROC/orc.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/ROC/undead.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/ROC/vsai/Blizzard.j

perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/ROC/common.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/ROC/Blizzard.j
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/ROC/elf.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/ROC/human.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/ROC/orc.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/ROC/undead.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/ROC/vsai/Blizzard.j

perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/ROC/common.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/ROC/Blizzard.j
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/ROC/elf.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/ROC/human.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/ROC/orc.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/ROC/undead.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/ROC/vsai/Blizzard.j

perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/TFT/common.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/TFT/Blizzard.j
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/TFT/elf.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/TFT/human.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/TFT/orc.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/TFT/undead.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/TFT/vsai/Blizzard.j

perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/TFT/common.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/TFT/Blizzard.j
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/TFT/elf.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/TFT/human.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/TFT/orc.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/TFT/undead.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/TFT/vsai/Blizzard.j

perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/common.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/Blizzard.j
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/elf.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/human.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/orc.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/undead.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/vsai/Blizzard.j

perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/TFT/common.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/TFT/Blizzard.j
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/TFT/elf.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/TFT/human.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/TFT/orc.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/TFT/undead.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/TFT/vsai/Blizzard.j

perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/TFT/common.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/TFT/Blizzard.j
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/TFT/elf.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/TFT/human.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/TFT/orc.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/TFT/undead.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/TFT/vsai/Blizzard.j

perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/TFT/common.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/TFT/Blizzard.j
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/TFT/elf.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/TFT/human.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/TFT/orc.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/TFT/undead.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/TFT/vsai/Blizzard.j

perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/REFORGED/common.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/REFORGED/Blizzard.j
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/REFORGED/elf.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/REFORGED/human.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/REFORGED/orc.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/REFORGED/undead.ai
perl -i -pe"s#(debug call Trace)#//$1#g" Scripts/REFORGED/vsai/Blizzard.j

perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/REFORGED/common.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/REFORGED/Blizzard.j
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/REFORGED/elf.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/REFORGED/human.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/REFORGED/orc.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/REFORGED/undead.ai
perl -i -pe"s#(call TracePlayer)#//$1#g" Scripts/REFORGED/vsai/Blizzard.j

perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/common.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/Blizzard.j
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/elf.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/human.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/orc.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/undead.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/vsai/Blizzard.j

perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/REFORGED/common.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/REFORGED/Blizzard.j
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/REFORGED/elf.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/REFORGED/human.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/REFORGED/orc.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/REFORGED/undead.ai
perl -i -pe"s#(call UpdateDebugTextTag)#//$1#g" Scripts/REFORGED/vsai/Blizzard.j

perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/REFORGED/common.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/REFORGED/Blizzard.j
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/REFORGED/elf.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/REFORGED/human.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/REFORGED/orc.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/REFORGED/undead.ai
perl -i -pe"s#(call CreateDebug)#//$1#g" Scripts/REFORGED/vsai/Blizzard.j

perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/REFORGED/common.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/REFORGED/Blizzard.j
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/REFORGED/elf.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/REFORGED/human.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/REFORGED/orc.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/REFORGED/undead.ai
perl -i -pe"s#(call DisplayToAllJobDebug)#//$1#g" Scripts/REFORGED/vsai/Blizzard.j

pjass ROC\common.j Scripts\ROC\common.ai
if "%errorlevel%"=="1" SET DisableROC=1
jassparser ROC\common.j Scripts\ROC\common.ai
if "%errorlevel%"=="1" SET DisableROC=1
pjass ROC\common.j Scripts\ROC\common.ai Scripts\ROC\elf.ai
if "%errorlevel%"=="1" SET DisableROC=1
jassparser ROC\common.j Scripts\ROC\common.ai Scripts\ROC\elf.ai
if "%errorlevel%"=="1" SET DisableROC=1
pjass ROC\common.j Scripts\ROC\common.ai Scripts\ROC\human.ai
if "%errorlevel%"=="1" SET DisableROC=1
jassparser ROC\common.j Scripts\ROC\common.ai Scripts\ROC\human.ai
if "%errorlevel%"=="1" SET DisableROC=1
pjass ROC\common.j Scripts\ROC\common.ai Scripts\ROC\orc.ai
if "%errorlevel%"=="1" SET DisableROC=1
jassparser ROC\common.j Scripts\ROC\common.ai Scripts\ROC\orc.ai
if "%errorlevel%"=="1" SET DisableROC=1
pjass ROC\common.j Scripts\ROC\common.ai Scripts\ROC\undead.ai
if "%errorlevel%"=="1" SET DisableROC=1
jassparser ROC\common.j Scripts\ROC\common.ai Scripts\ROC\undead.ai
if "%errorlevel%"=="1" SET DisableROC=1
pjass ROC\common.j Scripts\ROC\Blizzard.j
if "%errorlevel%"=="1" SET DisableROC=1
jassparser ROC\common.j Scripts\ROC\Blizzard.j
if "%errorlevel%"=="1" SET DisableROC=1
pjass ROC\common.j Scripts\ROC\vsai\Blizzard.j
if "%errorlevel%"=="1" SET DisableROC=1
jassparser ROC\common.j Scripts\ROC\vsai\Blizzard.j
if "%errorlevel%"=="1" SET DisableROC=1
if "%DisableROC%"=="1" (
  ECHO Disable Debug ROC scripts error
  SET Disable=1
) else (
  ECHO Disable Debug ROC scripts finish
)

pjass TFT\common.j Scripts\TFT\common.ai
if "%errorlevel%"=="1" SET DisableTFT=1
jassparser TFT\common.j Scripts\TFT\common.ai
if "%errorlevel%"=="1" SET DisableTFT=1
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
if "%errorlevel%"=="1" SET DisableTFT=1
jassparser TFT\common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
if "%errorlevel%"=="1" SET DisableTFT=1
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
if "%errorlevel%"=="1" SET DisableTFT=1
jassparser TFT\common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
if "%errorlevel%"=="1" SET DisableTFT=1
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
if "%errorlevel%"=="1" SET DisableTFT=1
jassparser TFT\common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
if "%errorlevel%"=="1" SET DisableTFT=1
pjass TFT\common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
if "%errorlevel%"=="1" SET DisableTFT=1
jassparser TFT\common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
if "%errorlevel%"=="1" SET DisableTFT=1
pjass TFT\common.j Scripts\TFT\Blizzard.j
if "%errorlevel%"=="1" SET DisableTFT=1
jassparser TFT\common.j Scripts\TFT\Blizzard.j
if "%errorlevel%"=="1" SET DisableTFT=1
pjass TFT\common.j Scripts\TFT\vsai\Blizzard.j
if "%errorlevel%"=="1" SET DisableTFT=1
jassparser TFT\common.j Scripts\TFT\vsai\Blizzard.j
if "%errorlevel%"=="1" SET DisableTFT=1
if "%DisableTFT%"=="1" (
  ECHO Disable Debug TFT scripts error
  SET Disable=1
) else (
  ECHO Disable Debug TFT scripts finish
)

pjass REFORGED\common.j Scripts\REFORGED\common.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\elf.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\elf.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\human.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\human.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\orc.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\orc.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
pjass REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\undead.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
jassparser REFORGED\common.j Scripts\REFORGED\common.ai Scripts\REFORGED\undead.ai
if "%errorlevel%"=="1" SET DisableREFORGED=1
pjass REFORGED\common.j Scripts\REFORGED\Blizzard.j
if "%errorlevel%"=="1" SET DisableREFORGED=1
jassparser REFORGED\common.j Scripts\REFORGED\Blizzard.j
if "%errorlevel%"=="1" SET DisableREFORGED=1
pjass REFORGED\common.j Scripts\REFORGED\vsai\Blizzard.j
if "%errorlevel%"=="1" SET DisableREFORGED=1
jassparser REFORGED\common.j Scripts\REFORGED\vsai\Blizzard.j
if "%errorlevel%"=="1" SET DisableREFORGED=1

if "%DisableREFORGED%"=="1" (
  ECHO Disable Debug REFORGED scripts error
  SET Disable=1
) else (
  ECHO Disable Debug REFORGED scripts finish
)

if "%Disable%"=="1" (
  pause
)