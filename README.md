# ![AMAI](AMAI.jpg)

Advanced Melee Artificial Intelligence Mod For Warcraft III.

Created by **AIAndy**, **Zalamander** and the **Strategy Master**.

Official Release Links available from https://www.hiveworkshop.com/threads/advanced-melee-ai.62879/.

AMAI was originally hosted on http://www.wc3campaigns.net/forumdisplay.php?f=601.

# How to Play

AMAI release has the standard AMAI scripts pre-built for you. You just need to install the scripts to maps or your game.

## Map Extraction

Most install options require installing onto maps, so these may need extraction first. 

It is suggested to create a subfolder in your "maps" folder like `C:\Users\<Username>\Documents\Warcraft III\Maps\AMAI\`, where `<Username>` should be replaced with your own username, and copy the maps you intend to use AMAI with there.

You can opt to download a map pack containing a selection with AMAI preinstalled if you struggle to install, use an OS that is not supported.

For Warcraft III 1.30 onwards, you need to use http://www.zezula.net/en/casc/main.html to extract a copy of the official blizzard maps to install AMAI onto.

On Windows, make sure the maps to install onto are not in a protected UAC location. 
  - This may mean you have to install to maps in a different directory then copy into your Maps folder afterwards.
  - Or run installer as an administrator.

## Warcraft III Requirements and Versions

There are multiple editions of AMAI available to install based on your Warcraft III version you run with. Some install methods you must use the correct abrievation in the table to install the correct scripts.
Improvements and fixes to the core AI engine will improve the older scripts as well.

| AMAI Scripts      | Optimal Version | Supported Version      |
| ----------------- | ------------------- | ------------------|
| **REFORGED** | **1.36.2** | 1.33+ |
| **TFT** | **1.24-1.28** | 1.24+ |
| **ROC** | **1.24-1.28** | 1.24 - 1.31 |

*Optimal* version is based on the Warcraft III tech tree this edition is based on. The further a version is from the optimal, the more likely it will affect the AMAIs' ability to build, usually just unoptimal build order, but at the worst case it can no longer build at all.

Classic AMAI scripts do have some forward compatibility built in to fix some major issues in later versions including 24 player support.

Avoid v1.29.x of Warcraft III and either upgrade or downgrade as it breaks various things including but not limited to: 
  - Preventing AMAI from chatting.
  - Heroes not learning skills although we have a fix that can get applied, this may not work if the map itself is too old.

## AMAI UI Installer

The installer only works on 64-bit Windows 7/8/10.

The installer has to be downloaded separately as its much larger compared to the AI package.

Unzip the contents of the installer to a folder of your choice.

Double-click amai-electron-manager.exe to open the installer.

You can install to a single map or a whole directory.

![installer](installer.jpg)

## Command-line Install

This guide assumes that your working directory is `AMAI`.

From Windows `CMD`/`PowerShell` or Wine `wineconsole`, run this:
```
.\Install<Version>ToMap.bat "C:\Documents\Warcraft III\Maps\AMAI\<Map>.w3m" <N>
```
Where `<Version>` should be replaced with `ROC`, `TFT`, or `REFORGED`, `<Map>` with your preferred map, `<N>` with `1` or `0` if you want to install the Commander or not, respectively.

Press enter to install AMAI to the selected map.

Note that disabling the Commander makes `-zoom xxxx` non-functional on pre-REFORGED game versions.

![example](example.jpg)

Alternatively, for complex installs, if you have `perl` installed, you can run this:
```
perl .\InstallToDir.pl <Version> "C:\Documents\Warcraft III\Maps\AMAI\"
```
This will install AMAI to all maps recursively.

You can disable the commander for this install by running this:
```
perl .\InstallToDir.pl <Version> "C:\Documents\Warcraft III\Maps\AMAI\" "false"
```

After installing AMAI on your map, just start Warcraft III and play the map against and/or with computers to make use of AMAI.

## Manual Install

You can manually use the included `MPQEditor.exe` to install to a single map.

You can use this with Wine to install on Linux/macOS systems too.

Copy contents of `AMAI\Scripts\<Version>` and `AMAI\Scripts\Blizzard.j` into the `Scripts` folder in a map.

## Manual Mod Install

You can install scripts locally to your game folder to enable AMAI for any map you play, freeing you from extracting the official maps, as well as being able to update AMAI easily.

For Warcraft III Windows version, change the registry key:
```
HKEY_CURRENT_USER\Software\Blizzard Entertainment\Warcraft III" - Allow Local Files"=dword:00000001
```
Or alternatively, run this:
```
reg add "HKCU\Software\Blizzard Entertainment\Warcraft III" /v "Allow Local Files" /t REG_DWORD /d 1
```

For Warcraft III macOS version, from `Terminal.app`, run this:
```
defaults write com.blizzard.<Game> "Allow Local Files" -int 1
```
Where `<Game>` should be replaced with `Warcraft\ III` if you have the release version, or `Warcraft\ III\ Public\ Test` if you have the PTR version.

Create a `Scripts` folder in the game directory, and include the `*.ai` and `Blizzard.j` from AMAI `Scripts` folder with the `<Version>` you want.
  - 1.32.6 and below: Create a `Scripts` folder at the root of the game directory.
  - 1.32.7 and above: Create a `Scripts` folder in `<Flavour>` folder at the root of the game directory, where `<Flavour>` should be replaced with `_retail_` if you have the release version, or `_ptr_` if you have the PTR version.

Run game and play a custom game on a standard melee map.

## Notes

Advanced Melee AI is made to be used on 'melee' maps only so please don't try to use it on completely custom maps (e.g Tower Defence). It will make no difference on such maps.

Custom melee maps need to be set to latest patch data. Open the map in the Warcraft editor, go to `Scenario` > `Map Options`, and change `Game Data Set` to `Melee (Latest Patch)`.

Lua maps do not appear to work. Open the map in the Warcraft editor, go to `Scenario` > `Map Options`, and change `Script Language` to `Jass`, then install AMAI to it. If `Script Language` is disabled, please reset the `Trigger Editor` to its initial state.

You may need to run as an administrator if you have issues with maps not displaying any teams.

Note that maps older than 1.24 will need resaving in the world editor if you want full 24 player support.

# Build Requirements

To build scripts from source code or to make custom changes you must install perl (via `strawberry` or `activestate`).

Additionally you need to install the *Tk* module if you want to run the **Strategy Manager UI Client** as described in the manual.

`Activestate` uses the package manager to install modules, while `strawberry` you need to use the CPAN client to install a module.

Tested with strawbery perl 5.30 and Tk 804.034.

(You may need to run as an administrator if you have issues with maps not displaying any teams.)

## Build Requirements for AMAI Installer (Via Electron)

- node 14 or greater...
- npm 6 or greater...
- angular-cli 16 or greater...

### Running Electron Locally

Go to the Electron folder inside the project and open the IDE of your choice.

Run this to install project dependencies:
```
npm i
```

Run this to open in development environment:
```
npm start
```

### Deploying the Electron Installer

Run this inside the Electron folder:
```
npm run electron:build
```

You must have a built or downloaded copy of AMAI and unzip it in the folder `<AMAI Installer>\resources\AMAI`.
  - You only need to include the `Scripts` folder and `MPQEditor.exe` within the AMAI directory.

Zip the contents of the release/win-unpacked folder and deploy this zipped file.

### Notes about the Electron Installer Build Process

I'm working on doing the zip mentioned above in an automated way.

The build process creates the executable for the current operating system only. To create other executables, the process must be run on the corresponding operating system.

I will be working on the possibility of building the linux executable on windows.

## Building Scripts

You need to use the various `Make<Version>` bat files to create the AMAI scripts for various versions.

For example, if you have REFORGED game version, run/double-click `MakeREFORGED.bat` to create REFORGED scripts.

Then install like normal by running this: 
```
.\InstallREFORGEDToMap.bat "C:\Documents\Warcraft III\Maps\AMAI\<Map>.w3m" <N>
```

To use the installer, you must copy the `Scripts` folder and `MPQEditor.exe` to the folder `<AMAI Installer>\resources\AMAI`.

Run up a custom game and select the map to play.

## Optimise Build

This will optimise previously built AI scripts to make them a little bit faster and leaner. Only useful if you are having performance issues, as it's not shipped by default.

Run/double-click one of the `MakeOpt<Version>` bat files. (e.g `MakeOptROC.bat` to create optimized ROC scripts for the classic ROC game version.)

Then install like normal by running this: 
```
.\InstallROCToMap.bat "C:\Documents\Warcraft III\Maps\AMAI\<Map>.w3m" <N>
```

## VS AI Build

This special version will make *odd* teams run with AMAI and *even* teams run with the standard Blizzard AI.

Useful for testing how much better AMAI is against the original AI.

Not shipped by default as it creates a very different `Blizzard.j` file.

Run/double click one of the `MakeVAI<Version>` bat files. (e.g `MakeVAITFT.bat` to create the AMAI vs Blizzard AI scripts for the classic TFT version.)

Then install like normal by running this: 
```
InstallTFTToMap.bat "C:\Documents\Warcraft III\Maps\AMAI\<Map>.w3m" <N>
```

# Features

**Personality Profiles**:
  - Each AMAI has a set of profiles which modifies depending on how it reacts or plays the game. Some can be real chickens and never dare to attack you while others will rush you down.

**Dynamic Strategies**:
  - Constantly monitors the current situation of the game and always try to pick the best suited strategy to counter the enemy forces.
  - The computers will pick from all strategies depending on what kind of units the enemy has, how long the game has been going and what favorite units the current profile has.

**Enhanced Micromanagement Control**:
  - To help keep as many units as possible alive by fleeing by town portal, zeppelin or foot.
  - This includes better use of items and healing items.
  - Makes the enemy force suffer as much as possible by focusing fire on the most vulnerable enemy units first if they are in range.
  - Will buy neutral heroes and units.
  - Can occasionally attempt tower rushes and militia/ancient expansions.

**Enhanced Team Play**:
  - Coordinates with allies on what it will be attacking or will join allies in attacking a target.
  - Real players have access to the Commander, letting you give commands.
  - Asks for aid if running out resources.

**Commander Game Modes**:
  - Play matches where real players can only order their allies to victory with the Commander, or real players and AMAI both directly control the same units and buildings.

**Surrenders**:
  - Based on profiles some AMAI computers will give up when it detects it's losing, while others will fight to the death.

**Chat Support**:
  - AMAI computers will taunt opponents, and share its' build strategy with team players.
  - Includes Support for **10 different languages**.

**Strategy and Profile Editor**:
  - Supports an unlimited amount of your own profiles.
  - Supports an unlimited amount of your own strategies.
  - Auto Building feature for example: an AMAI computer only needs to know that it shall build a hero and 15 footmen. It will automatically build all needed buildings, workers and farms in order to get this as fast as possible.

# Commander

The Commander allows you to give orders to your AMAI allies.

There will also be language selection dialogs to change the language of dialogs and AMAI chat messages.

To *disable* the Commander, pass the correct option to the install scripts in the first place, or run this:
```
.\DisableCommander.bat "C:Users\<Username>\Documents\Warcraft III\Maps\AMAI\<Map>.w3m"
```

Once installed another dialog will appear with game mode options:

1) `No Commander` - Disables the Commander during this game.
2) `With Commander` - Commander is availaable. Press `ESC` key to bring up the Commander menu.
3) `Computers Only` - Same as `With Commander`, except real players do not play, real player forces are removed and real players can only issue orders via the Commander to try and make AMAI ally win.
4) `Joint Control` - Same as `Computers Only`, but real players can also directly control their ally AMAI's forces.

## Commander Advanced Settings

It's now possible to set a default language and gametype so that the dialog box will not appear again and again when the game starts.

To find the settings, edit and search for `language` and `game_mode` from `Blizzard.j` file located at `AMAI\Scripts`. You should directly end up viewing the two rows below:

    string language = ""  // Possible values: "" (dialog), "English", "Deutsch", "Swedish", "French", "Spanish", "Romanian", "Russian", "Portuguese", "Norwegian", "Chinese"
    string game_mode = "" // Possible values: "" (dialog), "commander", "no_human", "ai_only", "shared"

If you make the first row look like this:

    string language = "English"  // Possible values: "" (dialog), "English", "Deutsch", "Swedish", "French", "Spanish", "Romanian", "Russian", "Portuguese", "Norwegian", "Chinese"

The language selection dialog box will not show up again when the game starts, instead the specified language "English" will always be used by the computers.

The `game_mode` setting works exactly the same way, but that setting will only apply if you play a game where different game modes are available, like if you got an allied computer in the game, else the normal melee game type will always be used.

## Custom Maps

AMAI is designed to work with melee maps.

If you make a custom map, you need to make sure in the world editor it is also set to `Latest Patch` dataset and still using the melee AI.

If you don't do this the AMAI will get stuck upgrading past tier 2 as it will use the vanilla patch.

Scripted maps may need to disable the Commander as it will otherwise conflict.

To change the patch data set, use the following menus from the world editor:
  - `Scenario` > `Map Properties` > `Options` > `Game Data Set`, Change from `Default` (based on map melee status) to `Latest Patch`.

If your custom map has custom units you will need to make custom changes to AMAI which can be followed in the `Manual`.

## Custom AI

AMAI has built in support to be able to write new strategies and profiles using the **Strategy Manager UI Client** . The `Manual` folder contains more details.

# Credits

### Helpers
- Hrothgaar
- WargH
- DK Slayer (For the Commander)

### Translations
- English - Chad Nicholas
- Swedish - Zalamander
- German - AIAndy, Sagan
- French - JUJU, WILL THE ALMIGHTY
- Spanish - Vexorian, Moyack, Slayer95
- Romanian - Andas_007
- Chinese - Dr Fan, Sheeryiro KeamSpring, Pixyy
- Russian - RaZ and Darkloke, Lolasik011
- Portuguese - imba curisco ghouleh
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
