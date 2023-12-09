ECHO Apply backwards compatability scripts
SET VER=%1
perl -i -pe"s/GetBJMaxPlayers/GetBJMaxPlayersAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/GetBJMaxPlayers/GetBJMaxPlayersAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/BlzGroupAddGroupFast/BlzGroupAddGroupFastAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/BlzGroupAddGroupFast/BlzGroupAddGroupFastAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/BlzGroupRemoveGroupFast/BlzGroupRemoveGroupFastAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/BlzGroupRemoveGroupFast/BlzGroupRemoveGroupFastAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/BlzGroupGetSize/BlzGroupGetSizeAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/BlzGroupGetSize/BlzGroupGetSizeAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_MAROON/PLAYER_COLOR_MAROONAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_MAROON/PLAYER_COLOR_MAROONAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_NAVY/PLAYER_COLOR_NAVYAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_NAVY/PLAYER_COLOR_NAVYAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_TURQUOISE/PLAYER_COLOR_TURQUOISEAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_TURQUOISE/PLAYER_COLOR_TURQUOISEAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_VIOLET/BPLAYER_COLOR_VIOLETAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_VIOLET/PLAYER_COLOR_VIOLETAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_WHEAT/PLAYER_COLOR_WHEATAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_WHEAT/PLAYER_COLOR_WHEATAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_PEACH/PLAYER_COLOR_PEACHAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_PEACH/PLAYER_COLOR_PEACHAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_MINT/PLAYER_COLOR_MINTAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_MINT/PLAYER_COLOR_MINTAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_LAVENDER/PLAYER_COLOR_LAVENDERAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_LAVENDER/PLAYER_COLOR_LAVENDERAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_COAL/PLAYER_COLOR_COALAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_COAL/PLAYER_COLOR_COALAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_SNOW/PLAYER_COLOR_SNOWAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_SNOW/PLAYER_COLOR_SNOWAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_SNOW/PLAYER_COLOR_SNOWAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_SNOW/PLAYER_COLOR_SNOWAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_EMERALD/PLAYER_COLOR_EMERALDAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_EMERALD/PLAYER_COLOR_EMERALDAMAI/g" Scripts/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_PEANUT/PLAYER_COLOR_PEANUTAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_PEANUT/PLAYER_COLOR_PEANUTAMAI/g" Scripts/Blizzard.j

pjass %VER%\common.j Scripts\%VER%\common.ai
jassparser %VER%\common.j Scripts\%VER%\common.ai
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\elf.ai
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\elf.ai
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\human.ai
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\human.ai
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\orc.ai
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\orc.ai
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\undead.ai
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\undead.ai
pjass %VER%\common.j Scripts\Blizzard.j
jassparser %VER%\common.j Scripts\Blizzard.j