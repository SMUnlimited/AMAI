@ECHO OFF
SET VER=%~1
SET SILENT=%~2
SET RESULTFWCOMPAT=0
ECHO Applying forwards compatability %VER% scripts
perl -i -pe"s/GetBJMaxPlayers/GetBJMaxPlayersAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/GetBJMaxPlayers/GetBJMaxPlayersAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/GetBJMaxPlayers/GetBJMaxPlayersAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/BlzGroupAddGroupFast/BlzGroupAddGroupFastAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/BlzGroupAddGroupFast/BlzGroupAddGroupFastAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/BlzGroupAddGroupFast/BlzGroupAddGroupFastAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/BlzGroupRemoveGroupFast/BlzGroupRemoveGroupFastAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/BlzGroupRemoveGroupFast/BlzGroupRemoveGroupFastAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/BlzGroupRemoveGroupFast/BlzGroupRemoveGroupFastAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/BlzGroupGetSize/BlzGroupGetSizeAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/BlzGroupGetSize/BlzGroupGetSizeAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/BlzGroupGetSize/BlzGroupGetSizeAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_MAROON/PLAYER_COLOR_MAROONAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_MAROON/PLAYER_COLOR_MAROONAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_MAROON/PLAYER_COLOR_MAROONAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_NAVY/PLAYER_COLOR_NAVYAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_NAVY/PLAYER_COLOR_NAVYAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_NAVY/PLAYER_COLOR_NAVYAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_TURQUOISE/PLAYER_COLOR_TURQUOISEAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_TURQUOISE/PLAYER_COLOR_TURQUOISEAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_TURQUOISE/PLAYER_COLOR_TURQUOISEAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_VIOLET/PLAYER_COLOR_VIOLETAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_VIOLET/PLAYER_COLOR_VIOLETAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_VIOLET/PLAYER_COLOR_VIOLETAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_WHEAT/PLAYER_COLOR_WHEATAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_WHEAT/PLAYER_COLOR_WHEATAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_WHEAT/PLAYER_COLOR_WHEATAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_PEACH/PLAYER_COLOR_PEACHAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_PEACH/PLAYER_COLOR_PEACHAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_PEACH/PLAYER_COLOR_PEACHAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_MINT/PLAYER_COLOR_MINTAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_MINT/PLAYER_COLOR_MINTAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_MINT/PLAYER_COLOR_MINTAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_LAVENDER/PLAYER_COLOR_LAVENDERAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_LAVENDER/PLAYER_COLOR_LAVENDERAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_LAVENDER/PLAYER_COLOR_LAVENDERAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_COAL/PLAYER_COLOR_COALAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_COAL/PLAYER_COLOR_COALAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_COAL/PLAYER_COLOR_COALAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_SNOW/PLAYER_COLOR_SNOWAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_SNOW/PLAYER_COLOR_SNOWAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_SNOW/PLAYER_COLOR_SNOWAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_EMERALD/PLAYER_COLOR_EMERALDAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_EMERALD/PLAYER_COLOR_EMERALDAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_EMERALD/PLAYER_COLOR_EMERALDAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_COLOR_PEANUT/PLAYER_COLOR_PEANUTAMAI/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_COLOR_PEANUT/PLAYER_COLOR_PEANUTAMAI/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_COLOR_PEANUT/PLAYER_COLOR_PEANUTAMAI/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_NEUTRAL_PASSIVE/PLAYER_AMAI_NEUTRAL_PASSIVE/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_NEUTRAL_PASSIVE/PLAYER_AMAI_NEUTRAL_PASSIVE/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_NEUTRAL_PASSIVE/PLAYER_AMAI_NEUTRAL_PASSIVE/g" Scripts/%VER%/vsai/Blizzard.j

perl -i -pe"s/PLAYER_NEUTRAL_AGGRESSIVE/PLAYER_AMAI_NEUTRAL_AGGRESSIVE/g" Scripts/%VER%/common.ai
perl -i -pe"s/PLAYER_NEUTRAL_AGGRESSIVE/PLAYER_AMAI_NEUTRAL_AGGRESSIVE/g" Scripts/%VER%/Blizzard.j
perl -i -pe"s/PLAYER_NEUTRAL_AGGRESSIVE/PLAYER_AMAI_NEUTRAL_AGGRESSIVE/g" Scripts/%VER%/vsai/Blizzard.j


pjass %VER%\common.j Scripts\%VER%\common.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
jassparser %VER%\common.j Scripts\%VER%\common.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\elf.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\elf.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\human.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\human.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\orc.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\orc.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
pjass %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\undead.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
jassparser %VER%\common.j Scripts\%VER%\common.ai Scripts\%VER%\undead.ai
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
pjass %VER%\common.j Scripts\%VER%\Blizzard.j
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
jassparser %VER%\common.j Scripts\%VER%\Blizzard.j
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
pjass %VER%\common.j Scripts\%VER%\vsai\Blizzard.j
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
jassparser %VER%\common.j Scripts\%VER%\vsai\Blizzard.j
if "%errorlevel%"=="1" SET RESULTFWCOMPAT=1
if "%RESULTFWCOMPAT%"=="1" (
  ECHO Apply forwards compatability %VER% scripts error
  exit /b %RESULTFWCOMPAT%
) else (
  ECHO Apply forwards compatability %VER% scripts finish
)