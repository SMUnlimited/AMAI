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

# 更新日志

## [AMAI3.10c 更新内容]

### 全局调整
- 重新调整动态策略系统，调整各单位的权重。
- 大规模调整各族战术，重做多个战术，完善大部分战术。
- 激活并完善各族反塔Rush战术。
- 为所有种族战术的二本阶段增加少量基础兵种，避免二本期间被Rush后不出兵的情况。
- 调整TP机制，现在即使队伍规模较小AI也会尝试TP回防。
- 提升各族重建分矿的优先级。
- 降低了AI英雄在家傻等恢复血量的时间。

### 种族调整
- 人族
  - 调整了AI生产农民的数量，现在AI在单矿时会用9个农民采木，确保在多个农民建造建筑时仍然有足够农民采木。
  - 调整人族多农民同时建造功能，现在AI只会在资源足够多的情况下双敲或多敲建筑。
  - 调整敲民兵开矿机制，因版本更新导致民兵时间缩短，因此等比例缩短允许AI使用民兵开矿的距离。
  - 调整AI后期建造塔的数量。
  - 完善小炮战术和飞机战术。
- 兽族
  - 调整各战术板砖车的数量。
  - 调整了剑圣的加点方式与骚扰模式，现在学习疾风步的剑圣可以正常骚扰对手农民了。
- 亡灵
  - 调整各战术前期蜘蛛数量，避免早期等着造坟场而不出兵。
  - 调整个别战术冰龙数量。
  - 为男巫海战术添加绞肉车，能提供更多尸体。
- 暗夜
  - 调整各战术前期女猎手数量，避免早期等着造猎手大厅而不出兵。
  - 恢复了暴雪自带AI的出兵战术，作为战术库备选之一。
  - 恢复了夜视的研究。
- 中立
  - 降低地精修补匠的出场率。
  - 调整了熊猫的技能加点。

## [AMAI3.10b 更新内容]

### 全局调整
- 修复了早期不出兵一直等科技建筑（铁匠铺等）的Bug。
- 调整了TP的使用：提高了购买TP的优先级；提升了对威胁的反应；缩短了使用TP的最小距离；降低了英雄使用TP最低生命值，使操作更加极限。
- 现在低血量英雄将会被移除出集火队伍。
- 调整了各族升级攻防的优先级：现在AI会在合适条件下优先升级高级兵的攻防；降低了一本升攻防的优先级，避免升级攻防影响升本。
- 现在AI会在经济充裕的情况下多造塔。
- 现在AI会在经济充裕的情况下在分矿多造一个商店。
- 重新调整了动态策略系统的参数，现在AI会更多地使用三本兵种来反制对手。
- 重新调整了各族战术，增加了三本兵的出场率和数量，确保战术后期的强度。
- 重新调整了各族战术，修复了升级兵种科技却不出兵的Bug。

### 种族调整
- 人族
  - 修复了AMAI文件中魔法岗哨和照明灯代码错误、错位的Bug，现在AI会正常升级魔法岗哨。
  - 调整了AI生产农民的数量，现在AI会用8个农民采木，确保前期不缺木。
  - 调整了哨塔和商店的优先级，现在AI会正常使用兵营开局。
  - 调整了一本时生产兵种的数量和比例，使前期兵足够用，造兵升本速度足够快。
  - 减少了二本步兵的数量。
  - 给部分战术三本添加了骑士和狮鹫。
  - 给纯法师战术添加了火枪和破法，使其更加万金油。
- 兽族
  - 调整了商店和磨坊的优先级，现在AI会正常使用兵营开局。
  - 调整了AI生产农民的数量，现在AI会用8个农民采木，确保前期不缺木。
  - 给部分战术二本添加了少量牛头人。
  - 给所有兽族战术三本添加大师级巫医，可以缓解兽族AI过多残血兵影响战斗力的问题。
- 亡灵
  - 解决了亡灵缺木的问题：确保每个战术所有阶段至少有三条狗；确保任何情况下AI至少会留下一只狗继续采木。
  - 修复了AI有时会先升本再出首发英雄的Bug
  - 移除了各个战术建造牺牲深渊。
  - 提高了三本购买腐球的优先级。
  - 修复了部分战术无法正确生产冰龙的Bug。
- 暗夜
  - 现在暗夜女英雄（白虎、守望者）不会在残血时使用夜间隐身来躲避对手。
  - 调整了各个战术女猎手的数量。
  - 调整了各个战术风德的数量。
  - 提高了三本购买毒球的优先级。
  - 重新调整了AI选择守望者的优先级。
  - 修改了守望者的撤离机制，降低了残血守望者闪烁逃离后继续回去战斗的概率。

## [AMAI3.10a 更新内容]

### 全局调整
- 战术
  - 恢复了被原作者删除的各族Normal战术（即暴雪原版AI下各族会使用的战术），这样使AI后期更有可能选择万金油战术，而不是纯法师或纯低级兵阵容。
  - 移除了战术编辑器中大部分战术的1 on 1 bonus，现在AI在1v1情况下不会再特别频繁的使用某些战术了。
  - 调整了AI升级攻防的优先级，现在AI在一本不太会升一攻一防，而是把资源省下来升本。
  - 提高了所有种族所有战术的三发英雄优先级，现在基本所有情况下，AI都会在80人口前召唤出三英雄。
  - 移除了各个战术的不合理骚扰。
- 动态策略系统
  - 恢复了动态策略清零函数，现在每次升本AI都会重置动态策略系统，重新计算用什么单位针对更好。（应该能部分修复AI各族总是暴法师应对的Bug）
  - 降低了动态策略系统对二本的影响，现在AI会更多的用三本部队来反制对手。
  - 调整了动态策略系统的计时器，现在更换针对战术后会等一段时间，而不是几十秒一换。
