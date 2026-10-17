// Track location ownership while running production attack and army tracking code.
// Invalid handle reads fail here; this does not model Warcraft access violations.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const read = file => readFileSync(new URL('../../' + file, import.meta.url), 'utf8');
const common = read('common.eai');

export function armyGame({ expansion = false } = {}) {
  const locations = new Set(), groups = new Set();
  const location = (x, y) => { const l = { x, y }; locations.add(l); return l; };
  const valid = l => { assert.ok(locations.has(l), 'Read a missing or destroyed location'); return l; };
  const units = [
    { x: 4000, y: 4000, owner: 0, alive: true, strength: 10 },
    { x: 4100, y: 4000, owner: 0, alive: true, strength: 10 },
  ];
  const target = { x: 9000, y: 4000, owner: 1, alive: true };
  const state = {
    ai_player: 0, main_army: 0, army_num: 1, army_radius: 1500, army_future_mult: 3,
    army_owner: [0], army_loc: [location(4000, 4000)], army_dir: [location(0, 0)],
    army_future: [location(4000, 4000)], army_strength: [20], army_count: [2],
    army_group: [new Set(units)], in_army_group: new Set(),
    major_hero: null, tmpmainarmy: -1, UNIT_TYPE_STRUCTURE: 'structure', UNIT_TYPE_PEON: 'peon',
    attacking_expansion: expansion, current_expansion: expansion ? target : null,
    town_threat_break: false, town_threatened: false, break_attack: false, isfleeing: false,
    attack_intrusion: null,
    desperation_assault: false, sleep_multiplier: 1, attack_reform_length: 10,
    home_location: location(0, 0), ally_loc: location(4000, 4000),
    c_ally_total: 0, amaiCache: null, ALLIANCE_TARGET: 0, lastcaptainx: 0, lastcaptainy: 0,
    full_threat_distance: 1000, no_threat_distance: 6000,
    ...groupNatives(groups),
    Location: location, GetLocationX: l => valid(l).x, GetLocationY: l => valid(l).y,
    RemoveLocation(l) { if (l !== null) { valid(l); locations.delete(l); } },
    GetUnitX: u => { assert.ok(u); return u.x; }, GetUnitY: u => { assert.ok(u); return u.y; },
    GetUnitLoc: u => { assert.ok(u); return location(u.x, u.y); },
    UnitAlive: u => Boolean(u?.alive), IsUnitType: (u, kind) => Boolean(u[kind]),
    GetOwningPlayer: u => u.owner, Player: p => p, IsPlayerAlly: (a, b) => a === b,
    IsUnitInvisibleAM: () => false, IsStandardUnit: () => true, IsUnitBuying: () => false,
    GetUnitCurrentOrder: () => 'attack', OrderId: order => order, GetUnitStrength: u => u.strength,
    GroupEnumUnitsInRange(g, x, y, radius) {
      units.filter(u => u.alive && Math.hypot(u.x - x, u.y - y) <= radius).forEach(u => g.add(u));
    },
    GroupEnumUnitsInRangeOfLoc(g, l, radius) { state.GroupEnumUnitsInRange(g, valid(l).x, valid(l).y, radius); },
    CaptainIsEmpty: () => false, CaptainInCombat: () => false, CaptainAtGoal: () => false, CaptainIsHome: () => false, CaptainRetreating: () => false,
    GetStoredInteger: () => 0, I2U: () => null, Int2Str: String, GetRandomReal: min => min,
    AttackMoveKill() {}, CreateDebugTag() {}, CreateDebugTagLoc() {}, Trace() {},
    waits: 0,
    StaggerSleep() { if (++state.waits === 2) target.alive = false; },
    Sleep() {}, ModuloInteger: (a, b) => a % b,
    I2R: Number, R2I: Math.trunc, RAbs: Math.abs, Max: Math.max, RMax: Math.max, SquareRoot: Math.sqrt,
  };
  const context = vm.createContext(state);
  for (const name of [
    'GetLengthOfLoc', 'GetLengthOfLoc_d', 'GetSubtractionLoc', 'GetSubtractionLoc_dd',
    'GetSubtractionLoc_kd', 'GetSubtractionLoc_dk', 'GetSumLoc_kd', 'GetMultipleLoc',
    'GetMultipleLoc_d', 'GetDivisionLoc', 'GetNormalisedLoc', 'GetProjectedLoc',
    'DistanceBetweenPoints', 'DistanceBetweenPoints_dd', 'DistanceBetweenPoints_kd',
    'AttackTransitIntrusion', 'CommonSleepUntilTargetDeadAM',
  ]) vm.runInContext(compile(common, name), context);
  for (const name of ['IsArmyUnit', 'TrackArmy']) {
    vm.runInContext(compile(read('Jobs/ARMY_TRACK.eai'), name), context);
  }
  return {
    state, units, target, locations,
    attack: () => state.CommonSleepUntilTargetDeadAM(target, false, false, false),
    trackArmy: () => state.TrackArmy(0),
  };
}
