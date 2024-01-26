SET LOG=0
@call MakeOptimizeAll
@call MakeVAIROC
@call MakeREFORGED %LOG%
@call MakeTFT %LOG%
rmdir /s /q "Scripts/REFORGED/elf2.ai"
rmdir /s /q "Scripts/REFORGED/human2.ai"
rmdir /s /q "Scripts/REFORGED/orc2.ai"
rmdir /s /q "Scripts/REFORGED/undead2.ai"
rmdir /s /q "Scripts/TFT/elf2.ai"
rmdir /s /q "Scripts/TFT/human2.ai"
rmdir /s /q "Scripts/TFT/orc2.ai"
rmdir /s /q "Scripts/TFT/undead2.ai"




