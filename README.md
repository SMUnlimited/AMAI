# AMAI
Advanced Melee Artifical Intelligence Mod For Warcraft 3

《魔兽争霸3》高级对战人工智能模组

原作者项目：https://github.com/SMUnlimited/AMAI

鉴于目前作者没有继续更新的想法，我决定自己动手打造全新的AMAI，新发布的AMAI命名为3.10，之后会在这个基础上持续更新。

贴吧讨论贴：https://tieba.baidu.com/p/7518495423

下载地址：历史版本见网页右侧Releases栏。
AMAI 3.10c 百度网盘：https://pan.baidu.com/s/1HMxkRacnVe38C6-lWrJmPg
已预安装了43张W3M地图，141张W3X地图，共184张地图。附赠安装包和其他版本AMAI。

# 关于不同版本War3和AMAI适配的问题：
AMAI2.54b，适配1.24b以上所有版本，但由于1.29之后科技树变化过大，不太推荐新版本继续使用。
AMAI2.61，和2.54b相比，功能上没有突破性的变化。同样适配1.24b以上，但进一步加强了对1.30+版本的支持。另外我安装的时候使用的地图是1.29以上版本的，因此更低版本的War3可能用不了。
AMAI3.10，功能与之前相比有很大提升，全面支持最新版1.32.10。老版本基本用不了。
综上，如果你还在用1.27或者1.29以下的War3，还是推荐继续使用2.54b；1.29-1.32之间的版本可以用2.61，最新版就用3.10。



简单介绍AMAI的各种功能：

# 个性档案：
每个 AI 对手都有一套配置文件，根据档案，不同AI的操作反应或游戏风格都会不同、喜欢使用的英雄、单位和战术也不同。

# 动态策略：
不断监测当前游戏局势，并始终尝试选择最适合的策略来反制对手。
AI将根据敌人拥有的单位类型、游戏进行了多长时间来调整策略，并且根据自身“个性”中最喜欢出的单位来选择策略。

# 强化微操：
通过TP卷轴、飞艇和极限拉扯，以及更好地使用物品和治疗道具，帮助尽可能多的单位存活。
如果敌方最脆弱的单位在射程内，AI会首先集火它们，从而使敌军尽可能遭受损失。
会购买中立的英雄和单位。偶尔会尝试Tower Rush和雇佣兵。

# 强化团队合作：
与盟友协调它将要攻击的对象，或将与盟友一起攻击目标。
人类玩家可以通过控制台给AI下达指令。如果资源耗尽，可以向AI寻求帮助。

# 投降：
根据个人资料，一些 AI 会在检测到快输的时候投降，而另一些AI则会战斗至死。

# 支持聊天：
AMAI 会嘲讽敌方玩家，并与队友玩家分享自己的出兵策略。支持10 种不同语言。
易操作的策略编辑器：
支持玩家不受限制地创建和编辑属于自己的策略、AI档案。



# AMAI安装包主程序使用方式：
从 Windows 命令行或 powershell 运行 MakeTFT.bat 为 AI 创建标准脚本。
从 Windows 命令行或 powershell 运行 InstallTFTtoMap，将 AI 脚本安装到魔兽争霸 3 地图。例如 "InstallTFTToMap.bat C:\mymap.w3m"。（输入时没有引号）
对于多个地图的安装，如果安装了 perl，你可以运行 "InstallTFTtoDir.pl 文件夹位置"将 AMAI 安装到目录和子目录中的所有地图。

# AMAI编辑器使用方式：
要从源代码构建脚本或进行自定义更改，你必须安装 perl（通过strawberry或activestate）。
此外，如果你想按照手册中的描述运行 Strategy Manager UI 客户端，你需要安装 Tk 模块。 Activestate 使用包管理器来安装模块，而strawberry则需要使用 CPAN 客户端来安装模块。
安装之后在perl命令行运行AMAIStrategyManager。

# 注意事项：
AMAI仅适用于对战地图，因此请不要尝试在自定义地图（例如塔防）上使用它，它在此类地图上没有任何作用。
来自老版本 AMAI 的旧 AMAI.exe 安装程序已移至 Templates 文件夹中，目前无法运行，请不要使用。
如果未安装成功，或打开地图后没有显示任何队伍，尝试以管理员身份运行安装。
AMAI自带英文操作手册，里面有对AMAI操作和编辑的详细解析，位置在AMAI/Manual文件夹下，有兴趣的可以阅读。

# 已知BUG
使用网易魔兽对战平台RPG房间联机游玩安装AMAI的地图时，可能会发生出生点重叠，AI进度不同步等问题。
安装淬火mod后打开安装AMAI的地图，内部的AI行为相较于原版会发生很大变化，比如侵略性大大增强，部分AI只会出一本兵等。原因是淬火mod中包含了部分老版本War3的文件。





Created by **AIAndy**, **Zalamander** and the **Strategy Master**.

Official Release Links available from: https://www.hiveworkshop.com/threads/advanced-melee-ai.62879/

As was originally hosted on http://www.wc3campaigns.net/forumdisplay.php?f=601



# Warcraft Requirements
| AMAI Version    | War3 Support                   | Comments |
| -----------|--------------------------------|---------------|
| 2.5.4      | Min 1.24+ | Classic edition from 2008 |
| 2.6.1      | Min 1.24+ | Better Support for 1.30+ |
| 3.0        | Min 1.32+ | Full Support for the 1.30+ era |

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
- This version is intended to be played in the original ROC (Reigns of Chaos) version of the game. This version is currently not supported in 1.30+.
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
