@ECHO OFF
call MakeTFTBase.bat 0
ECHO creating \Scripts\TFT\AMAI.mpq
copy empty.mpq Scripts\TFT\AMAI.mpq
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\common.ai Scripts\common.ai Scripts\Blizzard.j Scripts\Blizzard.j
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\elf.ai Scripts\elf.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\human.ai Scripts\human.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\orc.ai Scripts\orc.ai
AddToMPQ Scripts\TFT\AMAI.mpq Scripts\TFT\undead.ai Scripts\undead.ai
ECHO \Scripts\TFT\AMAI.mpq created
ECHO =============================
ECHO Making AMAI finished
pause