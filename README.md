# AMAI
Advanced Melee Artifical Intelligence Mod For Warcraft 3
 
Created by **AIAndy**, **Zalamander** and the **Strategy Master**.

Official Release Links available from: https://www.hiveworkshop.com/threads/advanced-melee-ai.62879/

As was originally hosted on http://www.wc3campaigns.net/forumdisplay.php?f=601 (Site is now down)

# How to Play
AMAI release comes with the standard AI scripts pre-built for you.

It is suggested to create a subfolder in your "maps" folder like "maps\AMAI" and copy the maps you intend to use AMAI with there.
For Warcraft 1.30 onwards you need to use http://www.zezula.net/en/casc/main.html to extract a copy of official maps.

Run *InstallTFTtoMap*, or *InstallROCtoMap*, or *InstallVAITFTtoMap* from a commandline, to install AMAI to maps e.g `InstallTFTToMap.bat "C:\mymap.w3m"`

Advanced Melee AI is made to be used on 'melee' maps only so please don't try to use it on custom maps (e.g towerdefence), it will make no difference on such maps.

Note: If you want to use the old `AMAI.exe` to install AMAI to maps you must have run `MPQEditor htsize "C:\mymap.w3m" 64` from a commandline to garuantee the AI will be installed correctly.

If you have `perl` installed you can use `InstallTFTtoDir.pl "C:\Documents\Warcraft III\Maps\AMAI"` to install AMAI (any edition) to all maps in a directory and subdirectories.

After installing AMAI on your map just start Warcraft3: RoC or TFT and play the map against and/or with computers to make use of AMAI.

# Build Requirements
To build scripts from source or to make custom changes you must install perl (via `strawberry` or `activestate`).
Additionally you need to install the *Tk* module if you want to run the **Strategy Manager UI Client** as described in the manual.
`Activestate` uses the package manager to install modules, while `strawberry` you need to use the CPAN client to install a module.

Tested with strawbery perl 5.30 and Tk 804.034

# Quick Build And Install
- Use *makeTFT.bat* to create the scripts for the AI. 
- Run *InstallTFTToMap.bat "C:\mymap.w3m"* to install the AI scripts to Warcraft 3 maps. 
- Run up a custom game and select the map to play.

## ROC Build And Install
- Use *makeROC.bat* to create the ROC scripts. This is currently not supported in 1.32+
- Run *InstallROCtoMap.bat "C:\mymap.w3m"* to install the AI scripts to Warcraft 3 maps.
- This version is intended to be played in the ROC version of the game. 

## VS AI Build And Install
- Use *makeVAITFT.bat* to create the AMAI vs AI scripts.
- Run *InstallVAITFTtoMap.bat "C:\mymap.w3m"* to install the AI scripts to Warcraft 3 maps.
- This special version will make *odd* teams run with AMAI and *even* teams run with the standard blizzard AI.

# Commander
To *disable* the commander rename/delete the blizzard.j file within `Scripts/` before running the install script.

If you installed The Commander to the map there will be language selection dialogs to select a language. Another dialog may also appear with options

1) No Commander
2) With Commander - The Commander allows you to give orders to your ally friends. Press 'ESC' to bring up the commander menu. 
3) Computers Only - Same as commander except you dont play at all and instead can only issue orders to try and make your ally ai win

## Commander Advanced Settings

It's now possible to set a default language and gametype so the dialog will not appear when game starts, instead the setting you made will apply at once.
To find the settings edit and search for "game_mode" in the Blizzard.j file located directly in the same folder as this readme file. You should directly end up viewing the two rows below.

    string language = ""  // Possible values: "" (dialog), "English", "Deutsch", "Swedish", "French", "Spanish", "Romanian"
    string game_mode = "" // Possible values: "" (dialog), "commander", "no_human", "ai_only"

Now enter a setting you prefer in one or both of these rows, an example will follow.

If you make the first row look like this:
    string language = "English"  // Possible values: "" (dialog), "English", "Deutsch", "Swedish", "French", "Spanish", "Romanian"

The language selection dialog will not show up again when the game starts, instead the specified language "English" will always be used by the computers.
The game_mode setting works exactly the same way but that setting will only apply if you play a game where different game modes are available like if you got an allied computer in the game, else the normal melee game type will always be used.

# Credits

## Helpers
Hrothgaar,
WargH

## Translations
English - Chad Nicholas,
Swedish - Zalamander,
German - AIAndy, Sagan,
French - JUJU, WILL THE ALMIGHTY,
Spanish - Vexorian, Moyack,
Romanian - Andas_007,
Chinese - Dr Fan,
Russian - RaZ and Darkloke,
Portuguese - imba curisco ghouleh,
Norwegian - Aray

## The Commander
AIAndy,
DK Slayer

## Quality Assurance - Reign of Chaos
WargH

## Quality Assurance - The Frozen Throne
Hrothgaar,
WargH,
ster,
Tommi,
xWOLF,
Feannor,
Jum-Jum,
and everyone else I might have forgotten to mention here.

## JASS Precompiler
Vidstige

## MPQEditor
Ladislav Zezula 
