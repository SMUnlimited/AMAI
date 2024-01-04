@ECHO OFF
SET LOG=%~1
if not "%LOG%"=="0" SET LOG=1
ECHO Synchronize files
perl ejass.pl REFORGED\AddedAggression.txt > %VER%\AddedAggression.txt
perl ejass.pl REFORGED\CommandBuilds.txt > %VER%\CommandBuilds.txt
perl ejass.pl REFORGED\Dragons.txt > %VER%\Dragons.txt
perl ejass.pl REFORGED\DragonTypes.txt > %VER%\DragonTypes.txt
perl ejass.pl REFORGED\Healers.txt > %VER%\Healers.txt
perl ejass.pl REFORGED\HealingItems.txt > %VER%\HealingItems.txt
perl ejass.pl REFORGED\HeroAbilities.txt > %VER%\HeroAbilities.txt
perl ejass.pl REFORGED\HeroLevels.txt > %VER%\HeroLevels.txt
perl ejass.pl REFORGED\ItemCheck.txt > %VER%\ItemCheck.txt
perl ejass.pl REFORGED\MercTypes.txt > %VER%\MercTypes.txt
perl ejass.pl REFORGED\NeutralShops.txt > %VER%\NeutralShops.txt
perl ejass.pl REFORGED\Profiles.txt > %VER%\Profiles.txt
perl ejass.pl REFORGED\Races.txt > %VER%\Races.txt
perl ejass.pl REFORGED\StandardAiSettings.txt > %VER%\StandardAiSettings.txt
perl ejass.pl REFORGED\Strengths.txt > %VER%\Strengths.txt
perl ejass.pl REFORGED\Tiers.txt > %VER%\Tiers.txt
perl ejass.pl REFORGED\Upkeep.txt > %VER%\Upkeep.txt
perl ejass.pl REFORGED\UnitConversions.txt > %VER%\UnitConversions.txt

perl ejass.pl REFORGED\Elf\CommandBuilds.txt > %VER%\Elf\CommandBuilds.txt
perl ejass.pl REFORGED\Elf\RaceAggression.txt > %VER%\Elf\RaceAggression.txt
perl ejass.pl REFORGED\Elf\Settings.txt > %VER%\Elf\Settings.txt
perl ejass.pl REFORGED\Elf\Tiers.txt > %VER%\Elf\Tiers.txt

perl ejass.pl REFORGED\Human\CommandBuilds.txt > %VER%\Human\CommandBuilds.txt
perl ejass.pl REFORGED\Human\RaceAggression.txt > %VER%\Human\RaceAggression.txt
perl ejass.pl REFORGED\Human\Settings.txt > %VER%\Human\Settings.txt
perl ejass.pl REFORGED\Human\Tiers.txt > %VER%\Human\Tiers.txt

perl ejass.pl REFORGED\Orc\CommandBuilds.txt > %VER%\Orc\CommandBuilds.txt
perl ejass.pl REFORGED\Orc\RaceAggression.txt > %VER%\Orc\RaceAggression.txt
perl ejass.pl REFORGED\Orc\Settings.txt > %VER%\Orc\Settings.txt
perl ejass.pl REFORGED\Orc\Tiers.txt > %VER%\Orc\Tiers.txt

perl ejass.pl REFORGED\Undead\CommandBuilds.txt > %VER%\Undead\CommandBuilds.txt
perl ejass.pl REFORGED\Undead\RaceAggression.txt > %VER%\Undead\RaceAggression.txt
perl ejass.pl REFORGED\Undead\Settings.txt > %VER%\Undead\Settings.txt
perl ejass.pl REFORGED\Undead\Tiers.txt > %VER%\Undead\Tiers.txt
ECHO Synchronize files done

call MakeOptVER TFT