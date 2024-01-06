@ECHO OFF
SET LOG=%~1
ECHO Synchronize TFT common library

copy /y REFORGED\AddedAggression.txt TFT\AddedAggression.txt
copy /y REFORGED\CommandBuilds.txt TFT\CommandBuilds.txt
copy /y REFORGED\Dragons.txt TFT\Dragons.txt
copy /y REFORGED\DragonTypes.txt TFT\DragonTypes.txt
copy /y REFORGED\Healers.txt TFT\Healers.txt
copy /y REFORGED\HealingItems.txt TFT\HealingItems.txt
copy /y REFORGED\HeroAbilities.txt TFT\HeroAbilities.txt
copy /y REFORGED\HeroLevels.txt TFT\HeroLevels.txt
copy /y REFORGED\ItemCheck.txt TFT\ItemCheck.txt
copy /y REFORGED\MercTypes.txt TFT\MercTypes.txt
copy /y REFORGED\NeutralShops.txt TFT\NeutralShops.txt
copy /y REFORGED\Profiles.txt TFT\Profiles.txt
copy /y REFORGED\Races.txt TFT\Races.txt
copy /y REFORGED\StandardAiSettings.txt TFT\StandardAiSettings.txt
copy /y REFORGED\Strengths.txt TFT\Strengths.txt
copy /y REFORGED\Upkeep.txt TFT\Upkeep.txt
copy /y REFORGED\UnitConversions.txt TFT\UnitConversions.txt

copy /y REFORGED\Elf\CommandBuilds.txt TFT\Elf\CommandBuilds.txt
copy /y REFORGED\Elf\RaceAggression.txt TFT\Elf\RaceAggression.txt
copy /y REFORGED\Elf\Settings.txt TFT\Elf\Settings.txt
copy /y REFORGED\Elf\Tiers.txt TFT\Elf\Tiers.txt

copy /y REFORGED\Human\CommandBuilds.txt TFT\Human\CommandBuilds.txt
copy /y REFORGED\Human\RaceAggression.txt TFT\Human\RaceAggression.txt
copy /y REFORGED\Human\Settings.txt TFT\Human\Settings.txt
copy /y REFORGED\Human\Tiers.txt TFT\Human\Tiers.txt

copy /y REFORGED\Orc\CommandBuilds.txt TFT\Orc\CommandBuilds.txt
copy /y REFORGED\Orc\RaceAggression.txt TFT\Orc\RaceAggression.txt
copy /y REFORGED\Orc\Settings.txt TFT\Orc\Settings.txt
copy /y REFORGED\Orc\Tiers.txt TFT\Orc\Tiers.txt

copy /y REFORGED\Undead\CommandBuilds.txt TFT\Undead\CommandBuilds.txt
copy /y REFORGED\Undead\RaceAggression.txt TFT\Undead\RaceAggression.txt
copy /y REFORGED\Undead\Settings.txt TFT\Undead\Settings.txt
copy /y REFORGED\Undead\Tiers.txt TFT\Undead\Tiers.txt

ECHO Synchronize TFT common library complete
ECHO _____________________________
call MakeVERBase.bat 0 TFT
ECHO _____________________________
call ForwardsCompat.bat TFT
ECHO =============================
if not "%LOG%"=="0" (
    pause
)