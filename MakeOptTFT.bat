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
ECHO _____________________________
ECHO creating \Scripts\TFT\AMAI.mpq
copy empty.mpq Scripts\TFT\AMAI.mpq
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\common.ai Scripts\common.ai Scripts\Blizzard.j Scripts\Blizzard.j
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\elf.ai Scripts\elf.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\human.ai Scripts\human.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\orc.ai Scripts\orc.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\undead.ai Scripts\undead.ai
copy Scripts\TFT\AMAI.mpq Scripts\AMAI.mpq
ECHO \Scripts\TFT\AMAI.mpq created
ECHO =============================
ECHO Making AMAI finished
pause