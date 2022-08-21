@ECHO OFF
ECHO Making AMAI VS AI
call MakeTFTBase.bat 1
ECHO creating \Scripts\TFT\AMAI.mpq
copy empty.mpq Scripts\TFT\AMAI.mpq
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\common.ai Scripts\common.ai Scripts\Blizzard.j Scripts\Blizzard.j
ECHO adding AMAI scripts
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\elf.ai Scripts\elf.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\human.ai Scripts\human.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\orc.ai Scripts\orc.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\undead.ai Scripts\undead.ai
ECHO adding blizzard_entertainment scripts
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\elf2.ai Scripts\elf2.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\human2.ai Scripts\human2.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\orc2.ai Scripts\orc2.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\undead2.ai Scripts\undead2.ai
ECHO \Scripts\TFT\AMAI.mpq created
ECHO =============================
ECHO Making AMAI finished
pause