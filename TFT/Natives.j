native DebugS               takes string str                            returns nothing
native DebugFI              takes string str, integer val               returns nothing
native DebugUnitID          takes string str, integer val               returns nothing
native DisplayText          takes integer p, string str                 returns nothing
native DisplayTextI         takes integer p, string str, integer val    returns nothing
native DisplayTextII        takes integer p, string str, integer v1, integer v2 returns nothing
native DisplayTextIII       takes integer p, string str, integer v1, integer v2, integer v3 returns nothing
native DoAiScriptDebug      takes nothing                               returns boolean

native GetAiPlayer          takes nothing                               returns integer
native GetHeroId            takes nothing                               returns integer
native GetHeroLevelAI       takes nothing                               returns integer

native GetUnitCount         takes integer unitid                        returns integer
native GetPlayerUnitTypeCount takes player p, integer unitid            returns integer
native GetUnitCountDone     takes integer unitid                        returns integer
native GetTownUnitCount     takes integer id, integer tn, boolean dn    returns integer
native GetUnitGoldCost      takes integer unitid                        returns integer
native GetUnitWoodCost      takes integer unitid                        returns integer
native GetUnitBuildTime     takes integer unitid                        returns integer

native GetMinesOwned        takes nothing                               returns integer
native GetGoldOwned         takes nothing                               returns integer
native TownWithMine         takes nothing                               returns integer
native TownHasMine          takes integer townid                        returns boolean
native TownHasHall          takes integer townid                        returns boolean

native GetUpgradeLevel      takes integer id                            returns integer
native GetUpgradeGoldCost   takes integer id                            returns integer
native GetUpgradeWoodCost   takes integer id                            returns integer
native GetNextExpansion     takes nothing                               returns integer
native GetMegaTarget        takes nothing                               returns unit
native GetBuilding          takes player p                              returns unit
native GetEnemyPower        takes nothing                               returns integer
native SetAllianceTarget    takes unit id                               returns nothing
native GetAllianceTarget    takes nothing                               returns unit

native SetProduce           takes integer qty, integer id, integer town returns boolean
native Unsummon             takes unit unitid                           returns nothing
native SetExpansion         takes unit peon, integer id                 returns boolean
native SetUpgrade           takes integer id                            returns boolean
native SetHeroLevels        takes code func                             returns nothing
native SetNewHeroes         takes boolean state                         returns nothing
native PurchaseZeppelin     takes nothing                               returns nothing

native MergeUnits           takes integer qty, integer a, integer b, integer make returns boolean
native ConvertUnits         takes integer qty, integer id               returns boolean

native SetCampaignAI        takes nothing                               returns nothing
native SetMeleeAI           takes nothing                               returns nothing
native SetTargetHeroes      takes boolean state                         returns nothing
native SetPeonsRepair       takes boolean state                         returns nothing
native SetRandomPaths       takes boolean state                         returns nothing
native SetDefendPlayer      takes boolean state                         returns nothing
native SetHeroesFlee        takes boolean state                         returns nothing
native SetHeroesBuyItems    takes boolean state                         returns nothing
native SetWatchMegaTargets  takes boolean state                         returns nothing
native SetIgnoreInjured     takes boolean state                         returns nothing
native SetHeroesTakeItems   takes boolean state                         returns nothing
native SetUnitsFlee         takes boolean state                         returns nothing
native SetGroupsFlee        takes boolean state                         returns nothing
native SetSlowChopping      takes boolean state                         returns nothing
native SetCaptainChanges    takes boolean allow                         returns nothing
native SetSmartArtillery    takes boolean state                         returns nothing
native SetReplacementCount  takes integer qty                           returns nothing
native GroupTimedLife       takes boolean allow                         returns nothing
native RemoveInjuries       takes nothing                               returns nothing
native RemoveSiege          takes nothing                               returns nothing

native InitAssault          takes nothing                               returns nothing
native AddAssault           takes integer qty, integer id               returns boolean
native AddDefenders         takes integer qty, integer id               returns boolean

native GetCreepCamp         takes integer min, integer max, boolean flyers_ok returns unit

native StartGetEnemyBase    takes nothing                               returns nothing
native WaitGetEnemyBase     takes nothing                               returns boolean
native GetEnemyBase         takes nothing                               returns unit
native GetExpansionFoe      takes nothing                               returns unit
native GetEnemyExpansion    takes nothing                               returns unit
native GetExpansionX        takes nothing                               returns integer
native GetExpansionY        takes nothing                               returns integer
native SetStagePoint        takes real x, real y                        returns nothing
native AttackMoveKill       takes unit target                           returns nothing
native AttackMoveXY         takes integer x, integer y                  returns nothing
native LoadZepWave          takes integer x, integer y                  returns nothing
native SuicidePlayer        takes player id, boolean check_full         returns boolean
native SuicidePlayerUnits   takes player id, boolean check_full         returns boolean
native CaptainInCombat      takes boolean attack_captain                returns boolean
native IsTowered            takes unit target                           returns boolean

native ClearHarvestAI       takes nothing                               returns nothing
native HarvestGold          takes integer town, integer peons           returns nothing
native HarvestWood          takes integer town, integer peons           returns nothing
native GetExpansionPeon     takes nothing                               returns unit

native StopGathering        takes nothing                               returns nothing
native AddGuardPost         takes integer id, real x, real y            returns nothing
native FillGuardPosts       takes nothing                               returns nothing
native ReturnGuardPosts     takes nothing                               returns nothing
native CreateCaptains       takes nothing                               returns nothing
native SetCaptainHome       takes integer which, real x, real y         returns nothing
native ResetCaptainLocs     takes nothing                               returns nothing
native ShiftTownSpot        takes real x, real y                        returns nothing
native TeleportCaptain      takes real x, real y                        returns nothing
native ClearCaptainTargets  takes nothing                               returns nothing
native CaptainAttack        takes real x, real y                        returns nothing
native CaptainVsUnits       takes player id                             returns nothing
native CaptainVsPlayer      takes player id                             returns nothing
native CaptainGoHome        takes nothing                               returns nothing
native CaptainIsHome        takes nothing                               returns boolean
native CaptainIsFull        takes nothing                               returns boolean
native CaptainIsEmpty       takes nothing                               returns boolean
native CaptainGroupSize     takes nothing                               returns integer
native CaptainReadiness     takes nothing                               returns integer
native CaptainRetreating    takes nothing                               returns boolean
native CaptainReadinessHP   takes nothing                               returns integer
native CaptainReadinessMa   takes nothing                               returns integer
native CaptainAtGoal        takes nothing                               returns boolean
native CreepsOnMap          takes nothing                               returns boolean
native SuicideUnit          takes integer count, integer unitid         returns nothing
native SuicideUnitEx        takes integer ct, integer uid, integer pid  returns nothing
native StartThread          takes code func                             returns nothing
native Sleep                takes real seconds                          returns nothing
native UnitAlive            takes unit id                               returns boolean
native UnitInvis            takes unit id                               returns boolean
native IgnoredUnits         takes integer unitid                        returns integer
native TownThreatened       takes nothing                               returns boolean
native DisablePathing       takes nothing                               returns nothing
native SetAmphibious        takes nothing                               returns nothing

native CommandsWaiting      takes nothing                               returns integer
native GetLastCommand       takes nothing                               returns integer
native GetLastData          takes nothing                               returns integer
native PopLastCommand       takes nothing                               returns nothing
native MeleeDifficulty      takes nothing                               returns integer