import assert from 'node:assert/strict';
import vm from 'node:vm';
import { compiledCommon, strengthGame } from './strength-game.mjs';
import { compile, zeros } from './jass.mjs';

// Run compiled production decisions; only Warcraft state and native calls are mocked.
export function townDefenseGame(version) {
  const game = strengthGame(version), state = game.state;
  const source = compiledCommon(version);
  const units = [], captains = new Map(), orders = [], locations = new Set();
  const location = (x, y) => { const l = { x, y }; locations.add(l); return l; };
  const point = l => { assert.ok(locations.has(l), 'Read a destroyed location'); return l; };
  const alliances = new Set([0]);
  const addUnit = (name, options = {}) => {
    const u = game.addUnit(name, { x: 500, y: 0, visible: true, order: 'attack', ...options });
    units.push(u);
    return u;
  };
  Object.assign(state, {
    now: 0, tq_timer: null, town_num: 0, town_radius: 2500, home_town: -1,
    home_location: location(0, 0), captain_home: null, defense_captain_home: null,
    town_threatened: false, town_threat_count: 0, captain_tp: true,
    most_threatened_town: -1, most_threatened_player_town: -1, most_threatened_enemy_town: -1,
    next_most_threatened_player_town: -1, next_most_threatened_town: -1, next_most_threatened_enemy_town: -1,
    ATTACK_CAPTAIN: 1, DEFENSE_CAPTAIN: 2, BOTH_CAPTAINS: 3,
    full_threat_distance: 1000, no_threat_distance: 6000, ver_tower_check_radius: 2000,
    distance_threat_mult: 540, distance_threat_exponent: 0.8,
    atl_time_start: 300, atl_time_end: 900, atl_time_start_val: 10, atl_time_end_val: 20,
    atl_enemy_start: 1, atl_enemy_end: 4, atl_enemy_start_mult: 1, atl_enemy_end_mult: 1.5,
    c_enemy_total: 1, lastFreeNum: 0, mode: 0, racial_expansion: 0,
    army_num: 1, main_army: 0, army_radius: 1500, army_future_mult: 3,
    in_army_group: new Set(), major_hero: null, tmpmainarmy: -1,
    army_owner: [0], army_loc: [location(5000, 0)], army_dir: [location(0, 0)],
    army_future: [location(5000, 0)], army_group: [new Set()], army_count: [10],
    army_strength: new Proxy([100], { get(array, key) { assert.notEqual(key, '-1', 'Negative army index'); return array[key]; } }),
    attack_running: true, break_attack: false, teleporting: false,
    retreat_controlled: true, isfleeing: false, canflee: false, retreat_group_refreshed: false,
    town_threat_break: true, player_defeated: false, desperation_assault: false,
    ancient_expanding: false, ancient_attack_running: false, br_rush_attacked: false,
    battle_radius: 1500, creep_battle_radius: 750, sleep_multiplier: 1, RETREAT_CONTROL: 1,
    enemy_loc: location(0, 0), last_enemy_loc: location(0, 0), last_ally_loc: location(0, 0),
    last_major_hero_loc: location(0, 0),
    UNIT_TYPE_TOWNHALL: 'townhall', PLAYER_NEUTRAL_PASSIVE: 15,
    GetUnitX: u => { assert.ok(u?.alive); return u.x; },
    GetUnitY: u => { assert.ok(u?.alive); return u.y; },
    GetUnitLoc: u => location(state.GetUnitX(u), state.GetUnitY(u)),
    UnitAlive: u => Boolean(u?.alive), IsUnitVisible: u => u.visible,
    IsUnitInvisibleAM: u => Boolean(u.invisible), GetUnitCurrentOrder: u => u.order,
    OrderId: name => name, IsStandardUnit: () => true, IsUnitBuying: () => false,
    IsPlayerAlly: (a, b) => a === b || (alliances.has(a) && alliances.has(b)),
    IsPlayerEnemy: (a, b) => a !== b && !(alliances.has(a) && alliances.has(b)),
    Location: location, GetLocationX: l => point(l).x, GetLocationY: l => point(l).y,
    MoveLocation(l, x, y) { Object.assign(point(l), { x, y }); },
    RemoveLocation(l) { if (l !== null) { point(l); locations.delete(l); } },
    GroupEnumUnitsInRange(g, x, y, radius) {
      g.clear();
      units.filter(u => Math.hypot(u.x - x, u.y - y) <= radius).forEach(u => g.add(u));
    },
    GroupEnumUnitsInRangeOfLoc(g, l, radius) { state.GroupEnumUnitsInRange(g, point(l).x, point(l).y, radius); },
    TimerGetElapsed: () => state.now, ApplyFleeStrengthModifier: strength => strength,
    SetCaptainHome(which, x, y) { orders.push({ which, x, y }); captains.set(which, { x, y }); },
    SelectByHidden(g) { for (const u of g) if (u.hidden) g.delete(u); return g; },
    SelectByAlive(g) { for (const u of g) if (!u.alive) g.delete(u); return g; },
    GetMajorHeroReplacement_k: () => null, CaptainRetreating: () => false,
    CaptainIsHome: () => false, CaptainInCombat: () => true, UnitIsSleeping: () => false,
    SetGroupsFlee() {}, CaptainGoHome() {}, FormGroupAM() {}, TQAddJob() {}, DisplayToAllJobDebug() {},
    B2S: String, Max: Math.max, RMin: Math.min, RAbs: Math.abs, Pow: Math.pow, ModuloInteger: (a, b) => a % b,
    Atan2: Math.atan2, Acos: Math.acos, Cos: Math.cos, Sin: Math.sin, GetRandomReal: min => min,
    Trace() {}, Real2Str: String, Int2Str: String, Sleep() {}, CreateDebugTagLoc() {},
  });
  for (const name of ['town_owner', 'town_loc', 'town_value', 'town_count', 'town_threat',
    'town_threat_army', 'town_has_expansion', 'town_destroyed_time', 'town_can_tp', 'town_dist',
    'town_mine', 'town_structures', 'town_builder', 'town_build_type', 'town_build_wait',
    'town_build_item', 'town_build_count', 'town_build_progress', 'town_build_distance',
    'town_intruder_since', 'town_intruder_seen', 'town_intruder_life', 'town_intruder_pressure']) state[name] = zeros();
  for (const name of ['town_defense_anchor', 'town_intruder', 'town_intruder_anchor', 'town_intruder_owner']) state[name] = Array(8192).fill(null);
  state.town_intruder_confirmed = Array(8192).fill(false);
  state.town_tower_progress = Array(8192).fill(false);
  state.max_value_town = -1;
  const names = ['ClearTownIntrusion', 'CopyTown', 'GetLiveTownDefenseValue', 'LocalIntrusionRank',
    'UpdateTownIntrusion', 'UpdateSpecificTownThreat', 'CanRecallToTown', 'UpdateTownThreat',
    'SetCaptainHomeLoc', 'SetDefenseCaptainHome', 'GetLocationTowerStrength', 'LinearInterpolation',
    'GetLengthOfLoc', 'GetLengthOfLoc_d', 'l_smult_kk', 'GetAngleBetweenLocs',
    'IsArmyUnit', 'TrackArmy', 'GetSubtractionLoc_kd', 'GetSubtractionLoc',
    'GetMultipleLoc', 'GetMultipleLoc_d', 'GetSumLoc_kd', 'GetProjectedLoc', 'GetNormalisedLoc', 'GetDivisionLoc', 'RetreatControlJob'];
  vm.runInContext(names.map(name => compile(source, name)).join('\n'), vm.createContext(state));
  function addTown({ x = 0, y = 0, owner = 0 } = {}) {
    const num = state.town_num++;
    alliances.add(owner);
    state.town_owner[num] = owner;
    state.town_loc[num] = location(x, y);
    state.town_count[num] = 1;
    state.town_can_tp[num] = true;
    state.town_has_expansion[num] = true;
    state.town_structures[num] = null;
    if (owner === 0 && state.home_town < 0) state.home_town = num;
    return addUnit('TOWN_HALL', { x, y, owner, structure: true, townhall: true });
  }
  const hall = addTown();
  return {
    state, units, captains, orders, locations, hall, addTown,
    addWorker: options => addUnit('PEASANT', { owner: 1, peon: true, level: 1, food: 1, ...options }),
    addTower: options => addUnit('ORC_WATCH_TOWER', { owner: 1, structure: true, ...options }),
    addAncient: options => addUnit('ANCIENT_WAR', { owner: 1, structure: true, ancient: true, melee: true, ...options }),
    addSoldier: options => addUnit('FOOTMAN', { owner: 1, food: 2, level: 2, ...options }),
    checkTown(time = state.now) { state.now = time; state.UpdateTownThreat(); },
    trackArmy: num => state.TrackArmy(num),
    copyTown: (from, to) => state.CopyTown(from, to),
    checkBattle: () => state.RetreatControlJob(),
  };
}
