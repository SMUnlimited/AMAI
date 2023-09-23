@ECHO OFF
call MakeROCBase.bat 0
ECHO Optimizing Scripts
perl Optimize.pl Scripts\ROC\common.ai -l ROC\Races.txt Scripts\ROC\$2
perl Optimize.pl -b Scripts\Blizzard.j
ECHO Optimizing finished
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai Scripts\ROC\elf.ai
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai Scripts\ROC\human.ai
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai Scripts\ROC\orc.ai
ECHO _____________________________
pjass common.j Scripts\ROC\common.ai Scripts\ROC\undead.ai
ECHO _____________________________
pjass common.j Scripts\Blizzard.j
ECHO =============================
ECHO Making AMAI finished
pause