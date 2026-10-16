import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile, zeros } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const read = file => readFileSync(new URL('../../' + file, import.meta.url), 'utf8');
const common = read('common.eai');

export function harassGame() {
  const units = [], jobs = [], groups = new Set();
  const load = (table, key, field) => table.get(key)?.get(field) ?? 0;
  const save = (table, key, field, value) => {
    if (!table.has(key)) table.set(key, new Map());
    table.get(key).set(field, value);
  };
  const state = {
    ai_player: 0, ai_time: 100, max_harass_groups: 10,
    harass_size: zeros(), harass_time: zeros(), harass_groups: new Map(), additional_info: new Map(),
    old_id: Array.from({ length: 100 }, (_, i) => i),
    unit_harassing: new Set(), unit_healing: new Set(), unit_rescueing: new Set(),
    unit_zepplin_move: new Set(), unit_buying_item: new Set(),
    unit_buying_merc: new Set(), unit_buying_tavern: new Set(),
    hero_unit: [], town_threatened: false, home_location: { x: 0, y: 0 },
    flee_health_percentage: 0.3, flee_minimum_health: 10,
    harass_radius_flee_ranged: 1200, sleep_multiplier: 1,
    ...groupNatives(groups),
    BlzGroupGetSize: g => g.size,
    BlzGroupAddGroupFast: (from, to) => from.forEach(u => to.add(u)),
    GroupEnumUnitsOfPlayer: g => units.forEach(u => g.add(u)),
    GroupEnumUnitsInRange() {},
    GetUnitTypeId: u => u.type, GetUnitStrength: u => u.food,
    UnitAlive: u => Boolean(u?.alive), IsUnitHidden: u => Boolean(u.hidden),
    GetPlayerHandicap: () => 1, GetFoodUsed: id => units.find(u => u.type === id)?.food ?? 0,
    TownCountDone: id => units.filter(u => u.type === id && u.alive).length,
    InitHashtable: () => new Map(), FlushParentHashtable: table => table.clear(),
    FlushChildHashtable: (table, key) => table.delete(key),
    SaveInteger: save, SaveReal: save, SaveBoolean: save, SaveUnitHandle: save,
    LoadInteger: load, LoadReal: load, LoadBoolean: (...args) => Boolean(load(...args)),
    LoadUnitHandle: (...args) => load(...args) || null,
    Min: Math.min, RMax: Math.max, Int2Str: String,
    TQAddUnitJob: (delay, job, key, target) => jobs.push({ delay, job, key, target }),
    GetUnitState: () => 100, IsUnitType: () => false,
    GetUnitLoc: u => ({ x: u.x, y: u.y }),
    DistanceBetweenPoints_dk: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    CreateDebugTag() {}, TraceAll() {}, DisplayToAll() {}, DisplayToAllJobDebug() {},
    GroupRecycleHarrassPositionInstant(g) {
      g.forEach(u => state.unit_harassing.delete(u));
      state.DestroyGroup(g);
    },
  };
  for (const name of [
    'START_STRENGTH_TEMP', 'START_STRENGTH', 'AVOID_TOWERS', 'STRENGTH_LIMIT',
    'STATE_ATTACKING', 'STATE_RETREAT', 'FLEE_PERCENT', 'FLEE_NUMBER', 'INVISIBLE_COUNT',
    'LOCX', 'LOCY', 'HARASS_TARGET', 'WINDWALK_COUNT', 'HARASS', 'UNIT_STATE_LIFE',
    'UNIT_STATE_MAX_LIFE', 'UNIT_TYPE_HERO', 'UNIT_TYPE_FLYING',
  ]) state[name] = name;
  state.HARASS_UNITGROUP = 1000;
  state.HARASS_TARGET_LOCATION = 2;
  const context = vm.createContext(state);
  for (const name of [
    'CopyGroup', 'GroupAddGroup', 'SelectNumberOfId', 'SelectByHidden', 'SelectByAlive',
    'IsStandardUnit', 'IsUnitBuying', 'SelectByUnitFree', 'SelectByUnitStandard',
    'UnitHashtableSize', 'AddUnitsToHashtable', 'ReturnLivingUnitsOfHashtable',
    'InitHarass', 'AddHarass', 'AddHarassUnittype', 'StartHarass', 'GetHarassGroupStrength',
  ]) vm.runInContext(compile(common, name), context);
  vm.runInContext(compile(read('Jobs/HARASS.eai'), 'HarassJob'), context);

  return {
    state, jobs, groups,
    addUnit(type, { food = 2, ...options } = {}) {
      const unit = { type, food, alive: true, x: 0, y: 0, ...options };
      units.push(unit);
      return unit;
    },
    request: (qty, type) => state.AddHarass(2, qty, type),
    start: () => state.StartHarass(2, 0, false, 10, 0.5, 0, 0, 0),
    checkHarass: () => state.HarassJob(2, null),
    strength: () => state.GetHarassGroupStrength(2),
    get: field => load(state.additional_info, 2, state[field]),
    set: (field, value) => save(state.additional_info, 2, state[field], value),
  };
}
