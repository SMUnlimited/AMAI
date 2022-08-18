@ECHO OFF
ECHO Making AMAI
ECHO _____________________________
ECHO creating \Scripts\\common.ai
perl ejass.pl common.eai  VER: > Scripts\\common.ai
ECHO \Scripts\\common.ai created
pjass common.j Scripts\\common.ai
