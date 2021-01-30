# AMAI
Advanced Melee Artifical Intelligence Mod For Warcraft 3

Created by **AIAndy**, **Zalamander** and the **Strategy Master**.

Official Release Links available from: https://www.hiveworkshop.com/threads/advanced-melee-ai.62879/

As was originally hosted on http://www.wc3campaigns.net/forumdisplay.php?f=601

# Warcraft Requirements
| AMAI Version    | War3 Support                   | Comments |
| -----------|--------------------------------|---------------|
| 2.5.4      | Min 1.24+ | Classic edition from 2008 |
| 2.6.1      | Min 1.24+ | Better Support for 1.30+ |
| 3.0        | Min 1.32+                      |     |

* There are reports that v1.29 of Warcraft 3 prevents AMAI from chatting. This is just an issue with this version and you can downgrade or upgrade.

# How to Play
AMAI release comes with the standard AI scripts pre-built for you.

It is suggested to create a subfolder in your "maps" folder like "maps\AMAI" and copy the maps you intend to use AMAI with there.
For Warcraft 1.30 onwards you need to use http://www.zezula.net/en/casc/main.html to extract a copy of official maps.

- Run *InstallTFTtoMap* from a windows commandline or powershell, to install AMAI to maps e.g `InstallTFTToMap.bat "C:\mymap.w3m"`
- Alternatively for complex installs if you have `perl` installed you can run `InstallTFTtoDir.pl "C:\Documents\Warcraft III\Maps\AMAI"` to install AMAI to all maps in a directory and subdirectories.
- After installing AMAI on your map just start Warcraft3: RoC or TFT and play the map against and/or with computers to make use of AMAI.

## Notes
- Advanced Melee AI is made to be used on 'melee' maps only so please don't try to use it on custom maps (e.g towerdefence), it will make no difference on such maps.
- The old `AMAI.exe` installer from classic AMAI has been moved into the `Templates` folder and will not work unless you run `MPQEditor htsize "C:\mymap.w3m" 64` from a commandline first.
- You may need to run as an administrator if you have issues with maps not displaying any teams.

# Build Requirements
To build scripts from source code or to make custom changes you must install perl (via `strawberry` or `activestate`).
Additionally you need to install the *Tk* module if you want to run the **Strategy Manager UI Client** as described in the manual.
`Activestate` uses the package manager to install modules, while `strawberry` you need to use the CPAN client to install a module.

Tested with strawbery perl 5.30 and Tk 804.034

*You may need to run as an administrator if you have issues with maps not displaying any teams.

## TFT Build
- Use *makeTFT.bat* to create the standard scripts for the AI.
- Run *InstallTFTToMap.bat "C:\mymap.w3m"* to install the AI scripts to Warcraft 3 maps.
- Run up a custom game and select the map to play.

## VS AI Build
- This special version will make *odd* teams run with AMAI and *even* teams run with the standard blizzard AI.
- Use *makeVAITFT.bat* to create the AMAI vs AI scripts.
- Run *InstallTFTToMap.bat "C:\mymap.w3m"* to install the AI scripts to Warcraft 3 maps.

## ROC Build
- This version is intended to be played in the original ROC (Reigns of Chaos) version of the game. This version is currently not supported in 1.32+.
- Use *makeROC.bat* to create the ROC scripts.
- Run *InstallROCtoMap.bat "C:\mymap.w3m"* to install the AI scripts to Warcraft 3 maps.

# Features
- **Personality Profiles**: Each AI opponent has a set profile which modifies how it reacts or plays the game. Some can be real chickens and never dare to attack you while others will rush you down.
- **Dynamic Strategies**: Constantly monitors the current situation of the game and always try to pick the best suited strategy to counter the enemy forces.
  - The computers will pick from all strategies depending on what kind of units the enemy has, how long the game has been going and what favorite units the current profile has.
- **Enhanced Micromanagement Control**
  - To help keep as many units as possible alive by fleeing by town portal, zeppelin or foot.
  - This includes better use of items and healing items.
  - Makes the enemy force suffer as much as possible by focusing fire on the most vulnerable enemy units first if they are in range.
  - Will buy neutral heroes and units.
  - Can occasionally attempt tower rushes and militia/ancient expansions.
- **Enhanced Team Play**
  - Coordinates with allies what it will be attacking or will join allies in attacking a target.
  - Human players have access to the Commander, letting you give commands.
  - Asks for aid if running out resources.
- **Surrenders** : Based on profiles some AI's will give up when it detects its losing, while others will fight to the death.
- **Chat Support**
  - AMAI will taunt enemy players, and share its build strategy with team players.
  - Includes Support for **10 different languages**.
- Easy to use **Strategy and Profile editor**.
  - Supports an unlimited amount of your own profiles.
  - Supports an unlimited amount of your own strategies.
  - Auto Building feature for example: a AMAI computer only needs to know that it shall build a hero and 15 footmen. It will automatically build all needed buildings, workers and farms in order to get this as fast as possible.


# Commander
The Commander allows you to give orders to your ally AI's.

To *disable* the commander rename/delete the blizzard.j file within `Scripts/` before running the install script.
You must disable the commander if you want to play on an older version of warcraft 3.

If you installed The Commander to the map there will be language selection dialogs to select a language. Another dialog may also appear with options

1) No Commander
2) With Commander - Press 'ESC' to bring up the commander menu.
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

## Custom Maps
AMAI is designed to work with melee maps.

If you make a custom map you need to make sure in the world editor it is also set to Latest Patch dataset and still using the melee AI.
If you don't do this the AI will get stuck upgrading past tier 2 as it will use the vanilla patch.

To change the patch data set use the following menus from the world editor.
> scenario -
> map properties -
> options -
> game data set -
> Change from Default (based on map melee status) to Latest Patch

If your custom map has custom units you will need to make custom changes to AMAI which can be followed in the `Manual`.

## Custom AI
AMAI has built in support to be able to write new strategies and profiles using the **Strategy Manager UI Client** . The `Manual` folder contains more details.

# Credits

### Helpers
- Hrothgaar
- WargH
- DK Slayer (For the Commander)

### Translations
- English - Chad Nicholas,
- Swedish - Zalamander,
- German - AIAndy, Sagan,
- French - JUJU, WILL THE ALMIGHTY,
- Spanish - Vexorian, Moyack,
- Romanian - Andas_007,
- Chinese - Dr Fan, Sheeryiro, KeamSpring
- Russian - RaZ and Darkloke,
- Portuguese - imba curisco ghouleh,
- Norwegian - Aray

### Quality Assurance
- Hrothgaar,
- WargH,
- ster,
- Tommi,
- xWOLF,
- Feannor,
- Jum-Jum,
- and anyone else missing a mention here.

### Tooling
- JASS Precompiler - Vidstige
- MPQEditor - Ladislav Zezula