- 操作
  - 修改了英雄微操，现在AI英雄在拉单情况下残血也会使用TP撤退。
  - 降低了英雄使用TP的最大生命值，现在AI英雄会更极限地使用TP。
  - 部分修复了AI英雄卡在家不操作的Bug，这个Bug现在偶尔会有，但降低了卡顿时间。英雄会在血量比较健康时重新参战。
  - 向标准单位文件中添加了熊猫大招的三种形态，现在熊猫到达6级后应该能正常使用大招了。
  - 向标准单位文件中添加了火凤凰和复仇天神，现在血法师和守望者使用大招的概率会进一步提升。
  - 现在AI会在满足条件的情况下，在分矿建造另一个商店。
  - AI现在不会在资源过剩的情况下建造三个祭坛了。

### 种族调整
- 人族
  - 重新调整各类战术的一本建造和出兵逻辑。
  - 降低了购买慢补的优先级，现在AI不会抢先建造商店了。
  - 调整了一本兵的优先级，现在AI会比以前少出步兵了。
  - 重新调整骑士战术，AI不会前期造太多步兵，导致三本没有人口出骑士了。
  - 提高了采木人数，避免前期缺木。
  - 现在AM会在接近人口上限时同时建造农场。
  - 现在AI在一本就会研究采木技术。
  - 现在AI在一本就会研究破法的控制魔法。
- 兽族
  - 提高了采木人数，避免前期缺木。
  - 降低了第一个药膏的优先级，将第二个药膏优先级和受伤单位数量挂钩。这会降低AI先造商店后造祭坛的Bug发生概率。
- 亡灵
  - AI不再会在分矿建造坟场，现在AI会在分矿建造大墓地。
  - 现在所有战术下AI都会造3条以上的狗，避免后期木材不够。
  - 修复了男巫海战术下，AI会先升二本再造英雄的Bug。
- 暗夜
  - AI不再研究夜视。（AI本来就开全图的）
  - 自然祝福的研究将移动到三本，以避免二本缺木和升三本过晚。
  - 下调驱散优先级，现在AI会先造小鹿再研究驱散。
  - 减少1本可能建造弩车的数量。
  - 进一步降低WD二发和三发几率，降低DH三发概率。
  - AI不再使用猛禽德鲁伊来针对空军。（因为AI的鸟德不会变身）
  - AI不再研究猛禽之痕。（原因同上）
  - 降低了AI三本仍出大量一本兵的概率。
  - 提高了部分战术升三本的优先级。
  - 部分战术提高了角鹰、精灵龙和奇美拉的出场率。
- 中立
  - 略微回调了炼金术士的优先级。


## [AMAI 3.10 更新内容]
- 更新直到1.32.10的科技树和物品价格变化。
- 重做聊天系统，更换中文翻译，现在AI使用的聊天和嘲讽语句总算跟上时代了。
- 重做动态策略系统，现在AI会在合适的时间调整战术，战术也会更灵活，兵种更多样。
- 重做所有英雄技能加点顺序。（剑圣终于不会主修镜像了）
- 重做暗夜英雄选择优先级。现在KOG取代DH成为带头大哥，更频繁地出场。
- 降低了守望者二发、三发的概率。
- 提高了炼金术士的登场率。
- 重做所有暗夜精灵战术。
- 调整了所有种族购买物品的优先级。
- 修改维护费对AI的限制，取消过去只有开二矿后才能超过80人口，现在单矿情况下只要攒钱足够也会直接暴人口。（这个改动加强了疯狂AI在小地图上的表现）
- 修复拉扯问题，AI现在会更谨慎和有效地拉扯残血远程单位。
- 修复背水一战功能，现在暗夜AI在最后一搏时不会再拉上小精灵并且把树都站起来。
- 修复AI暗夜开局问题，现在AI不会直到出第7个小精灵才造祭坛，而是会正常开局，4采矿1祭坛，第6个造月井，第7个采矿。
- 扩展了前线距离，避免暗夜AI容易被堵死在家的恶性Bug。
- 修改伐木机对应农民数量，现在AI使用伐木机时会取代更多农民。
- 其他Bug修复。

## [AMAI 2.54b到3.01的更新内容]
- 2.61
  - 修复了对1.32之前版本的支持问题。如果你现在玩的还是老版本魔兽争霸3，可以用这个版本来给地图安装AMAI。
- 3.0
  - 全面支持1.32以上版本，全面支持重制版。3.0要求魔兽争霸 3 最低版本为 1.32。
  - 支持直至1.32.6的所有科技树更新。
  - AMAI 玩家现在默认显示电脑难度等级。例如疯狂AI会带有前缀[AMAI Insane]。
  - 加强AMAI集火操作。
  - 加强AMAI拉扯残血单位操作，地面远程攻击单位现在会尽量避免移速较慢的近战单位近身。
  - 改进了对 24 名玩家的支持。
  - 启用动态策略系统，并作为所有策略的备用计划。动态策略模式下AI会根据对手单位攻击和护甲更快的改变战术，选择最针对的单位反制对手。
  - 添加背水一战功能。现在当 AMAI 资源不足时，如果当前的局势已经低于该AI设定档案中的投降阈值，它会拉上包括农民在内的所有部队进行最后一搏。
  - 其他Bug修复。
- 3.01
  - 移除 AMAI.exe，给地图安装AMAI统一使用bat文件和pl文件。
  - 修复中文翻译/编码问题（感谢keamspring）。



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
