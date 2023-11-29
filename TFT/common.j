//============================================================================
// 1.33 Native types. All native functions take extended handle types when
// possible to help prevent passing bad values to native functions
//
type agent			    extends     handle  // all reference counted objects
type event              extends     agent  // a reference to an event registration
type player             extends     agent  // a single player reference
type widget             extends     agent  // an interactive game object with life
type unit               extends     widget  // a single unit reference
type destructable       extends     widget
type item               extends     widget
type ability            extends     agent
type buff               extends     ability
type force              extends     agent
type group              extends     agent
type trigger            extends     agent
type triggercondition   extends     agent
type triggeraction      extends     handle
type timer              extends     agent
type location           extends     agent
type region             extends     agent
type rect               extends     agent
type boolexpr           extends     agent
type sound              extends     agent
type conditionfunc      extends     boolexpr
type filterfunc         extends     boolexpr
type unitpool           extends     handle
type itempool           extends     handle
type race               extends     handle
type alliancetype       extends     handle
type racepreference     extends     handle
type gamestate          extends     handle
type igamestate         extends     gamestate
type fgamestate         extends     gamestate
type playerstate        extends     handle
type playerscore        extends     handle
type playergameresult   extends     handle
type unitstate          extends     handle
type aidifficulty       extends     handle

type eventid            extends     handle
type gameevent          extends     eventid
type playerevent        extends     eventid
type playerunitevent    extends     eventid
type unitevent          extends     eventid
type limitop            extends     eventid
type widgetevent        extends     eventid
type dialogevent        extends     eventid
type unittype           extends     handle

type gamespeed          extends     handle
type gamedifficulty     extends     handle
type gametype           extends     handle
type mapflag            extends     handle
type mapvisibility      extends     handle
type mapsetting         extends     handle
type mapdensity         extends     handle
type mapcontrol         extends     handle
type minimapicon        extends     handle
type playerslotstate    extends     handle
type volumegroup        extends     handle
type camerafield        extends     handle
type camerasetup        extends     handle
type playercolor        extends     handle
type placement          extends     handle
type startlocprio       extends     handle
type raritycontrol      extends     handle
type blendmode          extends     handle
type texmapflags        extends     handle
type effect             extends     agent
type effecttype         extends     handle
type weathereffect      extends     handle
type terraindeformation extends     handle
type fogstate           extends     handle
type fogmodifier        extends     agent
type dialog             extends     agent
type button             extends     agent
type quest              extends     agent
type questitem          extends     agent
type defeatcondition    extends     agent
type timerdialog        extends     agent
type leaderboard        extends     agent
type multiboard         extends     agent
type multiboarditem     extends     agent
type trackable          extends     agent
type gamecache          extends     agent
type version            extends     handle
type itemtype           extends     handle
type texttag            extends     handle
type attacktype         extends     handle
type damagetype         extends     handle
type weapontype         extends     handle
type soundtype          extends     handle
type lightning          extends     handle
type pathingtype        extends     handle
type mousebuttontype    extends     handle
type animtype           extends     handle
type subanimtype        extends     handle
type image              extends     handle
type ubersplat          extends     handle
type hashtable          extends     agent
type framehandle        extends     handle
type originframetype    extends     handle
type framepointtype     extends     handle
type textaligntype      extends     handle
type frameeventtype     extends     handle
type oskeytype          extends     handle
type abilityintegerfield            extends handle
type abilityrealfield               extends handle
type abilitybooleanfield            extends handle
type abilitystringfield             extends handle
type abilityintegerlevelfield       extends handle
type abilityreallevelfield          extends handle
type abilitybooleanlevelfield       extends handle
type abilitystringlevelfield        extends handle
type abilityintegerlevelarrayfield  extends handle
type abilityreallevelarrayfield     extends handle
type abilitybooleanlevelarrayfield  extends handle
type abilitystringlevelarrayfield   extends handle
type unitintegerfield               extends handle
type unitrealfield                  extends handle
type unitbooleanfield               extends handle
type unitstringfield                extends handle
type unitweaponintegerfield         extends handle
type unitweaponrealfield            extends handle
type unitweaponbooleanfield         extends handle
type unitweaponstringfield          extends handle
type itemintegerfield               extends handle
type itemrealfield                  extends handle
type itembooleanfield               extends handle
type itemstringfield                extends handle
type movetype                       extends handle
type targetflag                     extends handle
type armortype                      extends handle
type heroattribute                  extends handle
type defensetype                    extends handle
type regentype                      extends handle
type unitcategory                   extends handle
type pathingflag                    extends handle
type commandbuttoneffect            extends handle


constant native ConvertRace                 takes integer i returns race
constant native ConvertAllianceType         takes integer i returns alliancetype
constant native ConvertRacePref             takes integer i returns racepreference
constant native ConvertIGameState           takes integer i returns igamestate
constant native ConvertFGameState           takes integer i returns fgamestate
constant native ConvertPlayerState          takes integer i returns playerstate
constant native ConvertPlayerScore          takes integer i returns playerscore
constant native ConvertPlayerGameResult     takes integer i returns playergameresult
constant native ConvertUnitState            takes integer i returns unitstate
constant native ConvertAIDifficulty         takes integer i returns aidifficulty
constant native ConvertGameEvent            takes integer i returns gameevent
constant native ConvertPlayerEvent          takes integer i returns playerevent
constant native ConvertPlayerUnitEvent      takes integer i returns playerunitevent
constant native ConvertWidgetEvent          takes integer i returns widgetevent
constant native ConvertDialogEvent          takes integer i returns dialogevent
constant native ConvertUnitEvent            takes integer i returns unitevent
constant native ConvertLimitOp              takes integer i returns limitop
constant native ConvertUnitType             takes integer i returns unittype
constant native ConvertGameSpeed            takes integer i returns gamespeed
constant native ConvertPlacement            takes integer i returns placement
constant native ConvertStartLocPrio         takes integer i returns startlocprio
constant native ConvertGameDifficulty       takes integer i returns gamedifficulty
constant native ConvertGameType             takes integer i returns gametype
constant native ConvertMapFlag              takes integer i returns mapflag
constant native ConvertMapVisibility        takes integer i returns mapvisibility
constant native ConvertMapSetting           takes integer i returns mapsetting
constant native ConvertMapDensity           takes integer i returns mapdensity
constant native ConvertMapControl           takes integer i returns mapcontrol
constant native ConvertPlayerColor          takes integer i returns playercolor
constant native ConvertPlayerSlotState      takes integer i returns playerslotstate
constant native ConvertVolumeGroup          takes integer i returns volumegroup
constant native ConvertCameraField          takes integer i returns camerafield
constant native ConvertBlendMode            takes integer i returns blendmode
constant native ConvertRarityControl        takes integer i returns raritycontrol
constant native ConvertTexMapFlags          takes integer i returns texmapflags
constant native ConvertFogState             takes integer i returns fogstate
constant native ConvertEffectType           takes integer i returns effecttype
constant native ConvertVersion              takes integer i returns version
constant native ConvertItemType             takes integer i returns itemtype
constant native ConvertAttackType           takes integer i returns attacktype
constant native ConvertDamageType           takes integer i returns damagetype
constant native ConvertWeaponType           takes integer i returns weapontype
constant native ConvertSoundType            takes integer i returns soundtype
constant native ConvertPathingType          takes integer i returns pathingtype
constant native ConvertMouseButtonType      takes integer i returns mousebuttontype
constant native ConvertAnimType             takes integer i returns animtype
constant native ConvertSubAnimType          takes integer i returns subanimtype
constant native ConvertOriginFrameType      takes integer i returns originframetype
constant native ConvertFramePointType       takes integer i returns framepointtype
constant native ConvertTextAlignType        takes integer i returns textaligntype
constant native ConvertFrameEventType       takes integer i returns frameeventtype
constant native ConvertOsKeyType            takes integer i returns oskeytype
constant native ConvertAbilityIntegerField              takes integer i returns abilityintegerfield
constant native ConvertAbilityRealField                 takes integer i returns abilityrealfield
constant native ConvertAbilityBooleanField              takes integer i returns abilitybooleanfield
constant native ConvertAbilityStringField               takes integer i returns abilitystringfield
constant native ConvertAbilityIntegerLevelField         takes integer i returns abilityintegerlevelfield
constant native ConvertAbilityRealLevelField            takes integer i returns abilityreallevelfield
constant native ConvertAbilityBooleanLevelField         takes integer i returns abilitybooleanlevelfield
constant native ConvertAbilityStringLevelField          takes integer i returns abilitystringlevelfield
constant native ConvertAbilityIntegerLevelArrayField    takes integer i returns abilityintegerlevelarrayfield
constant native ConvertAbilityRealLevelArrayField       takes integer i returns abilityreallevelarrayfield
constant native ConvertAbilityBooleanLevelArrayField    takes integer i returns abilitybooleanlevelarrayfield
constant native ConvertAbilityStringLevelArrayField     takes integer i returns abilitystringlevelarrayfield
constant native ConvertUnitIntegerField                 takes integer i returns unitintegerfield
constant native ConvertUnitRealField                    takes integer i returns unitrealfield
constant native ConvertUnitBooleanField                 takes integer i returns unitbooleanfield
constant native ConvertUnitStringField                  takes integer i returns unitstringfield
constant native ConvertUnitWeaponIntegerField           takes integer i returns unitweaponintegerfield
constant native ConvertUnitWeaponRealField              takes integer i returns unitweaponrealfield
constant native ConvertUnitWeaponBooleanField           takes integer i returns unitweaponbooleanfield
constant native ConvertUnitWeaponStringField            takes integer i returns unitweaponstringfield
constant native ConvertItemIntegerField                 takes integer i returns itemintegerfield
constant native ConvertItemRealField                    takes integer i returns itemrealfield
constant native ConvertItemBooleanField                 takes integer i returns itembooleanfield
constant native ConvertItemStringField                  takes integer i returns itemstringfield
constant native ConvertMoveType                         takes integer i returns movetype
constant native ConvertTargetFlag                       takes integer i returns targetflag
constant native ConvertArmorType                        takes integer i returns armortype
constant native ConvertHeroAttribute                    takes integer i returns heroattribute
constant native ConvertDefenseType                      takes integer i returns defensetype
constant native ConvertRegenType                        takes integer i returns regentype
constant native ConvertUnitCategory                     takes integer i returns unitcategory
constant native ConvertPathingFlag                      takes integer i returns pathingflag

constant native OrderId                     takes string  orderIdString     returns integer
constant native OrderId2String              takes integer orderId           returns string
constant native UnitId                      takes string  unitIdString      returns integer
constant native UnitId2String               takes integer unitId            returns string

// Not currently working correctly...
constant native AbilityId                   takes string  abilityIdString   returns integer
constant native AbilityId2String            takes integer abilityId         returns string

// Looks up the "name" field for any object (unit, item, ability)
constant native GetObjectName               takes integer objectId          returns string

constant native GetBJMaxPlayers             takes nothing returns integer
constant native GetBJPlayerNeutralVictim    takes nothing returns integer
constant native GetBJPlayerNeutralExtra     takes nothing returns integer
constant native GetBJMaxPlayerSlots         takes nothing returns integer
constant native GetPlayerNeutralPassive     takes nothing returns integer
constant native GetPlayerNeutralAggressive  takes nothing returns integer

globals

//===================================================
// Game Constants
//===================================================

    // pfff
    constant boolean            FALSE                           = false
    constant boolean            TRUE                            = true
    constant integer            JASS_MAX_ARRAY_SIZE             = 32768

    constant integer            PLAYER_NEUTRAL_PASSIVE          = GetPlayerNeutralPassive()
    constant integer            PLAYER_NEUTRAL_AGGRESSIVE       = GetPlayerNeutralAggressive()

    constant playercolor        PLAYER_COLOR_RED                = ConvertPlayerColor(0)
    constant playercolor        PLAYER_COLOR_BLUE               = ConvertPlayerColor(1)
    constant playercolor        PLAYER_COLOR_CYAN               = ConvertPlayerColor(2)
    constant playercolor        PLAYER_COLOR_PURPLE             = ConvertPlayerColor(3)
    constant playercolor        PLAYER_COLOR_YELLOW             = ConvertPlayerColor(4)
    constant playercolor        PLAYER_COLOR_ORANGE             = ConvertPlayerColor(5)
    constant playercolor        PLAYER_COLOR_GREEN              = ConvertPlayerColor(6)
    constant playercolor        PLAYER_COLOR_PINK               = ConvertPlayerColor(7)
    constant playercolor        PLAYER_COLOR_LIGHT_GRAY         = ConvertPlayerColor(8)
    constant playercolor        PLAYER_COLOR_LIGHT_BLUE         = ConvertPlayerColor(9)
    constant playercolor        PLAYER_COLOR_AQUA               = ConvertPlayerColor(10)
    constant playercolor        PLAYER_COLOR_BROWN              = ConvertPlayerColor(11)
    constant playercolor        PLAYER_COLOR_MAROON             = ConvertPlayerColor(12)
    constant playercolor        PLAYER_COLOR_NAVY               = ConvertPlayerColor(13)
    constant playercolor        PLAYER_COLOR_TURQUOISE          = ConvertPlayerColor(14)
    constant playercolor        PLAYER_COLOR_VIOLET             = ConvertPlayerColor(15)
    constant playercolor        PLAYER_COLOR_WHEAT              = ConvertPlayerColor(16)
    constant playercolor        PLAYER_COLOR_PEACH              = ConvertPlayerColor(17)
    constant playercolor        PLAYER_COLOR_MINT               = ConvertPlayerColor(18)
    constant playercolor        PLAYER_COLOR_LAVENDER           = ConvertPlayerColor(19)
    constant playercolor        PLAYER_COLOR_COAL               = ConvertPlayerColor(20)
    constant playercolor        PLAYER_COLOR_SNOW               = ConvertPlayerColor(21)
    constant playercolor        PLAYER_COLOR_EMERALD            = ConvertPlayerColor(22)
    constant playercolor        PLAYER_COLOR_PEANUT             = ConvertPlayerColor(23)

    constant race               RACE_HUMAN                      = ConvertRace(1)
    constant race               RACE_ORC                        = ConvertRace(2)
    constant race               RACE_UNDEAD                     = ConvertRace(3)
    constant race               RACE_NIGHTELF                   = ConvertRace(4)
    constant race               RACE_DEMON                      = ConvertRace(5)
    constant race               RACE_OTHER                      = ConvertRace(7)

    constant playergameresult   PLAYER_GAME_RESULT_VICTORY      = ConvertPlayerGameResult(0)
    constant playergameresult   PLAYER_GAME_RESULT_DEFEAT       = ConvertPlayerGameResult(1)
    constant playergameresult   PLAYER_GAME_RESULT_TIE          = ConvertPlayerGameResult(2)
    constant playergameresult   PLAYER_GAME_RESULT_NEUTRAL      = ConvertPlayerGameResult(3)

    constant alliancetype       ALLIANCE_PASSIVE                = ConvertAllianceType(0)
    constant alliancetype       ALLIANCE_HELP_REQUEST           = ConvertAllianceType(1)
    constant alliancetype       ALLIANCE_HELP_RESPONSE          = ConvertAllianceType(2)
    constant alliancetype       ALLIANCE_SHARED_XP              = ConvertAllianceType(3)
    constant alliancetype       ALLIANCE_SHARED_SPELLS          = ConvertAllianceType(4)
    constant alliancetype       ALLIANCE_SHARED_VISION          = ConvertAllianceType(5)
    constant alliancetype       ALLIANCE_SHARED_CONTROL         = ConvertAllianceType(6)
    constant alliancetype       ALLIANCE_SHARED_ADVANCED_CONTROL= ConvertAllianceType(7)
    constant alliancetype       ALLIANCE_RESCUABLE              = ConvertAllianceType(8)
    constant alliancetype       ALLIANCE_SHARED_VISION_FORCED   = ConvertAllianceType(9)

    constant version            VERSION_REIGN_OF_CHAOS          = ConvertVersion(0)
    constant version            VERSION_FROZEN_THRONE           = ConvertVersion(1)

    constant attacktype         ATTACK_TYPE_NORMAL              = ConvertAttackType(0)
    constant attacktype         ATTACK_TYPE_MELEE               = ConvertAttackType(1)
    constant attacktype         ATTACK_TYPE_PIERCE              = ConvertAttackType(2)
    constant attacktype         ATTACK_TYPE_SIEGE               = ConvertAttackType(3)
    constant attacktype         ATTACK_TYPE_MAGIC               = ConvertAttackType(4)
    constant attacktype         ATTACK_TYPE_CHAOS               = ConvertAttackType(5)
    constant attacktype         ATTACK_TYPE_HERO                = ConvertAttackType(6)

    constant damagetype         DAMAGE_TYPE_UNKNOWN             = ConvertDamageType(0)
    constant damagetype         DAMAGE_TYPE_NORMAL              = ConvertDamageType(4)
    constant damagetype         DAMAGE_TYPE_ENHANCED            = ConvertDamageType(5)
    constant damagetype         DAMAGE_TYPE_FIRE                = ConvertDamageType(8)
    constant damagetype         DAMAGE_TYPE_COLD                = ConvertDamageType(9)
    constant damagetype         DAMAGE_TYPE_LIGHTNING           = ConvertDamageType(10)
    constant damagetype         DAMAGE_TYPE_POISON              = ConvertDamageType(11)
    constant damagetype         DAMAGE_TYPE_DISEASE             = ConvertDamageType(12)
    constant damagetype         DAMAGE_TYPE_DIVINE              = ConvertDamageType(13)
    constant damagetype         DAMAGE_TYPE_MAGIC               = ConvertDamageType(14)
    constant damagetype         DAMAGE_TYPE_SONIC               = ConvertDamageType(15)
    constant damagetype         DAMAGE_TYPE_ACID                = ConvertDamageType(16)
    constant damagetype         DAMAGE_TYPE_FORCE               = ConvertDamageType(17)
    constant damagetype         DAMAGE_TYPE_DEATH               = ConvertDamageType(18)
    constant damagetype         DAMAGE_TYPE_MIND                = ConvertDamageType(19)
    constant damagetype         DAMAGE_TYPE_PLANT               = ConvertDamageType(20)
    constant damagetype         DAMAGE_TYPE_DEFENSIVE           = ConvertDamageType(21)
    constant damagetype         DAMAGE_TYPE_DEMOLITION          = ConvertDamageType(22)
    constant damagetype         DAMAGE_TYPE_SLOW_POISON         = ConvertDamageType(23)
    constant damagetype         DAMAGE_TYPE_SPIRIT_LINK         = ConvertDamageType(24)
    constant damagetype         DAMAGE_TYPE_SHADOW_STRIKE       = ConvertDamageType(25)
    constant damagetype         DAMAGE_TYPE_UNIVERSAL           = ConvertDamageType(26)

    constant weapontype         WEAPON_TYPE_WHOKNOWS            = ConvertWeaponType(0)
    constant weapontype         WEAPON_TYPE_METAL_LIGHT_CHOP    = ConvertWeaponType(1)
    constant weapontype         WEAPON_TYPE_METAL_MEDIUM_CHOP   = ConvertWeaponType(2)
    constant weapontype         WEAPON_TYPE_METAL_HEAVY_CHOP    = ConvertWeaponType(3)
    constant weapontype         WEAPON_TYPE_METAL_LIGHT_SLICE   = ConvertWeaponType(4)
    constant weapontype         WEAPON_TYPE_METAL_MEDIUM_SLICE  = ConvertWeaponType(5)
    constant weapontype         WEAPON_TYPE_METAL_HEAVY_SLICE   = ConvertWeaponType(6)
    constant weapontype         WEAPON_TYPE_METAL_MEDIUM_BASH   = ConvertWeaponType(7)
    constant weapontype         WEAPON_TYPE_METAL_HEAVY_BASH    = ConvertWeaponType(8)
    constant weapontype         WEAPON_TYPE_METAL_MEDIUM_STAB   = ConvertWeaponType(9)
    constant weapontype         WEAPON_TYPE_METAL_HEAVY_STAB    = ConvertWeaponType(10)
    constant weapontype         WEAPON_TYPE_WOOD_LIGHT_SLICE    = ConvertWeaponType(11)
    constant weapontype         WEAPON_TYPE_WOOD_MEDIUM_SLICE   = ConvertWeaponType(12)
    constant weapontype         WEAPON_TYPE_WOOD_HEAVY_SLICE    = ConvertWeaponType(13)
    constant weapontype         WEAPON_TYPE_WOOD_LIGHT_BASH     = ConvertWeaponType(14)
    constant weapontype         WEAPON_TYPE_WOOD_MEDIUM_BASH    = ConvertWeaponType(15)
    constant weapontype         WEAPON_TYPE_WOOD_HEAVY_BASH     = ConvertWeaponType(16)
    constant weapontype         WEAPON_TYPE_WOOD_LIGHT_STAB     = ConvertWeaponType(17)
    constant weapontype         WEAPON_TYPE_WOOD_MEDIUM_STAB    = ConvertWeaponType(18)
    constant weapontype         WEAPON_TYPE_CLAW_LIGHT_SLICE    = ConvertWeaponType(19)
    constant weapontype         WEAPON_TYPE_CLAW_MEDIUM_SLICE   = ConvertWeaponType(20)
    constant weapontype         WEAPON_TYPE_CLAW_HEAVY_SLICE    = ConvertWeaponType(21)
    constant weapontype         WEAPON_TYPE_AXE_MEDIUM_CHOP     = ConvertWeaponType(22)
    constant weapontype         WEAPON_TYPE_ROCK_HEAVY_BASH     = ConvertWeaponType(23)

    constant pathingtype        PATHING_TYPE_ANY                = ConvertPathingType(0)
    constant pathingtype        PATHING_TYPE_WALKABILITY        = ConvertPathingType(1)
    constant pathingtype        PATHING_TYPE_FLYABILITY         = ConvertPathingType(2)
    constant pathingtype        PATHING_TYPE_BUILDABILITY       = ConvertPathingType(3)
    constant pathingtype        PATHING_TYPE_PEONHARVESTPATHING = ConvertPathingType(4)
    constant pathingtype        PATHING_TYPE_BLIGHTPATHING      = ConvertPathingType(5)
    constant pathingtype        PATHING_TYPE_FLOATABILITY       = ConvertPathingType(6)
    constant pathingtype        PATHING_TYPE_AMPHIBIOUSPATHING  = ConvertPathingType(7)

    constant mousebuttontype    MOUSE_BUTTON_TYPE_LEFT          = ConvertMouseButtonType(1)
    constant mousebuttontype    MOUSE_BUTTON_TYPE_MIDDLE        = ConvertMouseButtonType(2)
    constant mousebuttontype    MOUSE_BUTTON_TYPE_RIGHT         = ConvertMouseButtonType(3)

    constant animtype           ANIM_TYPE_BIRTH                 = ConvertAnimType(0)
    constant animtype           ANIM_TYPE_DEATH                 = ConvertAnimType(1)
    constant animtype           ANIM_TYPE_DECAY                 = ConvertAnimType(2)
    constant animtype           ANIM_TYPE_DISSIPATE             = ConvertAnimType(3)
    constant animtype           ANIM_TYPE_STAND                 = ConvertAnimType(4)
    constant animtype           ANIM_TYPE_WALK                  = ConvertAnimType(5)
    constant animtype           ANIM_TYPE_ATTACK                = ConvertAnimType(6)
    constant animtype           ANIM_TYPE_MORPH                 = ConvertAnimType(7)
    constant animtype           ANIM_TYPE_SLEEP                 = ConvertAnimType(8)
    constant animtype           ANIM_TYPE_SPELL                 = ConvertAnimType(9)
    constant animtype           ANIM_TYPE_PORTRAIT              = ConvertAnimType(10)

    constant subanimtype        SUBANIM_TYPE_ROOTED             = ConvertSubAnimType(11)
    constant subanimtype        SUBANIM_TYPE_ALTERNATE_EX       = ConvertSubAnimType(12)
    constant subanimtype        SUBANIM_TYPE_LOOPING            = ConvertSubAnimType(13)
    constant subanimtype        SUBANIM_TYPE_SLAM               = ConvertSubAnimType(14)
    constant subanimtype        SUBANIM_TYPE_THROW              = ConvertSubAnimType(15)
    constant subanimtype        SUBANIM_TYPE_SPIKED             = ConvertSubAnimType(16)
    constant subanimtype        SUBANIM_TYPE_FAST               = ConvertSubAnimType(17)
    constant subanimtype        SUBANIM_TYPE_SPIN               = ConvertSubAnimType(18)
    constant subanimtype        SUBANIM_TYPE_READY              = ConvertSubAnimType(19)
    constant subanimtype        SUBANIM_TYPE_CHANNEL            = ConvertSubAnimType(20)
    constant subanimtype        SUBANIM_TYPE_DEFEND             = ConvertSubAnimType(21)
    constant subanimtype        SUBANIM_TYPE_VICTORY            = ConvertSubAnimType(22)
    constant subanimtype        SUBANIM_TYPE_TURN               = ConvertSubAnimType(23)
    constant subanimtype        SUBANIM_TYPE_LEFT               = ConvertSubAnimType(24)
    constant subanimtype        SUBANIM_TYPE_RIGHT              = ConvertSubAnimType(25)
    constant subanimtype        SUBANIM_TYPE_FIRE               = ConvertSubAnimType(26)
    constant subanimtype        SUBANIM_TYPE_FLESH              = ConvertSubAnimType(27)
    constant subanimtype        SUBANIM_TYPE_HIT                = ConvertSubAnimType(28)
    constant subanimtype        SUBANIM_TYPE_WOUNDED            = ConvertSubAnimType(29)
    constant subanimtype        SUBANIM_TYPE_LIGHT              = ConvertSubAnimType(30)
    constant subanimtype        SUBANIM_TYPE_MODERATE           = ConvertSubAnimType(31)
    constant subanimtype        SUBANIM_TYPE_SEVERE             = ConvertSubAnimType(32)
    constant subanimtype        SUBANIM_TYPE_CRITICAL           = ConvertSubAnimType(33)
    constant subanimtype        SUBANIM_TYPE_COMPLETE           = ConvertSubAnimType(34)
    constant subanimtype        SUBANIM_TYPE_GOLD               = ConvertSubAnimType(35)
    constant subanimtype        SUBANIM_TYPE_LUMBER             = ConvertSubAnimType(36)
    constant subanimtype        SUBANIM_TYPE_WORK               = ConvertSubAnimType(37)
    constant subanimtype        SUBANIM_TYPE_TALK               = ConvertSubAnimType(38)
    constant subanimtype        SUBANIM_TYPE_FIRST              = ConvertSubAnimType(39)
    constant subanimtype        SUBANIM_TYPE_SECOND             = ConvertSubAnimType(40)
    constant subanimtype        SUBANIM_TYPE_THIRD              = ConvertSubAnimType(41)
    constant subanimtype        SUBANIM_TYPE_FOURTH             = ConvertSubAnimType(42)
    constant subanimtype        SUBANIM_TYPE_FIFTH              = ConvertSubAnimType(43)
    constant subanimtype        SUBANIM_TYPE_ONE                = ConvertSubAnimType(44)
    constant subanimtype        SUBANIM_TYPE_TWO                = ConvertSubAnimType(45)
    constant subanimtype        SUBANIM_TYPE_THREE              = ConvertSubAnimType(46)
    constant subanimtype        SUBANIM_TYPE_FOUR               = ConvertSubAnimType(47)
    constant subanimtype        SUBANIM_TYPE_FIVE               = ConvertSubAnimType(48)
    constant subanimtype        SUBANIM_TYPE_SMALL              = ConvertSubAnimType(49)
    constant subanimtype        SUBANIM_TYPE_MEDIUM             = ConvertSubAnimType(50)
    constant subanimtype        SUBANIM_TYPE_LARGE              = ConvertSubAnimType(51)
    constant subanimtype        SUBANIM_TYPE_UPGRADE            = ConvertSubAnimType(52)
    constant subanimtype        SUBANIM_TYPE_DRAIN              = ConvertSubAnimType(53)
    constant subanimtype        SUBANIM_TYPE_FILL               = ConvertSubAnimType(54)
    constant subanimtype        SUBANIM_TYPE_CHAINLIGHTNING     = ConvertSubAnimType(55)
    constant subanimtype        SUBANIM_TYPE_EATTREE            = ConvertSubAnimType(56)
    constant subanimtype        SUBANIM_TYPE_PUKE               = ConvertSubAnimType(57)
    constant subanimtype        SUBANIM_TYPE_FLAIL              = ConvertSubAnimType(58)
    constant subanimtype        SUBANIM_TYPE_OFF                = ConvertSubAnimType(59)
    constant subanimtype        SUBANIM_TYPE_SWIM               = ConvertSubAnimType(60)
    constant subanimtype        SUBANIM_TYPE_ENTANGLE           = ConvertSubAnimType(61)
    constant subanimtype        SUBANIM_TYPE_BERSERK            = ConvertSubAnimType(62)

//===================================================
// Map Setup Constants
//===================================================

    constant racepreference     RACE_PREF_HUMAN                     = ConvertRacePref(1)
    constant racepreference     RACE_PREF_ORC                       = ConvertRacePref(2)
    constant racepreference     RACE_PREF_NIGHTELF                  = ConvertRacePref(4)
    constant racepreference     RACE_PREF_UNDEAD                    = ConvertRacePref(8)
    constant racepreference     RACE_PREF_DEMON                     = ConvertRacePref(16)
    constant racepreference     RACE_PREF_RANDOM                    = ConvertRacePref(32)
    constant racepreference     RACE_PREF_USER_SELECTABLE           = ConvertRacePref(64)

    constant mapcontrol         MAP_CONTROL_USER                    = ConvertMapControl(0)
    constant mapcontrol         MAP_CONTROL_COMPUTER                = ConvertMapControl(1)
    constant mapcontrol         MAP_CONTROL_RESCUABLE               = ConvertMapControl(2)
    constant mapcontrol         MAP_CONTROL_NEUTRAL                 = ConvertMapControl(3)
    constant mapcontrol         MAP_CONTROL_CREEP                   = ConvertMapControl(4)
    constant mapcontrol         MAP_CONTROL_NONE                    = ConvertMapControl(5)

    constant gametype           GAME_TYPE_MELEE                     = ConvertGameType(1)
    constant gametype           GAME_TYPE_FFA                       = ConvertGameType(2)
    constant gametype           GAME_TYPE_USE_MAP_SETTINGS          = ConvertGameType(4)
    constant gametype           GAME_TYPE_BLIZ                      = ConvertGameType(8)
    constant gametype           GAME_TYPE_ONE_ON_ONE                = ConvertGameType(16)
    constant gametype           GAME_TYPE_TWO_TEAM_PLAY             = ConvertGameType(32)
    constant gametype           GAME_TYPE_THREE_TEAM_PLAY           = ConvertGameType(64)
    constant gametype           GAME_TYPE_FOUR_TEAM_PLAY            = ConvertGameType(128)

    constant mapflag            MAP_FOG_HIDE_TERRAIN                = ConvertMapFlag(1)
    constant mapflag            MAP_FOG_MAP_EXPLORED                = ConvertMapFlag(2)
    constant mapflag            MAP_FOG_ALWAYS_VISIBLE              = ConvertMapFlag(4)

    constant mapflag            MAP_USE_HANDICAPS                   = ConvertMapFlag(8)
    constant mapflag            MAP_OBSERVERS                       = ConvertMapFlag(16)
    constant mapflag            MAP_OBSERVERS_ON_DEATH              = ConvertMapFlag(32)

    constant mapflag            MAP_FIXED_COLORS                    = ConvertMapFlag(128)

    constant mapflag            MAP_LOCK_RESOURCE_TRADING           = ConvertMapFlag(256)
    constant mapflag            MAP_RESOURCE_TRADING_ALLIES_ONLY    = ConvertMapFlag(512)

    constant mapflag            MAP_LOCK_ALLIANCE_CHANGES           = ConvertMapFlag(1024)
    constant mapflag            MAP_ALLIANCE_CHANGES_HIDDEN         = ConvertMapFlag(2048)

    constant mapflag            MAP_CHEATS                          = ConvertMapFlag(4096)
    constant mapflag            MAP_CHEATS_HIDDEN                   = ConvertMapFlag(8192)

    constant mapflag            MAP_LOCK_SPEED                      = ConvertMapFlag(8192*2)
    constant mapflag            MAP_LOCK_RANDOM_SEED                = ConvertMapFlag(8192*4)
    constant mapflag            MAP_SHARED_ADVANCED_CONTROL         = ConvertMapFlag(8192*8)
    constant mapflag            MAP_RANDOM_HERO                     = ConvertMapFlag(8192*16)
    constant mapflag            MAP_RANDOM_RACES                    = ConvertMapFlag(8192*32)
    constant mapflag            MAP_RELOADED                        = ConvertMapFlag(8192*64)

    constant placement          MAP_PLACEMENT_RANDOM                = ConvertPlacement(0)   // random among all slots
    constant placement          MAP_PLACEMENT_FIXED                 = ConvertPlacement(1)   // player 0 in start loc 0...
    constant placement          MAP_PLACEMENT_USE_MAP_SETTINGS      = ConvertPlacement(2)   // whatever was specified by the script
    constant placement          MAP_PLACEMENT_TEAMS_TOGETHER        = ConvertPlacement(3)   // random with allies next to each other

    constant startlocprio       MAP_LOC_PRIO_LOW                    = ConvertStartLocPrio(0)
    constant startlocprio       MAP_LOC_PRIO_HIGH                   = ConvertStartLocPrio(1)
    constant startlocprio       MAP_LOC_PRIO_NOT                    = ConvertStartLocPrio(2)

    constant mapdensity         MAP_DENSITY_NONE                    = ConvertMapDensity(0)
    constant mapdensity         MAP_DENSITY_LIGHT                   = ConvertMapDensity(1)
    constant mapdensity         MAP_DENSITY_MEDIUM                  = ConvertMapDensity(2)
    constant mapdensity         MAP_DENSITY_HEAVY                   = ConvertMapDensity(3)

    constant gamedifficulty     MAP_DIFFICULTY_EASY                 = ConvertGameDifficulty(0)
    constant gamedifficulty     MAP_DIFFICULTY_NORMAL               = ConvertGameDifficulty(1)
    constant gamedifficulty     MAP_DIFFICULTY_HARD                 = ConvertGameDifficulty(2)
    constant gamedifficulty     MAP_DIFFICULTY_INSANE               = ConvertGameDifficulty(3)

    constant gamespeed          MAP_SPEED_SLOWEST                   = ConvertGameSpeed(0)
    constant gamespeed          MAP_SPEED_SLOW                      = ConvertGameSpeed(1)
    constant gamespeed          MAP_SPEED_NORMAL                    = ConvertGameSpeed(2)
    constant gamespeed          MAP_SPEED_FAST                      = ConvertGameSpeed(3)
    constant gamespeed          MAP_SPEED_FASTEST                   = ConvertGameSpeed(4)

    constant playerslotstate    PLAYER_SLOT_STATE_EMPTY             = ConvertPlayerSlotState(0)
    constant playerslotstate    PLAYER_SLOT_STATE_PLAYING           = ConvertPlayerSlotState(1)
    constant playerslotstate    PLAYER_SLOT_STATE_LEFT              = ConvertPlayerSlotState(2)

//===================================================
// Sound Constants
//===================================================
    constant volumegroup        SOUND_VOLUMEGROUP_UNITMOVEMENT      = ConvertVolumeGroup(0)
    constant volumegroup        SOUND_VOLUMEGROUP_UNITSOUNDS        = ConvertVolumeGroup(1)
    constant volumegroup        SOUND_VOLUMEGROUP_COMBAT            = ConvertVolumeGroup(2)
    constant volumegroup        SOUND_VOLUMEGROUP_SPELLS            = ConvertVolumeGroup(3)
    constant volumegroup        SOUND_VOLUMEGROUP_UI                = ConvertVolumeGroup(4)
    constant volumegroup        SOUND_VOLUMEGROUP_MUSIC             = ConvertVolumeGroup(5)
    constant volumegroup        SOUND_VOLUMEGROUP_AMBIENTSOUNDS     = ConvertVolumeGroup(6)
    constant volumegroup        SOUND_VOLUMEGROUP_FIRE              = ConvertVolumeGroup(7)
//Cinematic Sound Constants
    constant volumegroup        SOUND_VOLUMEGROUP_CINEMATIC_GENERAL         = ConvertVolumeGroup(8)
    constant volumegroup        SOUND_VOLUMEGROUP_CINEMATIC_AMBIENT         = ConvertVolumeGroup(9)
    constant volumegroup        SOUND_VOLUMEGROUP_CINEMATIC_MUSIC           = ConvertVolumeGroup(10)
    constant volumegroup        SOUND_VOLUMEGROUP_CINEMATIC_DIALOGUE        = ConvertVolumeGroup(11)
    constant volumegroup        SOUND_VOLUMEGROUP_CINEMATIC_SOUND_EFFECTS_1 = ConvertVolumeGroup(12)
    constant volumegroup        SOUND_VOLUMEGROUP_CINEMATIC_SOUND_EFFECTS_2 = ConvertVolumeGroup(13)
    constant volumegroup        SOUND_VOLUMEGROUP_CINEMATIC_SOUND_EFFECTS_3 = ConvertVolumeGroup(14)


//===================================================
// Game, Player, and Unit States
//
// For use with TriggerRegister<X>StateEvent
//
//===================================================

    constant igamestate GAME_STATE_DIVINE_INTERVENTION          = ConvertIGameState(0)
    constant igamestate GAME_STATE_DISCONNECTED                 = ConvertIGameState(1)
    constant fgamestate GAME_STATE_TIME_OF_DAY                  = ConvertFGameState(2)

    constant playerstate PLAYER_STATE_GAME_RESULT               = ConvertPlayerState(0)

    // current resource levels
    //
    constant playerstate PLAYER_STATE_RESOURCE_GOLD             = ConvertPlayerState(1)
    constant playerstate PLAYER_STATE_RESOURCE_LUMBER           = ConvertPlayerState(2)
    constant playerstate PLAYER_STATE_RESOURCE_HERO_TOKENS      = ConvertPlayerState(3)
    constant playerstate PLAYER_STATE_RESOURCE_FOOD_CAP         = ConvertPlayerState(4)
    constant playerstate PLAYER_STATE_RESOURCE_FOOD_USED        = ConvertPlayerState(5)
    constant playerstate PLAYER_STATE_FOOD_CAP_CEILING          = ConvertPlayerState(6)

    constant playerstate PLAYER_STATE_GIVES_BOUNTY              = ConvertPlayerState(7)
    constant playerstate PLAYER_STATE_ALLIED_VICTORY            = ConvertPlayerState(8)
    constant playerstate PLAYER_STATE_PLACED                    = ConvertPlayerState(9)
    constant playerstate PLAYER_STATE_OBSERVER_ON_DEATH         = ConvertPlayerState(10)
    constant playerstate PLAYER_STATE_OBSERVER                  = ConvertPlayerState(11)
    constant playerstate PLAYER_STATE_UNFOLLOWABLE              = ConvertPlayerState(12)

    // taxation rate for each resource
    //
    constant playerstate PLAYER_STATE_GOLD_UPKEEP_RATE          = ConvertPlayerState(13)
    constant playerstate PLAYER_STATE_LUMBER_UPKEEP_RATE        = ConvertPlayerState(14)

    // cumulative resources collected by the player during the mission
    //
    constant playerstate PLAYER_STATE_GOLD_GATHERED             = ConvertPlayerState(15)
    constant playerstate PLAYER_STATE_LUMBER_GATHERED           = ConvertPlayerState(16)

    constant playerstate PLAYER_STATE_NO_CREEP_SLEEP            = ConvertPlayerState(25)

    constant unitstate UNIT_STATE_LIFE                          = ConvertUnitState(0)
    constant unitstate UNIT_STATE_MAX_LIFE                      = ConvertUnitState(1)
    constant unitstate UNIT_STATE_MANA                          = ConvertUnitState(2)
    constant unitstate UNIT_STATE_MAX_MANA                      = ConvertUnitState(3)

    constant aidifficulty AI_DIFFICULTY_NEWBIE                  = ConvertAIDifficulty(0)
    constant aidifficulty AI_DIFFICULTY_NORMAL                  = ConvertAIDifficulty(1)
    constant aidifficulty AI_DIFFICULTY_INSANE                  = ConvertAIDifficulty(2)

    // player score values
    constant playerscore PLAYER_SCORE_UNITS_TRAINED             = ConvertPlayerScore(0)
    constant playerscore PLAYER_SCORE_UNITS_KILLED              = ConvertPlayerScore(1)
    constant playerscore PLAYER_SCORE_STRUCT_BUILT              = ConvertPlayerScore(2)
    constant playerscore PLAYER_SCORE_STRUCT_RAZED              = ConvertPlayerScore(3)
    constant playerscore PLAYER_SCORE_TECH_PERCENT              = ConvertPlayerScore(4)
    constant playerscore PLAYER_SCORE_FOOD_MAXPROD              = ConvertPlayerScore(5)
    constant playerscore PLAYER_SCORE_FOOD_MAXUSED              = ConvertPlayerScore(6)
    constant playerscore PLAYER_SCORE_HEROES_KILLED             = ConvertPlayerScore(7)
    constant playerscore PLAYER_SCORE_ITEMS_GAINED              = ConvertPlayerScore(8)
    constant playerscore PLAYER_SCORE_MERCS_HIRED               = ConvertPlayerScore(9)
    constant playerscore PLAYER_SCORE_GOLD_MINED_TOTAL          = ConvertPlayerScore(10)
    constant playerscore PLAYER_SCORE_GOLD_MINED_UPKEEP         = ConvertPlayerScore(11)
    constant playerscore PLAYER_SCORE_GOLD_LOST_UPKEEP          = ConvertPlayerScore(12)
    constant playerscore PLAYER_SCORE_GOLD_LOST_TAX             = ConvertPlayerScore(13)
    constant playerscore PLAYER_SCORE_GOLD_GIVEN                = ConvertPlayerScore(14)
    constant playerscore PLAYER_SCORE_GOLD_RECEIVED             = ConvertPlayerScore(15)
    constant playerscore PLAYER_SCORE_LUMBER_TOTAL              = ConvertPlayerScore(16)
    constant playerscore PLAYER_SCORE_LUMBER_LOST_UPKEEP        = ConvertPlayerScore(17)
    constant playerscore PLAYER_SCORE_LUMBER_LOST_TAX           = ConvertPlayerScore(18)
    constant playerscore PLAYER_SCORE_LUMBER_GIVEN              = ConvertPlayerScore(19)
    constant playerscore PLAYER_SCORE_LUMBER_RECEIVED           = ConvertPlayerScore(20)
    constant playerscore PLAYER_SCORE_UNIT_TOTAL                = ConvertPlayerScore(21)
    constant playerscore PLAYER_SCORE_HERO_TOTAL                = ConvertPlayerScore(22)
    constant playerscore PLAYER_SCORE_RESOURCE_TOTAL            = ConvertPlayerScore(23)
    constant playerscore PLAYER_SCORE_TOTAL                     = ConvertPlayerScore(24)

//===================================================
// Game, Player and Unit Events
//
//  When an event causes a trigger to fire these
//  values allow the action code to determine which
//  event was dispatched and therefore which set of
//  native functions should be used to get information
//  about the event.
//
// Do NOT change the order or value of these constants
// without insuring that the JASS_GAME_EVENTS_WAR3 enum
// is changed to match.
//
//===================================================

    //===================================================
    // For use with TriggerRegisterGameEvent
    //===================================================

    constant gameevent EVENT_GAME_VICTORY                       = ConvertGameEvent(0)
    constant gameevent EVENT_GAME_END_LEVEL                     = ConvertGameEvent(1)

    constant gameevent EVENT_GAME_VARIABLE_LIMIT                = ConvertGameEvent(2)
    constant gameevent EVENT_GAME_STATE_LIMIT                   = ConvertGameEvent(3)

    constant gameevent EVENT_GAME_TIMER_EXPIRED                 = ConvertGameEvent(4)

    constant gameevent EVENT_GAME_ENTER_REGION                  = ConvertGameEvent(5)
    constant gameevent EVENT_GAME_LEAVE_REGION                  = ConvertGameEvent(6)

    constant gameevent EVENT_GAME_TRACKABLE_HIT                 = ConvertGameEvent(7)
    constant gameevent EVENT_GAME_TRACKABLE_TRACK               = ConvertGameEvent(8)

    constant gameevent EVENT_GAME_SHOW_SKILL                    = ConvertGameEvent(9)
    constant gameevent EVENT_GAME_BUILD_SUBMENU                 = ConvertGameEvent(10)

    //===================================================
    // For use with TriggerRegisterPlayerEvent
    //===================================================
    constant playerevent EVENT_PLAYER_STATE_LIMIT               = ConvertPlayerEvent(11)
    constant playerevent EVENT_PLAYER_ALLIANCE_CHANGED          = ConvertPlayerEvent(12)

    constant playerevent EVENT_PLAYER_DEFEAT                    = ConvertPlayerEvent(13)
    constant playerevent EVENT_PLAYER_VICTORY                   = ConvertPlayerEvent(14)
    constant playerevent EVENT_PLAYER_LEAVE                     = ConvertPlayerEvent(15)
    constant playerevent EVENT_PLAYER_CHAT                      = ConvertPlayerEvent(16)
    constant playerevent EVENT_PLAYER_END_CINEMATIC             = ConvertPlayerEvent(17)

    //===================================================
    // For use with TriggerRegisterPlayerUnitEvent
    //===================================================

    constant playerunitevent EVENT_PLAYER_UNIT_ATTACKED                 = ConvertPlayerUnitEvent(18)
    constant playerunitevent EVENT_PLAYER_UNIT_RESCUED                  = ConvertPlayerUnitEvent(19)

    constant playerunitevent EVENT_PLAYER_UNIT_DEATH                    = ConvertPlayerUnitEvent(20)
    constant playerunitevent EVENT_PLAYER_UNIT_DECAY                    = ConvertPlayerUnitEvent(21)

    constant playerunitevent EVENT_PLAYER_UNIT_DETECTED                 = ConvertPlayerUnitEvent(22)
    constant playerunitevent EVENT_PLAYER_UNIT_HIDDEN                   = ConvertPlayerUnitEvent(23)

    constant playerunitevent EVENT_PLAYER_UNIT_SELECTED                 = ConvertPlayerUnitEvent(24)
    constant playerunitevent EVENT_PLAYER_UNIT_DESELECTED               = ConvertPlayerUnitEvent(25)

    constant playerunitevent EVENT_PLAYER_UNIT_CONSTRUCT_START          = ConvertPlayerUnitEvent(26)
    constant playerunitevent EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL         = ConvertPlayerUnitEvent(27)
    constant playerunitevent EVENT_PLAYER_UNIT_CONSTRUCT_FINISH         = ConvertPlayerUnitEvent(28)

    constant playerunitevent EVENT_PLAYER_UNIT_UPGRADE_START            = ConvertPlayerUnitEvent(29)
    constant playerunitevent EVENT_PLAYER_UNIT_UPGRADE_CANCEL           = ConvertPlayerUnitEvent(30)
    constant playerunitevent EVENT_PLAYER_UNIT_UPGRADE_FINISH           = ConvertPlayerUnitEvent(31)

    constant playerunitevent EVENT_PLAYER_UNIT_TRAIN_START              = ConvertPlayerUnitEvent(32)
    constant playerunitevent EVENT_PLAYER_UNIT_TRAIN_CANCEL             = ConvertPlayerUnitEvent(33)
    constant playerunitevent EVENT_PLAYER_UNIT_TRAIN_FINISH             = ConvertPlayerUnitEvent(34)

    constant playerunitevent EVENT_PLAYER_UNIT_RESEARCH_START           = ConvertPlayerUnitEvent(35)
    constant playerunitevent EVENT_PLAYER_UNIT_RESEARCH_CANCEL          = ConvertPlayerUnitEvent(36)
    constant playerunitevent EVENT_PLAYER_UNIT_RESEARCH_FINISH          = ConvertPlayerUnitEvent(37)
    constant playerunitevent EVENT_PLAYER_UNIT_ISSUED_ORDER             = ConvertPlayerUnitEvent(38)
    constant playerunitevent EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER       = ConvertPlayerUnitEvent(39)
    constant playerunitevent EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER      = ConvertPlayerUnitEvent(40)
    constant playerunitevent EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER        = ConvertPlayerUnitEvent(40)    // for compat

    constant playerunitevent EVENT_PLAYER_HERO_LEVEL                    = ConvertPlayerUnitEvent(41)
    constant playerunitevent EVENT_PLAYER_HERO_SKILL                    = ConvertPlayerUnitEvent(42)

    constant playerunitevent EVENT_PLAYER_HERO_REVIVABLE                = ConvertPlayerUnitEvent(43)

    constant playerunitevent EVENT_PLAYER_HERO_REVIVE_START             = ConvertPlayerUnitEvent(44)
    constant playerunitevent EVENT_PLAYER_HERO_REVIVE_CANCEL            = ConvertPlayerUnitEvent(45)
    constant playerunitevent EVENT_PLAYER_HERO_REVIVE_FINISH            = ConvertPlayerUnitEvent(46)
    constant playerunitevent EVENT_PLAYER_UNIT_SUMMON                   = ConvertPlayerUnitEvent(47)
    constant playerunitevent EVENT_PLAYER_UNIT_DROP_ITEM                = ConvertPlayerUnitEvent(48)
    constant playerunitevent EVENT_PLAYER_UNIT_PICKUP_ITEM              = ConvertPlayerUnitEvent(49)
    constant playerunitevent EVENT_PLAYER_UNIT_USE_ITEM                 = ConvertPlayerUnitEvent(50)

    constant playerunitevent EVENT_PLAYER_UNIT_LOADED                   = ConvertPlayerUnitEvent(51)
    constant playerunitevent EVENT_PLAYER_UNIT_DAMAGED                  = ConvertPlayerUnitEvent(308)
    constant playerunitevent EVENT_PLAYER_UNIT_DAMAGING                 = ConvertPlayerUnitEvent(315)

    //===================================================
    // For use with TriggerRegisterUnitEvent
    //===================================================

    constant unitevent EVENT_UNIT_DAMAGED                               = ConvertUnitEvent(52)
    constant unitevent EVENT_UNIT_DAMAGING                              = ConvertUnitEvent(314)
    constant unitevent EVENT_UNIT_DEATH                                 = ConvertUnitEvent(53)
    constant unitevent EVENT_UNIT_DECAY                                 = ConvertUnitEvent(54)
    constant unitevent EVENT_UNIT_DETECTED                              = ConvertUnitEvent(55)
    constant unitevent EVENT_UNIT_HIDDEN                                = ConvertUnitEvent(56)
    constant unitevent EVENT_UNIT_SELECTED                              = ConvertUnitEvent(57)
    constant unitevent EVENT_UNIT_DESELECTED                            = ConvertUnitEvent(58)
                                                                        
    constant unitevent EVENT_UNIT_STATE_LIMIT                           = ConvertUnitEvent(59)                                                                        

    // Events which may have a filter for the "other unit"              
    //                                                                  
    constant unitevent EVENT_UNIT_ACQUIRED_TARGET                       = ConvertUnitEvent(60)
    constant unitevent EVENT_UNIT_TARGET_IN_RANGE                       = ConvertUnitEvent(61)
    constant unitevent EVENT_UNIT_ATTACKED                              = ConvertUnitEvent(62)
    constant unitevent EVENT_UNIT_RESCUED                               = ConvertUnitEvent(63)
                                                                        
    constant unitevent EVENT_UNIT_CONSTRUCT_CANCEL                      = ConvertUnitEvent(64)
    constant unitevent EVENT_UNIT_CONSTRUCT_FINISH                      = ConvertUnitEvent(65)
                                                                        
    constant unitevent EVENT_UNIT_UPGRADE_START                         = ConvertUnitEvent(66)
    constant unitevent EVENT_UNIT_UPGRADE_CANCEL                        = ConvertUnitEvent(67)
    constant unitevent EVENT_UNIT_UPGRADE_FINISH                        = ConvertUnitEvent(68)
                                                                        
    // Events which involve the specified unit performing               
    // training of other units                                          
    //                                                                  
    constant unitevent EVENT_UNIT_TRAIN_START                           = ConvertUnitEvent(69)
    constant unitevent EVENT_UNIT_TRAIN_CANCEL                          = ConvertUnitEvent(70)
    constant unitevent EVENT_UNIT_TRAIN_FINISH                          = ConvertUnitEvent(71)
                                                                        
    constant unitevent EVENT_UNIT_RESEARCH_START                        = ConvertUnitEvent(72)
    constant unitevent EVENT_UNIT_RESEARCH_CANCEL                       = ConvertUnitEvent(73)
    constant unitevent EVENT_UNIT_RESEARCH_FINISH                       = ConvertUnitEvent(74)
                                                                        
    constant unitevent EVENT_UNIT_ISSUED_ORDER                          = ConvertUnitEvent(75)
    constant unitevent EVENT_UNIT_ISSUED_POINT_ORDER                    = ConvertUnitEvent(76)
    constant unitevent EVENT_UNIT_ISSUED_TARGET_ORDER                   = ConvertUnitEvent(77)
                                                                       
    constant unitevent EVENT_UNIT_HERO_LEVEL                            = ConvertUnitEvent(78)
    constant unitevent EVENT_UNIT_HERO_SKILL                            = ConvertUnitEvent(79)
                                                                        
    constant unitevent EVENT_UNIT_HERO_REVIVABLE                        = ConvertUnitEvent(80)
    constant unitevent EVENT_UNIT_HERO_REVIVE_START                     = ConvertUnitEvent(81)
    constant unitevent EVENT_UNIT_HERO_REVIVE_CANCEL                    = ConvertUnitEvent(82)
    constant unitevent EVENT_UNIT_HERO_REVIVE_FINISH                    = ConvertUnitEvent(83)
                                                                        
    constant unitevent EVENT_UNIT_SUMMON                                = ConvertUnitEvent(84)
                                                                        
    constant unitevent EVENT_UNIT_DROP_ITEM                             = ConvertUnitEvent(85)
    constant unitevent EVENT_UNIT_PICKUP_ITEM                           = ConvertUnitEvent(86)
    constant unitevent EVENT_UNIT_USE_ITEM                              = ConvertUnitEvent(87)

    constant unitevent EVENT_UNIT_LOADED                                = ConvertUnitEvent(88)

    constant widgetevent EVENT_WIDGET_DEATH                             = ConvertWidgetEvent(89)

    constant dialogevent EVENT_DIALOG_BUTTON_CLICK                      = ConvertDialogEvent(90)
    constant dialogevent EVENT_DIALOG_CLICK                             = ConvertDialogEvent(91)

    //===================================================
    // Frozen Throne Expansion Events
    // Need to be added here to preserve compat
    //===================================================
   
    //===================================================    
    // For use with TriggerRegisterGameEvent
    //===================================================

    constant gameevent          EVENT_GAME_LOADED                       = ConvertGameEvent(256)
    constant gameevent          EVENT_GAME_TOURNAMENT_FINISH_SOON       = ConvertGameEvent(257)
    constant gameevent          EVENT_GAME_TOURNAMENT_FINISH_NOW        = ConvertGameEvent(258)
    constant gameevent          EVENT_GAME_SAVE                         = ConvertGameEvent(259)
    constant gameevent          EVENT_GAME_CUSTOM_UI_FRAME              = ConvertGameEvent(310)

    //===================================================
    // For use with TriggerRegisterPlayerEvent
    //===================================================

    constant playerevent        EVENT_PLAYER_ARROW_LEFT_DOWN            = ConvertPlayerEvent(261)
    constant playerevent        EVENT_PLAYER_ARROW_LEFT_UP              = ConvertPlayerEvent(262)
    constant playerevent        EVENT_PLAYER_ARROW_RIGHT_DOWN           = ConvertPlayerEvent(263)
    constant playerevent        EVENT_PLAYER_ARROW_RIGHT_UP             = ConvertPlayerEvent(264)
    constant playerevent        EVENT_PLAYER_ARROW_DOWN_DOWN            = ConvertPlayerEvent(265)
    constant playerevent        EVENT_PLAYER_ARROW_DOWN_UP              = ConvertPlayerEvent(266)
    constant playerevent        EVENT_PLAYER_ARROW_UP_DOWN              = ConvertPlayerEvent(267)
    constant playerevent        EVENT_PLAYER_ARROW_UP_UP                = ConvertPlayerEvent(268)
    constant playerevent        EVENT_PLAYER_MOUSE_DOWN                 = ConvertPlayerEvent(305)
    constant playerevent        EVENT_PLAYER_MOUSE_UP                   = ConvertPlayerEvent(306)
    constant playerevent        EVENT_PLAYER_MOUSE_MOVE                 = ConvertPlayerEvent(307)
    constant playerevent        EVENT_PLAYER_SYNC_DATA                  = ConvertPlayerEvent(309)
    constant playerevent        EVENT_PLAYER_KEY                        = ConvertPlayerEvent(311)
    constant playerevent        EVENT_PLAYER_KEY_DOWN                   = ConvertPlayerEvent(312)
    constant playerevent        EVENT_PLAYER_KEY_UP                     = ConvertPlayerEvent(313)

    //===================================================
    // For use with TriggerRegisterPlayerUnitEvent
    //===================================================

    constant playerunitevent    EVENT_PLAYER_UNIT_SELL                  = ConvertPlayerUnitEvent(269)
    constant playerunitevent    EVENT_PLAYER_UNIT_CHANGE_OWNER          = ConvertPlayerUnitEvent(270)
    constant playerunitevent    EVENT_PLAYER_UNIT_SELL_ITEM             = ConvertPlayerUnitEvent(271)
    constant playerunitevent    EVENT_PLAYER_UNIT_SPELL_CHANNEL         = ConvertPlayerUnitEvent(272)
    constant playerunitevent    EVENT_PLAYER_UNIT_SPELL_CAST            = ConvertPlayerUnitEvent(273)
    constant playerunitevent    EVENT_PLAYER_UNIT_SPELL_EFFECT          = ConvertPlayerUnitEvent(274)
    constant playerunitevent    EVENT_PLAYER_UNIT_SPELL_FINISH          = ConvertPlayerUnitEvent(275)
    constant playerunitevent    EVENT_PLAYER_UNIT_SPELL_ENDCAST         = ConvertPlayerUnitEvent(276)
    constant playerunitevent    EVENT_PLAYER_UNIT_PAWN_ITEM             = ConvertPlayerUnitEvent(277)
    constant playerunitevent    EVENT_PLAYER_UNIT_STACK_ITEM            = ConvertPlayerUnitEvent(319)

    //===================================================
    // For use with TriggerRegisterUnitEvent
    //===================================================

    constant unitevent          EVENT_UNIT_SELL                         = ConvertUnitEvent(286)
    constant unitevent          EVENT_UNIT_CHANGE_OWNER                 = ConvertUnitEvent(287)
    constant unitevent          EVENT_UNIT_SELL_ITEM                    = ConvertUnitEvent(288)
    constant unitevent          EVENT_UNIT_SPELL_CHANNEL                = ConvertUnitEvent(289)
    constant unitevent          EVENT_UNIT_SPELL_CAST                   = ConvertUnitEvent(290)
    constant unitevent          EVENT_UNIT_SPELL_EFFECT                 = ConvertUnitEvent(291)
    constant unitevent          EVENT_UNIT_SPELL_FINISH                 = ConvertUnitEvent(292)
    constant unitevent          EVENT_UNIT_SPELL_ENDCAST                = ConvertUnitEvent(293)
    constant unitevent          EVENT_UNIT_PAWN_ITEM                    = ConvertUnitEvent(294)
    constant unitevent          EVENT_UNIT_STACK_ITEM                   = ConvertUnitEvent(318)

    //===================================================
    // Limit Event API constants
    // variable, player state, game state, and unit state events
    // ( do NOT change the order of these... )
    //===================================================
    constant limitop LESS_THAN                              = ConvertLimitOp(0)
    constant limitop LESS_THAN_OR_EQUAL                     = ConvertLimitOp(1)
    constant limitop EQUAL                                  = ConvertLimitOp(2)
    constant limitop GREATER_THAN_OR_EQUAL                  = ConvertLimitOp(3)
    constant limitop GREATER_THAN                           = ConvertLimitOp(4)
    constant limitop NOT_EQUAL                              = ConvertLimitOp(5)

//===================================================
// Unit Type Constants for use with IsUnitType()
//===================================================

    constant unittype UNIT_TYPE_HERO                        = ConvertUnitType(0)
    constant unittype UNIT_TYPE_DEAD                        = ConvertUnitType(1)
    constant unittype UNIT_TYPE_STRUCTURE                   = ConvertUnitType(2)

    constant unittype UNIT_TYPE_FLYING                      = ConvertUnitType(3)
    constant unittype UNIT_TYPE_GROUND                      = ConvertUnitType(4)

    constant unittype UNIT_TYPE_ATTACKS_FLYING              = ConvertUnitType(5)
    constant unittype UNIT_TYPE_ATTACKS_GROUND              = ConvertUnitType(6)

    constant unittype UNIT_TYPE_MELEE_ATTACKER              = ConvertUnitType(7)
    constant unittype UNIT_TYPE_RANGED_ATTACKER             = ConvertUnitType(8)

    constant unittype UNIT_TYPE_GIANT                       = ConvertUnitType(9)
    constant unittype UNIT_TYPE_SUMMONED                    = ConvertUnitType(10)
    constant unittype UNIT_TYPE_STUNNED                     = ConvertUnitType(11)
    constant unittype UNIT_TYPE_PLAGUED                     = ConvertUnitType(12)
    constant unittype UNIT_TYPE_SNARED                      = ConvertUnitType(13)

    constant unittype UNIT_TYPE_UNDEAD                      = ConvertUnitType(14)
    constant unittype UNIT_TYPE_MECHANICAL                  = ConvertUnitType(15)
    constant unittype UNIT_TYPE_PEON                        = ConvertUnitType(16)
    constant unittype UNIT_TYPE_SAPPER                      = ConvertUnitType(17)
    constant unittype UNIT_TYPE_TOWNHALL                    = ConvertUnitType(18)
    constant unittype UNIT_TYPE_ANCIENT                     = ConvertUnitType(19)

    constant unittype UNIT_TYPE_TAUREN                      = ConvertUnitType(20)
    constant unittype UNIT_TYPE_POISONED                    = ConvertUnitType(21)
    constant unittype UNIT_TYPE_POLYMORPHED                 = ConvertUnitType(22)
    constant unittype UNIT_TYPE_SLEEPING                    = ConvertUnitType(23)
    constant unittype UNIT_TYPE_RESISTANT                   = ConvertUnitType(24)
    constant unittype UNIT_TYPE_ETHEREAL                    = ConvertUnitType(25)
    constant unittype UNIT_TYPE_MAGIC_IMMUNE                = ConvertUnitType(26)

//===================================================
// Unit Type Constants for use with ChooseRandomItemEx()
//===================================================

    constant itemtype ITEM_TYPE_PERMANENT                   = ConvertItemType(0)
    constant itemtype ITEM_TYPE_CHARGED                     = ConvertItemType(1)
    constant itemtype ITEM_TYPE_POWERUP                     = ConvertItemType(2)
    constant itemtype ITEM_TYPE_ARTIFACT                    = ConvertItemType(3)
    constant itemtype ITEM_TYPE_PURCHASABLE                 = ConvertItemType(4)
    constant itemtype ITEM_TYPE_CAMPAIGN                    = ConvertItemType(5)
    constant itemtype ITEM_TYPE_MISCELLANEOUS               = ConvertItemType(6)
    constant itemtype ITEM_TYPE_UNKNOWN                     = ConvertItemType(7)
    constant itemtype ITEM_TYPE_ANY                         = ConvertItemType(8)

    // Deprecated, should use ITEM_TYPE_POWERUP
    constant itemtype ITEM_TYPE_TOME                        = ConvertItemType(2)

//===================================================
// Animatable Camera Fields
//===================================================

    constant camerafield CAMERA_FIELD_TARGET_DISTANCE       = ConvertCameraField(0)
    constant camerafield CAMERA_FIELD_FARZ                  = ConvertCameraField(1)
    constant camerafield CAMERA_FIELD_ANGLE_OF_ATTACK       = ConvertCameraField(2)
    constant camerafield CAMERA_FIELD_FIELD_OF_VIEW         = ConvertCameraField(3)
    constant camerafield CAMERA_FIELD_ROLL                  = ConvertCameraField(4)
    constant camerafield CAMERA_FIELD_ROTATION              = ConvertCameraField(5)
    constant camerafield CAMERA_FIELD_ZOFFSET               = ConvertCameraField(6)
    constant camerafield CAMERA_FIELD_NEARZ                 = ConvertCameraField(7)
    constant camerafield CAMERA_FIELD_LOCAL_PITCH           = ConvertCameraField(8)
    constant camerafield CAMERA_FIELD_LOCAL_YAW             = ConvertCameraField(9)
    constant camerafield CAMERA_FIELD_LOCAL_ROLL            = ConvertCameraField(10)

    constant blendmode   BLEND_MODE_NONE                    = ConvertBlendMode(0)
    constant blendmode   BLEND_MODE_DONT_CARE               = ConvertBlendMode(0)
    constant blendmode   BLEND_MODE_KEYALPHA                = ConvertBlendMode(1)
    constant blendmode   BLEND_MODE_BLEND                   = ConvertBlendMode(2)
    constant blendmode   BLEND_MODE_ADDITIVE                = ConvertBlendMode(3)
    constant blendmode   BLEND_MODE_MODULATE                = ConvertBlendMode(4)
    constant blendmode   BLEND_MODE_MODULATE_2X             = ConvertBlendMode(5)

    constant raritycontrol  RARITY_FREQUENT                 = ConvertRarityControl(0)
    constant raritycontrol  RARITY_RARE                     = ConvertRarityControl(1)

    constant texmapflags    TEXMAP_FLAG_NONE                = ConvertTexMapFlags(0)
    constant texmapflags    TEXMAP_FLAG_WRAP_U              = ConvertTexMapFlags(1)
    constant texmapflags    TEXMAP_FLAG_WRAP_V              = ConvertTexMapFlags(2)
    constant texmapflags    TEXMAP_FLAG_WRAP_UV             = ConvertTexMapFlags(3)

    constant fogstate       FOG_OF_WAR_MASKED               = ConvertFogState(1)
    constant fogstate       FOG_OF_WAR_FOGGED               = ConvertFogState(2)
    constant fogstate       FOG_OF_WAR_VISIBLE              = ConvertFogState(4)

//===================================================
// Camera Margin constants for use with GetCameraMargin
//===================================================

    constant integer        CAMERA_MARGIN_LEFT              = 0
    constant integer        CAMERA_MARGIN_RIGHT             = 1
    constant integer        CAMERA_MARGIN_TOP               = 2
    constant integer        CAMERA_MARGIN_BOTTOM            = 3

//===================================================
// Effect API constants
//===================================================

    constant effecttype     EFFECT_TYPE_EFFECT              = ConvertEffectType(0)
    constant effecttype     EFFECT_TYPE_TARGET              = ConvertEffectType(1)
    constant effecttype     EFFECT_TYPE_CASTER              = ConvertEffectType(2)
    constant effecttype     EFFECT_TYPE_SPECIAL             = ConvertEffectType(3)
    constant effecttype     EFFECT_TYPE_AREA_EFFECT         = ConvertEffectType(4)
    constant effecttype     EFFECT_TYPE_MISSILE             = ConvertEffectType(5)
    constant effecttype     EFFECT_TYPE_LIGHTNING           = ConvertEffectType(6)

    constant soundtype      SOUND_TYPE_EFFECT               = ConvertSoundType(0)
    constant soundtype      SOUND_TYPE_EFFECT_LOOPED        = ConvertSoundType(1)

//===================================================
// Custom UI API constants
//===================================================

    constant originframetype        ORIGIN_FRAME_GAME_UI                    = ConvertOriginFrameType(0)
    constant originframetype        ORIGIN_FRAME_COMMAND_BUTTON             = ConvertOriginFrameType(1)
    constant originframetype        ORIGIN_FRAME_HERO_BAR                   = ConvertOriginFrameType(2)
    constant originframetype        ORIGIN_FRAME_HERO_BUTTON                = ConvertOriginFrameType(3)
    constant originframetype        ORIGIN_FRAME_HERO_HP_BAR                = ConvertOriginFrameType(4)
    constant originframetype        ORIGIN_FRAME_HERO_MANA_BAR              = ConvertOriginFrameType(5)
    constant originframetype        ORIGIN_FRAME_HERO_BUTTON_INDICATOR      = ConvertOriginFrameType(6)
    constant originframetype        ORIGIN_FRAME_ITEM_BUTTON                = ConvertOriginFrameType(7)
    constant originframetype        ORIGIN_FRAME_MINIMAP                    = ConvertOriginFrameType(8)
    constant originframetype        ORIGIN_FRAME_MINIMAP_BUTTON             = ConvertOriginFrameType(9)
    constant originframetype        ORIGIN_FRAME_SYSTEM_BUTTON              = ConvertOriginFrameType(10)
    constant originframetype        ORIGIN_FRAME_TOOLTIP                    = ConvertOriginFrameType(11)
    constant originframetype        ORIGIN_FRAME_UBERTOOLTIP                = ConvertOriginFrameType(12)
    constant originframetype        ORIGIN_FRAME_CHAT_MSG                   = ConvertOriginFrameType(13)
    constant originframetype        ORIGIN_FRAME_UNIT_MSG                   = ConvertOriginFrameType(14)
    constant originframetype        ORIGIN_FRAME_TOP_MSG                    = ConvertOriginFrameType(15)
    constant originframetype        ORIGIN_FRAME_PORTRAIT                   = ConvertOriginFrameType(16)
    constant originframetype        ORIGIN_FRAME_WORLD_FRAME                = ConvertOriginFrameType(17)
    constant originframetype        ORIGIN_FRAME_SIMPLE_UI_PARENT           = ConvertOriginFrameType(18)
    constant originframetype        ORIGIN_FRAME_PORTRAIT_HP_TEXT           = ConvertOriginFrameType(19)
    constant originframetype        ORIGIN_FRAME_PORTRAIT_MANA_TEXT         = ConvertOriginFrameType(20)
    constant originframetype        ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR        = ConvertOriginFrameType(21)
    constant originframetype        ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL  = ConvertOriginFrameType(22)

    constant framepointtype         FRAMEPOINT_TOPLEFT                   = ConvertFramePointType(0)
    constant framepointtype         FRAMEPOINT_TOP                       = ConvertFramePointType(1)
    constant framepointtype         FRAMEPOINT_TOPRIGHT                  = ConvertFramePointType(2)
    constant framepointtype         FRAMEPOINT_LEFT                      = ConvertFramePointType(3)
    constant framepointtype         FRAMEPOINT_CENTER                    = ConvertFramePointType(4)
    constant framepointtype         FRAMEPOINT_RIGHT                     = ConvertFramePointType(5)
    constant framepointtype         FRAMEPOINT_BOTTOMLEFT                = ConvertFramePointType(6)
    constant framepointtype         FRAMEPOINT_BOTTOM                    = ConvertFramePointType(7)
    constant framepointtype         FRAMEPOINT_BOTTOMRIGHT               = ConvertFramePointType(8)

    constant textaligntype          TEXT_JUSTIFY_TOP                     = ConvertTextAlignType(0)
    constant textaligntype          TEXT_JUSTIFY_MIDDLE                  = ConvertTextAlignType(1)
    constant textaligntype          TEXT_JUSTIFY_BOTTOM                  = ConvertTextAlignType(2)
    constant textaligntype          TEXT_JUSTIFY_LEFT                    = ConvertTextAlignType(3)
    constant textaligntype          TEXT_JUSTIFY_CENTER                  = ConvertTextAlignType(4)
    constant textaligntype          TEXT_JUSTIFY_RIGHT                   = ConvertTextAlignType(5)

    constant frameeventtype         FRAMEEVENT_CONTROL_CLICK             = ConvertFrameEventType(1)
    constant frameeventtype         FRAMEEVENT_MOUSE_ENTER               = ConvertFrameEventType(2)
    constant frameeventtype         FRAMEEVENT_MOUSE_LEAVE               = ConvertFrameEventType(3)
    constant frameeventtype         FRAMEEVENT_MOUSE_UP                  = ConvertFrameEventType(4)
    constant frameeventtype         FRAMEEVENT_MOUSE_DOWN                = ConvertFrameEventType(5)
    constant frameeventtype         FRAMEEVENT_MOUSE_WHEEL               = ConvertFrameEventType(6)
    constant frameeventtype         FRAMEEVENT_CHECKBOX_CHECKED          = ConvertFrameEventType(7)
    constant frameeventtype         FRAMEEVENT_CHECKBOX_UNCHECKED        = ConvertFrameEventType(8)
    constant frameeventtype         FRAMEEVENT_EDITBOX_TEXT_CHANGED      = ConvertFrameEventType(9)
    constant frameeventtype         FRAMEEVENT_POPUPMENU_ITEM_CHANGED    = ConvertFrameEventType(10)
    constant frameeventtype         FRAMEEVENT_MOUSE_DOUBLECLICK         = ConvertFrameEventType(11)
    constant frameeventtype         FRAMEEVENT_SPRITE_ANIM_UPDATE        = ConvertFrameEventType(12)
    constant frameeventtype         FRAMEEVENT_SLIDER_VALUE_CHANGED      = ConvertFrameEventType(13)
    constant frameeventtype         FRAMEEVENT_DIALOG_CANCEL             = ConvertFrameEventType(14)
    constant frameeventtype         FRAMEEVENT_DIALOG_ACCEPT             = ConvertFrameEventType(15)
    constant frameeventtype         FRAMEEVENT_EDITBOX_ENTER             = ConvertFrameEventType(16)

//===================================================
// OS Key constants
//===================================================

    constant oskeytype              OSKEY_BACKSPACE                      = ConvertOsKeyType($08)
    constant oskeytype              OSKEY_TAB                            = ConvertOsKeyType($09)
    constant oskeytype              OSKEY_CLEAR                          = ConvertOsKeyType($0C)
    constant oskeytype              OSKEY_RETURN                         = ConvertOsKeyType($0D)
    constant oskeytype              OSKEY_SHIFT                          = ConvertOsKeyType($10)
    constant oskeytype              OSKEY_CONTROL                        = ConvertOsKeyType($11)
    constant oskeytype              OSKEY_ALT                            = ConvertOsKeyType($12)
    constant oskeytype              OSKEY_PAUSE                          = ConvertOsKeyType($13)
    constant oskeytype              OSKEY_CAPSLOCK                       = ConvertOsKeyType($14)
    constant oskeytype              OSKEY_KANA                           = ConvertOsKeyType($15)
    constant oskeytype              OSKEY_HANGUL                         = ConvertOsKeyType($15)
    constant oskeytype              OSKEY_JUNJA                          = ConvertOsKeyType($17)
    constant oskeytype              OSKEY_FINAL                          = ConvertOsKeyType($18)
    constant oskeytype              OSKEY_HANJA                          = ConvertOsKeyType($19)
    constant oskeytype              OSKEY_KANJI                          = ConvertOsKeyType($19)
    constant oskeytype              OSKEY_ESCAPE                         = ConvertOsKeyType($1B)
    constant oskeytype              OSKEY_CONVERT                        = ConvertOsKeyType($1C)
    constant oskeytype              OSKEY_NONCONVERT                     = ConvertOsKeyType($1D)
    constant oskeytype              OSKEY_ACCEPT                         = ConvertOsKeyType($1E)
    constant oskeytype              OSKEY_MODECHANGE                     = ConvertOsKeyType($1F)
    constant oskeytype              OSKEY_SPACE                          = ConvertOsKeyType($20)
    constant oskeytype              OSKEY_PAGEUP                         = ConvertOsKeyType($21)
    constant oskeytype              OSKEY_PAGEDOWN                       = ConvertOsKeyType($22)
    constant oskeytype              OSKEY_END                            = ConvertOsKeyType($23)
    constant oskeytype              OSKEY_HOME                           = ConvertOsKeyType($24)
    constant oskeytype              OSKEY_LEFT                           = ConvertOsKeyType($25)
    constant oskeytype              OSKEY_UP                             = ConvertOsKeyType($26)
    constant oskeytype              OSKEY_RIGHT                          = ConvertOsKeyType($27)
    constant oskeytype              OSKEY_DOWN                           = ConvertOsKeyType($28)
    constant oskeytype              OSKEY_SELECT                         = ConvertOsKeyType($29)
    constant oskeytype              OSKEY_PRINT                          = ConvertOsKeyType($2A)
    constant oskeytype              OSKEY_EXECUTE                        = ConvertOsKeyType($2B)
    constant oskeytype              OSKEY_PRINTSCREEN                    = ConvertOsKeyType($2C)
    constant oskeytype              OSKEY_INSERT                         = ConvertOsKeyType($2D)
    constant oskeytype              OSKEY_DELETE                         = ConvertOsKeyType($2E)
    constant oskeytype              OSKEY_HELP                           = ConvertOsKeyType($2F)
    constant oskeytype              OSKEY_0                              = ConvertOsKeyType($30)
    constant oskeytype              OSKEY_1                              = ConvertOsKeyType($31)
    constant oskeytype              OSKEY_2                              = ConvertOsKeyType($32)
    constant oskeytype              OSKEY_3                              = ConvertOsKeyType($33)
    constant oskeytype              OSKEY_4                              = ConvertOsKeyType($34)
    constant oskeytype              OSKEY_5                              = ConvertOsKeyType($35)
    constant oskeytype              OSKEY_6                              = ConvertOsKeyType($36)
    constant oskeytype              OSKEY_7                              = ConvertOsKeyType($37)
    constant oskeytype              OSKEY_8                              = ConvertOsKeyType($38)
    constant oskeytype              OSKEY_9                              = ConvertOsKeyType($39)
    constant oskeytype              OSKEY_A                              = ConvertOsKeyType($41)
    constant oskeytype              OSKEY_B                              = ConvertOsKeyType($42)
    constant oskeytype              OSKEY_C                              = ConvertOsKeyType($43)
    constant oskeytype              OSKEY_D                              = ConvertOsKeyType($44)
    constant oskeytype              OSKEY_E                              = ConvertOsKeyType($45)
    constant oskeytype              OSKEY_F                              = ConvertOsKeyType($46)
    constant oskeytype              OSKEY_G                              = ConvertOsKeyType($47)
    constant oskeytype              OSKEY_H                              = ConvertOsKeyType($48)
    constant oskeytype              OSKEY_I                              = ConvertOsKeyType($49)
    constant oskeytype              OSKEY_J                              = ConvertOsKeyType($4A)
    constant oskeytype              OSKEY_K                              = ConvertOsKeyType($4B)
    constant oskeytype              OSKEY_L                              = ConvertOsKeyType($4C)
    constant oskeytype              OSKEY_M                              = ConvertOsKeyType($4D)
    constant oskeytype              OSKEY_N                              = ConvertOsKeyType($4E)
    constant oskeytype              OSKEY_O                              = ConvertOsKeyType($4F)
    constant oskeytype              OSKEY_P                              = ConvertOsKeyType($50)
    constant oskeytype              OSKEY_Q                              = ConvertOsKeyType($51)
    constant oskeytype              OSKEY_R                              = ConvertOsKeyType($52)
    constant oskeytype              OSKEY_S                              = ConvertOsKeyType($53)
    constant oskeytype              OSKEY_T                              = ConvertOsKeyType($54)
    constant oskeytype              OSKEY_U                              = ConvertOsKeyType($55)
    constant oskeytype              OSKEY_V                              = ConvertOsKeyType($56)
    constant oskeytype              OSKEY_W                              = ConvertOsKeyType($57)
    constant oskeytype              OSKEY_X                              = ConvertOsKeyType($58)
    constant oskeytype              OSKEY_Y                              = ConvertOsKeyType($59)
    constant oskeytype              OSKEY_Z                              = ConvertOsKeyType($5A)
    constant oskeytype              OSKEY_LMETA                          = ConvertOsKeyType($5B)
    constant oskeytype              OSKEY_RMETA                          = ConvertOsKeyType($5C)
    constant oskeytype              OSKEY_APPS                           = ConvertOsKeyType($5D)
    constant oskeytype              OSKEY_SLEEP                          = ConvertOsKeyType($5F)
    constant oskeytype              OSKEY_NUMPAD0                        = ConvertOsKeyType($60)
    constant oskeytype              OSKEY_NUMPAD1                        = ConvertOsKeyType($61)
    constant oskeytype              OSKEY_NUMPAD2                        = ConvertOsKeyType($62)
    constant oskeytype              OSKEY_NUMPAD3                        = ConvertOsKeyType($63)
    constant oskeytype              OSKEY_NUMPAD4                        = ConvertOsKeyType($64)
    constant oskeytype              OSKEY_NUMPAD5                        = ConvertOsKeyType($65)
    constant oskeytype              OSKEY_NUMPAD6                        = ConvertOsKeyType($66)
    constant oskeytype              OSKEY_NUMPAD7                        = ConvertOsKeyType($67)
    constant oskeytype              OSKEY_NUMPAD8                        = ConvertOsKeyType($68)
    constant oskeytype              OSKEY_NUMPAD9                        = ConvertOsKeyType($69)
    constant oskeytype              OSKEY_MULTIPLY                       = ConvertOsKeyType($6A)
    constant oskeytype              OSKEY_ADD                            = ConvertOsKeyType($6B)
    constant oskeytype              OSKEY_SEPARATOR                      = ConvertOsKeyType($6C)
    constant oskeytype              OSKEY_SUBTRACT                       = ConvertOsKeyType($6D)
    constant oskeytype              OSKEY_DECIMAL                        = ConvertOsKeyType($6E)
    constant oskeytype              OSKEY_DIVIDE                         = ConvertOsKeyType($6F)
    constant oskeytype              OSKEY_F1                             = ConvertOsKeyType($70)
    constant oskeytype              OSKEY_F2                             = ConvertOsKeyType($71)
    constant oskeytype              OSKEY_F3                             = ConvertOsKeyType($72)
    constant oskeytype              OSKEY_F4                             = ConvertOsKeyType($73)
    constant oskeytype              OSKEY_F5                             = ConvertOsKeyType($74)
    constant oskeytype              OSKEY_F6                             = ConvertOsKeyType($75)
    constant oskeytype              OSKEY_F7                             = ConvertOsKeyType($76)
    constant oskeytype              OSKEY_F8                             = ConvertOsKeyType($77)
    constant oskeytype              OSKEY_F9                             = ConvertOsKeyType($78)
    constant oskeytype              OSKEY_F10                            = ConvertOsKeyType($79)
    constant oskeytype              OSKEY_F11                            = ConvertOsKeyType($7A)
    constant oskeytype              OSKEY_F12                            = ConvertOsKeyType($7B)
    constant oskeytype              OSKEY_F13                            = ConvertOsKeyType($7C)
    constant oskeytype              OSKEY_F14                            = ConvertOsKeyType($7D)
    constant oskeytype              OSKEY_F15                            = ConvertOsKeyType($7E)
    constant oskeytype              OSKEY_F16                            = ConvertOsKeyType($7F)
    constant oskeytype              OSKEY_F17                            = ConvertOsKeyType($80)
    constant oskeytype              OSKEY_F18                            = ConvertOsKeyType($81)
    constant oskeytype              OSKEY_F19                            = ConvertOsKeyType($82)
    constant oskeytype              OSKEY_F20                            = ConvertOsKeyType($83)
    constant oskeytype              OSKEY_F21                            = ConvertOsKeyType($84)
    constant oskeytype              OSKEY_F22                            = ConvertOsKeyType($85)
    constant oskeytype              OSKEY_F23                            = ConvertOsKeyType($86)
    constant oskeytype              OSKEY_F24                            = ConvertOsKeyType($87)
    constant oskeytype              OSKEY_NUMLOCK                        = ConvertOsKeyType($90)
    constant oskeytype              OSKEY_SCROLLLOCK                     = ConvertOsKeyType($91)
    constant oskeytype              OSKEY_OEM_NEC_EQUAL                  = ConvertOsKeyType($92)
    constant oskeytype              OSKEY_OEM_FJ_JISHO                   = ConvertOsKeyType($92)
    constant oskeytype              OSKEY_OEM_FJ_MASSHOU                 = ConvertOsKeyType($93)
    constant oskeytype              OSKEY_OEM_FJ_TOUROKU                 = ConvertOsKeyType($94)
    constant oskeytype              OSKEY_OEM_FJ_LOYA                    = ConvertOsKeyType($95)
    constant oskeytype              OSKEY_OEM_FJ_ROYA                    = ConvertOsKeyType($96)
    constant oskeytype              OSKEY_LSHIFT                         = ConvertOsKeyType($A0)
    constant oskeytype              OSKEY_RSHIFT                         = ConvertOsKeyType($A1)
    constant oskeytype              OSKEY_LCONTROL                       = ConvertOsKeyType($A2)
    constant oskeytype              OSKEY_RCONTROL                       = ConvertOsKeyType($A3)
    constant oskeytype              OSKEY_LALT                           = ConvertOsKeyType($A4)
    constant oskeytype              OSKEY_RALT                           = ConvertOsKeyType($A5)
    constant oskeytype              OSKEY_BROWSER_BACK                   = ConvertOsKeyType($A6)
    constant oskeytype              OSKEY_BROWSER_FORWARD                = ConvertOsKeyType($A7)
    constant oskeytype              OSKEY_BROWSER_REFRESH                = ConvertOsKeyType($A8)
    constant oskeytype              OSKEY_BROWSER_STOP                   = ConvertOsKeyType($A9)
    constant oskeytype              OSKEY_BROWSER_SEARCH                 = ConvertOsKeyType($AA)
    constant oskeytype              OSKEY_BROWSER_FAVORITES              = ConvertOsKeyType($AB)
    constant oskeytype              OSKEY_BROWSER_HOME                   = ConvertOsKeyType($AC)
    constant oskeytype              OSKEY_VOLUME_MUTE                    = ConvertOsKeyType($AD)
    constant oskeytype              OSKEY_VOLUME_DOWN                    = ConvertOsKeyType($AE)
    constant oskeytype              OSKEY_VOLUME_UP                      = ConvertOsKeyType($AF)
    constant oskeytype              OSKEY_MEDIA_NEXT_TRACK               = ConvertOsKeyType($B0)
    constant oskeytype              OSKEY_MEDIA_PREV_TRACK               = ConvertOsKeyType($B1)
    constant oskeytype              OSKEY_MEDIA_STOP                     = ConvertOsKeyType($B2)
    constant oskeytype              OSKEY_MEDIA_PLAY_PAUSE               = ConvertOsKeyType($B3)
    constant oskeytype              OSKEY_LAUNCH_MAIL                    = ConvertOsKeyType($B4)
    constant oskeytype              OSKEY_LAUNCH_MEDIA_SELECT            = ConvertOsKeyType($B5)
    constant oskeytype              OSKEY_LAUNCH_APP1                    = ConvertOsKeyType($B6)
    constant oskeytype              OSKEY_LAUNCH_APP2                    = ConvertOsKeyType($B7)
    constant oskeytype              OSKEY_OEM_1                          = ConvertOsKeyType($BA)
    constant oskeytype              OSKEY_OEM_PLUS                       = ConvertOsKeyType($BB)
    constant oskeytype              OSKEY_OEM_COMMA                      = ConvertOsKeyType($BC)
    constant oskeytype              OSKEY_OEM_MINUS                      = ConvertOsKeyType($BD)
    constant oskeytype              OSKEY_OEM_PERIOD                     = ConvertOsKeyType($BE)
    constant oskeytype              OSKEY_OEM_2                          = ConvertOsKeyType($BF)
    constant oskeytype              OSKEY_OEM_3                          = ConvertOsKeyType($C0)
    constant oskeytype              OSKEY_OEM_4                          = ConvertOsKeyType($DB)
    constant oskeytype              OSKEY_OEM_5                          = ConvertOsKeyType($DC)
    constant oskeytype              OSKEY_OEM_6                          = ConvertOsKeyType($DD)
    constant oskeytype              OSKEY_OEM_7                          = ConvertOsKeyType($DE)
    constant oskeytype              OSKEY_OEM_8                          = ConvertOsKeyType($DF)
    constant oskeytype              OSKEY_OEM_AX                         = ConvertOsKeyType($E1)
    constant oskeytype              OSKEY_OEM_102                        = ConvertOsKeyType($E2)
    constant oskeytype              OSKEY_ICO_HELP                       = ConvertOsKeyType($E3)
    constant oskeytype              OSKEY_ICO_00                         = ConvertOsKeyType($E4)
    constant oskeytype              OSKEY_PROCESSKEY                     = ConvertOsKeyType($E5)
    constant oskeytype              OSKEY_ICO_CLEAR                      = ConvertOsKeyType($E6)
    constant oskeytype              OSKEY_PACKET                         = ConvertOsKeyType($E7)
    constant oskeytype              OSKEY_OEM_RESET                      = ConvertOsKeyType($E9)
    constant oskeytype              OSKEY_OEM_JUMP                       = ConvertOsKeyType($EA)
    constant oskeytype              OSKEY_OEM_PA1                        = ConvertOsKeyType($EB)
    constant oskeytype              OSKEY_OEM_PA2                        = ConvertOsKeyType($EC)
    constant oskeytype              OSKEY_OEM_PA3                        = ConvertOsKeyType($ED)
    constant oskeytype              OSKEY_OEM_WSCTRL                     = ConvertOsKeyType($EE)
    constant oskeytype              OSKEY_OEM_CUSEL                      = ConvertOsKeyType($EF)
    constant oskeytype              OSKEY_OEM_ATTN                       = ConvertOsKeyType($F0)
    constant oskeytype              OSKEY_OEM_FINISH                     = ConvertOsKeyType($F1)
    constant oskeytype              OSKEY_OEM_COPY                       = ConvertOsKeyType($F2)
    constant oskeytype              OSKEY_OEM_AUTO                       = ConvertOsKeyType($F3)
    constant oskeytype              OSKEY_OEM_ENLW                       = ConvertOsKeyType($F4)
    constant oskeytype              OSKEY_OEM_BACKTAB                    = ConvertOsKeyType($F5)
    constant oskeytype              OSKEY_ATTN                           = ConvertOsKeyType($F6)
    constant oskeytype              OSKEY_CRSEL                          = ConvertOsKeyType($F7)
    constant oskeytype              OSKEY_EXSEL                          = ConvertOsKeyType($F8)
    constant oskeytype              OSKEY_EREOF                          = ConvertOsKeyType($F9)
    constant oskeytype              OSKEY_PLAY                           = ConvertOsKeyType($FA)
    constant oskeytype              OSKEY_ZOOM                           = ConvertOsKeyType($FB)
    constant oskeytype              OSKEY_NONAME                         = ConvertOsKeyType($FC)
    constant oskeytype              OSKEY_PA1                            = ConvertOsKeyType($FD)
    constant oskeytype              OSKEY_OEM_CLEAR                      = ConvertOsKeyType($FE)

//===================================================
// Instanced Object Operation API constants
//===================================================
    
    // Ability
    constant abilityintegerfield ABILITY_IF_BUTTON_POSITION_NORMAL_X        = ConvertAbilityIntegerField('abpx')
    constant abilityintegerfield ABILITY_IF_BUTTON_POSITION_NORMAL_Y        = ConvertAbilityIntegerField('abpy')
    constant abilityintegerfield ABILITY_IF_BUTTON_POSITION_ACTIVATED_X     = ConvertAbilityIntegerField('aubx')
    constant abilityintegerfield ABILITY_IF_BUTTON_POSITION_ACTIVATED_Y     = ConvertAbilityIntegerField('auby')
    constant abilityintegerfield ABILITY_IF_BUTTON_POSITION_RESEARCH_X      = ConvertAbilityIntegerField('arpx')
    constant abilityintegerfield ABILITY_IF_BUTTON_POSITION_RESEARCH_Y      = ConvertAbilityIntegerField('arpy')
    constant abilityintegerfield ABILITY_IF_MISSILE_SPEED                   = ConvertAbilityIntegerField('amsp')
    constant abilityintegerfield ABILITY_IF_TARGET_ATTACHMENTS              = ConvertAbilityIntegerField('atac')
    constant abilityintegerfield ABILITY_IF_CASTER_ATTACHMENTS              = ConvertAbilityIntegerField('acac')
    constant abilityintegerfield ABILITY_IF_PRIORITY                        = ConvertAbilityIntegerField('apri')
    constant abilityintegerfield ABILITY_IF_LEVELS                          = ConvertAbilityIntegerField('alev')
    constant abilityintegerfield ABILITY_IF_REQUIRED_LEVEL                  = ConvertAbilityIntegerField('arlv')
    constant abilityintegerfield ABILITY_IF_LEVEL_SKIP_REQUIREMENT          = ConvertAbilityIntegerField('alsk') 

    constant abilitybooleanfield ABILITY_BF_HERO_ABILITY                    = ConvertAbilityBooleanField('aher') // Get only
    constant abilitybooleanfield ABILITY_BF_ITEM_ABILITY                    = ConvertAbilityBooleanField('aite')
    constant abilitybooleanfield ABILITY_BF_CHECK_DEPENDENCIES              = ConvertAbilityBooleanField('achd')

    constant abilityrealfield ABILITY_RF_ARF_MISSILE_ARC                    = ConvertAbilityRealField('amac')

    constant abilitystringfield ABILITY_SF_NAME                             = ConvertAbilityStringField('anam') // Get Only
    constant abilitystringfield ABILITY_SF_ICON_ACTIVATED                   = ConvertAbilityStringField('auar')
    constant abilitystringfield ABILITY_SF_ICON_RESEARCH                    = ConvertAbilityStringField('arar')
    constant abilitystringfield ABILITY_SF_EFFECT_SOUND                     = ConvertAbilityStringField('aefs')
    constant abilitystringfield ABILITY_SF_EFFECT_SOUND_LOOPING             = ConvertAbilityStringField('aefl')

    constant abilityintegerlevelfield ABILITY_ILF_MANA_COST                         = ConvertAbilityIntegerLevelField('amcs')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_WAVES                   = ConvertAbilityIntegerLevelField('Hbz1')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_SHARDS                  = ConvertAbilityIntegerLevelField('Hbz3')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_UNITS_TELEPORTED        = ConvertAbilityIntegerLevelField('Hmt1')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_COUNT_HWE2          = ConvertAbilityIntegerLevelField('Hwe2')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_IMAGES                  = ConvertAbilityIntegerLevelField('Omi1')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_UAN1     = ConvertAbilityIntegerLevelField('Uan1')
    constant abilityintegerlevelfield ABILITY_ILF_MORPHING_FLAGS                    = ConvertAbilityIntegerLevelField('Eme2')
    constant abilityintegerlevelfield ABILITY_ILF_STRENGTH_BONUS_NRG5               = ConvertAbilityIntegerLevelField('Nrg5')
    constant abilityintegerlevelfield ABILITY_ILF_DEFENSE_BONUS_NRG6                = ConvertAbilityIntegerLevelField('Nrg6')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_TARGETS_HIT             = ConvertAbilityIntegerLevelField('Ocl2')
    constant abilityintegerlevelfield ABILITY_ILF_DETECTION_TYPE_OFS1               = ConvertAbilityIntegerLevelField('Ofs1')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_OSF2     = ConvertAbilityIntegerLevelField('Osf2')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_EFN1     = ConvertAbilityIntegerLevelField('Efn1')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_HRE1     = ConvertAbilityIntegerLevelField('Hre1')
    constant abilityintegerlevelfield ABILITY_ILF_STACK_FLAGS                       = ConvertAbilityIntegerLevelField('Hca4')
    constant abilityintegerlevelfield ABILITY_ILF_MINIMUM_NUMBER_OF_UNITS           = ConvertAbilityIntegerLevelField('Ndp2')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_NDP3      = ConvertAbilityIntegerLevelField('Ndp3')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_UNITS_CREATED_NRC2      = ConvertAbilityIntegerLevelField('Nrc2')
    constant abilityintegerlevelfield ABILITY_ILF_SHIELD_LIFE                       = ConvertAbilityIntegerLevelField('Ams3')
    constant abilityintegerlevelfield ABILITY_ILF_MANA_LOSS_AMS4                    = ConvertAbilityIntegerLevelField('Ams4')
    constant abilityintegerlevelfield ABILITY_ILF_GOLD_PER_INTERVAL_BGM1            = ConvertAbilityIntegerLevelField('Bgm1')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_NUMBER_OF_MINERS              = ConvertAbilityIntegerLevelField('Bgm3')
    constant abilityintegerlevelfield ABILITY_ILF_CARGO_CAPACITY                    = ConvertAbilityIntegerLevelField('Car1')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_CREEP_LEVEL_DEV3          = ConvertAbilityIntegerLevelField('Dev3')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_CREEP_LEVEL_DEV1              = ConvertAbilityIntegerLevelField('Dev1')
    constant abilityintegerlevelfield ABILITY_ILF_GOLD_PER_INTERVAL_EGM1            = ConvertAbilityIntegerLevelField('Egm1')
    constant abilityintegerlevelfield ABILITY_ILF_DEFENSE_REDUCTION                 = ConvertAbilityIntegerLevelField('Fae1')
    constant abilityintegerlevelfield ABILITY_ILF_DETECTION_TYPE_FLA1               = ConvertAbilityIntegerLevelField('Fla1')
    constant abilityintegerlevelfield ABILITY_ILF_FLARE_COUNT                       = ConvertAbilityIntegerLevelField('Fla3')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_GOLD                          = ConvertAbilityIntegerLevelField('Gld1')
    constant abilityintegerlevelfield ABILITY_ILF_MINING_CAPACITY                   = ConvertAbilityIntegerLevelField('Gld3')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_GYD1    = ConvertAbilityIntegerLevelField('Gyd1')
    constant abilityintegerlevelfield ABILITY_ILF_DAMAGE_TO_TREE                    = ConvertAbilityIntegerLevelField('Har1')
    constant abilityintegerlevelfield ABILITY_ILF_LUMBER_CAPACITY                   = ConvertAbilityIntegerLevelField('Har2')
    constant abilityintegerlevelfield ABILITY_ILF_GOLD_CAPACITY                     = ConvertAbilityIntegerLevelField('Har3')
    constant abilityintegerlevelfield ABILITY_ILF_DEFENSE_INCREASE_INF2             = ConvertAbilityIntegerLevelField('Inf2')
    constant abilityintegerlevelfield ABILITY_ILF_INTERACTION_TYPE                  = ConvertAbilityIntegerLevelField('Neu2')
    constant abilityintegerlevelfield ABILITY_ILF_GOLD_COST_NDT1                    = ConvertAbilityIntegerLevelField('Ndt1')
    constant abilityintegerlevelfield ABILITY_ILF_LUMBER_COST_NDT2                  = ConvertAbilityIntegerLevelField('Ndt2')
    constant abilityintegerlevelfield ABILITY_ILF_DETECTION_TYPE_NDT3               = ConvertAbilityIntegerLevelField('Ndt3')
    constant abilityintegerlevelfield ABILITY_ILF_STACKING_TYPE_POI4                = ConvertAbilityIntegerLevelField('Poi4')
    constant abilityintegerlevelfield ABILITY_ILF_STACKING_TYPE_POA5                = ConvertAbilityIntegerLevelField('Poa5')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_CREEP_LEVEL_PLY1          = ConvertAbilityIntegerLevelField('Ply1')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_CREEP_LEVEL_POS1          = ConvertAbilityIntegerLevelField('Pos1')
    constant abilityintegerlevelfield ABILITY_ILF_MOVEMENT_UPDATE_FREQUENCY_PRG1    = ConvertAbilityIntegerLevelField('Prg1')
    constant abilityintegerlevelfield ABILITY_ILF_ATTACK_UPDATE_FREQUENCY_PRG2      = ConvertAbilityIntegerLevelField('Prg2')
    constant abilityintegerlevelfield ABILITY_ILF_MANA_LOSS_PRG6                    = ConvertAbilityIntegerLevelField('Prg6')
    constant abilityintegerlevelfield ABILITY_ILF_UNITS_SUMMONED_TYPE_ONE           = ConvertAbilityIntegerLevelField('Rai1')
    constant abilityintegerlevelfield ABILITY_ILF_UNITS_SUMMONED_TYPE_TWO           = ConvertAbilityIntegerLevelField('Rai2')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_UNITS_SUMMONED                = ConvertAbilityIntegerLevelField('Ucb5')
    constant abilityintegerlevelfield ABILITY_ILF_ALLOW_WHEN_FULL_REJ3              = ConvertAbilityIntegerLevelField('Rej3')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_UNITS_CHARGED_TO_CASTER   = ConvertAbilityIntegerLevelField('Rpb5')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_UNITS_AFFECTED            = ConvertAbilityIntegerLevelField('Rpb6')
    constant abilityintegerlevelfield ABILITY_ILF_DEFENSE_INCREASE_ROA2             = ConvertAbilityIntegerLevelField('Roa2')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_UNITS_ROA7                    = ConvertAbilityIntegerLevelField('Roa7')
    constant abilityintegerlevelfield ABILITY_ILF_ROOTED_WEAPONS                    = ConvertAbilityIntegerLevelField('Roo1')
    constant abilityintegerlevelfield ABILITY_ILF_UPROOTED_WEAPONS                  = ConvertAbilityIntegerLevelField('Roo2')
    constant abilityintegerlevelfield ABILITY_ILF_UPROOTED_DEFENSE_TYPE             = ConvertAbilityIntegerLevelField('Roo4')
    constant abilityintegerlevelfield ABILITY_ILF_ACCUMULATION_STEP                 = ConvertAbilityIntegerLevelField('Sal2')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_OWLS                    = ConvertAbilityIntegerLevelField('Esn4')
    constant abilityintegerlevelfield ABILITY_ILF_STACKING_TYPE_SPO4                = ConvertAbilityIntegerLevelField('Spo4')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_UNITS                   = ConvertAbilityIntegerLevelField('Sod1')
    constant abilityintegerlevelfield ABILITY_ILF_SPIDER_CAPACITY                   = ConvertAbilityIntegerLevelField('Spa1')
    constant abilityintegerlevelfield ABILITY_ILF_INTERVALS_BEFORE_CHANGING_TREES   = ConvertAbilityIntegerLevelField('Wha2')
    constant abilityintegerlevelfield ABILITY_ILF_AGILITY_BONUS                     = ConvertAbilityIntegerLevelField('Iagi')
    constant abilityintegerlevelfield ABILITY_ILF_INTELLIGENCE_BONUS                = ConvertAbilityIntegerLevelField('Iint')
    constant abilityintegerlevelfield ABILITY_ILF_STRENGTH_BONUS_ISTR               = ConvertAbilityIntegerLevelField('Istr')
    constant abilityintegerlevelfield ABILITY_ILF_ATTACK_BONUS                      = ConvertAbilityIntegerLevelField('Iatt')
    constant abilityintegerlevelfield ABILITY_ILF_DEFENSE_BONUS_IDEF                = ConvertAbilityIntegerLevelField('Idef')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMON_1_AMOUNT                   = ConvertAbilityIntegerLevelField('Isn1')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMON_2_AMOUNT                   = ConvertAbilityIntegerLevelField('Isn2')
    constant abilityintegerlevelfield ABILITY_ILF_EXPERIENCE_GAINED                 = ConvertAbilityIntegerLevelField('Ixpg')
    constant abilityintegerlevelfield ABILITY_ILF_HIT_POINTS_GAINED_IHPG            = ConvertAbilityIntegerLevelField('Ihpg')
    constant abilityintegerlevelfield ABILITY_ILF_MANA_POINTS_GAINED_IMPG           = ConvertAbilityIntegerLevelField('Impg')
    constant abilityintegerlevelfield ABILITY_ILF_HIT_POINTS_GAINED_IHP2            = ConvertAbilityIntegerLevelField('Ihp2')
    constant abilityintegerlevelfield ABILITY_ILF_MANA_POINTS_GAINED_IMP2           = ConvertAbilityIntegerLevelField('Imp2')
    constant abilityintegerlevelfield ABILITY_ILF_DAMAGE_BONUS_DICE                 = ConvertAbilityIntegerLevelField('Idic')
    constant abilityintegerlevelfield ABILITY_ILF_ARMOR_PENALTY_IARP                = ConvertAbilityIntegerLevelField('Iarp')
    constant abilityintegerlevelfield ABILITY_ILF_ENABLED_ATTACK_INDEX_IOB5         = ConvertAbilityIntegerLevelField('Iob5')
    constant abilityintegerlevelfield ABILITY_ILF_LEVELS_GAINED                     = ConvertAbilityIntegerLevelField('Ilev')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_LIFE_GAINED                   = ConvertAbilityIntegerLevelField('Ilif')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_MANA_GAINED                   = ConvertAbilityIntegerLevelField('Iman')
    constant abilityintegerlevelfield ABILITY_ILF_GOLD_GIVEN                        = ConvertAbilityIntegerLevelField('Igol')
    constant abilityintegerlevelfield ABILITY_ILF_LUMBER_GIVEN                      = ConvertAbilityIntegerLevelField('Ilum')
    constant abilityintegerlevelfield ABILITY_ILF_DETECTION_TYPE_IFA1               = ConvertAbilityIntegerLevelField('Ifa1')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_CREEP_LEVEL_ICRE          = ConvertAbilityIntegerLevelField('Icre')
    constant abilityintegerlevelfield ABILITY_ILF_MOVEMENT_SPEED_BONUS              = ConvertAbilityIntegerLevelField('Imvb')
    constant abilityintegerlevelfield ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND = ConvertAbilityIntegerLevelField('Ihpr')
    constant abilityintegerlevelfield ABILITY_ILF_SIGHT_RANGE_BONUS                 = ConvertAbilityIntegerLevelField('Isib')
    constant abilityintegerlevelfield ABILITY_ILF_DAMAGE_PER_DURATION               = ConvertAbilityIntegerLevelField('Icfd')
    constant abilityintegerlevelfield ABILITY_ILF_MANA_USED_PER_SECOND              = ConvertAbilityIntegerLevelField('Icfm')
    constant abilityintegerlevelfield ABILITY_ILF_EXTRA_MANA_REQUIRED               = ConvertAbilityIntegerLevelField('Icfx')
    constant abilityintegerlevelfield ABILITY_ILF_DETECTION_RADIUS_IDET             = ConvertAbilityIntegerLevelField('Idet')
    constant abilityintegerlevelfield ABILITY_ILF_MANA_LOSS_PER_UNIT_IDIM           = ConvertAbilityIntegerLevelField('Idim')
    constant abilityintegerlevelfield ABILITY_ILF_DAMAGE_TO_SUMMONED_UNITS_IDID     = ConvertAbilityIntegerLevelField('Idid')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_IREC      = ConvertAbilityIntegerLevelField('Irec')
    constant abilityintegerlevelfield ABILITY_ILF_DELAY_AFTER_DEATH_SECONDS         = ConvertAbilityIntegerLevelField('Ircd')
    constant abilityintegerlevelfield ABILITY_ILF_RESTORED_LIFE                     = ConvertAbilityIntegerLevelField('irc2')
    constant abilityintegerlevelfield ABILITY_ILF_RESTORED_MANA__1_FOR_CURRENT      = ConvertAbilityIntegerLevelField('irc3')
    constant abilityintegerlevelfield ABILITY_ILF_HIT_POINTS_RESTORED               = ConvertAbilityIntegerLevelField('Ihps')
    constant abilityintegerlevelfield ABILITY_ILF_MANA_POINTS_RESTORED              = ConvertAbilityIntegerLevelField('Imps')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_ITPM      = ConvertAbilityIntegerLevelField('Itpm')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_CAD1     = ConvertAbilityIntegerLevelField('Cad1')
    constant abilityintegerlevelfield ABILITY_ILF_TERRAIN_DEFORMATION_DURATION_MS   = ConvertAbilityIntegerLevelField('Wrs3')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_UNITS                     = ConvertAbilityIntegerLevelField('Uds1')
    constant abilityintegerlevelfield ABILITY_ILF_DETECTION_TYPE_DET1               = ConvertAbilityIntegerLevelField('Det1')
    constant abilityintegerlevelfield ABILITY_ILF_GOLD_COST_PER_STRUCTURE           = ConvertAbilityIntegerLevelField('Nsp1')
    constant abilityintegerlevelfield ABILITY_ILF_LUMBER_COST_PER_USE               = ConvertAbilityIntegerLevelField('Nsp2')
    constant abilityintegerlevelfield ABILITY_ILF_DETECTION_TYPE_NSP3               = ConvertAbilityIntegerLevelField('Nsp3')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_SWARM_UNITS             = ConvertAbilityIntegerLevelField('Uls1')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_SWARM_UNITS_PER_TARGET        = ConvertAbilityIntegerLevelField('Uls3')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NBA2     = ConvertAbilityIntegerLevelField('Nba2')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_CREEP_LEVEL_NCH1          = ConvertAbilityIntegerLevelField('Nch1')
    constant abilityintegerlevelfield ABILITY_ILF_ATTACKS_PREVENTED                 = ConvertAbilityIntegerLevelField('Nsi1')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_EFK3    = ConvertAbilityIntegerLevelField('Efk3')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_ESV1     = ConvertAbilityIntegerLevelField('Esv1')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_EXH1    = ConvertAbilityIntegerLevelField('exh1')
    constant abilityintegerlevelfield ABILITY_ILF_ITEM_CAPACITY                     = ConvertAbilityIntegerLevelField('inv1')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_SPL2    = ConvertAbilityIntegerLevelField('spl2')
    constant abilityintegerlevelfield ABILITY_ILF_ALLOW_WHEN_FULL_IRL3              = ConvertAbilityIntegerLevelField('irl3')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_DISPELLED_UNITS           = ConvertAbilityIntegerLevelField('idc3')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_LURES                   = ConvertAbilityIntegerLevelField('imo1')
    constant abilityintegerlevelfield ABILITY_ILF_NEW_TIME_OF_DAY_HOUR              = ConvertAbilityIntegerLevelField('ict1')
    constant abilityintegerlevelfield ABILITY_ILF_NEW_TIME_OF_DAY_MINUTE            = ConvertAbilityIntegerLevelField('ict2')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_UNITS_CREATED_MEC1      = ConvertAbilityIntegerLevelField('mec1')
    constant abilityintegerlevelfield ABILITY_ILF_MINIMUM_SPELLS                    = ConvertAbilityIntegerLevelField('spb3')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_SPELLS                    = ConvertAbilityIntegerLevelField('spb4')
    constant abilityintegerlevelfield ABILITY_ILF_DISABLED_ATTACK_INDEX             = ConvertAbilityIntegerLevelField('gra3')
    constant abilityintegerlevelfield ABILITY_ILF_ENABLED_ATTACK_INDEX_GRA4         = ConvertAbilityIntegerLevelField('gra4')
    constant abilityintegerlevelfield ABILITY_ILF_MAXIMUM_ATTACKS                   = ConvertAbilityIntegerLevelField('gra5')
    constant abilityintegerlevelfield ABILITY_ILF_BUILDING_TYPES_ALLOWED_NPR1       = ConvertAbilityIntegerLevelField('Npr1')
    constant abilityintegerlevelfield ABILITY_ILF_BUILDING_TYPES_ALLOWED_NSA1       = ConvertAbilityIntegerLevelField('Nsa1')
    constant abilityintegerlevelfield ABILITY_ILF_ATTACK_MODIFICATION               = ConvertAbilityIntegerLevelField('Iaa1')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_COUNT_NPA5          = ConvertAbilityIntegerLevelField('Npa5')
    constant abilityintegerlevelfield ABILITY_ILF_UPGRADE_LEVELS                    = ConvertAbilityIntegerLevelField('Igl1')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NDO2     = ConvertAbilityIntegerLevelField('Ndo2')
    constant abilityintegerlevelfield ABILITY_ILF_BEASTS_PER_SECOND                 = ConvertAbilityIntegerLevelField('Nst1')
    constant abilityintegerlevelfield ABILITY_ILF_TARGET_TYPE                       = ConvertAbilityIntegerLevelField('Ncl2')
    constant abilityintegerlevelfield ABILITY_ILF_OPTIONS                           = ConvertAbilityIntegerLevelField('Ncl3')
    constant abilityintegerlevelfield ABILITY_ILF_ARMOR_PENALTY_NAB3                = ConvertAbilityIntegerLevelField('Nab3')
    constant abilityintegerlevelfield ABILITY_ILF_WAVE_COUNT_NHS6                   = ConvertAbilityIntegerLevelField('Nhs6')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_CREEP_LEVEL_NTM3              = ConvertAbilityIntegerLevelField('Ntm3')
    constant abilityintegerlevelfield ABILITY_ILF_MISSILE_COUNT                     = ConvertAbilityIntegerLevelField('Ncs3')
    constant abilityintegerlevelfield ABILITY_ILF_SPLIT_ATTACK_COUNT                = ConvertAbilityIntegerLevelField('Nlm3')
    constant abilityintegerlevelfield ABILITY_ILF_GENERATION_COUNT                  = ConvertAbilityIntegerLevelField('Nlm6')
    constant abilityintegerlevelfield ABILITY_ILF_ROCK_RING_COUNT                   = ConvertAbilityIntegerLevelField('Nvc1')
    constant abilityintegerlevelfield ABILITY_ILF_WAVE_COUNT_NVC2                   = ConvertAbilityIntegerLevelField('Nvc2')
    constant abilityintegerlevelfield ABILITY_ILF_PREFER_HOSTILES_TAU1              = ConvertAbilityIntegerLevelField('Tau1')
    constant abilityintegerlevelfield ABILITY_ILF_PREFER_FRIENDLIES_TAU2            = ConvertAbilityIntegerLevelField('Tau2')
    constant abilityintegerlevelfield ABILITY_ILF_MAX_UNITS_TAU3                    = ConvertAbilityIntegerLevelField('Tau3')
    constant abilityintegerlevelfield ABILITY_ILF_NUMBER_OF_PULSES                  = ConvertAbilityIntegerLevelField('Tau4')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_TYPE_HWE1           = ConvertAbilityIntegerLevelField('Hwe1')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_UIN4                = ConvertAbilityIntegerLevelField('Uin4')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_OSF1                = ConvertAbilityIntegerLevelField('Osf1')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_TYPE_EFNU           = ConvertAbilityIntegerLevelField('Efnu')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_TYPE_NBAU           = ConvertAbilityIntegerLevelField('Nbau')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_TYPE_NTOU           = ConvertAbilityIntegerLevelField('Ntou')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_TYPE_ESVU           = ConvertAbilityIntegerLevelField('Esvu')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_TYPES               = ConvertAbilityIntegerLevelField('Nef1')
    constant abilityintegerlevelfield ABILITY_ILF_SUMMONED_UNIT_TYPE_NDOU           = ConvertAbilityIntegerLevelField('Ndou')
    constant abilityintegerlevelfield ABILITY_ILF_ALTERNATE_FORM_UNIT_EMEU          = ConvertAbilityIntegerLevelField('Emeu')
    constant abilityintegerlevelfield ABILITY_ILF_PLAGUE_WARD_UNIT_TYPE             = ConvertAbilityIntegerLevelField('Aplu')
    constant abilityintegerlevelfield ABILITY_ILF_ALLOWED_UNIT_TYPE_BTL1            = ConvertAbilityIntegerLevelField('Btl1')
    constant abilityintegerlevelfield ABILITY_ILF_NEW_UNIT_TYPE                     = ConvertAbilityIntegerLevelField('Cha1')
    constant abilityintegerlevelfield ABILITY_ILF_RESULTING_UNIT_TYPE_ENT1          = ConvertAbilityIntegerLevelField('ent1')
    constant abilityintegerlevelfield ABILITY_ILF_CORPSE_UNIT_TYPE                  = ConvertAbilityIntegerLevelField('Gydu')
    constant abilityintegerlevelfield ABILITY_ILF_ALLOWED_UNIT_TYPE_LOA1            = ConvertAbilityIntegerLevelField('Loa1')
    constant abilityintegerlevelfield ABILITY_ILF_UNIT_TYPE_FOR_LIMIT_CHECK         = ConvertAbilityIntegerLevelField('Raiu')
    constant abilityintegerlevelfield ABILITY_ILF_WARD_UNIT_TYPE_STAU               = ConvertAbilityIntegerLevelField('Stau')
    constant abilityintegerlevelfield ABILITY_ILF_EFFECT_ABILITY                    = ConvertAbilityIntegerLevelField('Iobu')
    constant abilityintegerlevelfield ABILITY_ILF_CONVERSION_UNIT                   = ConvertAbilityIntegerLevelField('Ndc2')
    constant abilityintegerlevelfield ABILITY_ILF_UNIT_TO_PRESERVE                  = ConvertAbilityIntegerLevelField('Nsl1')
    constant abilityintegerlevelfield ABILITY_ILF_UNIT_TYPE_ALLOWED                 = ConvertAbilityIntegerLevelField('Chl1')
    constant abilityintegerlevelfield ABILITY_ILF_SWARM_UNIT_TYPE                   = ConvertAbilityIntegerLevelField('Ulsu')
    constant abilityintegerlevelfield ABILITY_ILF_RESULTING_UNIT_TYPE_COAU          = ConvertAbilityIntegerLevelField('coau')
    constant abilityintegerlevelfield ABILITY_ILF_UNIT_TYPE_EXHU                    = ConvertAbilityIntegerLevelField('exhu')
    constant abilityintegerlevelfield ABILITY_ILF_WARD_UNIT_TYPE_HWDU               = ConvertAbilityIntegerLevelField('hwdu')
    constant abilityintegerlevelfield ABILITY_ILF_LURE_UNIT_TYPE                    = ConvertAbilityIntegerLevelField('imou')
    constant abilityintegerlevelfield ABILITY_ILF_UNIT_TYPE_IPMU                    = ConvertAbilityIntegerLevelField('ipmu')
    constant abilityintegerlevelfield ABILITY_ILF_FACTORY_UNIT_ID                   = ConvertAbilityIntegerLevelField('Nsyu')
    constant abilityintegerlevelfield ABILITY_ILF_SPAWN_UNIT_ID_NFYU                = ConvertAbilityIntegerLevelField('Nfyu')
    constant abilityintegerlevelfield ABILITY_ILF_DESTRUCTIBLE_ID                   = ConvertAbilityIntegerLevelField('Nvcu')
    constant abilityintegerlevelfield ABILITY_ILF_UPGRADE_TYPE                      = ConvertAbilityIntegerLevelField('Iglu')

    constant abilityreallevelfield ABILITY_RLF_CASTING_TIME                                      = ConvertAbilityRealLevelField('acas')
    constant abilityreallevelfield ABILITY_RLF_DURATION_NORMAL                                   = ConvertAbilityRealLevelField('adur')
    constant abilityreallevelfield ABILITY_RLF_DURATION_HERO                                     = ConvertAbilityRealLevelField('ahdu')
    constant abilityreallevelfield ABILITY_RLF_COOLDOWN                                          = ConvertAbilityRealLevelField('acdn')
    constant abilityreallevelfield ABILITY_RLF_AREA_OF_EFFECT                                    = ConvertAbilityRealLevelField('aare')
    constant abilityreallevelfield ABILITY_RLF_CAST_RANGE                                        = ConvertAbilityRealLevelField('aran')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_HBZ2                                       = ConvertAbilityRealLevelField('Hbz2')
    constant abilityreallevelfield ABILITY_RLF_BUILDING_REDUCTION_HBZ4                           = ConvertAbilityRealLevelField('Hbz4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_HBZ5                            = ConvertAbilityRealLevelField('Hbz5')
    constant abilityreallevelfield ABILITY_RLF_MAXIMUM_DAMAGE_PER_WAVE                           = ConvertAbilityRealLevelField('Hbz6')
    constant abilityreallevelfield ABILITY_RLF_MANA_REGENERATION_INCREASE                        = ConvertAbilityRealLevelField('Hab1')
    constant abilityreallevelfield ABILITY_RLF_CASTING_DELAY                                     = ConvertAbilityRealLevelField('Hmt2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_OWW1                            = ConvertAbilityRealLevelField('Oww1')
    constant abilityreallevelfield ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_OWW2                       = ConvertAbilityRealLevelField('Oww2')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_CRITICAL_STRIKE                         = ConvertAbilityRealLevelField('Ocr1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_MULTIPLIER_OCR2                            = ConvertAbilityRealLevelField('Ocr2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_OCR3                                 = ConvertAbilityRealLevelField('Ocr3')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_EVADE_OCR4                              = ConvertAbilityRealLevelField('Ocr4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_DEALT_PERCENT_OMI2                         = ConvertAbilityRealLevelField('Omi2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_TAKEN_PERCENT_OMI3                         = ConvertAbilityRealLevelField('Omi3')
    constant abilityreallevelfield ABILITY_RLF_ANIMATION_DELAY                                   = ConvertAbilityRealLevelField('Omi4')
    constant abilityreallevelfield ABILITY_RLF_TRANSITION_TIME                                   = ConvertAbilityRealLevelField('Owk1')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OWK2              = ConvertAbilityRealLevelField('Owk2')
    constant abilityreallevelfield ABILITY_RLF_BACKSTAB_DAMAGE                                   = ConvertAbilityRealLevelField('Owk3')
    constant abilityreallevelfield ABILITY_RLF_AMOUNT_HEALED_DAMAGED_UDC1                        = ConvertAbilityRealLevelField('Udc1')
    constant abilityreallevelfield ABILITY_RLF_LIFE_CONVERTED_TO_MANA                            = ConvertAbilityRealLevelField('Udp1')
    constant abilityreallevelfield ABILITY_RLF_LIFE_CONVERTED_TO_LIFE                            = ConvertAbilityRealLevelField('Udp2')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_UAU1              = ConvertAbilityRealLevelField('Uau1')
    constant abilityreallevelfield ABILITY_RLF_LIFE_REGENERATION_INCREASE_PERCENT                = ConvertAbilityRealLevelField('Uau2')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_EVADE_EEV1                              = ConvertAbilityRealLevelField('Eev1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_INTERVAL                               = ConvertAbilityRealLevelField('Eim1')
    constant abilityreallevelfield ABILITY_RLF_MANA_DRAINED_PER_SECOND_EIM2                      = ConvertAbilityRealLevelField('Eim2')
    constant abilityreallevelfield ABILITY_RLF_BUFFER_MANA_REQUIRED                              = ConvertAbilityRealLevelField('Eim3')
    constant abilityreallevelfield ABILITY_RLF_MAX_MANA_DRAINED                                  = ConvertAbilityRealLevelField('Emb1')
    constant abilityreallevelfield ABILITY_RLF_BOLT_DELAY                                        = ConvertAbilityRealLevelField('Emb2')
    constant abilityreallevelfield ABILITY_RLF_BOLT_LIFETIME                                     = ConvertAbilityRealLevelField('Emb3')
    constant abilityreallevelfield ABILITY_RLF_ALTITUDE_ADJUSTMENT_DURATION                      = ConvertAbilityRealLevelField('Eme3')
    constant abilityreallevelfield ABILITY_RLF_LANDING_DELAY_TIME                                = ConvertAbilityRealLevelField('Eme4')
    constant abilityreallevelfield ABILITY_RLF_ALTERNATE_FORM_HIT_POINT_BONUS                    = ConvertAbilityRealLevelField('Eme5')
    constant abilityreallevelfield ABILITY_RLF_MOVE_SPEED_BONUS_INFO_PANEL_ONLY                  = ConvertAbilityRealLevelField('Ncr5')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_BONUS_INFO_PANEL_ONLY                = ConvertAbilityRealLevelField('Ncr6')
    constant abilityreallevelfield ABILITY_RLF_LIFE_REGENERATION_RATE_PER_SECOND                 = ConvertAbilityRealLevelField('ave5')
    constant abilityreallevelfield ABILITY_RLF_STUN_DURATION_USL1                                = ConvertAbilityRealLevelField('Usl1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_DAMAGE_STOLEN_PERCENT                      = ConvertAbilityRealLevelField('Uav1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_UCS1                                       = ConvertAbilityRealLevelField('Ucs1')
    constant abilityreallevelfield ABILITY_RLF_MAX_DAMAGE_UCS2                                   = ConvertAbilityRealLevelField('Ucs2')
    constant abilityreallevelfield ABILITY_RLF_DISTANCE_UCS3                                     = ConvertAbilityRealLevelField('Ucs3')
    constant abilityreallevelfield ABILITY_RLF_FINAL_AREA_UCS4                                   = ConvertAbilityRealLevelField('Ucs4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_UIN1                                       = ConvertAbilityRealLevelField('Uin1')
    constant abilityreallevelfield ABILITY_RLF_DURATION                                          = ConvertAbilityRealLevelField('Uin2')
    constant abilityreallevelfield ABILITY_RLF_IMPACT_DELAY                                      = ConvertAbilityRealLevelField('Uin3')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_TARGET_OCL1                            = ConvertAbilityRealLevelField('Ocl1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_REDUCTION_PER_TARGET                       = ConvertAbilityRealLevelField('Ocl3')
    constant abilityreallevelfield ABILITY_RLF_EFFECT_DELAY_OEQ1                                 = ConvertAbilityRealLevelField('Oeq1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_TO_BUILDINGS                    = ConvertAbilityRealLevelField('Oeq2')
    constant abilityreallevelfield ABILITY_RLF_UNITS_SLOWED_PERCENT                              = ConvertAbilityRealLevelField('Oeq3')
    constant abilityreallevelfield ABILITY_RLF_FINAL_AREA_OEQ4                                   = ConvertAbilityRealLevelField('Oeq4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_EER1                            = ConvertAbilityRealLevelField('Eer1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_DEALT_TO_ATTACKERS                         = ConvertAbilityRealLevelField('Eah1')
    constant abilityreallevelfield ABILITY_RLF_LIFE_HEALED                                       = ConvertAbilityRealLevelField('Etq1')
    constant abilityreallevelfield ABILITY_RLF_HEAL_INTERVAL                                     = ConvertAbilityRealLevelField('Etq2')
    constant abilityreallevelfield ABILITY_RLF_BUILDING_REDUCTION_ETQ3                           = ConvertAbilityRealLevelField('Etq3')
    constant abilityreallevelfield ABILITY_RLF_INITIAL_IMMUNITY_DURATION                         = ConvertAbilityRealLevelField('Etq4')
    constant abilityreallevelfield ABILITY_RLF_MAX_LIFE_DRAINED_PER_SECOND_PERCENT               = ConvertAbilityRealLevelField('Udd1')
    constant abilityreallevelfield ABILITY_RLF_BUILDING_REDUCTION_UDD2                           = ConvertAbilityRealLevelField('Udd2')
    constant abilityreallevelfield ABILITY_RLF_ARMOR_DURATION                                    = ConvertAbilityRealLevelField('Ufa1')
    constant abilityreallevelfield ABILITY_RLF_ARMOR_BONUS_UFA2                                  = ConvertAbilityRealLevelField('Ufa2')
    constant abilityreallevelfield ABILITY_RLF_AREA_OF_EFFECT_DAMAGE                             = ConvertAbilityRealLevelField('Ufn1')
    constant abilityreallevelfield ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_UFN2                       = ConvertAbilityRealLevelField('Ufn2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_HFA1                                 = ConvertAbilityRealLevelField('Hfa1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_DEALT_ESF1                                 = ConvertAbilityRealLevelField('Esf1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_INTERVAL_ESF2                              = ConvertAbilityRealLevelField('Esf2')
    constant abilityreallevelfield ABILITY_RLF_BUILDING_REDUCTION_ESF3                           = ConvertAbilityRealLevelField('Esf3')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_PERCENT                              = ConvertAbilityRealLevelField('Ear1')
    constant abilityreallevelfield ABILITY_RLF_DEFENSE_BONUS_HAV1                                = ConvertAbilityRealLevelField('Hav1')
    constant abilityreallevelfield ABILITY_RLF_HIT_POINT_BONUS                                   = ConvertAbilityRealLevelField('Hav2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_HAV3                                 = ConvertAbilityRealLevelField('Hav3')
    constant abilityreallevelfield ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_HAV4                       = ConvertAbilityRealLevelField('Hav4')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_BASH                                    = ConvertAbilityRealLevelField('Hbh1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_MULTIPLIER_HBH2                            = ConvertAbilityRealLevelField('Hbh2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_HBH3                                 = ConvertAbilityRealLevelField('Hbh3')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_MISS_HBH4                               = ConvertAbilityRealLevelField('Hbh4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_HTB1                                       = ConvertAbilityRealLevelField('Htb1')
    constant abilityreallevelfield ABILITY_RLF_AOE_DAMAGE                                        = ConvertAbilityRealLevelField('Htc1')
    constant abilityreallevelfield ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_HTC2                       = ConvertAbilityRealLevelField('Htc2')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HTC3             = ConvertAbilityRealLevelField('Htc3')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HTC4               = ConvertAbilityRealLevelField('Htc4')
    constant abilityreallevelfield ABILITY_RLF_ARMOR_BONUS_HAD1                                  = ConvertAbilityRealLevelField('Had1')
    constant abilityreallevelfield ABILITY_RLF_AMOUNT_HEALED_DAMAGED_HHB1                        = ConvertAbilityRealLevelField('Hhb1')
    constant abilityreallevelfield ABILITY_RLF_EXTRA_DAMAGE_HCA1                                 = ConvertAbilityRealLevelField('Hca1')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_FACTOR_HCA2                        = ConvertAbilityRealLevelField('Hca2')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_FACTOR_HCA3                          = ConvertAbilityRealLevelField('Hca3')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OAE1              = ConvertAbilityRealLevelField('Oae1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_OAE2                = ConvertAbilityRealLevelField('Oae2')
    constant abilityreallevelfield ABILITY_RLF_REINCARNATION_DELAY                               = ConvertAbilityRealLevelField('Ore1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_OSH1                                       = ConvertAbilityRealLevelField('Osh1')
    constant abilityreallevelfield ABILITY_RLF_MAXIMUM_DAMAGE_OSH2                               = ConvertAbilityRealLevelField('Osh2')
    constant abilityreallevelfield ABILITY_RLF_DISTANCE_OSH3                                     = ConvertAbilityRealLevelField('Osh3')
    constant abilityreallevelfield ABILITY_RLF_FINAL_AREA_OSH4                                   = ConvertAbilityRealLevelField('Osh4')
    constant abilityreallevelfield ABILITY_RLF_GRAPHIC_DELAY_NFD1                                = ConvertAbilityRealLevelField('Nfd1')
    constant abilityreallevelfield ABILITY_RLF_GRAPHIC_DURATION_NFD2                             = ConvertAbilityRealLevelField('Nfd2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_NFD3                                       = ConvertAbilityRealLevelField('Nfd3')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_UNIT_DAMAGE_AMS1                         = ConvertAbilityRealLevelField('Ams1')
    constant abilityreallevelfield ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_AMS2                       = ConvertAbilityRealLevelField('Ams2')
    constant abilityreallevelfield ABILITY_RLF_AURA_DURATION                                     = ConvertAbilityRealLevelField('Apl1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_APL2                            = ConvertAbilityRealLevelField('Apl2')
    constant abilityreallevelfield ABILITY_RLF_DURATION_OF_PLAGUE_WARD                           = ConvertAbilityRealLevelField('Apl3')
    constant abilityreallevelfield ABILITY_RLF_AMOUNT_OF_HIT_POINTS_REGENERATED                  = ConvertAbilityRealLevelField('Oar1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_DAMAGE_INCREASE_AKB1                       = ConvertAbilityRealLevelField('Akb1')
    constant abilityreallevelfield ABILITY_RLF_MANA_LOSS_ADM1                                    = ConvertAbilityRealLevelField('Adm1')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_UNIT_DAMAGE_ADM2                         = ConvertAbilityRealLevelField('Adm2')
    constant abilityreallevelfield ABILITY_RLF_EXPANSION_AMOUNT                                  = ConvertAbilityRealLevelField('Bli1')
    constant abilityreallevelfield ABILITY_RLF_INTERVAL_DURATION_BGM2                            = ConvertAbilityRealLevelField('Bgm2')
    constant abilityreallevelfield ABILITY_RLF_RADIUS_OF_MINING_RING                             = ConvertAbilityRealLevelField('Bgm4')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_BLO1                = ConvertAbilityRealLevelField('Blo1')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_BLO2              = ConvertAbilityRealLevelField('Blo2')
    constant abilityreallevelfield ABILITY_RLF_SCALING_FACTOR                                    = ConvertAbilityRealLevelField('Blo3')
    constant abilityreallevelfield ABILITY_RLF_HIT_POINTS_PER_SECOND_CAN1                        = ConvertAbilityRealLevelField('Can1')
    constant abilityreallevelfield ABILITY_RLF_MAX_HIT_POINTS                                    = ConvertAbilityRealLevelField('Can2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_DEV2                            = ConvertAbilityRealLevelField('Dev2')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_UPDATE_FREQUENCY_CHD1                    = ConvertAbilityRealLevelField('Chd1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_UPDATE_FREQUENCY_CHD2                      = ConvertAbilityRealLevelField('Chd2')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_UNIT_DAMAGE_CHD3                         = ConvertAbilityRealLevelField('Chd3')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_CRI1             = ConvertAbilityRealLevelField('Cri1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_CRI2               = ConvertAbilityRealLevelField('Cri2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_REDUCTION_CRI3                             = ConvertAbilityRealLevelField('Cri3')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_MISS_CRS                                = ConvertAbilityRealLevelField('Crs1')
    constant abilityreallevelfield ABILITY_RLF_FULL_DAMAGE_RADIUS_DDA1                           = ConvertAbilityRealLevelField('Dda1')
    constant abilityreallevelfield ABILITY_RLF_FULL_DAMAGE_AMOUNT_DDA2                           = ConvertAbilityRealLevelField('Dda2')
    constant abilityreallevelfield ABILITY_RLF_PARTIAL_DAMAGE_RADIUS                             = ConvertAbilityRealLevelField('Dda3')
    constant abilityreallevelfield ABILITY_RLF_PARTIAL_DAMAGE_AMOUNT                             = ConvertAbilityRealLevelField('Dda4')
    constant abilityreallevelfield ABILITY_RLF_BUILDING_DAMAGE_FACTOR_SDS1                       = ConvertAbilityRealLevelField('Sds1')
    constant abilityreallevelfield ABILITY_RLF_MAX_DAMAGE_UCO5                                   = ConvertAbilityRealLevelField('Uco5')
    constant abilityreallevelfield ABILITY_RLF_MOVE_SPEED_BONUS_UCO6                             = ConvertAbilityRealLevelField('Uco6')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_TAKEN_PERCENT_DEF1                         = ConvertAbilityRealLevelField('Def1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_DEALT_PERCENT_DEF2                         = ConvertAbilityRealLevelField('Def2')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_FACTOR_DEF3                        = ConvertAbilityRealLevelField('Def3')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_FACTOR_DEF4                          = ConvertAbilityRealLevelField('Def4')
    constant abilityreallevelfield ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_DEF5                       = ConvertAbilityRealLevelField('Def5')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_DEFLECT                                 = ConvertAbilityRealLevelField('Def6')
    constant abilityreallevelfield ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_PIERCING                     = ConvertAbilityRealLevelField('Def7')
    constant abilityreallevelfield ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_SPELLS                       = ConvertAbilityRealLevelField('Def8')
    constant abilityreallevelfield ABILITY_RLF_RIP_DELAY                                         = ConvertAbilityRealLevelField('Eat1')
    constant abilityreallevelfield ABILITY_RLF_EAT_DELAY                                         = ConvertAbilityRealLevelField('Eat2')
    constant abilityreallevelfield ABILITY_RLF_HIT_POINTS_GAINED_EAT3                            = ConvertAbilityRealLevelField('Eat3')
    constant abilityreallevelfield ABILITY_RLF_AIR_UNIT_LOWER_DURATION                           = ConvertAbilityRealLevelField('Ens1')
    constant abilityreallevelfield ABILITY_RLF_AIR_UNIT_HEIGHT                                   = ConvertAbilityRealLevelField('Ens2')
    constant abilityreallevelfield ABILITY_RLF_MELEE_ATTACK_RANGE                                = ConvertAbilityRealLevelField('Ens3')
    constant abilityreallevelfield ABILITY_RLF_INTERVAL_DURATION_EGM2                            = ConvertAbilityRealLevelField('Egm2')
    constant abilityreallevelfield ABILITY_RLF_EFFECT_DELAY_FLA2                                 = ConvertAbilityRealLevelField('Fla2')
    constant abilityreallevelfield ABILITY_RLF_MINING_DURATION                                   = ConvertAbilityRealLevelField('Gld2')
    constant abilityreallevelfield ABILITY_RLF_RADIUS_OF_GRAVESTONES                             = ConvertAbilityRealLevelField('Gyd2')
    constant abilityreallevelfield ABILITY_RLF_RADIUS_OF_CORPSES                                 = ConvertAbilityRealLevelField('Gyd3')
    constant abilityreallevelfield ABILITY_RLF_HIT_POINTS_GAINED_HEA1                            = ConvertAbilityRealLevelField('Hea1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_INCREASE_PERCENT_INF1                      = ConvertAbilityRealLevelField('Inf1')
    constant abilityreallevelfield ABILITY_RLF_AUTOCAST_RANGE                                    = ConvertAbilityRealLevelField('Inf3')
    constant abilityreallevelfield ABILITY_RLF_LIFE_REGEN_RATE                                   = ConvertAbilityRealLevelField('Inf4')
    constant abilityreallevelfield ABILITY_RLF_GRAPHIC_DELAY_LIT1                                = ConvertAbilityRealLevelField('Lit1')
    constant abilityreallevelfield ABILITY_RLF_GRAPHIC_DURATION_LIT2                             = ConvertAbilityRealLevelField('Lit2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_LSH1                            = ConvertAbilityRealLevelField('Lsh1')
    constant abilityreallevelfield ABILITY_RLF_MANA_GAINED                                       = ConvertAbilityRealLevelField('Mbt1')
    constant abilityreallevelfield ABILITY_RLF_HIT_POINTS_GAINED_MBT2                            = ConvertAbilityRealLevelField('Mbt2')
    constant abilityreallevelfield ABILITY_RLF_AUTOCAST_REQUIREMENT                              = ConvertAbilityRealLevelField('Mbt3')
    constant abilityreallevelfield ABILITY_RLF_WATER_HEIGHT                                      = ConvertAbilityRealLevelField('Mbt4')
    constant abilityreallevelfield ABILITY_RLF_ACTIVATION_DELAY_MIN1                             = ConvertAbilityRealLevelField('Min1')
    constant abilityreallevelfield ABILITY_RLF_INVISIBILITY_TRANSITION_TIME                      = ConvertAbilityRealLevelField('Min2')
    constant abilityreallevelfield ABILITY_RLF_ACTIVATION_RADIUS                                 = ConvertAbilityRealLevelField('Neu1')
    constant abilityreallevelfield ABILITY_RLF_AMOUNT_REGENERATED                                = ConvertAbilityRealLevelField('Arm1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_POI1                            = ConvertAbilityRealLevelField('Poi1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_FACTOR_POI2                          = ConvertAbilityRealLevelField('Poi2')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POI3                        = ConvertAbilityRealLevelField('Poi3')
    constant abilityreallevelfield ABILITY_RLF_EXTRA_DAMAGE_POA1                                 = ConvertAbilityRealLevelField('Poa1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_POA2                            = ConvertAbilityRealLevelField('Poa2')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_FACTOR_POA3                          = ConvertAbilityRealLevelField('Poa3')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POA4                        = ConvertAbilityRealLevelField('Poa4')   
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_AMPLIFICATION                              = ConvertAbilityRealLevelField('Pos2')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_STOMP_PERCENT                           = ConvertAbilityRealLevelField('War1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_DEALT_WAR2                                 = ConvertAbilityRealLevelField('War2')
    constant abilityreallevelfield ABILITY_RLF_FULL_DAMAGE_RADIUS_WAR3                           = ConvertAbilityRealLevelField('War3')
    constant abilityreallevelfield ABILITY_RLF_HALF_DAMAGE_RADIUS_WAR4                           = ConvertAbilityRealLevelField('War4')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_UNIT_DAMAGE_PRG3                         = ConvertAbilityRealLevelField('Prg3')
    constant abilityreallevelfield ABILITY_RLF_UNIT_PAUSE_DURATION                               = ConvertAbilityRealLevelField('Prg4')
    constant abilityreallevelfield ABILITY_RLF_HERO_PAUSE_DURATION                               = ConvertAbilityRealLevelField('Prg5')
    constant abilityreallevelfield ABILITY_RLF_HIT_POINTS_GAINED_REJ1                            = ConvertAbilityRealLevelField('Rej1')
    constant abilityreallevelfield ABILITY_RLF_MANA_POINTS_GAINED_REJ2                           = ConvertAbilityRealLevelField('Rej2')
    constant abilityreallevelfield ABILITY_RLF_MINIMUM_LIFE_REQUIRED                             = ConvertAbilityRealLevelField('Rpb3')
    constant abilityreallevelfield ABILITY_RLF_MINIMUM_MANA_REQUIRED                             = ConvertAbilityRealLevelField('Rpb4')
    constant abilityreallevelfield ABILITY_RLF_REPAIR_COST_RATIO                                 = ConvertAbilityRealLevelField('Rep1')
    constant abilityreallevelfield ABILITY_RLF_REPAIR_TIME_RATIO                                 = ConvertAbilityRealLevelField('Rep2')
    constant abilityreallevelfield ABILITY_RLF_POWERBUILD_COST                                   = ConvertAbilityRealLevelField('Rep3')
    constant abilityreallevelfield ABILITY_RLF_POWERBUILD_RATE                                   = ConvertAbilityRealLevelField('Rep4')
    constant abilityreallevelfield ABILITY_RLF_NAVAL_RANGE_BONUS                                 = ConvertAbilityRealLevelField('Rep5')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_INCREASE_PERCENT_ROA1                      = ConvertAbilityRealLevelField('Roa1')
    constant abilityreallevelfield ABILITY_RLF_LIFE_REGENERATION_RATE                            = ConvertAbilityRealLevelField('Roa3')
    constant abilityreallevelfield ABILITY_RLF_MANA_REGEN                                        = ConvertAbilityRealLevelField('Roa4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_INCREASE                                   = ConvertAbilityRealLevelField('Nbr1')
    constant abilityreallevelfield ABILITY_RLF_SALVAGE_COST_RATIO                                = ConvertAbilityRealLevelField('Sal1')
    constant abilityreallevelfield ABILITY_RLF_IN_FLIGHT_SIGHT_RADIUS                            = ConvertAbilityRealLevelField('Esn1')
    constant abilityreallevelfield ABILITY_RLF_HOVERING_SIGHT_RADIUS                             = ConvertAbilityRealLevelField('Esn2')
    constant abilityreallevelfield ABILITY_RLF_HOVERING_HEIGHT                                   = ConvertAbilityRealLevelField('Esn3')
    constant abilityreallevelfield ABILITY_RLF_DURATION_OF_OWLS                                  = ConvertAbilityRealLevelField('Esn5')
    constant abilityreallevelfield ABILITY_RLF_FADE_DURATION                                     = ConvertAbilityRealLevelField('Shm1')
    constant abilityreallevelfield ABILITY_RLF_DAY_NIGHT_DURATION                                = ConvertAbilityRealLevelField('Shm2')
    constant abilityreallevelfield ABILITY_RLF_ACTION_DURATION                                   = ConvertAbilityRealLevelField('Shm3')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SLO1                        = ConvertAbilityRealLevelField('Slo1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_FACTOR_SLO2                          = ConvertAbilityRealLevelField('Slo2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_SPO1                            = ConvertAbilityRealLevelField('Spo1')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SPO2                        = ConvertAbilityRealLevelField('Spo2')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_FACTOR_SPO3                          = ConvertAbilityRealLevelField('Spo3')
    constant abilityreallevelfield ABILITY_RLF_ACTIVATION_DELAY_STA1                             = ConvertAbilityRealLevelField('Sta1')
    constant abilityreallevelfield ABILITY_RLF_DETECTION_RADIUS_STA2                             = ConvertAbilityRealLevelField('Sta2')
    constant abilityreallevelfield ABILITY_RLF_DETONATION_RADIUS                                 = ConvertAbilityRealLevelField('Sta3')
    constant abilityreallevelfield ABILITY_RLF_STUN_DURATION_STA4                                = ConvertAbilityRealLevelField('Sta4')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_BONUS_PERCENT                        = ConvertAbilityRealLevelField('Uhf1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_UHF2                            = ConvertAbilityRealLevelField('Uhf2')
    constant abilityreallevelfield ABILITY_RLF_LUMBER_PER_INTERVAL                               = ConvertAbilityRealLevelField('Wha1')
    constant abilityreallevelfield ABILITY_RLF_ART_ATTACHMENT_HEIGHT                             = ConvertAbilityRealLevelField('Wha3')
    constant abilityreallevelfield ABILITY_RLF_TELEPORT_AREA_WIDTH                               = ConvertAbilityRealLevelField('Wrp1')
    constant abilityreallevelfield ABILITY_RLF_TELEPORT_AREA_HEIGHT                              = ConvertAbilityRealLevelField('Wrp2')
    constant abilityreallevelfield ABILITY_RLF_LIFE_STOLEN_PER_ATTACK                            = ConvertAbilityRealLevelField('Ivam')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_IDAM                                 = ConvertAbilityRealLevelField('Idam')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_HIT_UNITS_PERCENT                       = ConvertAbilityRealLevelField('Iob2')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_HIT_HEROS_PERCENT                       = ConvertAbilityRealLevelField('Iob3')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_HIT_SUMMONS_PERCENT                     = ConvertAbilityRealLevelField('Iob4')
    constant abilityreallevelfield ABILITY_RLF_DELAY_FOR_TARGET_EFFECT                           = ConvertAbilityRealLevelField('Idel')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_DEALT_PERCENT_OF_NORMAL                    = ConvertAbilityRealLevelField('Iild')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_RECEIVED_MULTIPLIER                        = ConvertAbilityRealLevelField('Iilw')
    constant abilityreallevelfield ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL     = ConvertAbilityRealLevelField('Imrp')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_INCREASE_ISPI                      = ConvertAbilityRealLevelField('Ispi')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_IDPS                            = ConvertAbilityRealLevelField('Idps')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_DAMAGE_INCREASE_CAC1                       = ConvertAbilityRealLevelField('Cac1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_COR1                            = ConvertAbilityRealLevelField('Cor1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1                        = ConvertAbilityRealLevelField('Isx1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_WRS1                                       = ConvertAbilityRealLevelField('Wrs1')
    constant abilityreallevelfield ABILITY_RLF_TERRAIN_DEFORMATION_AMPLITUDE                     = ConvertAbilityRealLevelField('Wrs2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_CTC1                                       = ConvertAbilityRealLevelField('Ctc1')
    constant abilityreallevelfield ABILITY_RLF_EXTRA_DAMAGE_TO_TARGET                            = ConvertAbilityRealLevelField('Ctc2')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_CTC3                     = ConvertAbilityRealLevelField('Ctc3')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_REDUCTION_CTC4                       = ConvertAbilityRealLevelField('Ctc4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_CTB1                                       = ConvertAbilityRealLevelField('Ctb1')
    constant abilityreallevelfield ABILITY_RLF_CASTING_DELAY_SECONDS                             = ConvertAbilityRealLevelField('Uds2')
    constant abilityreallevelfield ABILITY_RLF_MANA_LOSS_PER_UNIT_DTN1                           = ConvertAbilityRealLevelField('Dtn1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_DTN2                     = ConvertAbilityRealLevelField('Dtn2')
    constant abilityreallevelfield ABILITY_RLF_TRANSITION_TIME_SECONDS                           = ConvertAbilityRealLevelField('Ivs1')
    constant abilityreallevelfield ABILITY_RLF_MANA_DRAINED_PER_SECOND_NMR1                      = ConvertAbilityRealLevelField('Nmr1')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_REDUCE_DAMAGE_PERCENT                   = ConvertAbilityRealLevelField('Ssk1')
    constant abilityreallevelfield ABILITY_RLF_MINIMUM_DAMAGE                                    = ConvertAbilityRealLevelField('Ssk2')
    constant abilityreallevelfield ABILITY_RLF_IGNORED_DAMAGE                                    = ConvertAbilityRealLevelField('Ssk3')
    constant abilityreallevelfield ABILITY_RLF_FULL_DAMAGE_DEALT                                 = ConvertAbilityRealLevelField('Hfs1')
    constant abilityreallevelfield ABILITY_RLF_FULL_DAMAGE_INTERVAL                              = ConvertAbilityRealLevelField('Hfs2')
    constant abilityreallevelfield ABILITY_RLF_HALF_DAMAGE_DEALT                                 = ConvertAbilityRealLevelField('Hfs3')
    constant abilityreallevelfield ABILITY_RLF_HALF_DAMAGE_INTERVAL                              = ConvertAbilityRealLevelField('Hfs4')
    constant abilityreallevelfield ABILITY_RLF_BUILDING_REDUCTION_HFS5                           = ConvertAbilityRealLevelField('Hfs5')
    constant abilityreallevelfield ABILITY_RLF_MAXIMUM_DAMAGE_HFS6                               = ConvertAbilityRealLevelField('Hfs6')
    constant abilityreallevelfield ABILITY_RLF_MANA_PER_HIT_POINT                                = ConvertAbilityRealLevelField('Nms1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_ABSORBED_PERCENT                           = ConvertAbilityRealLevelField('Nms2')
    constant abilityreallevelfield ABILITY_RLF_WAVE_DISTANCE                                     = ConvertAbilityRealLevelField('Uim1')
    constant abilityreallevelfield ABILITY_RLF_WAVE_TIME_SECONDS                                 = ConvertAbilityRealLevelField('Uim2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_DEALT_UIM3                                 = ConvertAbilityRealLevelField('Uim3')
    constant abilityreallevelfield ABILITY_RLF_AIR_TIME_SECONDS_UIM4                             = ConvertAbilityRealLevelField('Uim4')
    constant abilityreallevelfield ABILITY_RLF_UNIT_RELEASE_INTERVAL_SECONDS                     = ConvertAbilityRealLevelField('Uls2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_RETURN_FACTOR                              = ConvertAbilityRealLevelField('Uls4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_RETURN_THRESHOLD                           = ConvertAbilityRealLevelField('Uls5')
    constant abilityreallevelfield ABILITY_RLF_RETURNED_DAMAGE_FACTOR                            = ConvertAbilityRealLevelField('Uts1')
    constant abilityreallevelfield ABILITY_RLF_RECEIVED_DAMAGE_FACTOR                            = ConvertAbilityRealLevelField('Uts2')
    constant abilityreallevelfield ABILITY_RLF_DEFENSE_BONUS_UTS3                                = ConvertAbilityRealLevelField('Uts3')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_NBA1                                 = ConvertAbilityRealLevelField('Nba1')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NBA3               = ConvertAbilityRealLevelField('Nba3')
    constant abilityreallevelfield ABILITY_RLF_MANA_PER_SUMMONED_HITPOINT                        = ConvertAbilityRealLevelField('Cmg2')
    constant abilityreallevelfield ABILITY_RLF_CHARGE_FOR_CURRENT_LIFE                           = ConvertAbilityRealLevelField('Cmg3')
    constant abilityreallevelfield ABILITY_RLF_HIT_POINTS_DRAINED                                = ConvertAbilityRealLevelField('Ndr1')
    constant abilityreallevelfield ABILITY_RLF_MANA_POINTS_DRAINED                               = ConvertAbilityRealLevelField('Ndr2')
    constant abilityreallevelfield ABILITY_RLF_DRAIN_INTERVAL_SECONDS                            = ConvertAbilityRealLevelField('Ndr3')
    constant abilityreallevelfield ABILITY_RLF_LIFE_TRANSFERRED_PER_SECOND                       = ConvertAbilityRealLevelField('Ndr4')
    constant abilityreallevelfield ABILITY_RLF_MANA_TRANSFERRED_PER_SECOND                       = ConvertAbilityRealLevelField('Ndr5')
    constant abilityreallevelfield ABILITY_RLF_BONUS_LIFE_FACTOR                                 = ConvertAbilityRealLevelField('Ndr6')
    constant abilityreallevelfield ABILITY_RLF_BONUS_LIFE_DECAY                                  = ConvertAbilityRealLevelField('Ndr7')
    constant abilityreallevelfield ABILITY_RLF_BONUS_MANA_FACTOR                                 = ConvertAbilityRealLevelField('Ndr8')
    constant abilityreallevelfield ABILITY_RLF_BONUS_MANA_DECAY                                  = ConvertAbilityRealLevelField('Ndr9')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_MISS_PERCENT                            = ConvertAbilityRealLevelField('Nsi2')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_MODIFIER                           = ConvertAbilityRealLevelField('Nsi3')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_MODIFIER                             = ConvertAbilityRealLevelField('Nsi4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_TDG1                            = ConvertAbilityRealLevelField('Tdg1')
    constant abilityreallevelfield ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_TDG2                         = ConvertAbilityRealLevelField('Tdg2')
    constant abilityreallevelfield ABILITY_RLF_MEDIUM_DAMAGE_PER_SECOND                          = ConvertAbilityRealLevelField('Tdg3')
    constant abilityreallevelfield ABILITY_RLF_SMALL_DAMAGE_RADIUS_TDG4                          = ConvertAbilityRealLevelField('Tdg4')
    constant abilityreallevelfield ABILITY_RLF_SMALL_DAMAGE_PER_SECOND                           = ConvertAbilityRealLevelField('Tdg5')
    constant abilityreallevelfield ABILITY_RLF_AIR_TIME_SECONDS_TSP1                             = ConvertAbilityRealLevelField('Tsp1')
    constant abilityreallevelfield ABILITY_RLF_MINIMUM_HIT_INTERVAL_SECONDS                      = ConvertAbilityRealLevelField('Tsp2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_NBF5                            = ConvertAbilityRealLevelField('Nbf5')
    constant abilityreallevelfield ABILITY_RLF_MAXIMUM_RANGE                                     = ConvertAbilityRealLevelField('Ebl1')
    constant abilityreallevelfield ABILITY_RLF_MINIMUM_RANGE                                     = ConvertAbilityRealLevelField('Ebl2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_TARGET_EFK1                            = ConvertAbilityRealLevelField('Efk1')
    constant abilityreallevelfield ABILITY_RLF_MAXIMUM_TOTAL_DAMAGE                              = ConvertAbilityRealLevelField('Efk2')
    constant abilityreallevelfield ABILITY_RLF_MAXIMUM_SPEED_ADJUSTMENT                          = ConvertAbilityRealLevelField('Efk4')
    constant abilityreallevelfield ABILITY_RLF_DECAYING_DAMAGE                                   = ConvertAbilityRealLevelField('Esh1')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_FACTOR_ESH2                        = ConvertAbilityRealLevelField('Esh2')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_FACTOR_ESH3                          = ConvertAbilityRealLevelField('Esh3')
    constant abilityreallevelfield ABILITY_RLF_DECAY_POWER                                       = ConvertAbilityRealLevelField('Esh4')
    constant abilityreallevelfield ABILITY_RLF_INITIAL_DAMAGE_ESH5                               = ConvertAbilityRealLevelField('Esh5')
    constant abilityreallevelfield ABILITY_RLF_MAXIMUM_LIFE_ABSORBED                             = ConvertAbilityRealLevelField('abs1')
    constant abilityreallevelfield ABILITY_RLF_MAXIMUM_MANA_ABSORBED                             = ConvertAbilityRealLevelField('abs2')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_INCREASE_BSK1                      = ConvertAbilityRealLevelField('bsk1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_INCREASE_BSK2                        = ConvertAbilityRealLevelField('bsk2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_TAKEN_INCREASE                             = ConvertAbilityRealLevelField('bsk3')
    constant abilityreallevelfield ABILITY_RLF_LIFE_PER_UNIT                                     = ConvertAbilityRealLevelField('dvm1')
    constant abilityreallevelfield ABILITY_RLF_MANA_PER_UNIT                                     = ConvertAbilityRealLevelField('dvm2')
    constant abilityreallevelfield ABILITY_RLF_LIFE_PER_BUFF                                     = ConvertAbilityRealLevelField('dvm3')
    constant abilityreallevelfield ABILITY_RLF_MANA_PER_BUFF                                     = ConvertAbilityRealLevelField('dvm4')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_UNIT_DAMAGE_DVM5                         = ConvertAbilityRealLevelField('dvm5')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_FAK1                                 = ConvertAbilityRealLevelField('fak1')
    constant abilityreallevelfield ABILITY_RLF_MEDIUM_DAMAGE_FACTOR_FAK2                         = ConvertAbilityRealLevelField('fak2')
    constant abilityreallevelfield ABILITY_RLF_SMALL_DAMAGE_FACTOR_FAK3                          = ConvertAbilityRealLevelField('fak3')
    constant abilityreallevelfield ABILITY_RLF_FULL_DAMAGE_RADIUS_FAK4                           = ConvertAbilityRealLevelField('fak4')
    constant abilityreallevelfield ABILITY_RLF_HALF_DAMAGE_RADIUS_FAK5                           = ConvertAbilityRealLevelField('fak5')
    constant abilityreallevelfield ABILITY_RLF_EXTRA_DAMAGE_PER_SECOND                           = ConvertAbilityRealLevelField('liq1')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_LIQ2                     = ConvertAbilityRealLevelField('liq2')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_REDUCTION_LIQ3                       = ConvertAbilityRealLevelField('liq3')
    constant abilityreallevelfield ABILITY_RLF_MAGIC_DAMAGE_FACTOR                               = ConvertAbilityRealLevelField('mim1')
    constant abilityreallevelfield ABILITY_RLF_UNIT_DAMAGE_PER_MANA_POINT                        = ConvertAbilityRealLevelField('mfl1')
    constant abilityreallevelfield ABILITY_RLF_HERO_DAMAGE_PER_MANA_POINT                        = ConvertAbilityRealLevelField('mfl2')
    constant abilityreallevelfield ABILITY_RLF_UNIT_MAXIMUM_DAMAGE                               = ConvertAbilityRealLevelField('mfl3')
    constant abilityreallevelfield ABILITY_RLF_HERO_MAXIMUM_DAMAGE                               = ConvertAbilityRealLevelField('mfl4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_COOLDOWN                                   = ConvertAbilityRealLevelField('mfl5')
    constant abilityreallevelfield ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_SPL1                    = ConvertAbilityRealLevelField('spl1')
    constant abilityreallevelfield ABILITY_RLF_LIFE_REGENERATED                                  = ConvertAbilityRealLevelField('irl1')
    constant abilityreallevelfield ABILITY_RLF_MANA_REGENERATED                                  = ConvertAbilityRealLevelField('irl2')
    constant abilityreallevelfield ABILITY_RLF_MANA_LOSS_PER_UNIT_IDC1                           = ConvertAbilityRealLevelField('idc1')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_UNIT_DAMAGE_IDC2                         = ConvertAbilityRealLevelField('idc2')
    constant abilityreallevelfield ABILITY_RLF_ACTIVATION_DELAY_IMO2                             = ConvertAbilityRealLevelField('imo2')
    constant abilityreallevelfield ABILITY_RLF_LURE_INTERVAL_SECONDS                             = ConvertAbilityRealLevelField('imo3')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_ISR1                                 = ConvertAbilityRealLevelField('isr1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_REDUCTION_ISR2                             = ConvertAbilityRealLevelField('isr2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_IPV1                                 = ConvertAbilityRealLevelField('ipv1')
    constant abilityreallevelfield ABILITY_RLF_LIFE_STEAL_AMOUNT                                 = ConvertAbilityRealLevelField('ipv2')
    constant abilityreallevelfield ABILITY_RLF_LIFE_RESTORED_FACTOR                              = ConvertAbilityRealLevelField('ast1')
    constant abilityreallevelfield ABILITY_RLF_MANA_RESTORED_FACTOR                              = ConvertAbilityRealLevelField('ast2')
    constant abilityreallevelfield ABILITY_RLF_ATTACH_DELAY                                      = ConvertAbilityRealLevelField('gra1')
    constant abilityreallevelfield ABILITY_RLF_REMOVE_DELAY                                      = ConvertAbilityRealLevelField('gra2')
    constant abilityreallevelfield ABILITY_RLF_HERO_REGENERATION_DELAY                           = ConvertAbilityRealLevelField('Nsa2')
    constant abilityreallevelfield ABILITY_RLF_UNIT_REGENERATION_DELAY                           = ConvertAbilityRealLevelField('Nsa3')
    constant abilityreallevelfield ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_NSA4                       = ConvertAbilityRealLevelField('Nsa4')
    constant abilityreallevelfield ABILITY_RLF_HIT_POINTS_PER_SECOND_NSA5                        = ConvertAbilityRealLevelField('Nsa5')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_IXS1                     = ConvertAbilityRealLevelField('Ixs1')
    constant abilityreallevelfield ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_IXS2                       = ConvertAbilityRealLevelField('Ixs2')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_UNIT_DURATION                            = ConvertAbilityRealLevelField('Npa6')
    constant abilityreallevelfield ABILITY_RLF_SHIELD_COOLDOWN_TIME                              = ConvertAbilityRealLevelField('Nse1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_NDO1                            = ConvertAbilityRealLevelField('Ndo1')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NDO3               = ConvertAbilityRealLevelField('Ndo3')
    constant abilityreallevelfield ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_FLK1                         = ConvertAbilityRealLevelField('flk1')
    constant abilityreallevelfield ABILITY_RLF_SMALL_DAMAGE_RADIUS_FLK2                          = ConvertAbilityRealLevelField('flk2')
    constant abilityreallevelfield ABILITY_RLF_FULL_DAMAGE_AMOUNT_FLK3                           = ConvertAbilityRealLevelField('flk3')
    constant abilityreallevelfield ABILITY_RLF_MEDIUM_DAMAGE_AMOUNT                              = ConvertAbilityRealLevelField('flk4')
    constant abilityreallevelfield ABILITY_RLF_SMALL_DAMAGE_AMOUNT                               = ConvertAbilityRealLevelField('flk5')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HBN1             = ConvertAbilityRealLevelField('Hbn1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HBN2               = ConvertAbilityRealLevelField('Hbn2')
    constant abilityreallevelfield ABILITY_RLF_MAX_MANA_DRAINED_UNITS                            = ConvertAbilityRealLevelField('fbk1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_RATIO_UNITS_PERCENT                        = ConvertAbilityRealLevelField('fbk2')
    constant abilityreallevelfield ABILITY_RLF_MAX_MANA_DRAINED_HEROS                            = ConvertAbilityRealLevelField('fbk3')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_RATIO_HEROS_PERCENT                        = ConvertAbilityRealLevelField('fbk4')
    constant abilityreallevelfield ABILITY_RLF_SUMMONED_DAMAGE                                   = ConvertAbilityRealLevelField('fbk5')
    constant abilityreallevelfield ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_NCA1                    = ConvertAbilityRealLevelField('nca1')
    constant abilityreallevelfield ABILITY_RLF_INITIAL_DAMAGE_PXF1                               = ConvertAbilityRealLevelField('pxf1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_PXF2                            = ConvertAbilityRealLevelField('pxf2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PER_SECOND_MLS1                            = ConvertAbilityRealLevelField('mls1')
    constant abilityreallevelfield ABILITY_RLF_BEAST_COLLISION_RADIUS                            = ConvertAbilityRealLevelField('Nst2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_AMOUNT_NST3                                = ConvertAbilityRealLevelField('Nst3')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_RADIUS                                     = ConvertAbilityRealLevelField('Nst4')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_DELAY                                      = ConvertAbilityRealLevelField('Nst5')
    constant abilityreallevelfield ABILITY_RLF_FOLLOW_THROUGH_TIME                               = ConvertAbilityRealLevelField('Ncl1')
    constant abilityreallevelfield ABILITY_RLF_ART_DURATION                                      = ConvertAbilityRealLevelField('Ncl4')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NAB1             = ConvertAbilityRealLevelField('Nab1')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NAB2               = ConvertAbilityRealLevelField('Nab2')
    constant abilityreallevelfield ABILITY_RLF_PRIMARY_DAMAGE                                    = ConvertAbilityRealLevelField('Nab4')
    constant abilityreallevelfield ABILITY_RLF_SECONDARY_DAMAGE                                  = ConvertAbilityRealLevelField('Nab5')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_INTERVAL_NAB6                              = ConvertAbilityRealLevelField('Nab6')
    constant abilityreallevelfield ABILITY_RLF_GOLD_COST_FACTOR                                  = ConvertAbilityRealLevelField('Ntm1')
    constant abilityreallevelfield ABILITY_RLF_LUMBER_COST_FACTOR                                = ConvertAbilityRealLevelField('Ntm2')
    constant abilityreallevelfield ABILITY_RLF_MOVE_SPEED_BONUS_NEG1                             = ConvertAbilityRealLevelField('Neg1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_BONUS_NEG2                                 = ConvertAbilityRealLevelField('Neg2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_AMOUNT_NCS1                                = ConvertAbilityRealLevelField('Ncs1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_INTERVAL_NCS2                              = ConvertAbilityRealLevelField('Ncs2')
    constant abilityreallevelfield ABILITY_RLF_MAX_DAMAGE_NCS4                                   = ConvertAbilityRealLevelField('Ncs4')
    constant abilityreallevelfield ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NCS5                       = ConvertAbilityRealLevelField('Ncs5')
    constant abilityreallevelfield ABILITY_RLF_EFFECT_DURATION                                   = ConvertAbilityRealLevelField('Ncs6')
    constant abilityreallevelfield ABILITY_RLF_SPAWN_INTERVAL_NSY1                               = ConvertAbilityRealLevelField('Nsy1')
    constant abilityreallevelfield ABILITY_RLF_SPAWN_UNIT_DURATION                               = ConvertAbilityRealLevelField('Nsy3')
    constant abilityreallevelfield ABILITY_RLF_SPAWN_UNIT_OFFSET                                 = ConvertAbilityRealLevelField('Nsy4')
    constant abilityreallevelfield ABILITY_RLF_LEASH_RANGE_NSY5                                  = ConvertAbilityRealLevelField('Nsy5')
    constant abilityreallevelfield ABILITY_RLF_SPAWN_INTERVAL_NFY1                               = ConvertAbilityRealLevelField('Nfy1')
    constant abilityreallevelfield ABILITY_RLF_LEASH_RANGE_NFY2                                  = ConvertAbilityRealLevelField('Nfy2')
    constant abilityreallevelfield ABILITY_RLF_CHANCE_TO_DEMOLISH                                = ConvertAbilityRealLevelField('Nde1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_MULTIPLIER_BUILDINGS                       = ConvertAbilityRealLevelField('Nde2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_MULTIPLIER_UNITS                           = ConvertAbilityRealLevelField('Nde3')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_MULTIPLIER_HEROES                          = ConvertAbilityRealLevelField('Nde4')
    constant abilityreallevelfield ABILITY_RLF_BONUS_DAMAGE_MULTIPLIER                           = ConvertAbilityRealLevelField('Nic1')
    constant abilityreallevelfield ABILITY_RLF_DEATH_DAMAGE_FULL_AMOUNT                          = ConvertAbilityRealLevelField('Nic2')
    constant abilityreallevelfield ABILITY_RLF_DEATH_DAMAGE_FULL_AREA                            = ConvertAbilityRealLevelField('Nic3')
    constant abilityreallevelfield ABILITY_RLF_DEATH_DAMAGE_HALF_AMOUNT                          = ConvertAbilityRealLevelField('Nic4')
    constant abilityreallevelfield ABILITY_RLF_DEATH_DAMAGE_HALF_AREA                            = ConvertAbilityRealLevelField('Nic5')
    constant abilityreallevelfield ABILITY_RLF_DEATH_DAMAGE_DELAY                                = ConvertAbilityRealLevelField('Nic6')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_AMOUNT_NSO1                                = ConvertAbilityRealLevelField('Nso1')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PERIOD                                     = ConvertAbilityRealLevelField('Nso2')
    constant abilityreallevelfield ABILITY_RLF_DAMAGE_PENALTY                                    = ConvertAbilityRealLevelField('Nso3')
    constant abilityreallevelfield ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NSO4             = ConvertAbilityRealLevelField('Nso4')
    constant abilityreallevelfield ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NSO5               = ConvertAbilityRealLevelField('Nso5')
    constant abilityreallevelfield ABILITY_RLF_SPLIT_DELAY                                       = ConvertAbilityRealLevelField('Nlm2')
    constant abilityreallevelfield ABILITY_RLF_MAX_HITPOINT_FACTOR                               = ConvertAbilityRealLevelField('Nlm4')
    constant abilityreallevelfield ABILITY_RLF_LIFE_DURATION_SPLIT_BONUS                         = ConvertAbilityRealLevelField('Nlm5')
    constant abilityreallevelfield ABILITY_RLF_WAVE_INTERVAL                                     = ConvertAbilityRealLevelField('Nvc3')
    constant abilityreallevelfield ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NVC4                       = ConvertAbilityRealLevelField('Nvc4')
    constant abilityreallevelfield ABILITY_RLF_FULL_DAMAGE_AMOUNT_NVC5                           = ConvertAbilityRealLevelField('Nvc5')
    constant abilityreallevelfield ABILITY_RLF_HALF_DAMAGE_FACTOR                                = ConvertAbilityRealLevelField('Nvc6')
    constant abilityreallevelfield ABILITY_RLF_INTERVAL_BETWEEN_PULSES                           = ConvertAbilityRealLevelField('Tau5')

    constant abilitybooleanlevelfield ABILITY_BLF_PERCENT_BONUS_HAB2            = ConvertAbilityBooleanLevelField('Hab2')
    constant abilitybooleanlevelfield ABILITY_BLF_USE_TELEPORT_CLUSTERING_HMT3  = ConvertAbilityBooleanLevelField('Hmt3')
    constant abilitybooleanlevelfield ABILITY_BLF_NEVER_MISS_OCR5               = ConvertAbilityBooleanLevelField('Ocr5')
    constant abilitybooleanlevelfield ABILITY_BLF_EXCLUDE_ITEM_DAMAGE           = ConvertAbilityBooleanLevelField('Ocr6')
    constant abilitybooleanlevelfield ABILITY_BLF_BACKSTAB_DAMAGE               = ConvertAbilityBooleanLevelField('Owk4')
    constant abilitybooleanlevelfield ABILITY_BLF_INHERIT_UPGRADES_UAN3         = ConvertAbilityBooleanLevelField('Uan3')
    constant abilitybooleanlevelfield ABILITY_BLF_MANA_CONVERSION_AS_PERCENT    = ConvertAbilityBooleanLevelField('Udp3')
    constant abilitybooleanlevelfield ABILITY_BLF_LIFE_CONVERSION_AS_PERCENT    = ConvertAbilityBooleanLevelField('Udp4')
    constant abilitybooleanlevelfield ABILITY_BLF_LEAVE_TARGET_ALIVE            = ConvertAbilityBooleanLevelField('Udp5')
    constant abilitybooleanlevelfield ABILITY_BLF_PERCENT_BONUS_UAU3            = ConvertAbilityBooleanLevelField('Uau3')
    constant abilitybooleanlevelfield ABILITY_BLF_DAMAGE_IS_PERCENT_RECEIVED    = ConvertAbilityBooleanLevelField('Eah2')
    constant abilitybooleanlevelfield ABILITY_BLF_MELEE_BONUS                   = ConvertAbilityBooleanLevelField('Ear2')
    constant abilitybooleanlevelfield ABILITY_BLF_RANGED_BONUS                  = ConvertAbilityBooleanLevelField('Ear3')
    constant abilitybooleanlevelfield ABILITY_BLF_FLAT_BONUS                    = ConvertAbilityBooleanLevelField('Ear4')
    constant abilitybooleanlevelfield ABILITY_BLF_NEVER_MISS_HBH5               = ConvertAbilityBooleanLevelField('Hbh5')
    constant abilitybooleanlevelfield ABILITY_BLF_PERCENT_BONUS_HAD2            = ConvertAbilityBooleanLevelField('Had2')
    constant abilitybooleanlevelfield ABILITY_BLF_CAN_DEACTIVATE                = ConvertAbilityBooleanLevelField('Hds1')
    constant abilitybooleanlevelfield ABILITY_BLF_RAISED_UNITS_ARE_INVULNERABLE = ConvertAbilityBooleanLevelField('Hre2')
    constant abilitybooleanlevelfield ABILITY_BLF_PERCENTAGE_OAR2               = ConvertAbilityBooleanLevelField('Oar2')
    constant abilitybooleanlevelfield ABILITY_BLF_SUMMON_BUSY_UNITS             = ConvertAbilityBooleanLevelField('Btl2')
    constant abilitybooleanlevelfield ABILITY_BLF_CREATES_BLIGHT                = ConvertAbilityBooleanLevelField('Bli2')
    constant abilitybooleanlevelfield ABILITY_BLF_EXPLODES_ON_DEATH             = ConvertAbilityBooleanLevelField('Sds6')
    constant abilitybooleanlevelfield ABILITY_BLF_ALWAYS_AUTOCAST_FAE2          = ConvertAbilityBooleanLevelField('Fae2')
    constant abilitybooleanlevelfield ABILITY_BLF_REGENERATE_ONLY_AT_NIGHT      = ConvertAbilityBooleanLevelField('Mbt5')
    constant abilitybooleanlevelfield ABILITY_BLF_SHOW_SELECT_UNIT_BUTTON       = ConvertAbilityBooleanLevelField('Neu3')
    constant abilitybooleanlevelfield ABILITY_BLF_SHOW_UNIT_INDICATOR           = ConvertAbilityBooleanLevelField('Neu4')
    constant abilitybooleanlevelfield ABILITY_BLF_CHARGE_OWNING_PLAYER          = ConvertAbilityBooleanLevelField('Ans6')
    constant abilitybooleanlevelfield ABILITY_BLF_PERCENTAGE_ARM2               = ConvertAbilityBooleanLevelField('Arm2')
    constant abilitybooleanlevelfield ABILITY_BLF_TARGET_IS_INVULNERABLE        = ConvertAbilityBooleanLevelField('Pos3')
    constant abilitybooleanlevelfield ABILITY_BLF_TARGET_IS_MAGIC_IMMUNE        = ConvertAbilityBooleanLevelField('Pos4')
    constant abilitybooleanlevelfield ABILITY_BLF_KILL_ON_CASTER_DEATH          = ConvertAbilityBooleanLevelField('Ucb6')
    constant abilitybooleanlevelfield ABILITY_BLF_NO_TARGET_REQUIRED_REJ4       = ConvertAbilityBooleanLevelField('Rej4')
    constant abilitybooleanlevelfield ABILITY_BLF_ACCEPTS_GOLD                  = ConvertAbilityBooleanLevelField('Rtn1')
    constant abilitybooleanlevelfield ABILITY_BLF_ACCEPTS_LUMBER                = ConvertAbilityBooleanLevelField('Rtn2')
    constant abilitybooleanlevelfield ABILITY_BLF_PREFER_HOSTILES_ROA5          = ConvertAbilityBooleanLevelField('Roa5')
    constant abilitybooleanlevelfield ABILITY_BLF_PREFER_FRIENDLIES_ROA6        = ConvertAbilityBooleanLevelField('Roa6')
    constant abilitybooleanlevelfield ABILITY_BLF_ROOTED_TURNING                = ConvertAbilityBooleanLevelField('Roo3')
    constant abilitybooleanlevelfield ABILITY_BLF_ALWAYS_AUTOCAST_SLO3          = ConvertAbilityBooleanLevelField('Slo3')
    constant abilitybooleanlevelfield ABILITY_BLF_HIDE_BUTTON                   = ConvertAbilityBooleanLevelField('Ihid')
    constant abilitybooleanlevelfield ABILITY_BLF_USE_TELEPORT_CLUSTERING_ITP2  = ConvertAbilityBooleanLevelField('Itp2')
    constant abilitybooleanlevelfield ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS       = ConvertAbilityBooleanLevelField('Eth1')
    constant abilitybooleanlevelfield ABILITY_BLF_DOES_NOT_BLOCK_BUILDINGS      = ConvertAbilityBooleanLevelField('Eth2')
    constant abilitybooleanlevelfield ABILITY_BLF_AUTO_ACQUIRE_ATTACK_TARGETS   = ConvertAbilityBooleanLevelField('Gho1')
    constant abilitybooleanlevelfield ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS_GHO2  = ConvertAbilityBooleanLevelField('Gho2')
    constant abilitybooleanlevelfield ABILITY_BLF_DO_NOT_BLOCK_BUILDINGS        = ConvertAbilityBooleanLevelField('Gho3')
    constant abilitybooleanlevelfield ABILITY_BLF_INCLUDE_RANGED_DAMAGE         = ConvertAbilityBooleanLevelField('Ssk4')
    constant abilitybooleanlevelfield ABILITY_BLF_INCLUDE_MELEE_DAMAGE          = ConvertAbilityBooleanLevelField('Ssk5')
    constant abilitybooleanlevelfield ABILITY_BLF_MOVE_TO_PARTNER               = ConvertAbilityBooleanLevelField('coa2')
    constant abilitybooleanlevelfield ABILITY_BLF_CAN_BE_DISPELLED              = ConvertAbilityBooleanLevelField('cyc1')
    constant abilitybooleanlevelfield ABILITY_BLF_IGNORE_FRIENDLY_BUFFS         = ConvertAbilityBooleanLevelField('dvm6')
    constant abilitybooleanlevelfield ABILITY_BLF_DROP_ITEMS_ON_DEATH           = ConvertAbilityBooleanLevelField('inv2')
    constant abilitybooleanlevelfield ABILITY_BLF_CAN_USE_ITEMS                 = ConvertAbilityBooleanLevelField('inv3')
    constant abilitybooleanlevelfield ABILITY_BLF_CAN_GET_ITEMS                 = ConvertAbilityBooleanLevelField('inv4')
    constant abilitybooleanlevelfield ABILITY_BLF_CAN_DROP_ITEMS                = ConvertAbilityBooleanLevelField('inv5')
    constant abilitybooleanlevelfield ABILITY_BLF_REPAIRS_ALLOWED               = ConvertAbilityBooleanLevelField('liq4')
    constant abilitybooleanlevelfield ABILITY_BLF_CASTER_ONLY_SPLASH            = ConvertAbilityBooleanLevelField('mfl6')
    constant abilitybooleanlevelfield ABILITY_BLF_NO_TARGET_REQUIRED_IRL4       = ConvertAbilityBooleanLevelField('irl4')
    constant abilitybooleanlevelfield ABILITY_BLF_DISPEL_ON_ATTACK              = ConvertAbilityBooleanLevelField('irl5')
    constant abilitybooleanlevelfield ABILITY_BLF_AMOUNT_IS_RAW_VALUE           = ConvertAbilityBooleanLevelField('ipv3')
    constant abilitybooleanlevelfield ABILITY_BLF_SHARED_SPELL_COOLDOWN         = ConvertAbilityBooleanLevelField('spb2')
    constant abilitybooleanlevelfield ABILITY_BLF_SLEEP_ONCE                    = ConvertAbilityBooleanLevelField('sla1')
    constant abilitybooleanlevelfield ABILITY_BLF_ALLOW_ON_ANY_PLAYER_SLOT      = ConvertAbilityBooleanLevelField('sla2')
    constant abilitybooleanlevelfield ABILITY_BLF_DISABLE_OTHER_ABILITIES       = ConvertAbilityBooleanLevelField('Ncl5')
    constant abilitybooleanlevelfield ABILITY_BLF_ALLOW_BOUNTY                  = ConvertAbilityBooleanLevelField('Ntm4')

    constant abilitystringlevelfield ABILITY_SLF_ICON_NORMAL                    = ConvertAbilityStringLevelField('aart')
    constant abilitystringlevelfield ABILITY_SLF_CASTER                         = ConvertAbilityStringLevelField('acat')
    constant abilitystringlevelfield ABILITY_SLF_TARGET                         = ConvertAbilityStringLevelField('atat')
    constant abilitystringlevelfield ABILITY_SLF_SPECIAL                        = ConvertAbilityStringLevelField('asat')
    constant abilitystringlevelfield ABILITY_SLF_EFFECT                         = ConvertAbilityStringLevelField('aeat')
    constant abilitystringlevelfield ABILITY_SLF_AREA_EFFECT                    = ConvertAbilityStringLevelField('aaea')
    constant abilitystringlevelfield ABILITY_SLF_LIGHTNING_EFFECTS              = ConvertAbilityStringLevelField('alig')
    constant abilitystringlevelfield ABILITY_SLF_MISSILE_ART                    = ConvertAbilityStringLevelField('amat')
    constant abilitystringlevelfield ABILITY_SLF_TOOLTIP_LEARN                  = ConvertAbilityStringLevelField('aret')
    constant abilitystringlevelfield ABILITY_SLF_TOOLTIP_LEARN_EXTENDED         = ConvertAbilityStringLevelField('arut')
    constant abilitystringlevelfield ABILITY_SLF_TOOLTIP_NORMAL                 = ConvertAbilityStringLevelField('atp1')
    constant abilitystringlevelfield ABILITY_SLF_TOOLTIP_TURN_OFF               = ConvertAbilityStringLevelField('aut1')
    constant abilitystringlevelfield ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED        = ConvertAbilityStringLevelField('aub1')
    constant abilitystringlevelfield ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED      = ConvertAbilityStringLevelField('auu1')
    constant abilitystringlevelfield ABILITY_SLF_NORMAL_FORM_UNIT_EME1          = ConvertAbilityStringLevelField('Eme1')
    constant abilitystringlevelfield ABILITY_SLF_SPAWNED_UNITS                  = ConvertAbilityStringLevelField('Ndp1')
    constant abilitystringlevelfield ABILITY_SLF_ABILITY_FOR_UNIT_CREATION      = ConvertAbilityStringLevelField('Nrc1')
    constant abilitystringlevelfield ABILITY_SLF_NORMAL_FORM_UNIT_MIL1          = ConvertAbilityStringLevelField('Mil1')
    constant abilitystringlevelfield ABILITY_SLF_ALTERNATE_FORM_UNIT_MIL2       = ConvertAbilityStringLevelField('Mil2')
    constant abilitystringlevelfield ABILITY_SLF_BASE_ORDER_ID_ANS5             = ConvertAbilityStringLevelField('Ans5')
    constant abilitystringlevelfield ABILITY_SLF_MORPH_UNITS_GROUND             = ConvertAbilityStringLevelField('Ply2')
    constant abilitystringlevelfield ABILITY_SLF_MORPH_UNITS_AIR                = ConvertAbilityStringLevelField('Ply3')
    constant abilitystringlevelfield ABILITY_SLF_MORPH_UNITS_AMPHIBIOUS         = ConvertAbilityStringLevelField('Ply4')
    constant abilitystringlevelfield ABILITY_SLF_MORPH_UNITS_WATER              = ConvertAbilityStringLevelField('Ply5')
    constant abilitystringlevelfield ABILITY_SLF_UNIT_TYPE_ONE                  = ConvertAbilityStringLevelField('Rai3')
    constant abilitystringlevelfield ABILITY_SLF_UNIT_TYPE_TWO                  = ConvertAbilityStringLevelField('Rai4')
    constant abilitystringlevelfield ABILITY_SLF_UNIT_TYPE_SOD2                 = ConvertAbilityStringLevelField('Sod2')
    constant abilitystringlevelfield ABILITY_SLF_SUMMON_1_UNIT_TYPE             = ConvertAbilityStringLevelField('Ist1')
    constant abilitystringlevelfield ABILITY_SLF_SUMMON_2_UNIT_TYPE             = ConvertAbilityStringLevelField('Ist2')
    constant abilitystringlevelfield ABILITY_SLF_RACE_TO_CONVERT                = ConvertAbilityStringLevelField('Ndc1')
    constant abilitystringlevelfield ABILITY_SLF_PARTNER_UNIT_TYPE              = ConvertAbilityStringLevelField('coa1')
    constant abilitystringlevelfield ABILITY_SLF_PARTNER_UNIT_TYPE_ONE          = ConvertAbilityStringLevelField('dcp1')
    constant abilitystringlevelfield ABILITY_SLF_PARTNER_UNIT_TYPE_TWO          = ConvertAbilityStringLevelField('dcp2')
    constant abilitystringlevelfield ABILITY_SLF_REQUIRED_UNIT_TYPE             = ConvertAbilityStringLevelField('tpi1')
    constant abilitystringlevelfield ABILITY_SLF_CONVERTED_UNIT_TYPE            = ConvertAbilityStringLevelField('tpi2')
    constant abilitystringlevelfield ABILITY_SLF_SPELL_LIST                     = ConvertAbilityStringLevelField('spb1')
    constant abilitystringlevelfield ABILITY_SLF_BASE_ORDER_ID_SPB5             = ConvertAbilityStringLevelField('spb5')
    constant abilitystringlevelfield ABILITY_SLF_BASE_ORDER_ID_NCL6             = ConvertAbilityStringLevelField('Ncl6')
    constant abilitystringlevelfield ABILITY_SLF_ABILITY_UPGRADE_1              = ConvertAbilityStringLevelField('Neg3')
    constant abilitystringlevelfield ABILITY_SLF_ABILITY_UPGRADE_2              = ConvertAbilityStringLevelField('Neg4')
    constant abilitystringlevelfield ABILITY_SLF_ABILITY_UPGRADE_3              = ConvertAbilityStringLevelField('Neg5')
    constant abilitystringlevelfield ABILITY_SLF_ABILITY_UPGRADE_4              = ConvertAbilityStringLevelField('Neg6')
    constant abilitystringlevelfield ABILITY_SLF_SPAWN_UNIT_ID_NSY2             = ConvertAbilityStringLevelField('Nsy2')

    // Item
    constant itemintegerfield ITEM_IF_LEVEL                 = ConvertItemIntegerField('ilev')
    constant itemintegerfield ITEM_IF_NUMBER_OF_CHARGES     = ConvertItemIntegerField('iuse')
    constant itemintegerfield ITEM_IF_COOLDOWN_GROUP        = ConvertItemIntegerField('icid')
    constant itemintegerfield ITEM_IF_MAX_HIT_POINTS        = ConvertItemIntegerField('ihtp')
    constant itemintegerfield ITEM_IF_HIT_POINTS            = ConvertItemIntegerField('ihpc')
    constant itemintegerfield ITEM_IF_PRIORITY              = ConvertItemIntegerField('ipri')
    constant itemintegerfield ITEM_IF_ARMOR_TYPE            = ConvertItemIntegerField('iarm')
    constant itemintegerfield ITEM_IF_TINTING_COLOR_RED     = ConvertItemIntegerField('iclr')
    constant itemintegerfield ITEM_IF_TINTING_COLOR_GREEN   = ConvertItemIntegerField('iclg')
    constant itemintegerfield ITEM_IF_TINTING_COLOR_BLUE    = ConvertItemIntegerField('iclb')
    constant itemintegerfield ITEM_IF_TINTING_COLOR_ALPHA   = ConvertItemIntegerField('ical')

    constant itemrealfield ITEM_RF_SCALING_VALUE            = ConvertItemRealField('isca')

    constant itembooleanfield ITEM_BF_DROPPED_WHEN_CARRIER_DIES         = ConvertItemBooleanField('idrp')
    constant itembooleanfield ITEM_BF_CAN_BE_DROPPED                    = ConvertItemBooleanField('idro')
    constant itembooleanfield ITEM_BF_PERISHABLE                        = ConvertItemBooleanField('iper')
    constant itembooleanfield ITEM_BF_INCLUDE_AS_RANDOM_CHOICE          = ConvertItemBooleanField('iprn')
    constant itembooleanfield ITEM_BF_USE_AUTOMATICALLY_WHEN_ACQUIRED   = ConvertItemBooleanField('ipow')
    constant itembooleanfield ITEM_BF_CAN_BE_SOLD_TO_MERCHANTS          = ConvertItemBooleanField('ipaw')
    constant itembooleanfield ITEM_BF_ACTIVELY_USED                     = ConvertItemBooleanField('iusa')

    constant itemstringfield ITEM_SF_MODEL_USED                         = ConvertItemStringField('ifil')

    // Unit
    constant unitintegerfield UNIT_IF_DEFENSE_TYPE                          = ConvertUnitIntegerField('udty')
    constant unitintegerfield UNIT_IF_ARMOR_TYPE                            = ConvertUnitIntegerField('uarm')
    constant unitintegerfield UNIT_IF_LOOPING_FADE_IN_RATE                  = ConvertUnitIntegerField('ulfi')
    constant unitintegerfield UNIT_IF_LOOPING_FADE_OUT_RATE                 = ConvertUnitIntegerField('ulfo')
    constant unitintegerfield UNIT_IF_AGILITY                               = ConvertUnitIntegerField('uagc')
    constant unitintegerfield UNIT_IF_INTELLIGENCE                          = ConvertUnitIntegerField('uinc')
    constant unitintegerfield UNIT_IF_STRENGTH                              = ConvertUnitIntegerField('ustc')
    constant unitintegerfield UNIT_IF_AGILITY_PERMANENT                     = ConvertUnitIntegerField('uagm')
    constant unitintegerfield UNIT_IF_INTELLIGENCE_PERMANENT                = ConvertUnitIntegerField('uinm')
    constant unitintegerfield UNIT_IF_STRENGTH_PERMANENT                    = ConvertUnitIntegerField('ustm')
    constant unitintegerfield UNIT_IF_AGILITY_WITH_BONUS                    = ConvertUnitIntegerField('uagb')
    constant unitintegerfield UNIT_IF_INTELLIGENCE_WITH_BONUS               = ConvertUnitIntegerField('uinb')
    constant unitintegerfield UNIT_IF_STRENGTH_WITH_BONUS                   = ConvertUnitIntegerField('ustb')
    constant unitintegerfield UNIT_IF_GOLD_BOUNTY_AWARDED_NUMBER_OF_DICE    = ConvertUnitIntegerField('ubdi')
    constant unitintegerfield UNIT_IF_GOLD_BOUNTY_AWARDED_BASE              = ConvertUnitIntegerField('ubba')
    constant unitintegerfield UNIT_IF_GOLD_BOUNTY_AWARDED_SIDES_PER_DIE     = ConvertUnitIntegerField('ubsi')
    constant unitintegerfield UNIT_IF_LUMBER_BOUNTY_AWARDED_NUMBER_OF_DICE  = ConvertUnitIntegerField('ulbd')
    constant unitintegerfield UNIT_IF_LUMBER_BOUNTY_AWARDED_BASE            = ConvertUnitIntegerField('ulba')
    constant unitintegerfield UNIT_IF_LUMBER_BOUNTY_AWARDED_SIDES_PER_DIE   = ConvertUnitIntegerField('ulbs')
    constant unitintegerfield UNIT_IF_LEVEL                                 = ConvertUnitIntegerField('ulev')
    constant unitintegerfield UNIT_IF_FORMATION_RANK                        = ConvertUnitIntegerField('ufor')
    constant unitintegerfield UNIT_IF_ORIENTATION_INTERPOLATION             = ConvertUnitIntegerField('uori')
    constant unitintegerfield UNIT_IF_ELEVATION_SAMPLE_POINTS               = ConvertUnitIntegerField('uept')
    constant unitintegerfield UNIT_IF_TINTING_COLOR_RED                     = ConvertUnitIntegerField('uclr')
    constant unitintegerfield UNIT_IF_TINTING_COLOR_GREEN                   = ConvertUnitIntegerField('uclg')
    constant unitintegerfield UNIT_IF_TINTING_COLOR_BLUE                    = ConvertUnitIntegerField('uclb')
    constant unitintegerfield UNIT_IF_TINTING_COLOR_ALPHA                   = ConvertUnitIntegerField('ucal')
    constant unitintegerfield UNIT_IF_MOVE_TYPE                             = ConvertUnitIntegerField('umvt')
    constant unitintegerfield UNIT_IF_TARGETED_AS                           = ConvertUnitIntegerField('utar')
    constant unitintegerfield UNIT_IF_UNIT_CLASSIFICATION                   = ConvertUnitIntegerField('utyp')
    constant unitintegerfield UNIT_IF_HIT_POINTS_REGENERATION_TYPE          = ConvertUnitIntegerField('uhrt')
    constant unitintegerfield UNIT_IF_PLACEMENT_PREVENTED_BY                = ConvertUnitIntegerField('upar')
    constant unitintegerfield UNIT_IF_PRIMARY_ATTRIBUTE                     = ConvertUnitIntegerField('upra')

    constant unitrealfield UNIT_RF_STRENGTH_PER_LEVEL                       = ConvertUnitRealField('ustp')
    constant unitrealfield UNIT_RF_AGILITY_PER_LEVEL                        = ConvertUnitRealField('uagp')
    constant unitrealfield UNIT_RF_INTELLIGENCE_PER_LEVEL                   = ConvertUnitRealField('uinp')
    constant unitrealfield UNIT_RF_HIT_POINTS_REGENERATION_RATE             = ConvertUnitRealField('uhpr')
    constant unitrealfield UNIT_RF_MANA_REGENERATION                        = ConvertUnitRealField('umpr')
    constant unitrealfield UNIT_RF_DEATH_TIME                               = ConvertUnitRealField('udtm')
    constant unitrealfield UNIT_RF_FLY_HEIGHT                               = ConvertUnitRealField('ufyh')
    constant unitrealfield UNIT_RF_TURN_RATE                                = ConvertUnitRealField('umvr')
    constant unitrealfield UNIT_RF_ELEVATION_SAMPLE_RADIUS                  = ConvertUnitRealField('uerd')
    constant unitrealfield UNIT_RF_FOG_OF_WAR_SAMPLE_RADIUS                 = ConvertUnitRealField('ufrd')
    constant unitrealfield UNIT_RF_MAXIMUM_PITCH_ANGLE_DEGREES              = ConvertUnitRealField('umxp')
    constant unitrealfield UNIT_RF_MAXIMUM_ROLL_ANGLE_DEGREES               = ConvertUnitRealField('umxr')
    constant unitrealfield UNIT_RF_SCALING_VALUE                            = ConvertUnitRealField('usca')
    constant unitrealfield UNIT_RF_ANIMATION_RUN_SPEED                      = ConvertUnitRealField('urun')
    constant unitrealfield UNIT_RF_SELECTION_SCALE                          = ConvertUnitRealField('ussc')
    constant unitrealfield UNIT_RF_SELECTION_CIRCLE_HEIGHT                  = ConvertUnitRealField('uslz')
    constant unitrealfield UNIT_RF_SHADOW_IMAGE_HEIGHT                      = ConvertUnitRealField('ushh')
    constant unitrealfield UNIT_RF_SHADOW_IMAGE_WIDTH                       = ConvertUnitRealField('ushw')
    constant unitrealfield UNIT_RF_SHADOW_IMAGE_CENTER_X                    = ConvertUnitRealField('ushx')
    constant unitrealfield UNIT_RF_SHADOW_IMAGE_CENTER_Y                    = ConvertUnitRealField('ushy')
    constant unitrealfield UNIT_RF_ANIMATION_WALK_SPEED                     = ConvertUnitRealField('uwal')
    constant unitrealfield UNIT_RF_DEFENSE                                  = ConvertUnitRealField('udfc')
    constant unitrealfield UNIT_RF_SIGHT_RADIUS                             = ConvertUnitRealField('usir')
    constant unitrealfield UNIT_RF_PRIORITY                                 = ConvertUnitRealField('upri')
    constant unitrealfield UNIT_RF_SPEED                                    = ConvertUnitRealField('umvc')
    constant unitrealfield UNIT_RF_OCCLUDER_HEIGHT                          = ConvertUnitRealField('uocc')
    constant unitrealfield UNIT_RF_HP                                       = ConvertUnitRealField('uhpc')
    constant unitrealfield UNIT_RF_MANA                                     = ConvertUnitRealField('umpc')
    constant unitrealfield UNIT_RF_ACQUISITION_RANGE                        = ConvertUnitRealField('uacq')
    constant unitrealfield UNIT_RF_CAST_BACK_SWING                          = ConvertUnitRealField('ucbs')
    constant unitrealfield UNIT_RF_CAST_POINT                               = ConvertUnitRealField('ucpt')
    constant unitrealfield UNIT_RF_MINIMUM_ATTACK_RANGE                     = ConvertUnitRealField('uamn')

    constant unitbooleanfield UNIT_BF_RAISABLE                              = ConvertUnitBooleanField('urai')
    constant unitbooleanfield UNIT_BF_DECAYABLE                             = ConvertUnitBooleanField('udec')
    constant unitbooleanfield UNIT_BF_IS_A_BUILDING                         = ConvertUnitBooleanField('ubdg')
    constant unitbooleanfield UNIT_BF_USE_EXTENDED_LINE_OF_SIGHT            = ConvertUnitBooleanField('ulos')
    constant unitbooleanfield UNIT_BF_NEUTRAL_BUILDING_SHOWS_MINIMAP_ICON   = ConvertUnitBooleanField('unbm')
    constant unitbooleanfield UNIT_BF_HERO_HIDE_HERO_INTERFACE_ICON         = ConvertUnitBooleanField('uhhb')
    constant unitbooleanfield UNIT_BF_HERO_HIDE_HERO_MINIMAP_DISPLAY        = ConvertUnitBooleanField('uhhm')
    constant unitbooleanfield UNIT_BF_HERO_HIDE_HERO_DEATH_MESSAGE          = ConvertUnitBooleanField('uhhd')
    constant unitbooleanfield UNIT_BF_HIDE_MINIMAP_DISPLAY                  = ConvertUnitBooleanField('uhom')
    constant unitbooleanfield UNIT_BF_SCALE_PROJECTILES                     = ConvertUnitBooleanField('uscb')
    constant unitbooleanfield UNIT_BF_SELECTION_CIRCLE_ON_WATER             = ConvertUnitBooleanField('usew')
    constant unitbooleanfield UNIT_BF_HAS_WATER_SHADOW                      = ConvertUnitBooleanField('ushr')

    constant unitstringfield UNIT_SF_NAME                   = ConvertUnitStringField('unam')
    constant unitstringfield UNIT_SF_PROPER_NAMES           = ConvertUnitStringField('upro')
    constant unitstringfield UNIT_SF_GROUND_TEXTURE         = ConvertUnitStringField('uubs')
    constant unitstringfield UNIT_SF_SHADOW_IMAGE_UNIT      = ConvertUnitStringField('ushu')

    // Unit Weapon
    constant unitweaponintegerfield UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE     = ConvertUnitWeaponIntegerField('ua1d')
    constant unitweaponintegerfield UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE               = ConvertUnitWeaponIntegerField('ua1b')
    constant unitweaponintegerfield UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE      = ConvertUnitWeaponIntegerField('ua1s')
    constant unitweaponintegerfield UNIT_WEAPON_IF_ATTACK_MAXIMUM_NUMBER_OF_TARGETS = ConvertUnitWeaponIntegerField('utc1')
    constant unitweaponintegerfield UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE               = ConvertUnitWeaponIntegerField('ua1t')
    constant unitweaponintegerfield UNIT_WEAPON_IF_ATTACK_WEAPON_SOUND              = ConvertUnitWeaponIntegerField('ucs1')
    constant unitweaponintegerfield UNIT_WEAPON_IF_ATTACK_AREA_OF_EFFECT_TARGETS    = ConvertUnitWeaponIntegerField('ua1p')
    constant unitweaponintegerfield UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED           = ConvertUnitWeaponIntegerField('ua1g')

    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_BACKSWING_POINT              = ConvertUnitWeaponRealField('ubs1')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_DAMAGE_POINT                 = ConvertUnitWeaponRealField('udp1')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN                = ConvertUnitWeaponRealField('ua1c')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_DAMAGE_LOSS_FACTOR           = ConvertUnitWeaponRealField('udl1')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_MEDIUM         = ConvertUnitWeaponRealField('uhd1')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_SMALL          = ConvertUnitWeaponRealField('uqd1')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_DISTANCE        = ConvertUnitWeaponRealField('usd1')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_RADIUS          = ConvertUnitWeaponRealField('usr1')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_PROJECTILE_SPEED             = ConvertUnitWeaponRealField('ua1z')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_PROJECTILE_ARC               = ConvertUnitWeaponRealField('uma1')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_FULL_DAMAGE   = ConvertUnitWeaponRealField('ua1f')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_MEDIUM_DAMAGE = ConvertUnitWeaponRealField('ua1h')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_SMALL_DAMAGE  = ConvertUnitWeaponRealField('ua1q')
    constant unitweaponrealfield UNIT_WEAPON_RF_ATTACK_RANGE                        = ConvertUnitWeaponRealField('ua1r')

    constant unitweaponbooleanfield UNIT_WEAPON_BF_ATTACK_SHOW_UI                   = ConvertUnitWeaponBooleanField('uwu1')
    constant unitweaponbooleanfield UNIT_WEAPON_BF_ATTACKS_ENABLED                  = ConvertUnitWeaponBooleanField('uaen')
    constant unitweaponbooleanfield UNIT_WEAPON_BF_ATTACK_PROJECTILE_HOMING_ENABLED = ConvertUnitWeaponBooleanField('umh1')
    
    constant unitweaponstringfield UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART             = ConvertUnitWeaponStringField('ua1m')

    // Move Type
    constant movetype       MOVE_TYPE_UNKNOWN               = ConvertMoveType(0)
    constant movetype       MOVE_TYPE_FOOT                  = ConvertMoveType(1)
    constant movetype       MOVE_TYPE_FLY                   = ConvertMoveType(2)
    constant movetype       MOVE_TYPE_HORSE                 = ConvertMoveType(4)
    constant movetype       MOVE_TYPE_HOVER                 = ConvertMoveType(8)
    constant movetype       MOVE_TYPE_FLOAT                 = ConvertMoveType(16)
    constant movetype       MOVE_TYPE_AMPHIBIOUS            = ConvertMoveType(32)
    constant movetype       MOVE_TYPE_UNBUILDABLE           = ConvertMoveType(64)
    
    // Target Flag
    constant targetflag     TARGET_FLAG_NONE                = ConvertTargetFlag(1)
    constant targetflag     TARGET_FLAG_GROUND              = ConvertTargetFlag(2)
    constant targetflag     TARGET_FLAG_AIR                 = ConvertTargetFlag(4)
    constant targetflag     TARGET_FLAG_STRUCTURE           = ConvertTargetFlag(8)
    constant targetflag     TARGET_FLAG_WARD                = ConvertTargetFlag(16)
    constant targetflag     TARGET_FLAG_ITEM                = ConvertTargetFlag(32)
    constant targetflag     TARGET_FLAG_TREE                = ConvertTargetFlag(64)
    constant targetflag     TARGET_FLAG_WALL                = ConvertTargetFlag(128)
    constant targetflag     TARGET_FLAG_DEBRIS              = ConvertTargetFlag(256)
    constant targetflag     TARGET_FLAG_DECORATION          = ConvertTargetFlag(512)
    constant targetflag     TARGET_FLAG_BRIDGE              = ConvertTargetFlag(1024)

    // defense type
    constant defensetype    DEFENSE_TYPE_LIGHT              = ConvertDefenseType(0)
    constant defensetype    DEFENSE_TYPE_MEDIUM             = ConvertDefenseType(1)
    constant defensetype    DEFENSE_TYPE_LARGE              = ConvertDefenseType(2)
    constant defensetype    DEFENSE_TYPE_FORT               = ConvertDefenseType(3)
    constant defensetype    DEFENSE_TYPE_NORMAL             = ConvertDefenseType(4)
    constant defensetype    DEFENSE_TYPE_HERO               = ConvertDefenseType(5)
    constant defensetype    DEFENSE_TYPE_DIVINE             = ConvertDefenseType(6)
    constant defensetype    DEFENSE_TYPE_NONE               = ConvertDefenseType(7)

    // Hero Attribute
    constant heroattribute  HERO_ATTRIBUTE_STR              = ConvertHeroAttribute(1)
    constant heroattribute  HERO_ATTRIBUTE_INT              = ConvertHeroAttribute(2)
    constant heroattribute  HERO_ATTRIBUTE_AGI              = ConvertHeroAttribute(3)

    // Armor Type
    constant armortype      ARMOR_TYPE_WHOKNOWS             = ConvertArmorType(0)
    constant armortype      ARMOR_TYPE_FLESH                = ConvertArmorType(1)
    constant armortype      ARMOR_TYPE_METAL                = ConvertArmorType(2)
    constant armortype      ARMOR_TYPE_WOOD                 = ConvertArmorType(3)
    constant armortype      ARMOR_TYPE_ETHREAL              = ConvertArmorType(4)
    constant armortype      ARMOR_TYPE_STONE                = ConvertArmorType(5)

    // Regeneration Type
    constant regentype      REGENERATION_TYPE_NONE          = ConvertRegenType(0)
    constant regentype      REGENERATION_TYPE_ALWAYS        = ConvertRegenType(1)
    constant regentype      REGENERATION_TYPE_BLIGHT        = ConvertRegenType(2)
    constant regentype      REGENERATION_TYPE_DAY           = ConvertRegenType(3)
    constant regentype      REGENERATION_TYPE_NIGHT         = ConvertRegenType(4)

    // Unit Category
    constant unitcategory   UNIT_CATEGORY_GIANT             = ConvertUnitCategory(1)
    constant unitcategory   UNIT_CATEGORY_UNDEAD            = ConvertUnitCategory(2)
    constant unitcategory   UNIT_CATEGORY_SUMMONED          = ConvertUnitCategory(4)
    constant unitcategory   UNIT_CATEGORY_MECHANICAL        = ConvertUnitCategory(8)
    constant unitcategory   UNIT_CATEGORY_PEON              = ConvertUnitCategory(16)
    constant unitcategory   UNIT_CATEGORY_SAPPER            = ConvertUnitCategory(32)
    constant unitcategory   UNIT_CATEGORY_TOWNHALL          = ConvertUnitCategory(64)
    constant unitcategory   UNIT_CATEGORY_ANCIENT           = ConvertUnitCategory(128)
    constant unitcategory   UNIT_CATEGORY_NEUTRAL           = ConvertUnitCategory(256)
    constant unitcategory   UNIT_CATEGORY_WARD              = ConvertUnitCategory(512)
    constant unitcategory   UNIT_CATEGORY_STANDON           = ConvertUnitCategory(1024)
    constant unitcategory   UNIT_CATEGORY_TAUREN            = ConvertUnitCategory(2048)

    // Pathing Flag
    constant pathingflag    PATHING_FLAG_UNWALKABLE             = ConvertPathingFlag(2)
    constant pathingflag    PATHING_FLAG_UNFLYABLE              = ConvertPathingFlag(4)
    constant pathingflag    PATHING_FLAG_UNBUILDABLE            = ConvertPathingFlag(8)
    constant pathingflag    PATHING_FLAG_UNPEONHARVEST          = ConvertPathingFlag(16)
    constant pathingflag    PATHING_FLAG_BLIGHTED               = ConvertPathingFlag(32)
    constant pathingflag    PATHING_FLAG_UNFLOATABLE            = ConvertPathingFlag(64)
    constant pathingflag    PATHING_FLAG_UNAMPHIBIOUS           = ConvertPathingFlag(128)
    constant pathingflag    PATHING_FLAG_UNITEMPLACABLE         = ConvertPathingFlag(256)

endglobals

//============================================================================
// MathAPI
native Deg2Rad  takes real degrees returns real
native Rad2Deg  takes real radians returns real

native Sin      takes real radians returns real
native Cos      takes real radians returns real
native Tan      takes real radians returns real

// Expect values between -1 and 1...returns 0 for invalid input
native Asin     takes real y returns real
native Acos     takes real x returns real

native Atan     takes real x returns real

// Returns 0 if x and y are both 0
native Atan2    takes real y, real x returns real

// Returns 0 if x <= 0
native SquareRoot takes real x returns real

// computes x to the y power
// y == 0.0             => 1
// x ==0.0 and y < 0    => 0
//
native Pow      takes real x, real power returns real

constant native MathRound takes real r returns integer

//============================================================================
// String Utility API
native I2R  takes integer i returns real
native R2I  takes real r returns integer
native I2S  takes integer i returns string
native R2S  takes real r returns string
native R2SW takes real r, integer width, integer precision returns string
native S2I  takes string s returns integer
native S2R  takes string s returns real
native GetHandleId takes handle h returns integer
native SubString takes string source, integer start, integer end returns string
native StringLength takes string s returns integer
native StringCase takes string source, boolean upper returns string
native StringHash takes string s returns integer

native GetLocalizedString takes string source returns string
native GetLocalizedHotkey takes string source returns integer

//============================================================================
// Map Setup API
//
//  These are native functions for describing the map configuration
//  these funcs should only be used in the "config" function of
//  a map script. The functions should also be called in this order
//  ( i.e. call SetPlayers before SetPlayerColor...
//

native SetMapName           takes string name returns nothing
native SetMapDescription    takes string description returns nothing

native SetTeams             takes integer teamcount returns nothing
native SetPlayers           takes integer playercount returns nothing

native DefineStartLocation          takes integer whichStartLoc, real x, real y returns nothing
native DefineStartLocationLoc       takes integer whichStartLoc, location whichLocation returns nothing
native SetStartLocPrioCount         takes integer whichStartLoc, integer prioSlotCount returns nothing
native SetStartLocPrio              takes integer whichStartLoc, integer prioSlotIndex, integer otherStartLocIndex, startlocprio priority returns nothing
native GetStartLocPrioSlot          takes integer whichStartLoc, integer prioSlotIndex returns integer
native GetStartLocPrio              takes integer whichStartLoc, integer prioSlotIndex returns startlocprio
native SetEnemyStartLocPrioCount    takes integer whichStartLoc, integer prioSlotCount returns nothing
native SetEnemyStartLocPrio         takes integer whichStartLoc, integer prioSlotIndex, integer otherStartLocIndex, startlocprio priority returns nothing

native SetGameTypeSupported takes gametype whichGameType, boolean value returns nothing
native SetMapFlag           takes mapflag whichMapFlag, boolean value returns nothing
native SetGamePlacement     takes placement whichPlacementType returns nothing
native SetGameSpeed         takes gamespeed whichspeed returns nothing
native SetGameDifficulty    takes gamedifficulty whichdifficulty returns nothing
native SetResourceDensity   takes mapdensity whichdensity returns nothing
native SetCreatureDensity   takes mapdensity whichdensity returns nothing

native GetTeams             takes nothing returns integer
native GetPlayers           takes nothing returns integer

native IsGameTypeSupported  takes gametype whichGameType returns boolean
native GetGameTypeSelected  takes nothing returns gametype
native IsMapFlagSet         takes mapflag whichMapFlag returns boolean

constant native GetGamePlacement     takes nothing returns placement
constant native GetGameSpeed         takes nothing returns gamespeed
constant native GetGameDifficulty    takes nothing returns gamedifficulty
constant native GetResourceDensity   takes nothing returns mapdensity
constant native GetCreatureDensity   takes nothing returns mapdensity
constant native GetStartLocationX    takes integer whichStartLocation returns real
constant native GetStartLocationY    takes integer whichStartLocation returns real
constant native GetStartLocationLoc  takes integer whichStartLocation returns location


native SetPlayerTeam            takes player whichPlayer, integer whichTeam returns nothing
native SetPlayerStartLocation   takes player whichPlayer, integer startLocIndex returns nothing
// forces player to have the specified start loc and marks the start loc as occupied
// which removes it from consideration for subsequently placed players
// ( i.e. you can use this to put people in a fixed loc and then
//   use random placement for any unplaced players etc )
native ForcePlayerStartLocation takes player whichPlayer, integer startLocIndex returns nothing
native SetPlayerColor           takes player whichPlayer, playercolor color returns nothing
native SetPlayerAlliance        takes player sourcePlayer, player otherPlayer, alliancetype whichAllianceSetting, boolean value returns nothing
native SetPlayerTaxRate         takes player sourcePlayer, player otherPlayer, playerstate whichResource, integer rate returns nothing
native SetPlayerRacePreference  takes player whichPlayer, racepreference whichRacePreference returns nothing
native SetPlayerRaceSelectable  takes player whichPlayer, boolean value returns nothing
native SetPlayerController      takes player whichPlayer, mapcontrol controlType returns nothing
native SetPlayerName            takes player whichPlayer, string name returns nothing

native SetPlayerOnScoreScreen   takes player whichPlayer, boolean flag returns nothing

native GetPlayerTeam            takes player whichPlayer returns integer
native GetPlayerStartLocation   takes player whichPlayer returns integer
native GetPlayerColor           takes player whichPlayer returns playercolor
native GetPlayerSelectable      takes player whichPlayer returns boolean
native GetPlayerController      takes player whichPlayer returns mapcontrol
native GetPlayerSlotState       takes player whichPlayer returns playerslotstate
native GetPlayerTaxRate         takes player sourcePlayer, player otherPlayer, playerstate whichResource returns integer
native IsPlayerRacePrefSet      takes player whichPlayer, racepreference pref returns boolean
native GetPlayerName            takes player whichPlayer returns string

//============================================================================
// Timer API
//
native CreateTimer          takes nothing returns timer
native DestroyTimer         takes timer whichTimer returns nothing
native TimerStart           takes timer whichTimer, real timeout, boolean periodic, code handlerFunc returns nothing
native TimerGetElapsed      takes timer whichTimer returns real
native TimerGetRemaining    takes timer whichTimer returns real
native TimerGetTimeout      takes timer whichTimer returns real
native PauseTimer           takes timer whichTimer returns nothing
native ResumeTimer          takes timer whichTimer returns nothing
native GetExpiredTimer      takes nothing returns timer

//============================================================================
// Group API
//
native CreateGroup                          takes nothing returns group
native DestroyGroup                         takes group whichGroup returns nothing
native GroupAddUnit                         takes group whichGroup, unit whichUnit returns boolean
native GroupRemoveUnit                      takes group whichGroup, unit whichUnit returns boolean
native BlzGroupAddGroupFast                 takes group whichGroup, group addGroup returns integer
native BlzGroupRemoveGroupFast              takes group whichGroup, group removeGroup returns integer
native GroupClear                           takes group whichGroup returns nothing
native BlzGroupGetSize                      takes group whichGroup returns integer
native BlzGroupUnitAt                       takes group whichGroup, integer index returns unit
native GroupEnumUnitsOfType                 takes group whichGroup, string unitname, boolexpr filter returns nothing
native GroupEnumUnitsOfPlayer               takes group whichGroup, player whichPlayer, boolexpr filter returns nothing
native GroupEnumUnitsOfTypeCounted          takes group whichGroup, string unitname, boolexpr filter, integer countLimit returns nothing
native GroupEnumUnitsInRect                 takes group whichGroup, rect r, boolexpr filter returns nothing
native GroupEnumUnitsInRectCounted          takes group whichGroup, rect r, boolexpr filter, integer countLimit returns nothing
native GroupEnumUnitsInRange                takes group whichGroup, real x, real y, real radius, boolexpr filter returns nothing
native GroupEnumUnitsInRangeOfLoc           takes group whichGroup, location whichLocation, real radius, boolexpr filter returns nothing
native GroupEnumUnitsInRangeCounted         takes group whichGroup, real x, real y, real radius, boolexpr filter, integer countLimit returns nothing
native GroupEnumUnitsInRangeOfLocCounted    takes group whichGroup, location whichLocation, real radius, boolexpr filter, integer countLimit returns nothing
native GroupEnumUnitsSelected               takes group whichGroup, player whichPlayer, boolexpr filter returns nothing

native GroupImmediateOrder                  takes group whichGroup, string order returns boolean
native GroupImmediateOrderById              takes group whichGroup, integer order returns boolean
native GroupPointOrder                      takes group whichGroup, string order, real x, real y returns boolean
native GroupPointOrderLoc                   takes group whichGroup, string order, location whichLocation returns boolean
native GroupPointOrderById                  takes group whichGroup, integer order, real x, real y returns boolean
native GroupPointOrderByIdLoc               takes group whichGroup, integer order, location whichLocation returns boolean
native GroupTargetOrder                     takes group whichGroup, string order, widget targetWidget returns boolean
native GroupTargetOrderById                 takes group whichGroup, integer order, widget targetWidget returns boolean

// This will be difficult to support with potentially disjoint, cell-based regions
// as it would involve enumerating all the cells that are covered by a particularregion
// a better implementation would be a trigger that adds relevant units as they enter
// and removes them if they leave...
native ForGroup                 takes group whichGroup, code callback returns nothing
native FirstOfGroup             takes group whichGroup returns unit

//============================================================================
// Force API
//
native CreateForce              takes nothing returns force
native DestroyForce             takes force whichForce returns nothing
native ForceAddPlayer           takes force whichForce, player whichPlayer returns nothing
native ForceRemovePlayer        takes force whichForce, player whichPlayer returns nothing
native BlzForceHasPlayer        takes force whichForce, player whichPlayer returns boolean
native ForceClear               takes force whichForce returns nothing
native ForceEnumPlayers         takes force whichForce, boolexpr filter returns nothing
native ForceEnumPlayersCounted  takes force whichForce, boolexpr filter, integer countLimit returns nothing
native ForceEnumAllies          takes force whichForce, player whichPlayer, boolexpr filter returns nothing
native ForceEnumEnemies         takes force whichForce, player whichPlayer, boolexpr filter returns nothing
native ForForce                 takes force whichForce, code callback returns nothing

//============================================================================
// Region and Location API
//
native Rect                     takes real minx, real miny, real maxx, real maxy returns rect
native RectFromLoc              takes location min, location max returns rect
native RemoveRect               takes rect whichRect returns nothing
native SetRect                  takes rect whichRect, real minx, real miny, real maxx, real maxy returns nothing
native SetRectFromLoc           takes rect whichRect, location min, location max returns nothing
native MoveRectTo               takes rect whichRect, real newCenterX, real newCenterY returns nothing
native MoveRectToLoc            takes rect whichRect, location newCenterLoc returns nothing

native GetRectCenterX           takes rect whichRect returns real
native GetRectCenterY           takes rect whichRect returns real
native GetRectMinX              takes rect whichRect returns real
native GetRectMinY              takes rect whichRect returns real
native GetRectMaxX              takes rect whichRect returns real
native GetRectMaxY              takes rect whichRect returns real

native CreateRegion             takes nothing returns region
native RemoveRegion             takes region whichRegion returns nothing

native RegionAddRect            takes region whichRegion, rect r returns nothing
native RegionClearRect          takes region whichRegion, rect r returns nothing

native RegionAddCell           takes region whichRegion, real x, real y returns nothing
native RegionAddCellAtLoc      takes region whichRegion, location whichLocation returns nothing
native RegionClearCell         takes region whichRegion, real x, real y returns nothing
native RegionClearCellAtLoc    takes region whichRegion, location whichLocation returns nothing

native Location                 takes real x, real y returns location
native RemoveLocation           takes location whichLocation returns nothing
native MoveLocation             takes location whichLocation, real newX, real newY returns nothing
native GetLocationX             takes location whichLocation returns real
native GetLocationY             takes location whichLocation returns real

// This function is asynchronous. The values it returns are not guaranteed synchronous between each player.
//  If you attempt to use it in a synchronous manner, it may cause a desync.
native GetLocationZ             takes location whichLocation returns real

native IsUnitInRegion               takes region whichRegion, unit whichUnit returns boolean
native IsPointInRegion              takes region whichRegion, real x, real y returns boolean
native IsLocationInRegion           takes region whichRegion, location whichLocation returns boolean

// Returns full map bounds, including unplayable borders, in world coordinates
native GetWorldBounds           takes nothing returns rect

//============================================================================
// Native trigger interface
//
native CreateTrigger    takes nothing returns trigger
native DestroyTrigger   takes trigger whichTrigger returns nothing
native ResetTrigger     takes trigger whichTrigger returns nothing
native EnableTrigger    takes trigger whichTrigger returns nothing
native DisableTrigger   takes trigger whichTrigger returns nothing
native IsTriggerEnabled takes trigger whichTrigger returns boolean

native TriggerWaitOnSleeps   takes trigger whichTrigger, boolean flag returns nothing
native IsTriggerWaitOnSleeps takes trigger whichTrigger returns boolean

constant native GetFilterUnit       takes nothing returns unit
constant native GetEnumUnit         takes nothing returns unit

constant native GetFilterDestructable   takes nothing returns destructable
constant native GetEnumDestructable     takes nothing returns destructable

constant native GetFilterItem           takes nothing returns item
constant native GetEnumItem             takes nothing returns item

constant native ParseTags               takes string taggedString returns string

constant native GetFilterPlayer     takes nothing returns player
constant native GetEnumPlayer       takes nothing returns player

constant native GetTriggeringTrigger    takes nothing returns trigger
constant native GetTriggerEventId       takes nothing returns eventid
constant native GetTriggerEvalCount     takes trigger whichTrigger returns integer
constant native GetTriggerExecCount     takes trigger whichTrigger returns integer

native ExecuteFunc          takes string funcName returns nothing

//============================================================================
// Boolean Expr API ( for compositing trigger conditions and unit filter funcs...)
//============================================================================
native And              takes boolexpr operandA, boolexpr operandB returns boolexpr
native Or               takes boolexpr operandA, boolexpr operandB returns boolexpr
native Not              takes boolexpr operand returns boolexpr
native Condition        takes code func returns conditionfunc
native DestroyCondition takes conditionfunc c returns nothing
native Filter           takes code func returns filterfunc
native DestroyFilter    takes filterfunc f returns nothing
native DestroyBoolExpr  takes boolexpr e returns nothing

//============================================================================
// Trigger Game Event API
//============================================================================

native TriggerRegisterVariableEvent takes trigger whichTrigger, string varName, limitop opcode, real limitval returns event

    // EVENT_GAME_VARIABLE_LIMIT
    //constant native string GetTriggeringVariableName takes nothing returns string

// Creates it's own timer and triggers when it expires
native TriggerRegisterTimerEvent takes trigger whichTrigger, real timeout, boolean periodic returns event

// Triggers when the timer you tell it about expires
native TriggerRegisterTimerExpireEvent takes trigger whichTrigger, timer t returns event

native TriggerRegisterGameStateEvent takes trigger whichTrigger, gamestate whichState, limitop opcode, real limitval returns event

native TriggerRegisterDialogEvent       takes trigger whichTrigger, dialog whichDialog returns event
native TriggerRegisterDialogButtonEvent takes trigger whichTrigger, button whichButton returns event

//  EVENT_GAME_STATE_LIMIT
constant native GetEventGameState takes nothing returns gamestate

native TriggerRegisterGameEvent takes trigger whichTrigger, gameevent whichGameEvent returns event

// EVENT_GAME_VICTORY
constant native GetWinningPlayer takes nothing returns player


native TriggerRegisterEnterRegion takes trigger whichTrigger, region whichRegion, boolexpr filter returns event

// EVENT_GAME_ENTER_REGION
constant native GetTriggeringRegion takes nothing returns region
constant native GetEnteringUnit takes nothing returns unit

// EVENT_GAME_LEAVE_REGION

native TriggerRegisterLeaveRegion takes trigger whichTrigger, region whichRegion, boolexpr filter returns event
constant native GetLeavingUnit takes nothing returns unit

native TriggerRegisterTrackableHitEvent takes trigger whichTrigger, trackable t returns event
native TriggerRegisterTrackableTrackEvent takes trigger whichTrigger, trackable t returns event

// EVENT_COMMAND_BUTTON_CLICK
native TriggerRegisterCommandEvent takes trigger whichTrigger, integer whichAbility, string order returns event
native TriggerRegisterUpgradeCommandEvent takes trigger whichTrigger, integer whichUpgrade returns event

// EVENT_GAME_TRACKABLE_HIT
// EVENT_GAME_TRACKABLE_TRACK
constant native GetTriggeringTrackable takes nothing returns trackable

// EVENT_DIALOG_BUTTON_CLICK
constant native GetClickedButton takes nothing returns button
constant native GetClickedDialog    takes nothing returns dialog

// EVENT_GAME_TOURNAMENT_FINISH_SOON
constant native GetTournamentFinishSoonTimeRemaining takes nothing returns real
constant native GetTournamentFinishNowRule takes nothing returns integer
constant native GetTournamentFinishNowPlayer takes nothing returns player
constant native GetTournamentScore takes player whichPlayer returns integer

// EVENT_GAME_SAVE
constant native GetSaveBasicFilename takes nothing returns string

//============================================================================
// Trigger Player Based Event API
//============================================================================

native TriggerRegisterPlayerEvent takes trigger whichTrigger, player  whichPlayer, playerevent whichPlayerEvent returns event

// EVENT_PLAYER_DEFEAT
// EVENT_PLAYER_VICTORY
constant native GetTriggerPlayer takes nothing returns player

native TriggerRegisterPlayerUnitEvent takes trigger whichTrigger, player whichPlayer, playerunitevent whichPlayerUnitEvent, boolexpr filter returns event

// EVENT_PLAYER_HERO_LEVEL
// EVENT_UNIT_HERO_LEVEL
constant native GetLevelingUnit takes nothing returns unit

// EVENT_PLAYER_HERO_SKILL
// EVENT_UNIT_HERO_SKILL
constant native GetLearningUnit      takes nothing returns unit
constant native GetLearnedSkill      takes nothing returns integer
constant native GetLearnedSkillLevel takes nothing returns integer

// EVENT_PLAYER_HERO_REVIVABLE
constant native GetRevivableUnit takes nothing returns unit

// EVENT_PLAYER_HERO_REVIVE_START
// EVENT_PLAYER_HERO_REVIVE_CANCEL
// EVENT_PLAYER_HERO_REVIVE_FINISH
// EVENT_UNIT_HERO_REVIVE_START
// EVENT_UNIT_HERO_REVIVE_CANCEL
// EVENT_UNIT_HERO_REVIVE_FINISH
constant native GetRevivingUnit takes nothing returns unit

// EVENT_PLAYER_UNIT_ATTACKED
constant native GetAttacker takes nothing returns unit

// EVENT_PLAYER_UNIT_RESCUED
constant native GetRescuer  takes nothing returns unit

// EVENT_PLAYER_UNIT_DEATH
constant native GetDyingUnit takes nothing returns unit
constant native GetKillingUnit takes nothing returns unit

// EVENT_PLAYER_UNIT_DECAY
constant native GetDecayingUnit takes nothing returns unit

// EVENT_PLAYER_UNIT_SELECTED
//constant native GetSelectedUnit takes nothing returns unit

// EVENT_PLAYER_UNIT_CONSTRUCT_START
constant native GetConstructingStructure takes nothing returns unit

// EVENT_PLAYER_UNIT_CONSTRUCT_FINISH
// EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL
constant native GetCancelledStructure takes nothing returns unit
constant native GetConstructedStructure takes nothing returns unit

// EVENT_PLAYER_UNIT_RESEARCH_START
// EVENT_PLAYER_UNIT_RESEARCH_CANCEL
// EVENT_PLAYER_UNIT_RESEARCH_FINISH
constant native GetResearchingUnit takes nothing returns unit
constant native GetResearched takes nothing returns integer

// EVENT_PLAYER_UNIT_TRAIN_START
// EVENT_PLAYER_UNIT_TRAIN_CANCEL
constant native GetTrainedUnitType takes nothing returns integer

// EVENT_PLAYER_UNIT_TRAIN_FINISH
constant native GetTrainedUnit takes nothing returns unit

// EVENT_PLAYER_UNIT_DETECTED
constant native GetDetectedUnit takes nothing returns unit

// EVENT_PLAYER_UNIT_SUMMONED
constant native GetSummoningUnit    takes nothing returns unit
constant native GetSummonedUnit     takes nothing returns unit

// EVENT_PLAYER_UNIT_LOADED
constant native GetTransportUnit    takes nothing returns unit
constant native GetLoadedUnit       takes nothing returns unit

// EVENT_PLAYER_UNIT_SELL
constant native GetSellingUnit      takes nothing returns unit
constant native GetSoldUnit         takes nothing returns unit
constant native GetBuyingUnit       takes nothing returns unit

// EVENT_PLAYER_UNIT_SELL_ITEM
constant native GetSoldItem         takes nothing returns item

// EVENT_PLAYER_UNIT_CHANGE_OWNER
constant native GetChangingUnit             takes nothing returns unit
constant native GetChangingUnitPrevOwner    takes nothing returns player

// EVENT_PLAYER_UNIT_DROP_ITEM
// EVENT_PLAYER_UNIT_PICKUP_ITEM
// EVENT_PLAYER_UNIT_USE_ITEM
constant native GetManipulatingUnit takes nothing returns unit
constant native GetManipulatedItem  takes nothing returns item

// For EVENT_PLAYER_UNIT_PICKUP_ITEM, returns the item absorbing the picked up item in case it is stacking.
// Returns null if the item was a powerup and not a stacking item.
constant native BlzGetAbsorbingItem takes nothing returns item
constant native BlzGetManipulatedItemWasAbsorbed takes nothing returns boolean

// EVENT_PLAYER_UNIT_STACK_ITEM
// Source is the item that is losing charges, Target is the item getting charges.
constant native BlzGetStackingItemSource takes nothing returns item
constant native BlzGetStackingItemTarget takes nothing returns item
constant native BlzGetStackingItemTargetPreviousCharges takes nothing returns integer

// EVENT_PLAYER_UNIT_ISSUED_ORDER
constant native GetOrderedUnit takes nothing returns unit
constant native GetIssuedOrderId takes nothing returns integer

// EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER
constant native GetOrderPointX takes nothing returns real
constant native GetOrderPointY takes nothing returns real
constant native GetOrderPointLoc takes nothing returns location

// EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER
constant native GetOrderTarget              takes nothing returns widget
constant native GetOrderTargetDestructable  takes nothing returns destructable
constant native GetOrderTargetItem          takes nothing returns item
constant native GetOrderTargetUnit          takes nothing returns unit

// EVENT_UNIT_SPELL_CHANNEL
// EVENT_UNIT_SPELL_CAST
// EVENT_UNIT_SPELL_EFFECT
// EVENT_UNIT_SPELL_FINISH
// EVENT_UNIT_SPELL_ENDCAST
// EVENT_PLAYER_UNIT_SPELL_CHANNEL
// EVENT_PLAYER_UNIT_SPELL_CAST
// EVENT_PLAYER_UNIT_SPELL_EFFECT
// EVENT_PLAYER_UNIT_SPELL_FINISH
// EVENT_PLAYER_UNIT_SPELL_ENDCAST
constant native GetSpellAbilityUnit         takes nothing returns unit
constant native GetSpellAbilityId           takes nothing returns integer
constant native GetSpellAbility             takes nothing returns ability
constant native GetSpellTargetLoc           takes nothing returns location
constant native GetSpellTargetX				takes nothing returns real
constant native GetSpellTargetY				takes nothing returns real
constant native GetSpellTargetDestructable  takes nothing returns destructable
constant native GetSpellTargetItem          takes nothing returns item
constant native GetSpellTargetUnit          takes nothing returns unit

native TriggerRegisterPlayerAllianceChange takes trigger whichTrigger, player whichPlayer, alliancetype whichAlliance returns event
native TriggerRegisterPlayerStateEvent takes trigger whichTrigger, player whichPlayer, playerstate whichState, limitop opcode, real limitval returns event

// EVENT_PLAYER_STATE_LIMIT
constant native GetEventPlayerState takes nothing returns playerstate

native TriggerRegisterPlayerChatEvent takes trigger whichTrigger, player whichPlayer, string chatMessageToDetect, boolean exactMatchOnly returns event

// EVENT_PLAYER_CHAT

// returns the actual string they typed in ( same as what you registered for
// if you required exact match )
constant native GetEventPlayerChatString takes nothing returns string

// returns the string that you registered for
constant native GetEventPlayerChatStringMatched takes nothing returns string

native TriggerRegisterDeathEvent takes trigger whichTrigger, widget whichWidget returns event

//============================================================================
// Trigger Unit Based Event API
//============================================================================

// returns handle to unit which triggered the most recent event when called from
// within a trigger action function...returns null handle when used incorrectly

constant native GetTriggerUnit takes nothing returns unit

native TriggerRegisterUnitStateEvent takes trigger whichTrigger, unit whichUnit, unitstate whichState, limitop opcode, real limitval returns event

// EVENT_UNIT_STATE_LIMIT
constant native GetEventUnitState takes nothing returns unitstate

native TriggerRegisterUnitEvent takes trigger whichTrigger, unit whichUnit, unitevent whichEvent returns event

// EVENT_UNIT_DAMAGED
constant native GetEventDamage takes nothing returns real
constant native GetEventDamageSource takes nothing returns unit

// EVENT_UNIT_DEATH
// EVENT_UNIT_DECAY
// Use the GetDyingUnit and GetDecayingUnit funcs above

// EVENT_UNIT_DETECTED
constant native GetEventDetectingPlayer takes nothing returns player

native TriggerRegisterFilterUnitEvent takes trigger whichTrigger, unit whichUnit, unitevent whichEvent, boolexpr filter returns event

// EVENT_UNIT_ACQUIRED_TARGET
// EVENT_UNIT_TARGET_IN_RANGE
constant native GetEventTargetUnit takes nothing returns unit

// EVENT_UNIT_ATTACKED
// Use GetAttacker from the Player Unit Event API Below...

// EVENT_UNIT_RESCUEDED
// Use GetRescuer from the Player Unit Event API Below...

// EVENT_UNIT_CONSTRUCT_CANCEL
// EVENT_UNIT_CONSTRUCT_FINISH

// See the Player Unit Construction Event API above for event info funcs

// EVENT_UNIT_TRAIN_START
// EVENT_UNIT_TRAIN_CANCELLED
// EVENT_UNIT_TRAIN_FINISH

// See the Player Unit Training Event API above for event info funcs

// EVENT_UNIT_SELL

// See the Player Unit Sell Event API above for event info funcs

// EVENT_UNIT_DROP_ITEM
// EVENT_UNIT_PICKUP_ITEM
// EVENT_UNIT_USE_ITEM
// See the Player Unit/Item manipulation Event API above for event info funcs

// EVENT_UNIT_STACK_ITEM
// See the Player Unit/Item stack Event API above for event info funcs

// EVENT_UNIT_ISSUED_ORDER
// EVENT_UNIT_ISSUED_POINT_ORDER
// EVENT_UNIT_ISSUED_TARGET_ORDER

// See the Player Unit Order Event API above for event info funcs

native TriggerRegisterUnitInRange takes trigger whichTrigger, unit whichUnit, real range, boolexpr filter returns event

native TriggerAddCondition    takes trigger whichTrigger, boolexpr condition returns triggercondition
native TriggerRemoveCondition takes trigger whichTrigger, triggercondition whichCondition returns nothing
native TriggerClearConditions takes trigger whichTrigger returns nothing

native TriggerAddAction     takes trigger whichTrigger, code actionFunc returns triggeraction
native TriggerRemoveAction  takes trigger whichTrigger, triggeraction whichAction returns nothing
native TriggerClearActions  takes trigger whichTrigger returns nothing
native TriggerSleepAction   takes real timeout returns nothing
native TriggerWaitForSound  takes sound s, real offset returns nothing
native TriggerEvaluate      takes trigger whichTrigger returns boolean
native TriggerExecute       takes trigger whichTrigger returns nothing
native TriggerExecuteWait   takes trigger whichTrigger returns nothing
native TriggerSyncStart     takes nothing returns nothing
native TriggerSyncReady     takes nothing returns nothing

//============================================================================
// Widget API
native  GetWidgetLife   takes widget whichWidget returns real
native  SetWidgetLife   takes widget whichWidget, real newLife returns nothing
native  GetWidgetX      takes widget whichWidget returns real
native  GetWidgetY      takes widget whichWidget returns real
constant native GetTriggerWidget takes nothing returns widget

//============================================================================
// Destructable Object API
// Facing arguments are specified in degrees
native          CreateDestructable          takes integer objectid, real x, real y, real face, real scale, integer variation returns destructable
native          CreateDestructableZ         takes integer objectid, real x, real y, real z, real face, real scale, integer variation returns destructable
native          CreateDeadDestructable      takes integer objectid, real x, real y, real face, real scale, integer variation returns destructable
native          CreateDeadDestructableZ     takes integer objectid, real x, real y, real z, real face, real scale, integer variation returns destructable
native          RemoveDestructable          takes destructable d returns nothing
native          KillDestructable            takes destructable d returns nothing
native          SetDestructableInvulnerable takes destructable d, boolean flag returns nothing
native          IsDestructableInvulnerable  takes destructable d returns boolean
native          EnumDestructablesInRect     takes rect r, boolexpr filter, code actionFunc returns nothing
native          GetDestructableTypeId       takes destructable d returns integer
native          GetDestructableX            takes destructable d returns real
native          GetDestructableY            takes destructable d returns real
native          SetDestructableLife         takes destructable d, real life returns nothing
native          GetDestructableLife         takes destructable d returns real
native          SetDestructableMaxLife      takes destructable d, real max returns nothing
native          GetDestructableMaxLife      takes destructable d returns real
native          DestructableRestoreLife     takes destructable d, real life, boolean birth returns nothing
native          QueueDestructableAnimation  takes destructable d, string whichAnimation returns nothing
native          SetDestructableAnimation    takes destructable d, string whichAnimation returns nothing
native          SetDestructableAnimationSpeed takes destructable d, real speedFactor returns nothing
native          ShowDestructable            takes destructable d, boolean flag returns nothing
native          GetDestructableOccluderHeight takes destructable d returns real
native          SetDestructableOccluderHeight takes destructable d, real height returns nothing
native          GetDestructableName         takes destructable d returns string
constant native GetTriggerDestructable takes nothing returns destructable

//============================================================================
// Item API
native          CreateItem      takes integer itemid, real x, real y returns item
native          RemoveItem      takes item whichItem returns nothing
native          GetItemPlayer   takes item whichItem returns player
native          GetItemTypeId   takes item i returns integer
native          GetItemX        takes item i returns real
native          GetItemY        takes item i returns real
native          SetItemPosition takes item i, real x, real y returns nothing
native          SetItemDropOnDeath  takes item whichItem, boolean flag returns nothing
native          SetItemDroppable takes item i, boolean flag returns nothing
native          SetItemPawnable takes item i, boolean flag returns nothing
native          SetItemPlayer    takes item whichItem, player whichPlayer, boolean changeColor returns nothing
native          SetItemInvulnerable takes item whichItem, boolean flag returns nothing
native          IsItemInvulnerable  takes item whichItem returns boolean
native          SetItemVisible  takes item whichItem, boolean show returns nothing
native          IsItemVisible   takes item whichItem returns boolean
native          IsItemOwned     takes item whichItem returns boolean
native          IsItemPowerup   takes item whichItem returns boolean
native          IsItemSellable  takes item whichItem returns boolean
native          IsItemPawnable  takes item whichItem returns boolean
native          IsItemIdPowerup takes integer itemId returns boolean
native          IsItemIdSellable takes integer itemId returns boolean
native          IsItemIdPawnable takes integer itemId returns boolean
native          EnumItemsInRect     takes rect r, boolexpr filter, code actionFunc returns nothing
native          GetItemLevel    takes item whichItem returns integer
native          GetItemType     takes item whichItem returns itemtype
native          SetItemDropID   takes item whichItem, integer unitId returns nothing
constant native GetItemName     takes item whichItem returns string
native          GetItemCharges  takes item whichItem returns integer
native          SetItemCharges  takes item whichItem, integer charges returns nothing
native          GetItemUserData takes item whichItem returns integer
native          SetItemUserData takes item whichItem, integer data returns nothing

//============================================================================
// Unit API
// Facing arguments are specified in degrees
native          CreateUnit              takes player id, integer unitid, real x, real y, real face returns unit
native          CreateUnitByName        takes player whichPlayer, string unitname, real x, real y, real face returns unit
native          CreateUnitAtLoc         takes player id, integer unitid, location whichLocation, real face returns unit
native          CreateUnitAtLocByName   takes player id, string unitname, location whichLocation, real face returns unit
native          CreateCorpse            takes player whichPlayer, integer unitid, real x, real y, real face returns unit

native          KillUnit            takes unit whichUnit returns nothing
native          RemoveUnit          takes unit whichUnit returns nothing
native          ShowUnit            takes unit whichUnit, boolean show returns nothing

native          SetUnitState        takes unit whichUnit, unitstate whichUnitState, real newVal returns nothing
native          SetUnitX            takes unit whichUnit, real newX returns nothing
native          SetUnitY            takes unit whichUnit, real newY returns nothing
native          SetUnitPosition     takes unit whichUnit, real newX, real newY returns nothing
native          SetUnitPositionLoc  takes unit whichUnit, location whichLocation returns nothing
native          SetUnitFacing       takes unit whichUnit, real facingAngle returns nothing
native          SetUnitFacingTimed  takes unit whichUnit, real facingAngle, real duration returns nothing
native          SetUnitMoveSpeed    takes unit whichUnit, real newSpeed returns nothing
native          SetUnitFlyHeight    takes unit whichUnit, real newHeight, real rate returns nothing
native          SetUnitTurnSpeed    takes unit whichUnit, real newTurnSpeed returns nothing
native          SetUnitPropWindow   takes unit whichUnit, real newPropWindowAngle returns nothing
native          SetUnitAcquireRange takes unit whichUnit, real newAcquireRange returns nothing
native          SetUnitCreepGuard   takes unit whichUnit, boolean creepGuard returns nothing

native          GetUnitAcquireRange     takes unit whichUnit returns real
native          GetUnitTurnSpeed        takes unit whichUnit returns real
native          GetUnitPropWindow       takes unit whichUnit returns real
native          GetUnitFlyHeight        takes unit whichUnit returns real

native          GetUnitDefaultAcquireRange      takes unit whichUnit returns real
native          GetUnitDefaultTurnSpeed         takes unit whichUnit returns real
native          GetUnitDefaultPropWindow        takes unit whichUnit returns real
native          GetUnitDefaultFlyHeight         takes unit whichUnit returns real

native          SetUnitOwner        takes unit whichUnit, player whichPlayer, boolean changeColor returns nothing
native          SetUnitColor        takes unit whichUnit, playercolor whichColor returns nothing

native          SetUnitScale        takes unit whichUnit, real scaleX, real scaleY, real scaleZ returns nothing
native          SetUnitTimeScale    takes unit whichUnit, real timeScale returns nothing
native          SetUnitBlendTime    takes unit whichUnit, real blendTime returns nothing
native          SetUnitVertexColor  takes unit whichUnit, integer red, integer green, integer blue, integer alpha returns nothing

native          QueueUnitAnimation          takes unit whichUnit, string whichAnimation returns nothing
native          SetUnitAnimation            takes unit whichUnit, string whichAnimation returns nothing
native          SetUnitAnimationByIndex     takes unit whichUnit, integer whichAnimation returns nothing
native          SetUnitAnimationWithRarity  takes unit whichUnit, string whichAnimation, raritycontrol rarity returns nothing
native          AddUnitAnimationProperties  takes unit whichUnit, string animProperties, boolean add returns nothing

native          SetUnitLookAt       takes unit whichUnit, string whichBone, unit lookAtTarget, real offsetX, real offsetY, real offsetZ returns nothing
native          ResetUnitLookAt     takes unit whichUnit returns nothing

native          SetUnitRescuable    takes unit whichUnit, player byWhichPlayer, boolean flag returns nothing
native          SetUnitRescueRange  takes unit whichUnit, real range returns nothing

native          SetHeroStr          takes unit whichHero, integer newStr, boolean permanent returns nothing
native          SetHeroAgi          takes unit whichHero, integer newAgi, boolean permanent returns nothing
native          SetHeroInt          takes unit whichHero, integer newInt, boolean permanent returns nothing

native          GetHeroStr          takes unit whichHero, boolean includeBonuses returns integer
native          GetHeroAgi          takes unit whichHero, boolean includeBonuses returns integer
native          GetHeroInt          takes unit whichHero, boolean includeBonuses returns integer

native          UnitStripHeroLevel  takes unit whichHero, integer howManyLevels returns boolean

native          GetHeroXP           takes unit whichHero returns integer
native          SetHeroXP           takes unit whichHero, integer newXpVal,  boolean showEyeCandy returns nothing

native          GetHeroSkillPoints      takes unit whichHero returns integer
native          UnitModifySkillPoints   takes unit whichHero, integer skillPointDelta returns boolean

native          AddHeroXP           takes unit whichHero, integer xpToAdd,   boolean showEyeCandy returns nothing
native          SetHeroLevel        takes unit whichHero, integer level,  boolean showEyeCandy returns nothing
constant native GetHeroLevel        takes unit whichHero returns integer
constant native GetUnitLevel        takes unit whichUnit returns integer
native          GetHeroProperName   takes unit whichHero returns string
native          SuspendHeroXP       takes unit whichHero, boolean flag returns nothing
native          IsSuspendedXP       takes unit whichHero returns boolean
native          SelectHeroSkill     takes unit whichHero, integer abilcode returns nothing
native          GetUnitAbilityLevel takes unit whichUnit, integer abilcode returns integer
native          DecUnitAbilityLevel takes unit whichUnit, integer abilcode returns integer
native          IncUnitAbilityLevel takes unit whichUnit, integer abilcode returns integer
native          SetUnitAbilityLevel takes unit whichUnit, integer abilcode, integer level returns integer
native          ReviveHero          takes unit whichHero, real x, real y, boolean doEyecandy returns boolean
native          ReviveHeroLoc       takes unit whichHero, location loc, boolean doEyecandy returns boolean
native          SetUnitExploded     takes unit whichUnit, boolean exploded returns nothing
native          SetUnitInvulnerable takes unit whichUnit, boolean flag returns nothing
native          PauseUnit           takes unit whichUnit, boolean flag returns nothing
native          IsUnitPaused        takes unit whichHero returns boolean
native          SetUnitPathing      takes unit whichUnit, boolean flag returns nothing

native          ClearSelection      takes nothing returns nothing
native          SelectUnit          takes unit whichUnit, boolean flag returns nothing

native          GetUnitPointValue       takes unit whichUnit returns integer
native          GetUnitPointValueByType takes integer unitType returns integer
//native        SetUnitPointValueByType takes integer unitType, integer newPointValue returns nothing

native          UnitAddItem             takes unit whichUnit, item whichItem returns boolean
native          UnitAddItemById         takes unit whichUnit, integer itemId returns item
native          UnitAddItemToSlotById   takes unit whichUnit, integer itemId, integer itemSlot returns boolean
native          UnitRemoveItem          takes unit whichUnit, item whichItem returns nothing
native          UnitRemoveItemFromSlot  takes unit whichUnit, integer itemSlot returns item
native          UnitHasItem             takes unit whichUnit, item whichItem returns boolean
native          UnitItemInSlot          takes unit whichUnit, integer itemSlot returns item
native          UnitInventorySize       takes unit whichUnit returns integer

native          UnitDropItemPoint       takes unit whichUnit, item whichItem, real x, real y returns boolean
native          UnitDropItemSlot        takes unit whichUnit, item whichItem, integer slot returns boolean
native          UnitDropItemTarget      takes unit whichUnit, item whichItem, widget target returns boolean

native          UnitUseItem             takes unit whichUnit, item whichItem returns boolean
native          UnitUseItemPoint        takes unit whichUnit, item whichItem, real x, real y returns boolean
native          UnitUseItemTarget       takes unit whichUnit, item whichItem, widget target returns boolean

constant native GetUnitX            takes unit whichUnit returns real
constant native GetUnitY            takes unit whichUnit returns real
constant native GetUnitLoc          takes unit whichUnit returns location
constant native GetUnitFacing       takes unit whichUnit returns real
constant native GetUnitMoveSpeed    takes unit whichUnit returns real
constant native GetUnitDefaultMoveSpeed takes unit whichUnit returns real
constant native GetUnitState        takes unit whichUnit, unitstate whichUnitState returns real
constant native GetOwningPlayer     takes unit whichUnit returns player
constant native GetUnitTypeId       takes unit whichUnit returns integer
constant native GetUnitRace         takes unit whichUnit returns race
constant native GetUnitName         takes unit whichUnit returns string
constant native GetUnitFoodUsed     takes unit whichUnit returns integer
constant native GetUnitFoodMade     takes unit whichUnit returns integer
constant native GetFoodMade         takes integer unitId returns integer
constant native GetFoodUsed         takes integer unitId returns integer
native          SetUnitUseFood      takes unit whichUnit, boolean useFood returns nothing

constant native GetUnitRallyPoint           takes unit whichUnit returns location
constant native GetUnitRallyUnit            takes unit whichUnit returns unit
constant native GetUnitRallyDestructable    takes unit whichUnit returns destructable

constant native IsUnitInGroup       takes unit whichUnit, group whichGroup returns boolean
constant native IsUnitInForce       takes unit whichUnit, force whichForce returns boolean
constant native IsUnitOwnedByPlayer takes unit whichUnit, player whichPlayer returns boolean
constant native IsUnitAlly          takes unit whichUnit, player whichPlayer returns boolean
constant native IsUnitEnemy         takes unit whichUnit, player whichPlayer returns boolean
constant native IsUnitVisible       takes unit whichUnit, player whichPlayer returns boolean
constant native IsUnitDetected      takes unit whichUnit, player whichPlayer returns boolean
constant native IsUnitInvisible     takes unit whichUnit, player whichPlayer returns boolean
constant native IsUnitFogged        takes unit whichUnit, player whichPlayer returns boolean
constant native IsUnitMasked        takes unit whichUnit, player whichPlayer returns boolean
constant native IsUnitSelected      takes unit whichUnit, player whichPlayer returns boolean
constant native IsUnitRace          takes unit whichUnit, race whichRace returns boolean
constant native IsUnitType          takes unit whichUnit, unittype whichUnitType returns boolean
constant native IsUnit              takes unit whichUnit, unit whichSpecifiedUnit returns boolean
constant native IsUnitInRange       takes unit whichUnit, unit otherUnit, real distance returns boolean
constant native IsUnitInRangeXY     takes unit whichUnit, real x, real y, real distance returns boolean
constant native IsUnitInRangeLoc    takes unit whichUnit, location whichLocation, real distance returns boolean
constant native IsUnitHidden        takes unit whichUnit returns boolean
constant native IsUnitIllusion      takes unit whichUnit returns boolean

constant native IsUnitInTransport   takes unit whichUnit, unit whichTransport returns boolean
constant native IsUnitLoaded        takes unit whichUnit returns boolean

constant native IsHeroUnitId        takes integer unitId returns boolean
constant native IsUnitIdType        takes integer unitId, unittype whichUnitType returns boolean

native UnitShareVision              takes unit whichUnit, player whichPlayer, boolean share returns nothing
native UnitSuspendDecay             takes unit whichUnit, boolean suspend returns nothing
native UnitAddType                  takes unit whichUnit, unittype whichUnitType returns boolean
native UnitRemoveType               takes unit whichUnit, unittype whichUnitType returns boolean

native UnitAddAbility               takes unit whichUnit, integer abilityId returns boolean
native UnitRemoveAbility            takes unit whichUnit, integer abilityId returns boolean
native UnitMakeAbilityPermanent     takes unit whichUnit, boolean permanent, integer abilityId returns boolean
native UnitRemoveBuffs              takes unit whichUnit, boolean removePositive, boolean removeNegative returns nothing
native UnitRemoveBuffsEx            takes unit whichUnit, boolean removePositive, boolean removeNegative, boolean magic, boolean physical, boolean timedLife, boolean aura, boolean autoDispel returns nothing
native UnitHasBuffsEx               takes unit whichUnit, boolean removePositive, boolean removeNegative, boolean magic, boolean physical, boolean timedLife, boolean aura, boolean autoDispel returns boolean
native UnitCountBuffsEx             takes unit whichUnit, boolean removePositive, boolean removeNegative, boolean magic, boolean physical, boolean timedLife, boolean aura, boolean autoDispel returns integer
native UnitAddSleep                 takes unit whichUnit, boolean add returns nothing
native UnitCanSleep                 takes unit whichUnit returns boolean
native UnitAddSleepPerm             takes unit whichUnit, boolean add returns nothing
native UnitCanSleepPerm             takes unit whichUnit returns boolean
native UnitIsSleeping               takes unit whichUnit returns boolean
native UnitWakeUp                   takes unit whichUnit returns nothing
native UnitApplyTimedLife           takes unit whichUnit, integer buffId, real duration returns nothing
native UnitIgnoreAlarm              takes unit whichUnit, boolean flag returns boolean
native UnitIgnoreAlarmToggled       takes unit whichUnit returns boolean
native UnitResetCooldown            takes unit whichUnit returns nothing
native UnitSetConstructionProgress  takes unit whichUnit, integer constructionPercentage returns nothing
native UnitSetUpgradeProgress       takes unit whichUnit, integer upgradePercentage returns nothing
native UnitPauseTimedLife           takes unit whichUnit, boolean flag returns nothing
native UnitSetUsesAltIcon           takes unit whichUnit, boolean flag returns nothing

native UnitDamagePoint              takes unit whichUnit, real delay, real radius, real x, real y, real amount, boolean attack, boolean ranged, attacktype attackType, damagetype damageType, weapontype weaponType returns boolean
native UnitDamageTarget             takes unit whichUnit, widget target, real amount, boolean attack, boolean ranged, attacktype attackType, damagetype damageType, weapontype weaponType returns boolean

native IssueImmediateOrder          takes unit whichUnit, string order returns boolean
native IssueImmediateOrderById      takes unit whichUnit, integer order returns boolean
native IssuePointOrder              takes unit whichUnit, string order, real x, real y returns boolean
native IssuePointOrderLoc           takes unit whichUnit, string order, location whichLocation returns boolean
native IssuePointOrderById          takes unit whichUnit, integer order, real x, real y returns boolean
native IssuePointOrderByIdLoc       takes unit whichUnit, integer order, location whichLocation returns boolean
native IssueTargetOrder             takes unit whichUnit, string order, widget targetWidget returns boolean
native IssueTargetOrderById         takes unit whichUnit, integer order, widget targetWidget returns boolean
native IssueInstantPointOrder       takes unit whichUnit, string order, real x, real y, widget instantTargetWidget returns boolean
native IssueInstantPointOrderById   takes unit whichUnit, integer order, real x, real y, widget instantTargetWidget returns boolean
native IssueInstantTargetOrder      takes unit whichUnit, string order, widget targetWidget, widget instantTargetWidget returns boolean
native IssueInstantTargetOrderById  takes unit whichUnit, integer order, widget targetWidget, widget instantTargetWidget returns boolean
native IssueBuildOrder              takes unit whichPeon, string unitToBuild, real x, real y returns boolean
native IssueBuildOrderById          takes unit whichPeon, integer unitId, real x, real y returns boolean

native IssueNeutralImmediateOrder       takes player forWhichPlayer, unit neutralStructure, string unitToBuild returns boolean
native IssueNeutralImmediateOrderById   takes player forWhichPlayer,unit neutralStructure, integer unitId returns boolean
native IssueNeutralPointOrder           takes player forWhichPlayer,unit neutralStructure, string unitToBuild, real x, real y returns boolean
native IssueNeutralPointOrderById       takes player forWhichPlayer,unit neutralStructure, integer unitId, real x, real y returns boolean
native IssueNeutralTargetOrder          takes player forWhichPlayer,unit neutralStructure, string unitToBuild, widget target returns boolean
native IssueNeutralTargetOrderById      takes player forWhichPlayer,unit neutralStructure, integer unitId, widget target returns boolean

native GetUnitCurrentOrder          takes unit whichUnit returns integer

native SetResourceAmount            takes unit whichUnit, integer amount returns nothing
native AddResourceAmount            takes unit whichUnit, integer amount returns nothing
native GetResourceAmount            takes unit whichUnit returns integer

native WaygateGetDestinationX       takes unit waygate returns real
native WaygateGetDestinationY       takes unit waygate returns real
native WaygateSetDestination        takes unit waygate, real x, real y returns nothing
native WaygateActivate              takes unit waygate, boolean activate returns nothing
native WaygateIsActive              takes unit waygate returns boolean

native AddItemToAllStock            takes integer itemId, integer currentStock, integer stockMax returns nothing
native AddItemToStock               takes unit whichUnit, integer itemId, integer currentStock, integer stockMax returns nothing
native AddUnitToAllStock            takes integer unitId, integer currentStock, integer stockMax returns nothing
native AddUnitToStock               takes unit whichUnit, integer unitId, integer currentStock, integer stockMax returns nothing

native RemoveItemFromAllStock       takes integer itemId returns nothing
native RemoveItemFromStock          takes unit whichUnit, integer itemId returns nothing
native RemoveUnitFromAllStock       takes integer unitId returns nothing
native RemoveUnitFromStock          takes unit whichUnit, integer unitId returns nothing

native SetAllItemTypeSlots          takes integer slots returns nothing
native SetAllUnitTypeSlots          takes integer slots returns nothing
native SetItemTypeSlots             takes unit whichUnit, integer slots returns nothing
native SetUnitTypeSlots             takes unit whichUnit, integer slots returns nothing

native GetUnitUserData              takes unit whichUnit returns integer
native SetUnitUserData              takes unit whichUnit, integer data returns nothing

//============================================================================
// Player API
constant native Player              takes integer number returns player
constant native GetLocalPlayer      takes nothing returns player
constant native IsPlayerAlly        takes player whichPlayer, player otherPlayer returns boolean
constant native IsPlayerEnemy       takes player whichPlayer, player otherPlayer returns boolean
constant native IsPlayerInForce     takes player whichPlayer, force whichForce returns boolean
constant native IsPlayerObserver    takes player whichPlayer returns boolean
constant native IsVisibleToPlayer           takes real x, real y, player whichPlayer returns boolean
constant native IsLocationVisibleToPlayer   takes location whichLocation, player whichPlayer returns boolean
constant native IsFoggedToPlayer            takes real x, real y, player whichPlayer returns boolean
constant native IsLocationFoggedToPlayer    takes location whichLocation, player whichPlayer returns boolean
constant native IsMaskedToPlayer            takes real x, real y, player whichPlayer returns boolean
constant native IsLocationMaskedToPlayer    takes location whichLocation, player whichPlayer returns boolean

constant native GetPlayerRace           takes player whichPlayer returns race
constant native GetPlayerId             takes player whichPlayer returns integer
constant native GetPlayerUnitCount      takes player whichPlayer, boolean includeIncomplete returns integer
constant native GetPlayerTypedUnitCount takes player whichPlayer, string unitName, boolean includeIncomplete, boolean includeUpgrades returns integer
constant native GetPlayerStructureCount takes player whichPlayer, boolean includeIncomplete returns integer
constant native GetPlayerState          takes player whichPlayer, playerstate whichPlayerState returns integer
constant native GetPlayerScore          takes player whichPlayer, playerscore whichPlayerScore returns integer
constant native GetPlayerAlliance       takes player sourcePlayer, player otherPlayer, alliancetype whichAllianceSetting returns boolean

constant native GetPlayerHandicap       takes player whichPlayer returns real
constant native GetPlayerHandicapXP     takes player whichPlayer returns real
constant native GetPlayerHandicapReviveTime takes player whichPlayer returns real
constant native GetPlayerHandicapDamage takes player whichPlayer returns real
constant native SetPlayerHandicap       takes player whichPlayer, real handicap returns nothing
constant native SetPlayerHandicapXP     takes player whichPlayer, real handicap returns nothing
constant native SetPlayerHandicapReviveTime takes player whichPlayer, real handicap returns nothing
constant native SetPlayerHandicapDamage takes player whichPlayer, real handicap returns nothing

constant native SetPlayerTechMaxAllowed takes player whichPlayer, integer techid, integer maximum returns nothing
constant native GetPlayerTechMaxAllowed takes player whichPlayer, integer techid returns integer
constant native AddPlayerTechResearched takes player whichPlayer, integer techid, integer levels returns nothing
constant native SetPlayerTechResearched takes player whichPlayer, integer techid, integer setToLevel returns nothing
constant native GetPlayerTechResearched takes player whichPlayer, integer techid, boolean specificonly returns boolean
constant native GetPlayerTechCount      takes player whichPlayer, integer techid, boolean specificonly returns integer

native SetPlayerUnitsOwner takes player whichPlayer, integer newOwner returns nothing
native CripplePlayer takes player whichPlayer, force toWhichPlayers, boolean flag returns nothing

native SetPlayerAbilityAvailable        takes player whichPlayer, integer abilid, boolean avail returns nothing

native SetPlayerState   takes player whichPlayer, playerstate whichPlayerState, integer value returns nothing
native RemovePlayer     takes player whichPlayer, playergameresult gameResult returns nothing

// Used to store hero level data for the scorescreen
// before units are moved to neutral passive in melee games
//
native CachePlayerHeroData takes player whichPlayer returns nothing

//============================================================================
// Fog of War API
native  SetFogStateRect      takes player forWhichPlayer, fogstate whichState, rect where, boolean useSharedVision returns nothing
native  SetFogStateRadius    takes player forWhichPlayer, fogstate whichState, real centerx, real centerY, real radius, boolean useSharedVision returns nothing
native  SetFogStateRadiusLoc takes player forWhichPlayer, fogstate whichState, location center, real radius, boolean useSharedVision returns nothing
native  FogMaskEnable        takes boolean enable returns nothing
native  IsFogMaskEnabled     takes nothing returns boolean
native  FogEnable            takes boolean enable returns nothing
native  IsFogEnabled         takes nothing returns boolean

native CreateFogModifierRect        takes player forWhichPlayer, fogstate whichState, rect where, boolean useSharedVision, boolean afterUnits returns fogmodifier
native CreateFogModifierRadius      takes player forWhichPlayer, fogstate whichState, real centerx, real centerY, real radius, boolean useSharedVision, boolean afterUnits returns fogmodifier
native CreateFogModifierRadiusLoc   takes player forWhichPlayer, fogstate whichState, location center, real radius, boolean useSharedVision, boolean afterUnits returns fogmodifier
native DestroyFogModifier           takes fogmodifier whichFogModifier returns nothing
native FogModifierStart             takes fogmodifier whichFogModifier returns nothing
native FogModifierStop              takes fogmodifier whichFogModifier returns nothing

//============================================================================
// Game API
native VersionGet takes nothing returns version
native VersionCompatible takes version whichVersion returns boolean
native VersionSupported takes version whichVersion returns boolean

native EndGame takes boolean doScoreScreen returns nothing

// Async only!
native          ChangeLevel         takes string newLevel, boolean doScoreScreen returns nothing
native          RestartGame         takes boolean doScoreScreen returns nothing
native          ReloadGame          takes nothing returns nothing
// %%% SetCampaignMenuRace is deprecated.  It must remain to support
// old maps which use it, but all new maps should use SetCampaignMenuRaceEx
native          SetCampaignMenuRace takes race r returns nothing
native          SetCampaignMenuRaceEx takes integer campaignIndex returns nothing
native          ForceCampaignSelectScreen takes nothing returns nothing

native          LoadGame            	takes string saveFileName, boolean doScoreScreen returns nothing
native          SaveGame            	takes string saveFileName returns nothing
native          RenameSaveDirectory 	takes string sourceDirName, string destDirName returns boolean
native          RemoveSaveDirectory 	takes string sourceDirName returns boolean
native          CopySaveGame        	takes string sourceSaveName, string destSaveName returns boolean
native          SaveGameExists      	takes string saveName returns boolean
native          SetMaxCheckpointSaves  	takes integer maxCheckpointSaves returns nothing
native          SaveGameCheckpoint  	takes string saveFileName, boolean showWindow returns nothing
native          SyncSelections      	takes nothing returns nothing
native          SetFloatGameState   	takes fgamestate whichFloatGameState, real value returns nothing
constant native GetFloatGameState   	takes fgamestate whichFloatGameState returns real
native          SetIntegerGameState 	takes igamestate whichIntegerGameState, integer value returns nothing
constant native GetIntegerGameState		takes igamestate whichIntegerGameState returns integer


//============================================================================
// Campaign API
native  SetTutorialCleared      takes boolean cleared returns nothing
native  SetMissionAvailable     takes integer campaignNumber, integer missionNumber, boolean available returns nothing
native  SetCampaignAvailable    takes integer campaignNumber, boolean available  returns nothing
native  SetOpCinematicAvailable takes integer campaignNumber, boolean available  returns nothing
native  SetEdCinematicAvailable takes integer campaignNumber, boolean available  returns nothing
native  GetDefaultDifficulty    takes nothing returns gamedifficulty
native  SetDefaultDifficulty    takes gamedifficulty g returns nothing
native  SetCustomCampaignButtonVisible  takes integer whichButton, boolean visible returns nothing
native  GetCustomCampaignButtonVisible  takes integer whichButton returns boolean
native  DoNotSaveReplay         takes nothing returns nothing

//============================================================================
// Dialog API
native DialogCreate                 takes nothing returns dialog
native DialogDestroy                takes dialog whichDialog returns nothing
native DialogClear                  takes dialog whichDialog returns nothing
native DialogSetMessage             takes dialog whichDialog, string messageText returns nothing
native DialogAddButton              takes dialog whichDialog, string buttonText, integer hotkey returns button
native DialogAddQuitButton          takes dialog whichDialog, boolean doScoreScreen, string buttonText, integer hotkey returns button
native DialogDisplay                takes player whichPlayer, dialog whichDialog, boolean flag returns nothing

// Creates a new or reads in an existing game cache file stored
// in the current campaign profile dir
//
native  ReloadGameCachesFromDisk takes nothing returns boolean

native  InitGameCache    takes string campaignFile returns gamecache
native  SaveGameCache    takes gamecache whichCache returns boolean

native  StoreInteger					takes gamecache cache, string missionKey, string key, integer value returns nothing
native  StoreReal						takes gamecache cache, string missionKey, string key, real value returns nothing
native  StoreBoolean					takes gamecache cache, string missionKey, string key, boolean value returns nothing
native  StoreUnit						takes gamecache cache, string missionKey, string key, unit whichUnit returns boolean
native  StoreString						takes gamecache cache, string missionKey, string key, string value returns boolean

native SyncStoredInteger        takes gamecache cache, string missionKey, string key returns nothing
native SyncStoredReal           takes gamecache cache, string missionKey, string key returns nothing
native SyncStoredBoolean        takes gamecache cache, string missionKey, string key returns nothing
native SyncStoredUnit           takes gamecache cache, string missionKey, string key returns nothing
native SyncStoredString         takes gamecache cache, string missionKey, string key returns nothing

native  HaveStoredInteger					takes gamecache cache, string missionKey, string key returns boolean
native  HaveStoredReal						takes gamecache cache, string missionKey, string key returns boolean
native  HaveStoredBoolean					takes gamecache cache, string missionKey, string key returns boolean
native  HaveStoredUnit						takes gamecache cache, string missionKey, string key returns boolean
native  HaveStoredString					takes gamecache cache, string missionKey, string key returns boolean

native  FlushGameCache						takes gamecache cache returns nothing
native  FlushStoredMission					takes gamecache cache, string missionKey returns nothing
native  FlushStoredInteger					takes gamecache cache, string missionKey, string key returns nothing
native  FlushStoredReal						takes gamecache cache, string missionKey, string key returns nothing
native  FlushStoredBoolean					takes gamecache cache, string missionKey, string key returns nothing
native  FlushStoredUnit						takes gamecache cache, string missionKey, string key returns nothing
native  FlushStoredString					takes gamecache cache, string missionKey, string key returns nothing

// Will return 0 if the specified value's data is not found in the cache
native  GetStoredInteger				takes gamecache cache, string missionKey, string key returns integer
native  GetStoredReal					takes gamecache cache, string missionKey, string key returns real
native  GetStoredBoolean				takes gamecache cache, string missionKey, string key returns boolean
native  GetStoredString					takes gamecache cache, string missionKey, string key returns string
native  RestoreUnit						takes gamecache cache, string missionKey, string key, player forWhichPlayer, real x, real y, real facing returns unit


native  InitHashtable    takes nothing returns hashtable

native  SaveInteger						takes hashtable table, integer parentKey, integer childKey, integer value returns nothing
native  SaveReal						takes hashtable table, integer parentKey, integer childKey, real value returns nothing
native  SaveBoolean						takes hashtable table, integer parentKey, integer childKey, boolean value returns nothing
native  SaveStr							takes hashtable table, integer parentKey, integer childKey, string value returns boolean
native  SavePlayerHandle				takes hashtable table, integer parentKey, integer childKey, player whichPlayer returns boolean
native  SaveWidgetHandle				takes hashtable table, integer parentKey, integer childKey, widget whichWidget returns boolean
native  SaveDestructableHandle			takes hashtable table, integer parentKey, integer childKey, destructable whichDestructable returns boolean
native  SaveItemHandle					takes hashtable table, integer parentKey, integer childKey, item whichItem returns boolean
native  SaveUnitHandle					takes hashtable table, integer parentKey, integer childKey, unit whichUnit returns boolean
native  SaveAbilityHandle				takes hashtable table, integer parentKey, integer childKey, ability whichAbility returns boolean
native  SaveTimerHandle					takes hashtable table, integer parentKey, integer childKey, timer whichTimer returns boolean
native  SaveTriggerHandle				takes hashtable table, integer parentKey, integer childKey, trigger whichTrigger returns boolean
native  SaveTriggerConditionHandle		takes hashtable table, integer parentKey, integer childKey, triggercondition whichTriggercondition returns boolean
native  SaveTriggerActionHandle			takes hashtable table, integer parentKey, integer childKey, triggeraction whichTriggeraction returns boolean
native  SaveTriggerEventHandle			takes hashtable table, integer parentKey, integer childKey, event whichEvent returns boolean
native  SaveForceHandle					takes hashtable table, integer parentKey, integer childKey, force whichForce returns boolean
native  SaveGroupHandle					takes hashtable table, integer parentKey, integer childKey, group whichGroup returns boolean
native  SaveLocationHandle				takes hashtable table, integer parentKey, integer childKey, location whichLocation returns boolean
native  SaveRectHandle					takes hashtable table, integer parentKey, integer childKey, rect whichRect returns boolean
native  SaveBooleanExprHandle			takes hashtable table, integer parentKey, integer childKey, boolexpr whichBoolexpr returns boolean
native  SaveSoundHandle					takes hashtable table, integer parentKey, integer childKey, sound whichSound returns boolean
native  SaveEffectHandle				takes hashtable table, integer parentKey, integer childKey, effect whichEffect returns boolean
native  SaveUnitPoolHandle				takes hashtable table, integer parentKey, integer childKey, unitpool whichUnitpool returns boolean
native  SaveItemPoolHandle				takes hashtable table, integer parentKey, integer childKey, itempool whichItempool returns boolean
native  SaveQuestHandle					takes hashtable table, integer parentKey, integer childKey, quest whichQuest returns boolean
native  SaveQuestItemHandle				takes hashtable table, integer parentKey, integer childKey, questitem whichQuestitem returns boolean
native  SaveDefeatConditionHandle		takes hashtable table, integer parentKey, integer childKey, defeatcondition whichDefeatcondition returns boolean
native  SaveTimerDialogHandle			takes hashtable table, integer parentKey, integer childKey, timerdialog whichTimerdialog returns boolean
native  SaveLeaderboardHandle			takes hashtable table, integer parentKey, integer childKey, leaderboard whichLeaderboard returns boolean
native  SaveMultiboardHandle			takes hashtable table, integer parentKey, integer childKey, multiboard whichMultiboard returns boolean
native  SaveMultiboardItemHandle		takes hashtable table, integer parentKey, integer childKey, multiboarditem whichMultiboarditem returns boolean
native  SaveTrackableHandle				takes hashtable table, integer parentKey, integer childKey, trackable whichTrackable returns boolean
native  SaveDialogHandle				takes hashtable table, integer parentKey, integer childKey, dialog whichDialog returns boolean
native  SaveButtonHandle				takes hashtable table, integer parentKey, integer childKey, button whichButton returns boolean
native  SaveTextTagHandle				takes hashtable table, integer parentKey, integer childKey, texttag whichTexttag returns boolean
native  SaveLightningHandle				takes hashtable table, integer parentKey, integer childKey, lightning whichLightning returns boolean
native  SaveImageHandle					takes hashtable table, integer parentKey, integer childKey, image whichImage returns boolean
native  SaveUbersplatHandle				takes hashtable table, integer parentKey, integer childKey, ubersplat whichUbersplat returns boolean
native  SaveRegionHandle				takes hashtable table, integer parentKey, integer childKey, region whichRegion returns boolean
native  SaveFogStateHandle				takes hashtable table, integer parentKey, integer childKey, fogstate whichFogState returns boolean
native  SaveFogModifierHandle			takes hashtable table, integer parentKey, integer childKey, fogmodifier whichFogModifier returns boolean
native  SaveAgentHandle					takes hashtable table, integer parentKey, integer childKey, agent whichAgent returns boolean
native  SaveHashtableHandle				takes hashtable table, integer parentKey, integer childKey, hashtable whichHashtable returns boolean
native  SaveFrameHandle					takes hashtable table, integer parentKey, integer childKey, framehandle whichFrameHandle returns boolean


native  LoadInteger					takes hashtable table, integer parentKey, integer childKey returns integer
native  LoadReal					takes hashtable table, integer parentKey, integer childKey returns real
native  LoadBoolean				    takes hashtable table, integer parentKey, integer childKey returns boolean
native  LoadStr 					takes hashtable table, integer parentKey, integer childKey returns string
native  LoadPlayerHandle			takes hashtable table, integer parentKey, integer childKey returns player
native  LoadWidgetHandle			takes hashtable table, integer parentKey, integer childKey returns widget
native  LoadDestructableHandle		takes hashtable table, integer parentKey, integer childKey returns destructable
native  LoadItemHandle				takes hashtable table, integer parentKey, integer childKey returns item
native  LoadUnitHandle				takes hashtable table, integer parentKey, integer childKey returns unit
native  LoadAbilityHandle			takes hashtable table, integer parentKey, integer childKey returns ability
native  LoadTimerHandle				takes hashtable table, integer parentKey, integer childKey returns timer
native  LoadTriggerHandle			takes hashtable table, integer parentKey, integer childKey returns trigger
native  LoadTriggerConditionHandle	takes hashtable table, integer parentKey, integer childKey returns triggercondition
native  LoadTriggerActionHandle		takes hashtable table, integer parentKey, integer childKey returns triggeraction
native  LoadTriggerEventHandle		takes hashtable table, integer parentKey, integer childKey returns event
native  LoadForceHandle				takes hashtable table, integer parentKey, integer childKey returns force
native  LoadGroupHandle				takes hashtable table, integer parentKey, integer childKey returns group
native  LoadLocationHandle			takes hashtable table, integer parentKey, integer childKey returns location
native  LoadRectHandle				takes hashtable table, integer parentKey, integer childKey returns rect
native  LoadBooleanExprHandle		takes hashtable table, integer parentKey, integer childKey returns boolexpr
native  LoadSoundHandle				takes hashtable table, integer parentKey, integer childKey returns sound
native  LoadEffectHandle			takes hashtable table, integer parentKey, integer childKey returns effect
native  LoadUnitPoolHandle			takes hashtable table, integer parentKey, integer childKey returns unitpool
native  LoadItemPoolHandle			takes hashtable table, integer parentKey, integer childKey returns itempool
native  LoadQuestHandle				takes hashtable table, integer parentKey, integer childKey returns quest
native  LoadQuestItemHandle			takes hashtable table, integer parentKey, integer childKey returns questitem
native  LoadDefeatConditionHandle	takes hashtable table, integer parentKey, integer childKey returns defeatcondition
native  LoadTimerDialogHandle		takes hashtable table, integer parentKey, integer childKey returns timerdialog
native  LoadLeaderboardHandle		takes hashtable table, integer parentKey, integer childKey returns leaderboard
native  LoadMultiboardHandle		takes hashtable table, integer parentKey, integer childKey returns multiboard
native  LoadMultiboardItemHandle	takes hashtable table, integer parentKey, integer childKey returns multiboarditem
native  LoadTrackableHandle			takes hashtable table, integer parentKey, integer childKey returns trackable
native  LoadDialogHandle			takes hashtable table, integer parentKey, integer childKey returns dialog
native  LoadButtonHandle			takes hashtable table, integer parentKey, integer childKey returns button
native  LoadTextTagHandle			takes hashtable table, integer parentKey, integer childKey returns texttag
native  LoadLightningHandle			takes hashtable table, integer parentKey, integer childKey returns lightning
native  LoadImageHandle				takes hashtable table, integer parentKey, integer childKey returns image
native  LoadUbersplatHandle			takes hashtable table, integer parentKey, integer childKey returns ubersplat
native  LoadRegionHandle			takes hashtable table, integer parentKey, integer childKey returns region
native  LoadFogStateHandle			takes hashtable table, integer parentKey, integer childKey returns fogstate
native  LoadFogModifierHandle		takes hashtable table, integer parentKey, integer childKey returns fogmodifier
native  LoadHashtableHandle			takes hashtable table, integer parentKey, integer childKey returns hashtable
native  LoadFrameHandle				takes hashtable table, integer parentKey, integer childKey returns framehandle

native  HaveSavedInteger					takes hashtable table, integer parentKey, integer childKey returns boolean
native  HaveSavedReal						takes hashtable table, integer parentKey, integer childKey returns boolean
native  HaveSavedBoolean					takes hashtable table, integer parentKey, integer childKey returns boolean
native  HaveSavedString					    takes hashtable table, integer parentKey, integer childKey returns boolean
native  HaveSavedHandle     				takes hashtable table, integer parentKey, integer childKey returns boolean

native  RemoveSavedInteger					takes hashtable table, integer parentKey, integer childKey returns nothing
native  RemoveSavedReal						takes hashtable table, integer parentKey, integer childKey returns nothing
native  RemoveSavedBoolean					takes hashtable table, integer parentKey, integer childKey returns nothing
native  RemoveSavedString					takes hashtable table, integer parentKey, integer childKey returns nothing
native  RemoveSavedHandle					takes hashtable table, integer parentKey, integer childKey returns nothing

native  FlushParentHashtable						takes hashtable table returns nothing
native  FlushChildHashtable					takes hashtable table, integer parentKey returns nothing


//============================================================================
// Randomization API
native GetRandomInt takes integer lowBound, integer highBound returns integer
native GetRandomReal takes real lowBound, real highBound returns real

native CreateUnitPool           takes nothing returns unitpool
native DestroyUnitPool          takes unitpool whichPool returns nothing
native UnitPoolAddUnitType      takes unitpool whichPool, integer unitId, real weight returns nothing
native UnitPoolRemoveUnitType   takes unitpool whichPool, integer unitId returns nothing
native PlaceRandomUnit          takes unitpool whichPool, player forWhichPlayer, real x, real y, real facing returns unit

native CreateItemPool           takes nothing returns itempool
native DestroyItemPool          takes itempool whichItemPool returns nothing
native ItemPoolAddItemType      takes itempool whichItemPool, integer itemId, real weight returns nothing
native ItemPoolRemoveItemType   takes itempool whichItemPool, integer itemId returns nothing
native PlaceRandomItem          takes itempool whichItemPool, real x, real y returns item

// Choose any random unit/item. (NP means Neutral Passive)
native ChooseRandomCreep        takes integer level returns integer
native ChooseRandomNPBuilding   takes nothing returns integer
native ChooseRandomItem         takes integer level returns integer
native ChooseRandomItemEx       takes itemtype whichType, integer level returns integer
native SetRandomSeed            takes integer seed returns nothing

//============================================================================
// Visual API
native SetTerrainFog                takes real a, real b, real c, real d, real e returns nothing
native ResetTerrainFog              takes nothing returns nothing

native SetUnitFog                   takes real a, real b, real c, real d, real e returns nothing
native SetTerrainFogEx              takes integer style, real zstart, real zend, real density, real red, real green, real blue returns nothing
native DisplayTextToPlayer          takes player toPlayer, real x, real y, string message returns nothing
native DisplayTimedTextToPlayer     takes player toPlayer, real x, real y, real duration, string message returns nothing
native DisplayTimedTextFromPlayer   takes player toPlayer, real x, real y, real duration, string message returns nothing
native ClearTextMessages            takes nothing returns nothing
native SetDayNightModels            takes string terrainDNCFile, string unitDNCFile returns nothing
native SetPortraitLight             takes string portraitDNCFile returns nothing
native SetSkyModel                  takes string skyModelFile returns nothing
native EnableUserControl            takes boolean b returns nothing
native EnableUserUI                 takes boolean b returns nothing
native SuspendTimeOfDay             takes boolean b returns nothing
native SetTimeOfDayScale            takes real r returns nothing
native GetTimeOfDayScale            takes nothing returns real
native ShowInterface                takes boolean flag, real fadeDuration returns nothing
native PauseGame                    takes boolean flag returns nothing
native UnitAddIndicator             takes unit whichUnit, integer red, integer green, integer blue, integer alpha returns nothing
native AddIndicator                 takes widget whichWidget, integer red, integer green, integer blue, integer alpha returns nothing
native PingMinimap                  takes real x, real y, real duration returns nothing
native PingMinimapEx                takes real x, real y, real duration, integer red, integer green, integer blue, boolean extraEffects returns nothing
native CreateMinimapIconOnUnit      takes unit whichUnit, integer red, integer green, integer blue, string pingPath, fogstate fogVisibility returns minimapicon
native CreateMinimapIconAtLoc       takes location where, integer red, integer green, integer blue, string pingPath, fogstate fogVisibility returns minimapicon
native CreateMinimapIcon            takes real x, real y, integer red, integer green, integer blue, string pingPath, fogstate fogVisibility returns minimapicon
native SkinManagerGetLocalPath      takes string key returns string
native DestroyMinimapIcon           takes minimapicon pingId returns nothing
native SetMinimapIconVisible        takes minimapicon whichMinimapIcon, boolean visible returns nothing
native SetMinimapIconOrphanDestroy  takes minimapicon whichMinimapIcon, boolean doDestroy returns nothing
native EnableOcclusion              takes boolean flag returns nothing
native SetIntroShotText             takes string introText returns nothing
native SetIntroShotModel            takes string introModelPath returns nothing
native EnableWorldFogBoundary       takes boolean b returns nothing
native PlayModelCinematic           takes string modelName returns nothing
native PlayCinematic                takes string movieName returns nothing
native ForceUIKey                   takes string key returns nothing
native ForceUICancel                takes nothing returns nothing
native DisplayLoadDialog            takes nothing returns nothing
native SetAltMinimapIcon            takes string iconPath returns nothing
native DisableRestartMission        takes boolean flag returns nothing

native CreateTextTag                takes nothing returns texttag
native DestroyTextTag               takes texttag t returns nothing
native SetTextTagText               takes texttag t, string s, real height returns nothing
native SetTextTagPos                takes texttag t, real x, real y, real heightOffset returns nothing
native SetTextTagPosUnit            takes texttag t, unit whichUnit, real heightOffset returns nothing
native SetTextTagColor              takes texttag t, integer red, integer green, integer blue, integer alpha returns nothing
native SetTextTagVelocity           takes texttag t, real xvel, real yvel returns nothing
native SetTextTagVisibility         takes texttag t, boolean flag returns nothing
native SetTextTagSuspended          takes texttag t, boolean flag returns nothing
native SetTextTagPermanent          takes texttag t, boolean flag returns nothing
native SetTextTagAge                takes texttag t, real age returns nothing
native SetTextTagLifespan           takes texttag t, real lifespan returns nothing
native SetTextTagFadepoint          takes texttag t, real fadepoint returns nothing

native SetReservedLocalHeroButtons  takes integer reserved returns nothing
native GetAllyColorFilterState      takes nothing returns integer
native SetAllyColorFilterState      takes integer state returns nothing
native GetCreepCampFilterState      takes nothing returns boolean
native SetCreepCampFilterState      takes boolean state returns nothing
native EnableMinimapFilterButtons   takes boolean enableAlly, boolean enableCreep returns nothing
native EnableDragSelect             takes boolean state, boolean ui returns nothing
native EnablePreSelect              takes boolean state, boolean ui returns nothing
native EnableSelect                 takes boolean state, boolean ui returns nothing

//============================================================================
// Trackable API
native CreateTrackable      takes string trackableModelPath, real x, real y, real facing returns trackable

//============================================================================
// Quest API
native CreateQuest          takes nothing returns quest
native DestroyQuest         takes quest whichQuest returns nothing
native QuestSetTitle        takes quest whichQuest, string title returns nothing
native QuestSetDescription  takes quest whichQuest, string description returns nothing
native QuestSetIconPath     takes quest whichQuest, string iconPath returns nothing

native QuestSetRequired     takes quest whichQuest, boolean required   returns nothing
native QuestSetCompleted    takes quest whichQuest, boolean completed  returns nothing
native QuestSetDiscovered   takes quest whichQuest, boolean discovered returns nothing
native QuestSetFailed       takes quest whichQuest, boolean failed     returns nothing
native QuestSetEnabled      takes quest whichQuest, boolean enabled    returns nothing

native IsQuestRequired     takes quest whichQuest returns boolean
native IsQuestCompleted    takes quest whichQuest returns boolean
native IsQuestDiscovered   takes quest whichQuest returns boolean
native IsQuestFailed       takes quest whichQuest returns boolean
native IsQuestEnabled      takes quest whichQuest returns boolean

native QuestCreateItem          takes quest whichQuest returns questitem
native QuestItemSetDescription  takes questitem whichQuestItem, string description returns nothing
native QuestItemSetCompleted    takes questitem whichQuestItem, boolean completed returns nothing

native IsQuestItemCompleted     takes questitem whichQuestItem returns boolean

native CreateDefeatCondition            takes nothing returns defeatcondition
native DestroyDefeatCondition           takes defeatcondition whichCondition returns nothing
native DefeatConditionSetDescription    takes defeatcondition whichCondition, string description returns nothing

native FlashQuestDialogButton   takes nothing returns nothing
native ForceQuestDialogUpdate   takes nothing returns nothing

//============================================================================
// Timer Dialog API
native CreateTimerDialog                takes timer t returns timerdialog
native DestroyTimerDialog               takes timerdialog whichDialog returns nothing
native TimerDialogSetTitle              takes timerdialog whichDialog, string title returns nothing
native TimerDialogSetTitleColor         takes timerdialog whichDialog, integer red, integer green, integer blue, integer alpha returns nothing
native TimerDialogSetTimeColor          takes timerdialog whichDialog, integer red, integer green, integer blue, integer alpha returns nothing
native TimerDialogSetSpeed              takes timerdialog whichDialog, real speedMultFactor returns nothing
native TimerDialogDisplay               takes timerdialog whichDialog, boolean display returns nothing
native IsTimerDialogDisplayed           takes timerdialog whichDialog returns boolean
native TimerDialogSetRealTimeRemaining  takes timerdialog whichDialog, real timeRemaining returns nothing

//============================================================================
// Leaderboard API

// Create a leaderboard object
native CreateLeaderboard                takes nothing returns leaderboard
native DestroyLeaderboard               takes leaderboard lb returns nothing

native LeaderboardDisplay               takes leaderboard lb, boolean show returns nothing
native IsLeaderboardDisplayed           takes leaderboard lb returns boolean

native LeaderboardGetItemCount          takes leaderboard lb returns integer

native LeaderboardSetSizeByItemCount    takes leaderboard lb, integer count returns nothing
native LeaderboardAddItem               takes leaderboard lb, string label, integer value, player p returns nothing
native LeaderboardRemoveItem            takes leaderboard lb, integer index returns nothing
native LeaderboardRemovePlayerItem      takes leaderboard lb, player p returns nothing
native LeaderboardClear                 takes leaderboard lb returns nothing

native LeaderboardSortItemsByValue      takes leaderboard lb, boolean ascending returns nothing
native LeaderboardSortItemsByPlayer     takes leaderboard lb, boolean ascending returns nothing
native LeaderboardSortItemsByLabel      takes leaderboard lb, boolean ascending returns nothing

native LeaderboardHasPlayerItem         takes leaderboard lb, player p returns boolean
native LeaderboardGetPlayerIndex        takes leaderboard lb, player p returns integer
native LeaderboardSetLabel              takes leaderboard lb, string label returns nothing
native LeaderboardGetLabelText          takes leaderboard lb returns string

native PlayerSetLeaderboard             takes player toPlayer, leaderboard lb returns nothing
native PlayerGetLeaderboard             takes player toPlayer returns leaderboard

native LeaderboardSetLabelColor         takes leaderboard lb, integer red, integer green, integer blue, integer alpha returns nothing
native LeaderboardSetValueColor         takes leaderboard lb, integer red, integer green, integer blue, integer alpha returns nothing
native LeaderboardSetStyle              takes leaderboard lb, boolean showLabel, boolean showNames, boolean showValues, boolean showIcons returns nothing

native LeaderboardSetItemValue          takes leaderboard lb, integer whichItem, integer val returns nothing
native LeaderboardSetItemLabel          takes leaderboard lb, integer whichItem, string val returns nothing
native LeaderboardSetItemStyle          takes leaderboard lb, integer whichItem, boolean showLabel, boolean showValue, boolean showIcon returns nothing
native LeaderboardSetItemLabelColor     takes leaderboard lb, integer whichItem, integer red, integer green, integer blue, integer alpha returns nothing
native LeaderboardSetItemValueColor     takes leaderboard lb, integer whichItem, integer red, integer green, integer blue, integer alpha returns nothing

//============================================================================
// Multiboard API
//============================================================================

// Create a multiboard object
native CreateMultiboard                 takes nothing returns multiboard
native DestroyMultiboard                takes multiboard lb returns nothing

native MultiboardDisplay                takes multiboard lb, boolean show returns nothing
native IsMultiboardDisplayed            takes multiboard lb returns boolean

native MultiboardMinimize               takes multiboard lb, boolean minimize returns nothing
native IsMultiboardMinimized            takes multiboard lb returns boolean
native MultiboardClear                  takes multiboard lb returns nothing

native MultiboardSetTitleText           takes multiboard lb, string label returns nothing
native MultiboardGetTitleText           takes multiboard lb returns string
native MultiboardSetTitleTextColor      takes multiboard lb, integer red, integer green, integer blue, integer alpha returns nothing

native MultiboardGetRowCount            takes multiboard lb returns integer
native MultiboardGetColumnCount         takes multiboard lb returns integer

native MultiboardSetColumnCount         takes multiboard lb, integer count returns nothing
native MultiboardSetRowCount            takes multiboard lb, integer count returns nothing

// broadcast settings to all items
native MultiboardSetItemsStyle          takes multiboard lb, boolean showValues, boolean showIcons returns nothing
native MultiboardSetItemsValue          takes multiboard lb, string value returns nothing
native MultiboardSetItemsValueColor     takes multiboard lb, integer red, integer green, integer blue, integer alpha returns nothing
native MultiboardSetItemsWidth          takes multiboard lb, real width returns nothing
native MultiboardSetItemsIcon           takes multiboard lb, string iconPath returns nothing


// funcs for modifying individual items
native MultiboardGetItem                takes multiboard lb, integer row, integer column returns multiboarditem
native MultiboardReleaseItem            takes multiboarditem mbi returns nothing

native MultiboardSetItemStyle           takes multiboarditem mbi, boolean showValue, boolean showIcon returns nothing
native MultiboardSetItemValue           takes multiboarditem mbi, string val returns nothing
native MultiboardSetItemValueColor      takes multiboarditem mbi, integer red, integer green, integer blue, integer alpha returns nothing
native MultiboardSetItemWidth           takes multiboarditem mbi, real width returns nothing
native MultiboardSetItemIcon            takes multiboarditem mbi, string iconFileName returns nothing

// meant to unequivocally suspend display of existing and
// subsequently displayed multiboards
//
native MultiboardSuppressDisplay        takes boolean flag returns nothing

//============================================================================
// Camera API
native SetCameraPosition            takes real x, real y returns nothing
native SetCameraQuickPosition       takes real x, real y returns nothing
native SetCameraBounds              takes real x1, real y1, real x2, real y2, real x3, real y3, real x4, real y4 returns nothing
native StopCamera                   takes nothing returns nothing
native ResetToGameCamera            takes real duration returns nothing
native PanCameraTo                  takes real x, real y returns nothing
native PanCameraToTimed             takes real x, real y, real duration returns nothing
native PanCameraToWithZ             takes real x, real y, real zOffsetDest returns nothing
native PanCameraToTimedWithZ        takes real x, real y, real zOffsetDest, real duration returns nothing
native SetCinematicCamera           takes string cameraModelFile returns nothing
native SetCameraRotateMode          takes real x, real y, real radiansToSweep, real duration returns nothing
native SetCameraField               takes camerafield whichField, real value, real duration returns nothing
native AdjustCameraField            takes camerafield whichField, real offset, real duration returns nothing
native SetCameraTargetController    takes unit whichUnit, real xoffset, real yoffset, boolean inheritOrientation returns nothing
native SetCameraOrientController    takes unit whichUnit, real xoffset, real yoffset returns nothing

native CreateCameraSetup                    takes nothing returns camerasetup
native CameraSetupSetField                  takes camerasetup whichSetup, camerafield whichField, real value, real duration returns nothing
native CameraSetupGetField                  takes camerasetup whichSetup, camerafield whichField returns real
native CameraSetupSetDestPosition           takes camerasetup whichSetup, real x, real y, real duration returns nothing
native CameraSetupGetDestPositionLoc        takes camerasetup whichSetup returns location
native CameraSetupGetDestPositionX          takes camerasetup whichSetup returns real
native CameraSetupGetDestPositionY          takes camerasetup whichSetup returns real
native CameraSetupApply                     takes camerasetup whichSetup, boolean doPan, boolean panTimed returns nothing
native CameraSetupApplyWithZ                takes camerasetup whichSetup, real zDestOffset returns nothing
native CameraSetupApplyForceDuration        takes camerasetup whichSetup, boolean doPan, real forceDuration returns nothing
native CameraSetupApplyForceDurationWithZ   takes camerasetup whichSetup, real zDestOffset, real forceDuration returns nothing
native BlzCameraSetupSetLabel               takes camerasetup whichSetup, string label returns nothing
native BlzCameraSetupGetLabel               takes camerasetup whichSetup returns string

native CameraSetTargetNoise             takes real mag, real velocity returns nothing
native CameraSetSourceNoise             takes real mag, real velocity returns nothing

native CameraSetTargetNoiseEx           takes real mag, real velocity, boolean vertOnly returns nothing
native CameraSetSourceNoiseEx           takes real mag, real velocity, boolean vertOnly returns nothing

native CameraSetSmoothingFactor         takes real factor returns nothing

native CameraSetFocalDistance			takes real distance returns nothing
native CameraSetDepthOfFieldScale       takes real scale returns nothing

native SetCineFilterTexture             takes string filename returns nothing
native SetCineFilterBlendMode           takes blendmode whichMode returns nothing
native SetCineFilterTexMapFlags         takes texmapflags whichFlags returns nothing
native SetCineFilterStartUV             takes real minu, real minv, real maxu, real maxv returns nothing
native SetCineFilterEndUV               takes real minu, real minv, real maxu, real maxv returns nothing
native SetCineFilterStartColor          takes integer red, integer green, integer blue, integer alpha returns nothing
native SetCineFilterEndColor            takes integer red, integer green, integer blue, integer alpha returns nothing
native SetCineFilterDuration            takes real duration returns nothing
native DisplayCineFilter                takes boolean flag returns nothing
native IsCineFilterDisplayed            takes nothing returns boolean

native SetCinematicScene                takes integer portraitUnitId, playercolor color, string speakerTitle, string text, real sceneDuration, real voiceoverDuration returns nothing
native EndCinematicScene                takes nothing returns nothing
native ForceCinematicSubtitles          takes boolean flag returns nothing
native SetCinematicAudio                takes boolean cinematicAudio returns nothing

native GetCameraMargin                  takes integer whichMargin returns real

// These return values for the local players camera only...
constant native GetCameraBoundMinX          takes nothing returns real
constant native GetCameraBoundMinY          takes nothing returns real
constant native GetCameraBoundMaxX          takes nothing returns real
constant native GetCameraBoundMaxY          takes nothing returns real
constant native GetCameraField              takes camerafield whichField returns real
constant native GetCameraTargetPositionX    takes nothing returns real
constant native GetCameraTargetPositionY    takes nothing returns real
constant native GetCameraTargetPositionZ    takes nothing returns real
constant native GetCameraTargetPositionLoc  takes nothing returns location
constant native GetCameraEyePositionX       takes nothing returns real
constant native GetCameraEyePositionY       takes nothing returns real
constant native GetCameraEyePositionZ       takes nothing returns real
constant native GetCameraEyePositionLoc     takes nothing returns location

//============================================================================
// Sound API
//
native NewSoundEnvironment          takes string environmentName returns nothing

native CreateSound                  takes string fileName, boolean looping, boolean is3D, boolean stopwhenoutofrange, integer fadeInRate, integer fadeOutRate, string eaxSetting returns sound
native CreateSoundFilenameWithLabel takes string fileName, boolean looping, boolean is3D, boolean stopwhenoutofrange, integer fadeInRate, integer fadeOutRate, string SLKEntryName returns sound
native CreateSoundFromLabel         takes string soundLabel, boolean looping, boolean is3D, boolean stopwhenoutofrange, integer fadeInRate, integer fadeOutRate returns sound
native CreateMIDISound              takes string soundLabel, integer fadeInRate, integer fadeOutRate returns sound

native SetSoundParamsFromLabel      takes sound soundHandle, string soundLabel returns nothing
native SetSoundDistanceCutoff       takes sound soundHandle, real cutoff returns nothing
native SetSoundChannel              takes sound soundHandle, integer channel returns nothing
native SetSoundVolume               takes sound soundHandle, integer volume returns nothing
native SetSoundPitch                takes sound soundHandle, real pitch returns nothing

// the following method must be called immediately after calling "StartSound"
native SetSoundPlayPosition         takes sound soundHandle, integer millisecs returns nothing

// these calls are only valid if the sound was created with 3d enabled
native SetSoundDistances            takes sound soundHandle, real minDist, real maxDist returns nothing
native SetSoundConeAngles           takes sound soundHandle, real inside, real outside, integer outsideVolume returns nothing
native SetSoundConeOrientation      takes sound soundHandle, real x, real y, real z returns nothing
native SetSoundPosition             takes sound soundHandle, real x, real y, real z returns nothing
native SetSoundVelocity             takes sound soundHandle, real x, real y, real z returns nothing
native AttachSoundToUnit            takes sound soundHandle, unit whichUnit returns nothing

native StartSound                   takes sound soundHandle returns nothing
native StartSoundEx                 takes sound soundHandle, boolean fadeIn returns nothing
native StopSound                    takes sound soundHandle, boolean killWhenDone, boolean fadeOut returns nothing
native KillSoundWhenDone            takes sound soundHandle returns nothing

// Music Interface. Note that if music is disabled, these calls do nothing
native SetMapMusic                  takes string musicName, boolean random, integer index returns nothing
native ClearMapMusic                takes nothing returns nothing

native PlayMusic                    takes string musicName returns nothing
native PlayMusicEx                  takes string musicName, integer frommsecs, integer fadeinmsecs returns nothing
native StopMusic                    takes boolean fadeOut returns nothing
native ResumeMusic                  takes nothing returns nothing

native PlayThematicMusic            takes string musicFileName returns nothing
native PlayThematicMusicEx          takes string musicFileName, integer frommsecs returns nothing
native EndThematicMusic             takes nothing returns nothing

native SetMusicVolume               takes integer volume returns nothing
native SetMusicPlayPosition         takes integer millisecs returns nothing
native SetThematicMusicVolume       takes integer volume returns nothing
native SetThematicMusicPlayPosition takes integer millisecs returns nothing

// other music and sound calls
native SetSoundDuration             takes sound soundHandle, integer duration returns nothing
native GetSoundDuration             takes sound soundHandle returns integer
native GetSoundFileDuration         takes string musicFileName returns integer

native VolumeGroupSetVolume         takes volumegroup vgroup, real scale returns nothing
native VolumeGroupReset             takes nothing returns nothing

native GetSoundIsPlaying            takes sound soundHandle returns boolean
native GetSoundIsLoading            takes sound soundHandle returns boolean

native RegisterStackedSound         takes sound soundHandle, boolean byPosition, real rectwidth, real rectheight returns nothing
native UnregisterStackedSound       takes sound soundHandle, boolean byPosition, real rectwidth, real rectheight returns nothing

native SetSoundFacialAnimationLabel takes sound soundHandle, string animationLabel returns boolean
native SetSoundFacialAnimationGroupLabel takes sound soundHandle, string groupLabel returns boolean
native SetSoundFacialAnimationSetFilepath takes sound soundHandle, string animationSetFilepath returns boolean

//Subtitle support that is attached to the soundHandle rather than as disperate data with the legacy UI
native SetDialogueSpeakerNameKey    takes sound soundHandle, string speakerName returns boolean
native GetDialogueSpeakerNameKey    takes sound soundHandle returns string
native SetDialogueTextKey           takes sound soundHandle, string dialogueText returns boolean
native GetDialogueTextKey           takes sound soundHandle returns string

//============================================================================
// Effects API
//
native AddWeatherEffect             takes rect where, integer effectID returns weathereffect
native RemoveWeatherEffect          takes weathereffect whichEffect returns nothing
native EnableWeatherEffect          takes weathereffect whichEffect, boolean enable returns nothing

native TerrainDeformCrater          takes real x, real y, real radius, real depth, integer duration, boolean permanent returns terraindeformation
native TerrainDeformRipple          takes real x, real y, real radius, real depth, integer duration, integer count, real spaceWaves, real timeWaves, real radiusStartPct, boolean limitNeg returns terraindeformation
native TerrainDeformWave            takes real x, real y, real dirX, real dirY, real distance, real speed, real radius, real depth, integer trailTime, integer count returns terraindeformation
native TerrainDeformRandom          takes real x, real y, real radius, real minDelta, real maxDelta, integer duration, integer updateInterval returns terraindeformation
native TerrainDeformStop            takes terraindeformation deformation, integer duration returns nothing
native TerrainDeformStopAll         takes nothing returns nothing

native AddSpecialEffect             takes string modelName, real x, real y returns effect
native AddSpecialEffectLoc          takes string modelName, location where returns effect
native AddSpecialEffectTarget       takes string modelName, widget targetWidget, string attachPointName returns effect
native DestroyEffect                takes effect whichEffect returns nothing

native AddSpellEffect               takes string abilityString, effecttype t, real x, real y returns effect
native AddSpellEffectLoc            takes string abilityString, effecttype t,location where returns effect
native AddSpellEffectById           takes integer abilityId, effecttype t,real x, real y returns effect
native AddSpellEffectByIdLoc        takes integer abilityId, effecttype t,location where returns effect
native AddSpellEffectTarget         takes string modelName, effecttype t, widget targetWidget, string attachPoint returns effect
native AddSpellEffectTargetById     takes integer abilityId, effecttype t, widget targetWidget, string attachPoint returns effect

native AddLightning                 takes string codeName, boolean checkVisibility, real x1, real y1, real x2, real y2 returns lightning
native AddLightningEx               takes string codeName, boolean checkVisibility, real x1, real y1, real z1, real x2, real y2, real z2 returns lightning
native DestroyLightning             takes lightning whichBolt returns boolean
native MoveLightning                takes lightning whichBolt, boolean checkVisibility, real x1, real y1, real x2, real y2 returns boolean
native MoveLightningEx              takes lightning whichBolt, boolean checkVisibility, real x1, real y1, real z1, real x2, real y2, real z2 returns boolean
native GetLightningColorA           takes lightning whichBolt returns real
native GetLightningColorR           takes lightning whichBolt returns real
native GetLightningColorG           takes lightning whichBolt returns real
native GetLightningColorB           takes lightning whichBolt returns real
native SetLightningColor            takes lightning whichBolt, real r, real g, real b, real a returns boolean

native GetAbilityEffect             takes string abilityString, effecttype t, integer index returns string
native GetAbilityEffectById         takes integer abilityId, effecttype t, integer index returns string
native GetAbilitySound              takes string abilityString, soundtype t returns string
native GetAbilitySoundById          takes integer abilityId, soundtype t returns string

//============================================================================
// Terrain API
//
native GetTerrainCliffLevel         takes real x, real y returns integer
native SetWaterBaseColor            takes integer red, integer green, integer blue, integer alpha returns nothing
native SetWaterDeforms              takes boolean val returns nothing
native GetTerrainType               takes real x, real y returns integer
native GetTerrainVariance           takes real x, real y returns integer
native SetTerrainType               takes real x, real y, integer terrainType, integer variation, integer area, integer shape returns nothing
native IsTerrainPathable            takes real x, real y, pathingtype t returns boolean
native SetTerrainPathable           takes real x, real y, pathingtype t, boolean flag returns nothing

//============================================================================
// Image API
//
native CreateImage                  takes string file, real sizeX, real sizeY, real sizeZ, real posX, real posY, real posZ, real originX, real originY, real originZ, integer imageType returns image
native DestroyImage                 takes image whichImage returns nothing
native ShowImage                    takes image whichImage, boolean flag returns nothing
native SetImageConstantHeight       takes image whichImage, boolean flag, real height returns nothing
native SetImagePosition             takes image whichImage, real x, real y, real z returns nothing
native SetImageColor                takes image whichImage, integer red, integer green, integer blue, integer alpha returns nothing
native SetImageRender               takes image whichImage, boolean flag returns nothing
native SetImageRenderAlways         takes image whichImage, boolean flag returns nothing
native SetImageAboveWater           takes image whichImage, boolean flag, boolean useWaterAlpha returns nothing
native SetImageType                 takes image whichImage, integer imageType returns nothing

//============================================================================
// Ubersplat API
//
native CreateUbersplat              takes real x, real y, string name, integer red, integer green, integer blue, integer alpha, boolean forcePaused, boolean noBirthTime returns ubersplat
native DestroyUbersplat             takes ubersplat whichSplat returns nothing
native ResetUbersplat               takes ubersplat whichSplat returns nothing
native FinishUbersplat              takes ubersplat whichSplat returns nothing
native ShowUbersplat                takes ubersplat whichSplat, boolean flag returns nothing
native SetUbersplatRender           takes ubersplat whichSplat, boolean flag returns nothing
native SetUbersplatRenderAlways     takes ubersplat whichSplat, boolean flag returns nothing

//============================================================================
// Blight API
//
native SetBlight                takes player whichPlayer, real x, real y, real radius, boolean addBlight returns nothing
native SetBlightRect            takes player whichPlayer, rect r, boolean addBlight returns nothing
native SetBlightPoint           takes player whichPlayer, real x, real y, boolean addBlight returns nothing
native SetBlightLoc             takes player whichPlayer, location whichLocation, real radius, boolean addBlight returns nothing
native CreateBlightedGoldmine   takes player id, real x, real y, real face returns unit
native IsPointBlighted          takes real x, real y returns boolean

//============================================================================
// Doodad API
//
native SetDoodadAnimation       takes real x, real y, real radius, integer doodadID, boolean nearestOnly, string animName, boolean animRandom returns nothing
native SetDoodadAnimationRect   takes rect r, integer doodadID, string animName, boolean animRandom returns nothing

//============================================================================
// Computer AI interface
//
native StartMeleeAI         takes player num, string script                 returns nothing
native StartCampaignAI      takes player num, string script                 returns nothing
native CommandAI            takes player num, integer command, integer data returns nothing
native PauseCompAI          takes player p,   boolean pause                 returns nothing
native GetAIDifficulty      takes player num                                returns aidifficulty

native RemoveGuardPosition  takes unit hUnit                                returns nothing
native RecycleGuardPosition takes unit hUnit                                returns nothing
native RemoveAllGuardPositions takes player num                             returns nothing

//============================================================================
native Cheat            takes string cheatStr returns nothing
native IsNoVictoryCheat takes nothing returns boolean
native IsNoDefeatCheat  takes nothing returns boolean

native Preload          takes string filename returns nothing
native PreloadEnd       takes real timeout returns nothing

native PreloadStart     takes nothing returns nothing
native PreloadRefresh   takes nothing returns nothing
native PreloadEndEx     takes nothing returns nothing

native PreloadGenClear  takes nothing returns nothing
native PreloadGenStart  takes nothing returns nothing
native PreloadGenEnd    takes string filename returns nothing
native Preloader        takes string filename returns nothing


//============================================================================
//Machinima API
//============================================================================
native BlzHideCinematicPanels                     takes boolean enable returns nothing


// Automation Test
native AutomationSetTestType                    takes string testType returns nothing
native AutomationTestStart                      takes string testName returns nothing
native AutomationTestEnd                        takes nothing returns nothing
native AutomationTestingFinished                takes nothing returns nothing

// JAPI Functions
native BlzGetTriggerPlayerMouseX                   takes nothing returns real
native BlzGetTriggerPlayerMouseY                   takes nothing returns real
native BlzGetTriggerPlayerMousePosition            takes nothing returns location
native BlzGetTriggerPlayerMouseButton              takes nothing returns mousebuttontype
native BlzSetAbilityTooltip                        takes integer abilCode, string tooltip, integer level returns nothing
native BlzSetAbilityActivatedTooltip               takes integer abilCode, string tooltip, integer level returns nothing
native BlzSetAbilityExtendedTooltip                takes integer abilCode, string extendedTooltip, integer level returns nothing
native BlzSetAbilityActivatedExtendedTooltip       takes integer abilCode, string extendedTooltip, integer level returns nothing
native BlzSetAbilityResearchTooltip                takes integer abilCode, string researchTooltip, integer level returns nothing
native BlzSetAbilityResearchExtendedTooltip        takes integer abilCode, string researchExtendedTooltip, integer level returns nothing
native BlzGetAbilityTooltip                        takes integer abilCode, integer level returns string
native BlzGetAbilityActivatedTooltip               takes integer abilCode, integer level returns string
native BlzGetAbilityExtendedTooltip                takes integer abilCode, integer level returns string
native BlzGetAbilityActivatedExtendedTooltip       takes integer abilCode, integer level returns string
native BlzGetAbilityResearchTooltip                takes integer abilCode, integer level returns string
native BlzGetAbilityResearchExtendedTooltip        takes integer abilCode, integer level returns string
native BlzSetAbilityIcon                           takes integer abilCode, string iconPath returns nothing
native BlzGetAbilityIcon                           takes integer abilCode returns string
native BlzSetAbilityActivatedIcon                  takes integer abilCode, string iconPath returns nothing
native BlzGetAbilityActivatedIcon                  takes integer abilCode returns string
native BlzGetAbilityPosX                           takes integer abilCode returns integer
native BlzGetAbilityPosY                           takes integer abilCode returns integer
native BlzSetAbilityPosX                           takes integer abilCode, integer x returns nothing
native BlzSetAbilityPosY                           takes integer abilCode, integer y returns nothing
native BlzGetAbilityActivatedPosX                  takes integer abilCode returns integer
native BlzGetAbilityActivatedPosY                  takes integer abilCode returns integer
native BlzSetAbilityActivatedPosX                  takes integer abilCode, integer x returns nothing
native BlzSetAbilityActivatedPosY                  takes integer abilCode, integer y returns nothing
native BlzGetUnitMaxHP                             takes unit whichUnit returns integer
native BlzSetUnitMaxHP                             takes unit whichUnit, integer hp returns nothing
native BlzGetUnitMaxMana                           takes unit whichUnit returns integer
native BlzSetUnitMaxMana                           takes unit whichUnit, integer mana returns nothing
native BlzSetItemName                              takes item whichItem, string name returns nothing
native BlzSetItemDescription                       takes item whichItem, string description returns nothing
native BlzGetItemDescription                       takes item whichItem returns string
native BlzSetItemTooltip                           takes item whichItem, string tooltip returns nothing
native BlzGetItemTooltip                           takes item whichItem returns string
native BlzSetItemExtendedTooltip                   takes item whichItem, string extendedTooltip returns nothing
native BlzGetItemExtendedTooltip                   takes item whichItem returns string
native BlzSetItemIconPath                          takes item whichItem, string iconPath returns nothing
native BlzGetItemIconPath                          takes item whichItem returns string
native BlzSetUnitName                              takes unit whichUnit, string name returns nothing
native BlzSetHeroProperName                        takes unit whichUnit, string heroProperName returns nothing
native BlzGetUnitBaseDamage                        takes unit whichUnit, integer weaponIndex returns integer
native BlzSetUnitBaseDamage                        takes unit whichUnit, integer baseDamage, integer weaponIndex returns nothing
native BlzGetUnitDiceNumber                        takes unit whichUnit, integer weaponIndex returns integer
native BlzSetUnitDiceNumber                        takes unit whichUnit, integer diceNumber, integer weaponIndex returns nothing
native BlzGetUnitDiceSides                         takes unit whichUnit, integer weaponIndex returns integer
native BlzSetUnitDiceSides                         takes unit whichUnit, integer diceSides, integer weaponIndex returns nothing
native BlzGetUnitAttackCooldown                    takes unit whichUnit, integer weaponIndex returns real
native BlzSetUnitAttackCooldown                    takes unit whichUnit, real cooldown, integer weaponIndex returns nothing
native BlzSetSpecialEffectColorByPlayer            takes effect whichEffect, player whichPlayer returns nothing
native BlzSetSpecialEffectColor                    takes effect whichEffect, integer r, integer g, integer b returns nothing
native BlzSetSpecialEffectAlpha                    takes effect whichEffect, integer alpha returns nothing
native BlzSetSpecialEffectScale                    takes effect whichEffect, real scale returns nothing
native BlzSetSpecialEffectPosition                 takes effect whichEffect, real x, real y, real z returns nothing
native BlzSetSpecialEffectHeight                   takes effect whichEffect, real height returns nothing
native BlzSetSpecialEffectTimeScale                takes effect whichEffect, real timeScale returns nothing
native BlzSetSpecialEffectTime                     takes effect whichEffect, real time returns nothing
native BlzSetSpecialEffectOrientation              takes effect whichEffect, real yaw, real pitch, real roll returns nothing
native BlzSetSpecialEffectYaw                      takes effect whichEffect, real yaw returns nothing
native BlzSetSpecialEffectPitch                    takes effect whichEffect, real pitch returns nothing
native BlzSetSpecialEffectRoll                     takes effect whichEffect, real roll returns nothing
native BlzSetSpecialEffectX                        takes effect whichEffect, real x returns nothing
native BlzSetSpecialEffectY                        takes effect whichEffect, real y returns nothing
native BlzSetSpecialEffectZ                        takes effect whichEffect, real z returns nothing
native BlzSetSpecialEffectPositionLoc              takes effect whichEffect, location loc returns nothing
native BlzGetLocalSpecialEffectX                   takes effect whichEffect returns real
native BlzGetLocalSpecialEffectY                   takes effect whichEffect returns real
native BlzGetLocalSpecialEffectZ                   takes effect whichEffect returns real
native BlzSpecialEffectClearSubAnimations          takes effect whichEffect returns nothing
native BlzSpecialEffectRemoveSubAnimation          takes effect whichEffect, subanimtype whichSubAnim returns nothing
native BlzSpecialEffectAddSubAnimation             takes effect whichEffect, subanimtype whichSubAnim returns nothing
native BlzPlaySpecialEffect                        takes effect whichEffect, animtype whichAnim returns nothing
native BlzPlaySpecialEffectWithTimeScale           takes effect whichEffect, animtype whichAnim, real timeScale returns nothing
native BlzGetAnimName                              takes animtype whichAnim returns string
native BlzGetUnitArmor                             takes unit whichUnit returns real
native BlzSetUnitArmor                             takes unit whichUnit, real armorAmount returns nothing
native BlzUnitHideAbility                          takes unit whichUnit, integer abilId, boolean flag returns nothing
native BlzUnitDisableAbility                       takes unit whichUnit, integer abilId, boolean flag, boolean hideUI returns nothing
native BlzUnitCancelTimedLife                      takes unit whichUnit returns nothing
native BlzIsUnitSelectable                         takes unit whichUnit returns boolean
native BlzIsUnitInvulnerable                       takes unit whichUnit returns boolean
native BlzUnitInterruptAttack                      takes unit whichUnit returns nothing
native BlzGetUnitCollisionSize                     takes unit whichUnit returns real
native BlzGetAbilityManaCost                       takes integer abilId, integer level returns integer
native BlzGetAbilityCooldown                       takes integer abilId, integer level returns real
native BlzSetUnitAbilityCooldown                   takes unit whichUnit, integer abilId, integer level, real cooldown returns nothing
native BlzGetUnitAbilityCooldown                   takes unit whichUnit, integer abilId, integer level returns real
native BlzGetUnitAbilityCooldownRemaining          takes unit whichUnit, integer abilId returns real
native BlzEndUnitAbilityCooldown                   takes unit whichUnit, integer abilCode returns nothing
native BlzStartUnitAbilityCooldown                 takes unit whichUnit, integer abilCode, real cooldown returns nothing
native BlzGetUnitAbilityManaCost                   takes unit whichUnit, integer abilId, integer level returns integer
native BlzSetUnitAbilityManaCost                   takes unit whichUnit, integer abilId, integer level, integer manaCost returns nothing
native BlzGetLocalUnitZ                            takes unit whichUnit returns real
native BlzDecPlayerTechResearched                  takes player whichPlayer, integer techid, integer levels returns nothing
native BlzSetEventDamage                           takes real damage returns nothing
native BlzGetEventDamageTarget 	                   takes nothing returns unit
native BlzGetEventAttackType  	                   takes nothing returns attacktype
native BlzGetEventDamageType                       takes nothing returns damagetype
native BlzGetEventWeaponType  	                   takes nothing returns weapontype
native BlzSetEventAttackType                       takes attacktype attackType returns boolean
native BlzSetEventDamageType                       takes damagetype damageType returns boolean
native BlzSetEventWeaponType                       takes weapontype weaponType returns boolean
native BlzGetEventIsAttack                         takes nothing returns boolean
native RequestExtraIntegerData                     takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns integer
native RequestExtraBooleanData                     takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns boolean
native RequestExtraStringData                      takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns string
native RequestExtraRealData                        takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns real
// Add this function to follow the style of GetUnitX and GetUnitY, it has the same result as BlzGetLocalUnitZ
native BlzGetUnitZ                                 takes unit whichUnit returns real
native BlzEnableSelections                         takes boolean enableSelection, boolean enableSelectionCircle returns nothing
native BlzIsSelectionEnabled                       takes nothing returns boolean
native BlzIsSelectionCircleEnabled                 takes nothing returns boolean
native BlzCameraSetupApplyForceDurationSmooth      takes camerasetup whichSetup, boolean doPan, real forcedDuration, real easeInDuration, real easeOutDuration, real smoothFactor returns nothing
native BlzEnableTargetIndicator                    takes boolean enable returns nothing
native BlzIsTargetIndicatorEnabled                 takes nothing returns boolean
native BlzShowTerrain                              takes boolean show returns nothing
native BlzShowSkyBox                               takes boolean show returns nothing
native BlzStartRecording                           takes integer fps returns nothing
native BlzEndRecording                             takes nothing returns nothing
native BlzShowUnitTeamGlow                         takes unit whichUnit, boolean show returns nothing

native BlzGetOriginFrame                           takes originframetype frameType, integer index returns framehandle
native BlzEnableUIAutoPosition                     takes boolean enable returns nothing
native BlzHideOriginFrames                         takes boolean enable returns nothing
native BlzConvertColor                             takes integer a, integer r, integer g, integer b returns integer
native BlzLoadTOCFile                              takes string TOCFile returns boolean
native BlzCreateFrame                              takes string name, framehandle owner, integer priority, integer createContext returns framehandle
native BlzCreateSimpleFrame                        takes string name, framehandle owner, integer createContext returns framehandle
native BlzCreateFrameByType                        takes string typeName, string name, framehandle owner, string inherits, integer createContext returns framehandle
native BlzDestroyFrame                             takes framehandle frame returns nothing
native BlzFrameSetPoint                            takes framehandle frame, framepointtype point, framehandle relative, framepointtype relativePoint, real x, real y returns nothing
native BlzFrameSetAbsPoint                         takes framehandle frame, framepointtype point, real x, real y returns nothing
native BlzFrameClearAllPoints                      takes framehandle frame returns nothing
native BlzFrameSetAllPoints                        takes framehandle frame, framehandle relative returns nothing
native BlzFrameSetVisible                          takes framehandle frame, boolean visible returns nothing
native BlzFrameIsVisible                           takes framehandle frame returns boolean
native BlzGetFrameByName                           takes string name, integer createContext returns framehandle
native BlzFrameGetName                             takes framehandle frame returns string
native BlzFrameClick                               takes framehandle frame returns nothing
native BlzFrameSetText                             takes framehandle frame, string text returns nothing
native BlzFrameGetText                             takes framehandle frame returns string
native BlzFrameAddText                             takes framehandle frame, string text returns nothing
native BlzFrameSetTextSizeLimit                    takes framehandle frame, integer size returns nothing
native BlzFrameGetTextSizeLimit                    takes framehandle frame returns integer
native BlzFrameSetTextColor                        takes framehandle frame, integer color returns nothing
native BlzFrameSetFocus                            takes framehandle frame, boolean flag returns nothing
native BlzFrameSetModel                            takes framehandle frame, string modelFile, integer cameraIndex returns nothing
native BlzFrameSetEnable                           takes framehandle frame, boolean enabled returns nothing
native BlzFrameGetEnable                           takes framehandle frame returns boolean
native BlzFrameSetAlpha                            takes framehandle frame, integer alpha returns nothing
native BlzFrameGetAlpha                            takes framehandle frame returns integer
native BlzFrameSetSpriteAnimate                    takes framehandle frame, integer primaryProp, integer flags returns nothing
native BlzFrameSetTexture                          takes framehandle frame, string texFile, integer flag, boolean blend returns nothing
native BlzFrameSetScale                            takes framehandle frame, real scale returns nothing
native BlzFrameSetTooltip                          takes framehandle frame, framehandle tooltip returns nothing
native BlzFrameCageMouse                           takes framehandle frame, boolean enable returns nothing
native BlzFrameSetValue                            takes framehandle frame, real value returns nothing
native BlzFrameGetValue                            takes framehandle frame returns real
native BlzFrameSetMinMaxValue                      takes framehandle frame, real minValue, real maxValue returns nothing
native BlzFrameSetStepSize                         takes framehandle frame, real stepSize returns nothing
native BlzFrameSetSize                             takes framehandle frame, real width, real height returns nothing
native BlzFrameSetVertexColor                      takes framehandle frame, integer color returns nothing
native BlzFrameSetLevel                            takes framehandle frame, integer level returns nothing
native BlzFrameSetParent                           takes framehandle frame, framehandle parent returns nothing
native BlzFrameGetParent                           takes framehandle frame returns framehandle
native BlzFrameGetHeight                           takes framehandle frame returns real
native BlzFrameGetWidth                            takes framehandle frame returns real
native BlzFrameSetFont                             takes framehandle frame, string fileName, real height, integer flags returns nothing
native BlzFrameSetTextAlignment                    takes framehandle frame, textaligntype vert, textaligntype horz returns nothing
native BlzFrameGetChildrenCount                    takes framehandle frame returns integer
native BlzFrameGetChild                            takes framehandle frame, integer index returns framehandle
native BlzTriggerRegisterFrameEvent                takes trigger whichTrigger, framehandle frame, frameeventtype eventId returns event
native BlzGetTriggerFrame                          takes nothing returns framehandle
native BlzGetTriggerFrameEvent                     takes nothing returns frameeventtype
native BlzGetTriggerFrameValue                     takes nothing returns real
native BlzGetTriggerFrameText                      takes nothing returns string
native BlzTriggerRegisterPlayerSyncEvent           takes trigger whichTrigger, player whichPlayer, string prefix, boolean fromServer returns event
native BlzSendSyncData                             takes string prefix, string data returns boolean
native BlzGetTriggerSyncPrefix                     takes nothing returns string
native BlzGetTriggerSyncData                       takes nothing returns string
native BlzTriggerRegisterPlayerKeyEvent            takes trigger whichTrigger, player whichPlayer, oskeytype key, integer metaKey, boolean keyDown returns event
native BlzGetTriggerPlayerKey                      takes nothing returns oskeytype
native BlzGetTriggerPlayerMetaKey                  takes nothing returns integer
native BlzGetTriggerPlayerIsKeyDown                takes nothing returns boolean
native BlzEnableCursor                             takes boolean enable returns nothing
native BlzSetMousePos                              takes integer x, integer y returns nothing
native BlzGetLocalClientWidth                      takes nothing returns integer
native BlzGetLocalClientHeight                     takes nothing returns integer
native BlzIsLocalClientActive                      takes nothing returns boolean
native BlzGetMouseFocusUnit                        takes nothing returns unit
native BlzChangeMinimapTerrainTex                  takes string texFile returns boolean
native BlzGetLocale                                takes nothing returns string
native BlzGetSpecialEffectScale                    takes effect whichEffect returns real
native BlzSetSpecialEffectMatrixScale              takes effect whichEffect, real x, real y, real z returns nothing
native BlzResetSpecialEffectMatrix                 takes effect whichEffect returns nothing
native BlzGetUnitAbility                           takes unit whichUnit, integer abilId returns ability
native BlzGetUnitAbilityByIndex                    takes unit whichUnit, integer index returns ability
native BlzGetAbilityId                             takes ability whichAbility returns integer
native BlzDisplayChatMessage                       takes player whichPlayer, integer recipient, string message returns nothing
native BlzPauseUnitEx                              takes unit whichUnit, boolean flag returns nothing
// native BlzFourCC2S                                 takes integer value returns string
// native BlzS2FourCC                                 takes string value returns integer
native BlzSetUnitFacingEx                          takes unit whichUnit, real facingAngle returns nothing

native CreateCommandButtonEffect                   takes integer abilityId, string order returns commandbuttoneffect
native CreateUpgradeCommandButtonEffect            takes integer whichUprgade returns commandbuttoneffect
native CreateLearnCommandButtonEffect              takes integer abilityId returns commandbuttoneffect
native DestroyCommandButtonEffect                  takes commandbuttoneffect whichEffect returns nothing

// Bit Operations
native BlzBitOr                                    takes integer x, integer y returns integer
native BlzBitAnd                                   takes integer x, integer y returns integer
native BlzBitXor                                   takes integer x, integer y returns integer 

// Intanced Object Operations
// Ability
native BlzGetAbilityBooleanField                   takes ability whichAbility, abilitybooleanfield whichField returns boolean
native BlzGetAbilityIntegerField                   takes ability whichAbility, abilityintegerfield whichField returns integer
native BlzGetAbilityRealField                      takes ability whichAbility, abilityrealfield whichField returns real
native BlzGetAbilityStringField                    takes ability whichAbility, abilitystringfield whichField returns string
native BlzGetAbilityBooleanLevelField              takes ability whichAbility, abilitybooleanlevelfield whichField, integer level returns boolean
native BlzGetAbilityIntegerLevelField              takes ability whichAbility, abilityintegerlevelfield whichField, integer level returns integer
native BlzGetAbilityRealLevelField                 takes ability whichAbility, abilityreallevelfield whichField, integer level returns real
native BlzGetAbilityStringLevelField               takes ability whichAbility, abilitystringlevelfield whichField, integer level returns string
native BlzGetAbilityBooleanLevelArrayField         takes ability whichAbility, abilitybooleanlevelarrayfield whichField, integer level, integer index returns boolean
native BlzGetAbilityIntegerLevelArrayField         takes ability whichAbility, abilityintegerlevelarrayfield whichField, integer level, integer index returns integer
native BlzGetAbilityRealLevelArrayField            takes ability whichAbility, abilityreallevelarrayfield whichField, integer level, integer index returns real
native BlzGetAbilityStringLevelArrayField          takes ability whichAbility, abilitystringlevelarrayfield whichField, integer level, integer index returns string
native BlzSetAbilityBooleanField                   takes ability whichAbility, abilitybooleanfield whichField, boolean value returns boolean
native BlzSetAbilityIntegerField                   takes ability whichAbility, abilityintegerfield whichField, integer value returns boolean
native BlzSetAbilityRealField                      takes ability whichAbility, abilityrealfield whichField, real value returns boolean
native BlzSetAbilityStringField                    takes ability whichAbility, abilitystringfield whichField, string value returns boolean
native BlzSetAbilityBooleanLevelField              takes ability whichAbility, abilitybooleanlevelfield whichField, integer level, boolean value returns boolean
native BlzSetAbilityIntegerLevelField              takes ability whichAbility, abilityintegerlevelfield whichField, integer level, integer value returns boolean
native BlzSetAbilityRealLevelField                 takes ability whichAbility, abilityreallevelfield whichField, integer level, real value returns boolean
native BlzSetAbilityStringLevelField               takes ability whichAbility, abilitystringlevelfield whichField, integer level, string value returns boolean
native BlzSetAbilityBooleanLevelArrayField         takes ability whichAbility, abilitybooleanlevelarrayfield whichField, integer level, integer index, boolean value returns boolean
native BlzSetAbilityIntegerLevelArrayField         takes ability whichAbility, abilityintegerlevelarrayfield whichField, integer level, integer index, integer value returns boolean
native BlzSetAbilityRealLevelArrayField            takes ability whichAbility, abilityreallevelarrayfield whichField, integer level, integer index, real value returns boolean
native BlzSetAbilityStringLevelArrayField          takes ability whichAbility, abilitystringlevelarrayfield whichField, integer level, integer index, string value returns boolean
native BlzAddAbilityBooleanLevelArrayField         takes ability whichAbility, abilitybooleanlevelarrayfield whichField, integer level, boolean value returns boolean
native BlzAddAbilityIntegerLevelArrayField         takes ability whichAbility, abilityintegerlevelarrayfield whichField, integer level, integer value returns boolean
native BlzAddAbilityRealLevelArrayField            takes ability whichAbility, abilityreallevelarrayfield whichField, integer level, real value returns boolean
native BlzAddAbilityStringLevelArrayField          takes ability whichAbility, abilitystringlevelarrayfield whichField, integer level, string value returns boolean
native BlzRemoveAbilityBooleanLevelArrayField      takes ability whichAbility, abilitybooleanlevelarrayfield whichField, integer level, boolean value returns boolean
native BlzRemoveAbilityIntegerLevelArrayField      takes ability whichAbility, abilityintegerlevelarrayfield whichField, integer level, integer value returns boolean
native BlzRemoveAbilityRealLevelArrayField         takes ability whichAbility, abilityreallevelarrayfield whichField, integer level, real value returns boolean
native BlzRemoveAbilityStringLevelArrayField       takes ability whichAbility, abilitystringlevelarrayfield whichField, integer level, string value returns boolean

// Item 
native BlzGetItemAbilityByIndex                    takes item whichItem, integer index returns ability
native BlzGetItemAbility                           takes item whichItem, integer abilCode returns ability
native BlzItemAddAbility                           takes item whichItem, integer abilCode returns boolean
native BlzGetItemBooleanField                      takes item whichItem, itembooleanfield whichField returns boolean
native BlzGetItemIntegerField                      takes item whichItem, itemintegerfield whichField returns integer
native BlzGetItemRealField                         takes item whichItem, itemrealfield whichField returns real
native BlzGetItemStringField                       takes item whichItem, itemstringfield whichField returns string
native BlzSetItemBooleanField                      takes item whichItem, itembooleanfield whichField, boolean value returns boolean
native BlzSetItemIntegerField                      takes item whichItem, itemintegerfield whichField, integer value returns boolean
native BlzSetItemRealField                         takes item whichItem, itemrealfield whichField, real value returns boolean
native BlzSetItemStringField                       takes item whichItem, itemstringfield whichField, string value returns boolean
native BlzItemRemoveAbility                        takes item whichItem, integer abilCode returns boolean

// Unit 
native BlzGetUnitBooleanField                      takes unit whichUnit, unitbooleanfield whichField returns boolean
native BlzGetUnitIntegerField                      takes unit whichUnit, unitintegerfield whichField returns integer
native BlzGetUnitRealField                         takes unit whichUnit, unitrealfield whichField returns real
native BlzGetUnitStringField                       takes unit whichUnit, unitstringfield whichField returns string
native BlzSetUnitBooleanField                      takes unit whichUnit, unitbooleanfield whichField, boolean value returns boolean
native BlzSetUnitIntegerField                      takes unit whichUnit, unitintegerfield whichField, integer value returns boolean
native BlzSetUnitRealField                         takes unit whichUnit, unitrealfield whichField, real value returns boolean
native BlzSetUnitStringField                       takes unit whichUnit, unitstringfield whichField, string value returns boolean

// Unit Weapon
native BlzGetUnitWeaponBooleanField                takes unit whichUnit, unitweaponbooleanfield whichField, integer index returns boolean
native BlzGetUnitWeaponIntegerField                takes unit whichUnit, unitweaponintegerfield whichField, integer index returns integer
native BlzGetUnitWeaponRealField                   takes unit whichUnit, unitweaponrealfield whichField, integer index returns real
native BlzGetUnitWeaponStringField                 takes unit whichUnit, unitweaponstringfield whichField, integer index returns string
native BlzSetUnitWeaponBooleanField                takes unit whichUnit, unitweaponbooleanfield whichField, integer index, boolean value returns boolean
native BlzSetUnitWeaponIntegerField                takes unit whichUnit, unitweaponintegerfield whichField, integer index, integer value returns boolean
native BlzSetUnitWeaponRealField                   takes unit whichUnit, unitweaponrealfield whichField, integer index, real value returns boolean
native BlzSetUnitWeaponStringField                 takes unit whichUnit, unitweaponstringfield whichField, integer index, string value returns boolean

// Skin
native BlzGetUnitSkin                                 takes unit whichUnit returns integer
native BlzGetItemSkin                                 takes item whichItem returns integer
// native BlzGetDestructableSkin                         takes destructable whichDestructable returns integer
native BlzSetUnitSkin                                 takes unit whichUnit, integer skinId returns nothing
native BlzSetItemSkin                                 takes item whichItem, integer skinId returns nothing
// native BlzSetDestructableSkin                         takes destructable whichDestructable, integer skinId returns nothing

native BlzCreateItemWithSkin                       takes integer itemid, real x, real y, integer skinId returns item
native BlzCreateUnitWithSkin                       takes player id, integer unitid, real x, real y, real face, integer skinId returns unit
native BlzCreateDestructableWithSkin               takes integer objectid, real x, real y, real face, real scale, integer variation, integer skinId returns destructable
native BlzCreateDestructableZWithSkin              takes integer objectid, real x, real y, real z, real face, real scale, integer variation, integer skinId returns destructable
native BlzCreateDeadDestructableWithSkin           takes integer objectid, real x, real y, real face, real scale, integer variation, integer skinId returns destructable
native BlzCreateDeadDestructableZWithSkin          takes integer objectid, real x, real y, real z, real face, real scale, integer variation, integer skinId returns destructable
native BlzGetPlayerTownHallCount                   takes player whichPlayer returns integer

native BlzQueueImmediateOrderById      takes unit whichUnit, integer order returns boolean
native BlzQueuePointOrderById          takes unit whichUnit, integer order, real x, real y returns boolean
native BlzQueueTargetOrderById         takes unit whichUnit, integer order, widget targetWidget returns boolean
native BlzQueueInstantPointOrderById   takes unit whichUnit, integer order, real x, real y, widget instantTargetWidget returns boolean
native BlzQueueInstantTargetOrderById  takes unit whichUnit, integer order, widget targetWidget, widget instantTargetWidget returns boolean
native BlzQueueBuildOrderById          takes unit whichPeon, integer unitId, real x, real y returns boolean
native BlzQueueNeutralImmediateOrderById   takes player forWhichPlayer,unit neutralStructure, integer unitId returns boolean
native BlzQueueNeutralPointOrderById       takes player forWhichPlayer,unit neutralStructure, integer unitId, real x, real y returns boolean
native BlzQueueNeutralTargetOrderById      takes player forWhichPlayer,unit neutralStructure, integer unitId, widget target returns boolean

// returns the number of orders the unit currently has queued up
native BlzGetUnitOrderCount takes unit whichUnit returns integer
// clears either all orders or only queued up orders
native BlzUnitClearOrders takes unit whichUnit, boolean onlyQueued returns nothing
// stops the current order and optionally clears the queue
native BlzUnitForceStopOrder takes unit whichUnit, boolean clearQueue returns nothing