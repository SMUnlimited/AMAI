@ECHO OFF
SET LOG=%~1
if not "%LOG%"=="0" SET LOG=1
ECHO Synchronize files
perl ejass.pl REFORGED\AddedAggression.txt > TFT\AddedAggression.txt
perl ejass.pl REFORGED\CommandBuilds.txt > TFT\CommandBuilds.txt
perl ejass.pl REFORGED\Dragons.txt > TFT\Dragons.txt
perl ejass.pl REFORGED\DragonTypes.txt > TFT\DragonTypes.txt
perl ejass.pl REFORGED\Healers.txt > TFT\Healers.txt
perl ejass.pl REFORGED\HealingItems.txt > TFT\HealingItems.txt
perl ejass.pl REFORGED\HeroAbilities.txt > TFT\HeroAbilities.txt
perl ejass.pl REFORGED\HeroLevels.txt > TFT\HeroLevels.txt
perl ejass.pl REFORGED\ItemCheck.txt > TFT\ItemCheck.txt
perl ejass.pl REFORGED\MercTypes.txt > TFT\MercTypes.txt
perl ejass.pl REFORGED\NeutralShops.txt > TFT\NeutralShops.txt
perl ejass.pl REFORGED\Profiles.txt > TFT\Profiles.txt
perl ejass.pl REFORGED\Races.txt > TFT\Races.txt
perl ejass.pl REFORGED\StandardAiSettings.txt > TFT\StandardAiSettings.txt
perl ejass.pl REFORGED\Strengths.txt > TFT\Strengths.txt
perl ejass.pl REFORGED\Upkeep.txt > TFT\Upkeep.txt
perl ejass.pl REFORGED\UnitConversions.txt > TFT\UnitConversions.txt

perl ejass.pl REFORGED\Elf\CommandBuilds.txt > TFT\Elf\CommandBuilds.txt
perl ejass.pl REFORGED\Elf\RaceAggression.txt > TFT\Elf\RaceAggression.txt
perl ejass.pl REFORGED\Elf\Settings.txt > TFT\Elf\Settings.txt
perl ejass.pl REFORGED\Elf\Tiers.txt > TFT\Elf\Tiers.txt

perl ejass.pl REFORGED\Human\CommandBuilds.txt > TFT\Human\CommandBuilds.txt
perl ejass.pl REFORGED\Human\RaceAggression.txt > TFT\Human\RaceAggression.txt
perl ejass.pl REFORGED\Human\Settings.txt > TFT\Human\Settings.txt
perl ejass.pl REFORGED\Human\Tiers.txt > TFT\Human\Tiers.txt

perl ejass.pl REFORGED\Orc\CommandBuilds.txt > TFT\Orc\CommandBuilds.txt
perl ejass.pl REFORGED\Orc\RaceAggression.txt > TFT\Orc\RaceAggression.txt
perl ejass.pl REFORGED\Orc\Settings.txt > TFT\Orc\Settings.txt
perl ejass.pl REFORGED\Orc\Tiers.txt > TFT\Orc\Tiers.txt

perl ejass.pl REFORGED\Undead\CommandBuilds.txt > TFT\Undead\CommandBuilds.txt
perl ejass.pl REFORGED\Undead\RaceAggression.txt > TFT\Undead\RaceAggression.txt
perl ejass.pl REFORGED\Undead\Settings.txt > TFT\Undead\Settings.txt
perl ejass.pl REFORGED\Undead\Tiers.txt > TFT\Undead\Tiers.txt
ECHO Synchronize files done

call MakeOptVER TFT %LOG%