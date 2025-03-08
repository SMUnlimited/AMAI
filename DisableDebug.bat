@ECHO OFF
ECHO Disable Debug

perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/common.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/Blizzard.j
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/elf.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/human.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/orc.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/undead.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/ROC/vsai/Blizzard.j

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

perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/common.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/Blizzard.j
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/elf.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/human.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/orc.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/undead.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/TFT/vsai/Blizzard.j

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

perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/common.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/Blizzard.j
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/elf.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/human.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/orc.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/undead.ai
perl -i -pe"s#(call Trace)#//$1#g" Scripts/REFORGED/vsai/Blizzard.j

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