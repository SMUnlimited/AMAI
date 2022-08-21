@ECHO OFF
ECHO Making AMAI VS AI
ECHO _____________________________
ECHO creating \Scripts\TFT\common.ai
perl ejass.pl common.eai TFT VER:TFT > Scripts\TFT\common.ai
ECHO \Scripts\TFT\common.ai created
pjass common.j Scripts\TFT\common.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\elf.ai
perl ejass.pl races.eai TFT VER:TFT ELF RACE:ELF > Scripts\TFT\elf.ai
ECHO \Scripts\TFT\elf.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\elf.ai
pjass common.j Scripts\TFT\common.ai Scripts\TFT\elf2.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\human.ai
perl ejass.pl races.eai TFT VER:TFT HUMAN RACE:HUMAN > Scripts\TFT\human.ai
ECHO \Scripts\TFT\human.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\human.ai
pjass common.j Scripts\TFT\common.ai Scripts\TFT\human2.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\orc.ai
perl ejass.pl races.eai TFT VER:TFT ORC RACE:ORC > Scripts\TFT\orc.ai
ECHO \Scripts\TFT\orc.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\orc.ai
pjass common.j Scripts\TFT\common.ai Scripts\TFT\orc2.ai
ECHO _____________________________
ECHO creating \Scripts\TFT\undead.ai
perl ejass.pl races.eai TFT VER:TFT UNDEAD RACE:UNDEAD > Scripts\TFT\undead.ai
ECHO \Scripts\TFT\undead.ai created
pjass common.j Scripts\TFT\common.ai Scripts\TFT\undead.ai
pjass common.j Scripts\TFT\common.ai Scripts\TFT\undead2.ai
ECHO _____________________________
ECHO creating \Scripts\Blizzard.j
perl SplitBlizzardJ.pl
perl ejass.pl Blizzard3VAI.eai TFT VER:TFT > Blizzard3Gen.j
perl ejass.pl Blizzard.eai TFT VER:TFT > Scripts\Blizzard.j
ECHO \Scripts\Blizzard.j created
pjass common.j Scripts\Blizzard.j
ECHO _____________________________
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