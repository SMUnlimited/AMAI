// Production recovery and selling logic; native refunds/construction need Warcraft.
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile, zeros } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const read = path => readFileSync(new URL('../../' + path, import.meta.url), 'utf8');
const recovery = read('UndeadRecovery.eai');
const selling = read('Jobs/SELL_ZIGGURATS.eai');

export function zigguratGame({ gold = 0, wood = 1000, mines = 0, buildingMine = false, workers = 1, exhausted = false } = {}) {
  const units = [];
  function addUnit(type, changes = {}) {
    const unit = { type, owner: 0, alive: true, order: 0, x: 0, y: 0,
      structure: !['worker', 'ghoul', 'mine'].includes(type), food: type === 'ziggurat' || type === 'tower' ? 10 : 0,
      gold: type === 'mine' ? 10000 : 0, ...changes };
    units.push(unit);
    return unit;
  }
  const hall = addUnit('hall');
  const ziggurats = Array.from({ length: 3 }, () => addUnit('ziggurat'));
  const mine = addUnit('mine', { owner: 15, gold: exhausted ? 0 : 10000 });
  for (let i = 0; i < workers; i++) addUnit('worker');
  const sales = [];
  const jobs = [];
  const groups = new Set();
  const production = [];
  const counts = (id, done = false) => units.filter(u => u.alive && u.owner === 0 && u.type === id && (!done || !u.unfinished)).length;
  const state = {
    own_town_num: 0,
    gold, wood, harvest_mine_count: mines, buildingMine,
    ai_player: 0, racial_expansion: 1, racial_peon: 2, racial_farm: 3,
    racial_shop: 4, racial_ghoul: 5, racial_hall: [0, 6],
    old_id: { 1: 'haunted', 2: 'worker', 3: 'ziggurat', 4: 'shop', 5: 'ghoul', 6: 'hall', 7: 'fiend' },
    racial_zigg: ['ziggurat', 'tower'], ziggarray: 1,
    race_ziggurat_keep_distance: 1500, SELL_ZIGGURATS: 4,
    race_sell_ziggurats: true, race_uses_mine_expansion: true, campaign_ai: false,
    current_expansion: exhausted ? null : mine, claimed: false, cooldown: false, foodSpace: 30, threat: 0,
    pathing_done: true, expansion_list: [mine], expansion_list_length: 1, water_expansion_list: [], farm_food: 8,
    home_location: { x: 0, y: 0 }, playerScans: 0, rangeScans: 0,
    BUILD_UNIT: 1, BUILD_EXPAND: 2, BUILD_ITEM: 3, BUILD_UPGRADE: 4,
    BUY_NEUTRAL: 7, BUY_NEUTRAL_HERO: 8, tq_timer: null,
    GAME_STATE_TIME_OF_DAY: 0, GetFloatGameState: () => 12, TimerGetElapsed: () => 0,
    GetNeutralNumber: () => 0, nearest_neutral: [hall], neutral_sent: [hall], neutral_guarded: [false],
    ...groupNatives(groups),
    GetGold: () => state.gold, GetWood: () => state.wood,
    GetMinesHarvested: () => state.harvest_mine_count,
    GetGoldOwned: () => units.filter(u => u.alive && u.owner === 0 && u.type === 'haunted').reduce((sum, u) => sum + u.gold, 0),
    GetUnitGoldCost2: id => ({ 1: 225, 2: 75, 3: 150, 7: 215 })[id] ?? 0,
    GetUnitWoodCost2: id => ({ 1: 210, 3: 50 })[id] ?? 0,
    TownCount: id => id === 1 ? Number(state.buildingMine) : counts(state.old_id[id]),
    TownCountDone: id => id === 1 ? 0 : counts(state.old_id[id], true),
    GetUnitCount: id => counts(id), GetUnitCountDone: id => counts(id, true),
    GetFoodUsed: () => 1, FoodSpace: () => state.foodSpace, GetUnitFoodMade: u => u.food, GetFoodMade: () => 10,
    GroupEnumUnitsOfPlayer(g, p) { state.playerScans++; units.filter(u => u.owner === p).forEach(u => g.add(u)); },
    SelectByAlive: g => new Set([...g].filter(u => u.alive)),
    GetUnitTypeId: u => u.type, GetUnitCurrentOrder: u => u.order, OrderId: s => s,
    UnitAlive: u => Boolean(u?.alive), GetResourceAmount: u => u.gold,
    CheckExpansionTaken: u => state.claimed || Boolean(u.claimed), IsExpansionRebuildCoolingDown: () => state.cooldown,
    GetMineClaimant: u => u.claimed ? hall : null, CanYieldAlliedMine: u => Boolean(u.shareable),
    GetExpFoe: () => state.guarded ? hall : null,
    GetUnitX: u => u.x, GetUnitY: u => u.y, GetOwningPlayer: u => u.owner,
    GetLocationX: l => l.x, GetLocationY: l => l.y, ModuloInteger: (a, b) => a % b, Sleep() {},
    GroupEnumUnitsInRange(g, x, y, radius) {
      state.rangeScans++;
      units.filter(u => Math.hypot(u.x - x, u.y - y) <= radius).forEach(u => g.add(u));
    },
    SelectByPlayer: (g, p) => new Set([...g].filter(u => u.owner === p)),
    SelectUnittype: g => new Set([...g].filter(u => u.structure)),
    IsUnitType: u => u.structure, IsUnitGoldMine: u => u.type === 'mine' || u.type === 'haunted',
    IsRacialHall: (u, tier) => u.type === 'hall' && (u.tier ?? 1) >= tier,
    GetLocationNonCreepStrength: () => state.threat,
    UNIT_TYPE_STRUCTURE: 1, BlzGroupGetSize: g => g.size,
    Unsummon(u) { sales.push(u); u.order = 'unsummon'; },
    DisplayToAllJobDebug() {}, TQAddJob: (...args) => jobs.push(args),
    no_ai_ally: false, humanPlayerAllys: false, console_on: false, disable_surrender: false,
    p_surrender: [3], profile: 0, desperation_assault: false,
    FoodUsed: () => 10, Chat() {}, SaveYourself: () => false,
    KillYourself: () => { state.surrendered = true; },
    zeros, Max: Math.max, Min: Math.min, Int2Str: String,
    BUILT_ALL: 0, BUILT_SOME: 1, NOT_ENOUGH_RES: 2, CANNOT_BUILD: 3,
    BUILD_ADAPTIVE: 5, BUILD_ADAPTIVE_UPGRADE: 6,
    build_length: 0, t_build_length: 0, OBJECT_NUM: 1000, tier: 1,
    gold_buffer: 100, wood_buffer: 100, ver_food_limit: 100, water_expansion_list_length: 0,
    prio_t_inc: 1, neededPeons: 0, unitNames: [],
    InitLastUpkeep() {}, TimeKeeper() {}, SetBuildFree() {}, FarmBuilder() {}, PeonBuilder() {},
    ExpansionBuilder() {}, HeroReviver() {}, CheckUpkeepAllowed() {}, GetBuildLock() {},
    RefreshAdaptiveReservation() {}, ReleaseBuildLock() {}, RefreshAllNeeded() {},
    FactoryNumberUpdate() {}, ResetUpkeepSaveTime() {}, Trace() {},
    AdaptiveCountersEnabled: () => false, IsRacialHallId: () => false,
    IsUnitIdType: id => ['haunted', 'ziggurat', 'shop', 'hall'].includes(id),
    bl_tier_unitlock: [1], bl_tier_foodlock: [100], bl_tier_lockactive: [false], bl_tier_expansionblock: [false],
    RBlockListCheck: q => q, BlockListCheck: q => q, TownCountTown: id => counts(state.old_id[id]),
    CanBuildUnit: () => !state.unbuildable,
    StartUnitAM(qty, id) { production.push({ qty, id, gold: state.total_gold }); return state.BUILT_SOME; },
    StartExpansionAM(qty, id) { production.push({ qty, id, gold: state.total_gold }); return state.BUILT_SOME; },
    StartUpgradeAM() { production.push('upgrade'); return state.BUILT_SOME; },
    StartItem() { production.push('item'); return state.BUILT_SOME; },
    AddRefresh() {}, BuildAdaptiveReinforcements() { production.push('reinforcements'); },
  };
  const context = vm.createContext(state);
  for (const suffix of ['qty', 'type', 'item', 'town', 'loc', 'prio']) state['build_' + suffix] = zeros();
  for (const match of recovery.matchAll(/function (\w+) takes/g)) vm.runInContext(compile(recovery, match[1]), context);
  for (const name of ['SelectByZiggurat', 'CheckSellZiggurat', 'SellZigguratJob']) vm.runInContext(compile(selling, name), context);
  vm.runInContext(compile(read('Jobs/DETECT_DEFEAT.eai'), 'Defeated'), context);
  vm.runInContext(compile(read('common.eai'), 'RefreshTrackedTownBuilders'), context);
  vm.runInContext(compile(read('common.eai'), 'OneBuildLoopAM'), context);
  vm.runInContext(compile(read('Jobs/BUY_NEUTRAL.eai'), 'BuyNeutral'), context);
  vm.runInContext(compile(read('Jobs/BUY_NEUTRAL_HERO.eai'), 'BuyNeutralHero'), context);
  return {
    state, units, hall, mine, ziggurats, sales, jobs, groups, addUnit, production,
    checkSales: () => state.SellZigguratJob(), checkDefeat: () => state.Defeated(),
    canBuild: (type, id) => state.UndeadRecoveryBuildAllowed(state.UndeadMineRecoveryNeeded(), type, id),
    requestBuild(type, id, qty = 1) {
      const index = state.build_length++;
      state.build_type[index] = type; state.build_item[index] = id; state.build_qty[index] = qty;
    },
    checkBuild: () => state.OneBuildLoopAM(),
    checkNeutralPurchases() { state.BuyNeutral(7); state.BuyNeutralHero(8); },
  };
}
