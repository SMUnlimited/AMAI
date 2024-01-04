SET LOG=0
@call MakeOptROC.bat %LOG%
@call MakeOptTFT.bat %LOG%
SET LOG=1
@call MakeOptREFORGED.bat %LOG%