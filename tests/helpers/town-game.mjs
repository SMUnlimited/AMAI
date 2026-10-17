// Execute production town counting, construction and upgrades. Warcraft pathing,
// foundation timing, blight and accepted orders require the in-game scenarios.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile, zeros } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const read = path => readFileSync(new URL('../../' + path, import.meta.url), 'utf8');
const common = read('common.eai').replace(/#INCLUDETABLE[^\n]*\n[\s\S]*?#ENDINCLUDE/g, '');
const tracking = read('Jobs/TOWN_TRACK.eai');
const harvest = read('Jobs/HARVEST_CHECK.eai');
const rows = read('REFORGED/StandardUnits.txt').trim().split(/\r?\n/).map(row => row.split('\t'));
const names = {
  undead: ['NECROPOLIS_1', 'NECROPOLIS_2', 'NECROPOLIS_3', 'ZIGGURAT_1', 'ZIGGURAT_2', 'ACOLYTE', 'UNDEAD_MINE'],
  human: ['TOWN_HALL', 'KEEP', 'CASTLE', 'WATCH_TOWER', 'GUARD_TOWER', 'PEASANT', 'TOWN_HALL'],
  orc: ['GREAT_HALL', 'STRONGHOLD', 'FORTRESS', 'BURROW', 'ORC_WATCH_TOWER', 'PEON', 'GREAT_HALL'],
  elf: ['TREE_LIFE', 'TREE_AGES', 'TREE_ETERNITY', 'MOON_WELL', 'ANCIENT_PROTECT', 'WISP', 'TREE_LIFE'],
};

export function townGame(race = 'undead') {
  const units = [], orders = [], production = [], groups = new Set();
  const ids = Object.fromEntries(rows.map((row, index) => [row[0], index]));
  const array = () => zeros();
  const count = (raw, done = false) => units.filter(u => u.alive && u.owner === 0 && u.type === raw && (!done || !u.unfinished)).length;
  const state = {
    ai_player: 0, IsAMAI: true, ai_time: 100, debugging: 0,
    own_town: [2, 0], own_town_num: 2, town_num: 3, home_town: 2, town_radius: 2500,
    town_owner: [0, 1, 0], town_loc: [{ x: 6000, y: 0 }, { x: 12000, y: 0 }, { x: 0, y: 0 }],
    town_structures: [new Set(), null, new Set()], tracked_structures: new Map(),
    town_builder: [], town_build_type: [], town_build_wait: [], town_mine: [],
    town_build_item: [], town_build_count: [], town_build_progress: [], town_build_distance: [],
    in_town_group: new Set(), town_value: array(), town_count: array(), town_has_expansion: [],
    town_can_tp: [], town_dist: [6000, 12000, 0], town_destroyed_time: array(),
    town_threat: array(), town_threat_army: array(), max_value_town: -1, home_found_temp: false,
    home_location: { x: 0, y: 0 }, own_race: 4, tq_timer: null,
    old_id: [], needed1: array(), needed2: array(), needed3: array(), tc_add1: array(), tc_add2: array(),
    buy_type: array(), available_time: array(), unitNames: [],
    UPGRADED: -1, BT_UNIT: 1, BT_BUILDING: 2, BT_HERO: 3, BT_NEUTRAL_HERO: 4, BT_ML_UPGRADE: 5, BT_RACIAL_ITEM: 6,
    BUILD_UNIT: 1, BUILD_UPGRADE: 2, BUILD_ITEM: 3, BUILD_ADAPTIVE: 5, BUILD_ADAPTIVE_UPGRADE: 6,
    BLOC_STD: 0, BLOC_FRONT: 1, BLOC_MINE: 2, JASS_MAX_ARRAY_SIZE: 8192,
    BUILT_ALL: 0, BUILT_SOME: 1, NOT_ENOUGH_RES: 2, CANNOT_BUILD: 3,
    UNIT_TYPE_STRUCTURE: 'structure', UNIT_TYPE_TOWNHALL: 'hall', UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife',
    PLAYER_NEUTRAL_PASSIVE: 15, GAME_STATE_TIME_OF_DAY: 0,
    total_gold: 5000, total_wood: 5000, total_food: 80, neededPeons: 0,
    build_length: 0, prio_n_inc: 10, prio_q_inc: 2, neutral_available: [true],
    ancient_expanding: false, ancient_exp_state: 0, front_locs_computed: true,
    front_loc: [{ x: 1000, y: 0 }], front_loc_num: 1, mine_loc: { x: 300, y: 0 }, race_has_ghouls: false,
    racial_rushcreep: 0, racial_lumber: 0, br_rush_built: true,
    expansion_peon: null, militia_builder: null, early_remote_builders: new Set(),
    militia_reserved_peons: new Set(), towerrush: false, race_tower_peon: 0,
    harvestgrp: new Set(), UNIT_TYPE_HERO: 'hero', hero: [], build_free: array(),
    gold_sum: array(), build_time_sum: array(), build_num: array(), prio_sum: array(),
    scans: { player: 0, range: 0 }, probeOffset: 500, randomValues: [],
    ...groupNatives(groups),
    Player: p => p, GetHandleId: u => u?.id ?? 0, GetOwningPlayer: u => u.owner,
    UnitAlive: u => Boolean(u?.alive), IsUnitHidden: u => u.hidden, IsUnitLoaded: u => u.loaded,
    GetUnitTypeId: u => u.type, IsUnitType: (u, kind) => Boolean(u[kind]),
    GetUnitX: u => u.x, GetUnitY: u => u.y, GetUnitLoc: u => ({ x: u.x, y: u.y }),
    GetLocationX: l => l.x, GetLocationY: l => l.y, Location: (x, y) => ({ x, y }), RemoveLocation() {},
    Atan2: Math.atan2, Cos: Math.cos, Sin: Math.sin,
    GetRandomReal: (min, max) => min + (max - min) * (state.randomValues.shift() ?? 0.5),
    GetRandomInt: min => min,
    GetUnitState: (u, key) => u[key], GetResourceAmount: u => u.gold,
    GetUnitCurrentOrder: u => u.order, OrderId: order => order,
    GetUnitCount: raw => count(raw), GetUnitCountDone: raw => count(raw, true),
    GetTownUnitCount() { assert.fail('Building count used a native town index'); },
    TownHasMine() { assert.fail('Construction eligibility used a native town index'); },
    TownHasHall() { assert.fail('Hall eligibility used a native town index'); },
    TownWithMine() { assert.fail('Town selection used a native town index'); },
    IsUnitIdType: (raw, kind) => kind === 'structure' && rows.some(row => row[1] === raw && row[4] === 'BUILDING'),
    IsUnitGoldMine: u => u.mine,
    GetFloatGameState: () => 12, GetNeutralNumber: () => 0,
    GetUnitGoldCost2: () => 200, GetUnitWoodCost2: () => 50, GetFoodUsed: () => 0,
    GetUnitBuildTime: () => 60, AdaptiveCountersEnabled: () => false,
    BlockListCheck: qty => qty, Get_f_qty: () => 1, CheckNotBuiltFrom: () => true,
    GetBuildLock() {}, ReleaseBuildLock() {}, Trace() {}, CreateDebugTagLoc() {},
    TimerGetElapsed: () => state.ai_time * 5, Max: Math.max, Min: Math.min, Int2Str: String, R2I: Math.trunc,
    BlzGroupAddGroupFast: (source, target) => source.forEach(u => target.add(u)),
    GroupEnumUnitsOfPlayer(g, owner) { state.scans.player++; units.filter(u => u.owner === owner).forEach(u => g.add(u)); },
    GroupEnumUnitsInRangeOfLoc(g, loc, radius) {
      state.scans.range++;
      units.filter(u => Math.hypot(u.x - loc.x, u.y - loc.y) <= radius).forEach(u => g.add(u));
    },
    LoadInteger: (table, parent, child) => table.get(`${parent}:${child}`) ?? 0,
    SaveInteger: (table, parent, child, value) => table.set(`${parent}:${child}`, value),
    FlushChildHashtable(table, parent) { for (const key of table.keys()) if (key.startsWith(`${parent}:`)) table.delete(key); },
    GetSumLoc_dd: (a, b) => ({ x: a.x + b.x, y: a.y + b.y }),
    GetDivisionLoc_d: (a, n) => ({ x: a.x / n, y: a.y / n }),
    DistanceBetweenPoints: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    DistanceBetweenPoints_dk: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    GetMineNearLoc: (_, loc, radius) => units.filter(u => u.mine && u.alive && Math.hypot(u.x - loc.x, u.y - loc.y) <= radius)
      .sort((a, b) => Math.hypot(a.x - loc.x, a.y - loc.y) - Math.hypot(b.x - loc.x, b.y - loc.y))[0] ?? null,
    SetProduce(qty, raw, town) {
      assert.ok(town === -1 || !state.IsUnitIdType(raw, 'structure'), 'Building placement used a native town index');
      production.push({ qty, raw, town });
      return true;
    },
    AdaptiveProductionStarted() {},
    IssueImmediateOrderById(u, raw) { orders.push({ unit: u, order: raw }); u.order = raw; return true; },
    IssueImmediateOrder(u, order) { orders.push({ unit: u, order }); u.order = 0; return true; },
    IssuePointOrderByIdLoc(u, raw, loc) {
      orders.push({ unit: u, order: raw, x: loc.x, y: loc.y }); u.order = raw;
      return false; // AI runtime return value cannot establish acceptance.
    },
    CreateUnitAtLoc(owner, raw, loc) { return { owner, type: raw, x: loc.x + state.probeOffset, y: loc.y, alive: true }; },
    CreatePathingUnitFull: (_, owner, raw, x, y) => ({ owner, type: raw, x, y, alive: true }),
    GetExpansionPeon: () => units.find(u => u.alive && u.type === state.old_id[state.racial_peon]) ?? null,
    GetExpansionPeon2: () => null,
    Sleep() {},
    RemoveUnit(u) { u.alive = false; },
    GetMinesHarvested: () => state.town_mine.filter(u => u?.alive && u.gold > 0).length,
  };
  for (const suffix of ['qty', 'type', 'item', 'town', 'loc', 'prio']) state['build_' + suffix] = array();
  for (const row of rows.slice(1)) {
    const n = ids[row[0]];
    const resolve = name => name === 'UPGRADED' ? -1 : ids[name] ?? 0;
    state.old_id[n] = row[1]; state.unitNames[n] = row[0];
    state.buy_type[n] = state['BT_' + row[4]] ?? 0;
    state.needed1[n] = resolve(row[5]); state.needed2[n] = resolve(row[6]); state.needed3[n] = resolve(row[7]);
    state.tc_add1[n] = resolve(row[8]); state.tc_add2[n] = resolve(row[9]);
  }
  assert.ok(names[race].every(name => ids[name]), 'Unknown race fixture unit name: ' + names[race]);
  const [hall, hall2, hall3, farm, tower, worker, expansion] = names[race].map(name => ids[name]);
  Object.assign(state, { racial_hall: [0, hall, hall2, hall3], tiernum: 3, racial_peon: worker, racial_expansion: expansion });
  const context = vm.createContext(state);
  for (const name of [
    'CopyGroup', 'GetTrackedTown', 'GetTrackedTownAtPoint', 'GetTrackedStructureTown', 'TrackedStructureDone',
    'GetTrackedTownUnitCount', 'TrackedTownHasMine', 'TrackedTownHasHall', 'IsTrackedTownBuilder',
    'GetUnitCountEx', 'isSameUpgradeLine', 'GetUnitCountAlt', 'TownCountEx', 'TownCount', 'TownCountDone', 'TownCountTown',
    'SetBuildAllAMCore', 'SetBuildDependency', 'RefreshNeeded', 'SetBuildAllAM', 'SecondaryTownAM',
    'DefendTownsEx', 'DefendTownsDone', 'DefendTownsCond', 'IsRacialHallId',
    'AIGetProjectedLoc', 'GetTrackedTownBuilder', 'RefreshTrackedTownStructures', 'GetTrackedTownBuildLocation',
    'StartTrackedTownBuilding', 'RefreshTrackedTownBuilders', 'StartUnitAM', 'UpgradeBuilding', 'HasExpanded',
    'GetBaseBuildLocation', 'GetBuildLocation', 'BuildAtSpecialLoc', 'GetLumberLocationAtBase', 'BuildLumberMillAtBase',
  ]) vm.runInContext(compile(common, name), context);
  for (const name of ['IsConstructionOrder', 'IsReservedHarvestPeon']) vm.runInContext(compile(harvest, name), context);
  vm.runInContext(compile(tracking, 'TrackTown'), context);
  vm.runInContext(compile(read('races.eai'), 'KeepHarvestLocal'), context);
  Object.assign(state, { fixharvest: 0, front_base_distance: 1000 });

  function addUnit(type, changes = {}) {
    const raw = state.old_id[type] ?? type;
    const u = { id: units.length + 1, type: raw, owner: 0, alive: true, hidden: false, loaded: false,
      structure: state.IsUnitIdType(raw, 'structure'), hall: [hall, hall2, hall3].includes(type),
      mine: raw === 'ngol' || raw === state.old_id[expansion] && race === 'undead',
      unfinished: false, life: 1000, maxLife: 1000, gold: 0, order: 0, x: 6000, y: 0, ...changes };
    units.push(u);
    return u;
  }
  return {
    state, units, orders, production, groups, ids: { hall, hall2, hall3, farm, tower, worker, expansion }, addUnit,
    addMine: (changes = {}) => addUnit(race === 'undead' ? expansion : 'ngol', { mine: true, gold: 10000, ...changes }),
    trackTowns() { state.GroupClear(state.in_town_group); for (const tracked of state.own_town) state.TrackTown(tracked); },
    count: (id, town = 1, done = false) => state.TownCountEx(id, done, town),
    build: (id, qty = 1, town = 1) => state.StartUnitAM(qty, id, town, 0, 95, 1),
    buildAtFront: id => state.StartUnitAM(1, id, -1, state.BLOC_FRONT, 95, 1),
    buildAtMine: id => state.StartUnitAM(1, id, -1, state.BLOC_MINE, 95, 1),
    findLumber: () => state.GetLumberLocationAtBase(),
    requestDefenses: (id, qty = 1) => state.DefendTownsDone(qty, id, 95),
    upgrade: (id, town = 1) => state.UpgradeBuilding(1, id, town, 0),
    maintainBuilders: () => state.RefreshTrackedTownBuilders(),
    keepHarvestLocal: () => state.KeepHarvestLocal(),
    advance: seconds => { state.ai_time += seconds / 5; },
  };
}
