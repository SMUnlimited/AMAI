@ECHO OFF
perl Optimize.pl Scripts\TFT\common.ai Scripts\TFT\elf.ai Scripts\TFT\human.ai Scripts\TFT\orc.ai Scripts\TFT\undead.ai
pjass common.j Scripts\TFT\common.ai
pjass common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
pjass common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
pjass common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
pjass common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
copy TFT_SEMPQ.exe Scripts\TFT\AMAI_TFT.exe
AddToMPQ Scripts\TFT\AMAI_TFT.exe Scripts\TFT\common.ai Scripts\common.ai Scripts\Blizzard.j Scripts\Blizzard.j
AddToMPQ Scripts\TFT\AMAI_TFT.exe Scripts\TFT\elf.ai Scripts\elf.ai
AddToMPQ Scripts\TFT\AMAI_TFT.exe Scripts\TFT\human.ai Scripts\human.ai
AddToMPQ Scripts\TFT\AMAI_TFT.exe Scripts\TFT\orc.ai Scripts\orc.ai
AddToMPQ Scripts\TFT\AMAI_TFT.exe Scripts\TFT\undead.ai Scripts\undead.ai
perl Optimize.pl Scripts\RoC\common.ai Scripts\RoC\elf.ai Scripts\RoC\human.ai Scripts\RoC\orc.ai Scripts\RoC\undead.ai
pjass common.j Scripts\RoC\common.ai
pjass common.j Scripts\RoC\common.ai Scripts\RoC\elf.ai
pjass common.j Scripts\RoC\common.ai Scripts\RoC\human.ai
pjass common.j Scripts\RoC\common.ai Scripts\RoC\orc.ai
pjass common.j Scripts\RoC\common.ai Scripts\RoC\undead.ai
pause