@ECHO OFF
call MakeTFTBase.bat 0
ECHO Optimizing Scripts
perl Optimize.pl Scripts\TFT\common.ai -l TFT\Races.txt Scripts\TFT\$2
perl Optimize.pl -b Scripts\Blizzard.j
ECHO Optimizing finished
ECHO _____________________________
pjass common.j Scripts\TFT\common.ai
ECHO _____________________________
pjass common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
ECHO _____________________________
pjass common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
ECHO _____________________________
pjass common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
ECHO _____________________________
pjass common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
ECHO _____________________________
pjass common.j Scripts\Blizzard.j
ECHO =============================
ECHO Making AMAI finished
pause