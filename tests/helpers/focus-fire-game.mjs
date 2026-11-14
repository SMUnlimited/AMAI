import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const common = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');
const source = readFileSync(new URL('../../Jobs/FOCUSFIRE_CONTROL.eai', import.meta.url), 'utf8');
const windwalker = readFileSync(new URL('../../Jobs/RESET_WINDWALKER.eai', import.meta.url), 'utf8');
const rawcode = text => [...text].reduce((value, char) => value * 256 + char.charCodeAt(0), 0);

// Orders record intent; Warcraft still has to verify captain tracking and movement.
export function focusFireGame() {
  const units = [], orders = [], jobs = [], sleeps = [], groups = new Set(), captain = new Set();
  const guardChanges = [], assaults = [], handledResets = new Set();
  const natives = groupNatives(groups);
  const validGroup = group => assert.ok(groups.has(group), 'Used a destroyed or borrowed replacement group');
  const validUnit = unit => assert.ok(unit && !unit.removed, 'Read a missing unit');
  const state = {
    ai_player: 0, PLAYER_NEUTRAL_AGGRESSIVE: 12,
    UNIT_TYPE_PEON: 'worker', UNIT_TYPE_STRUCTURE: 'structure', UNIT_TYPE_FLYING: 'flying',
    UNIT_TYPE_RANGED_ATTACKER: 'ranged', UNIT_TYPE_MELEE_ATTACKER: 'melee',
    UNIT_TYPE_ATTACKS_FLYING: 'attacksAir', UNIT_TYPE_HERO: 'hero', UNIT_TYPE_TOWNHALL: 'hall',
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife',
    major_hero: null, main_army: 0, army_num: 1, army_loc: [{ x: 0, y: 0 }], army_owner: [0],
    last_major_hero_loc: { x: 0, y: 0 },
    attack_running: true, town_threatened: false, town_threat_break: false,
    isfleeing: false, retreat_controlled: false, CaptainRetreating: () => false,
    difficulty: 1, EASY: 0, sleep_multiplier: 1, FOCUSFIRE_CONTROL: 40, RESET_WINDWALKER: 9,
    battle_radius: 1000, normal_battle_radius: 1000,
    focus_fire_ranged_dist: 500, focus_fire_melee_dist: 250, focus_fire_limit: 30,
    bj_RADTODEG: 180 / Math.PI,
    ...natives,
    CreateGroup: () => natives.CreateGroup(),
    DestroyGroup(group) { validGroup(group); natives.DestroyGroup(group); },
    GroupClear(group) { validGroup(group); natives.GroupClear(group); },
    GroupAddUnit(group, unit) { validGroup(group); validUnit(unit); natives.GroupAddUnit(group, unit); },
    GroupRemoveUnit(group, unit) { validGroup(group); natives.GroupRemoveUnit(group, unit); },
    FirstOfGroup(group) { validGroup(group); return natives.FirstOfGroup(group); },
    GroupEnumUnitsInRange(group, x, y, radius) {
      validGroup(group);
      group.clear();
      for (const unit of units) {
        if (!unit.removed && Math.hypot(unit.x - x, unit.y - y) <= radius) group.add(unit);
      }
    },
    Player: id => id, GetOwningPlayer: unit => unit.owner,
    IsPlayerAlly: (a, b) => a === b || a === 2 || b === 2,
    IsPlayerEnemy: (a, b) => a !== b && (a === 1 || b === 1 || a === 12 || b === 12),
    UnitAlive: unit => Boolean(unit && !unit.removed && unit.life > 0),
    GetUnitTypeId: unit => unit && !unit.removed ? 1 : 0,
    IsUnitType: (unit, type) => Boolean(unit[type]), IsUnitHidden: unit => unit.hidden,
    IsUnitLoaded: unit => unit.loaded, IsUnitVisible: unit => !unit.hidden,
    IsUnitInvisibleAM: unit => unit.invisible, IsUnitInvisible: unit => unit.windwalking,
    UnitIsSleeping: unit => unit.sleeping, GetUnitState: (unit, type) => unit[type],
    GetUnitCurrentOrder: unit => unit.order, OrderId: name => name,
    GetUnitAbilityLevel: (unit, id) => unit.windwalk && id === rawcode('AOwk') ? 1 : 0,
    GetUnitX(unit) { validUnit(unit); return unit.x; },
    GetUnitY(unit) { validUnit(unit); return unit.y; },
    GetUnitFacing: unit => unit.facing, GetUnitMoveSpeed: unit => unit.speed,
    GetUnitStrength: unit => unit.strength,
    GetLocationX: location => location.x, GetLocationY: location => location.y,
    MoveLocation: (location, x, y) => Object.assign(location, { x, y }),
    GetMajorHeroReplacement_k: () => units.find(unit => unit.owner === 0 && unit.hero && state.UnitAlive(unit)) ?? null,
    Atan2: Math.atan2, RAbs: Math.abs, RMax: Math.max, SquareRoot: Math.sqrt,
    R2I: Math.trunc, I2R: value => value, ModuloInteger: (a, b) => a % b,
    SetTargetHeroes() {}, DisplayToAllJobDebug() {},
    Sleep(delay) { sleeps.push(delay); state.onSleep?.(); },
    TQAddJob: (delay, id, parameter) => jobs.push({ delay, id, parameter }),
    TQAddUnitJob(delay, id, parameter, unit) {
      state.onEnqueue?.();
      if (state.queueFull) return false;
      jobs.push({ delay, id, parameter, unit });
      return true;
    },
    RemoveGuardPosition(unit) { captain.delete(unit); guardChanges.push(unit); },
    RecycleGuardPosition(unit) { validUnit(unit); guardChanges.push(unit); },
    AddAssault(count, id) {
      assaults.push({ count, id });
      const unit = units.find(unit => unit.owner === 0 && state.GetUnitTypeId(unit) === id && !captain.has(unit));
      if (unit) captain.add(unit);
      return true;
    },
    CreateDebugTag() {},
    GroupTargetOrder() { assert.fail('Focus fire used a bulk native order'); },
    IssuePointOrder: (unit, order, x, y) => record({ unit, order, x, y }),
    IssueTargetOrder: (unit, order, target) => {
      validUnit(target);
      assert.ok(state.UnitAlive(target));
      if (unit.windwalk && unit.windwalking) {
        assert.equal(captain.has(unit), false, 'Wind Walk attack requires guard removal');
      }
      return record({ unit, order, target });
    },
    IssueImmediateOrder: (unit, order) => record({ unit, order }),
  };
  for (const name of ['unit_retreating', 'unit_healing', 'unit_rescueing', 'unit_harassing', 'unit_zepplin_move',
    'unit_buying_item', 'unit_buying_merc', 'unit_buying_tavern',
    'focus_fire_group', 'micro_ranged_group', 'micro_enemymelee_group', 'windwalk_group']) state[name] = natives.CreateGroup();
  const persistentGroups = groups.size;
  function record(order) {
    validUnit(order.unit);
    assert.equal(order.unit.owner, 0);
    assert.ok(state.UnitAlive(order.unit));
    orders.push(order);
    order.unit.order = order.order;
    state.onOrder?.(order);
    return true;
  }
  const context = vm.createContext(state);
  for (const name of ['IsStandardUnit', 'IsUnitBuying', 'IsRetreatingAM', 'RequestAssaultAM', 'ModuloReal']) {
    vm.runInContext(compile(common, name), context);
  }
  for (const [, name] of source.matchAll(/^function (\w+) takes/gm)) {
    vm.runInContext(compile(source, name), context);
  }
  vm.runInContext(compile(windwalker, 'ResetWindWalkerGuardPosition'), context);
  return {
    state, units, orders, jobs, sleeps, groups, captain, guardChanges, assaults, persistentGroups,
    addArcher(changes = {}) {
      const unit = { owner: 0, x: 0, y: 0, life: 100, maxLife: 100,
        ranged: true, melee: false, attacksAir: true, strength: 2,
        facing: 0, speed: 300, order: 'attack', ...changes };
      units.push(unit);
      if (unit.owner === 0) captain.add(unit);
      return unit;
    },
    addEnemy(changes = {}) {
      return this.addArcher({ owner: 1, x: 100, facing: 180, ...changes });
    },
    checkBattle() {
      state.FocusFireJob();
      assert.equal(groups.size, persistentGroups, 'Temporary focus-fire groups leaked');
    },
    runGuardReset() {
      const job = jobs.find(job => job.id === state.RESET_WINDWALKER && !handledResets.has(job));
      assert.ok(job, 'No Wind Walk guard reset is pending');
      handledResets.add(job);
      state.ResetWindWalkerGuardPosition(job.unit, job.parameter);
    },
  };
}
