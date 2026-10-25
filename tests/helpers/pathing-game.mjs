// Execute production requests, probe polling and mine promotion. Warcraft movement
// is a native boundary; these scenarios supply movement and a game clock.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile, zeros } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const source = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');

export function pathingGame() {
  const probes = [], locations = new Set(), groups = new Set(), neutralChecks = [];
  const location = (x, y) => { const l = { x, y }; locations.add(l); return l; };
  const validLocation = l => { assert.ok(locations.has(l), 'Used a released location'); return l; };
  const state = {
    now: 0, tq_timer: null, ai_player: 0, groundid: 1234, buy_distance: 200,
    PATHING_TYPE_WALKABILITY: 'walk', PATHING_TYPE_FLOATABILITY: 'float',
    PATHING_TYPE_AMPHIBIOUSPATHING: 'amphibious', PATHING_TYPE_FLYABILITY: 'fly',
    pathing_check_active: 0, pathing_check_next: 1, pathing_check_probe: null,
    pathing_check_started: 0, pathing_check_progress: 0, pathing_check_x: 0, pathing_check_y: 0,
    water_pathing_request: 0, water_pathing_cursor: 0, water_pathing_mine: null, water_pathing_next_time: 60,
    expansion_list: [], expansion_list_length: 0, expansion_dist: [], expansion_creeps: new Map(),
    water_expansion_list: [], water_expansion_list_length: 0, water_expansion_dist: [], water_expansion_creeps: new Map(),
    bad_expansion_flag: zeros(), bad_water_expansion_flag: zeros(), expansion_ancient: [],
    water_expansion: new Set(), far_expansion: new Set(), home_location: location(0, 0),
    water_map: true, first_expansion_chosen: true, current_expansion: null,
    current_expansion_creeps: 0, current_expansion_iswater: false, specialexpand: false,
    racial_expansion: 1, neutral_zeppelin: 2, exp_number: 0, shared_expansion_target: null,
    exp_unit: [], exp_dist: [], exp_ancient: [], exp_creeps: [], exp_iswater: [],
    active_expansion: true, pathing_done: true, rebuild_exp_number: 0, prefer_rebuild_now: false,
    c_enemy_total: 0, c_ally_total: 0,
    debugging: 0, sleep_multiplier: 1, NEUTRAL_COUNT: 4,
    NEUTRAL_HEALING_FOUNTAIN: 0, NEUTRAL_MANA_FOUNTAIN: 1, NEUTRAL_POWER_FOUNTAIN: 2, NEUTRAL_HEAL_WARD: 3,
    nearest_neutral: [{}, null, null, null],
    TimerGetElapsed: () => state.now, ModuloInteger: (a, b) => a % b, SquareRoot: Math.sqrt,
    GetLocationX: l => validLocation(l).x, GetLocationY: l => validLocation(l).y,
    GetUnitX: u => u?.x ?? 0, GetUnitY: u => u?.y ?? 0,
    GetUnitLoc: u => location(u.x, u.y),
    RemoveLocation(l) { assert.ok(locations.delete(l), 'Released a location twice'); },
    UnitAlive: u => Boolean(u?.alive && !u.removed), GetResourceAmount: u => u.gold,
    CreatePathingUnitFull(_, owner, id, x, y) {
      const probe = { owner, id, x, y, alive: true, routeOpen: state.routeOpen ?? false };
      probes.push(probe);
      return probe;
    },
    IssuePointOrder(u, order, x, y) { u.order = order; u.target = { x, y }; },
    GetUnitCurrentOrder: u => u.order, OrderId: order => order,
    RemoveUnit(u) { assert.ok(u && !u.removed, 'Removed a probe twice'); u.removed = true; },
    ...groupNatives(groups), BlzGroupGetSize: g => g.size,
    GetExpFoeGroup(g, mine) { for (const creep of mine.creeps) g.add(creep); return g; },
    AddUnitsToHashtable: (table, index, _, group) => table.set(index, [...group]),
    CheckExpansionTaken: mine => Boolean(mine.claimed), CanYieldAlliedMine: () => false,
    GetMineClaimant: () => null, IsExpansionRebuildCoolingDown: () => false,
    GetUnitGoldCost2: () => 100, TownCountDone: () => 0,
    add_exp_rp() {}, ChooseExp: () => 0, GetRandomInt: () => 100, Trace() {},
    SetAIArray() {}, ComputeFrontPoints() {}, PingFrontPoints() {},
    CheckAllNeutralsQuick() {}, MakeExpansionList() {}, CheckAllNeutrals() {},
    NeutralGuardedJob: i => neutralChecks.push({ kind: 'guards', i }),
    NeutralEnemyCheckJob: i => neutralChecks.push({ kind: 'enemies', i }),
  };
  for (const [, name, value] of source.matchAll(/constant integer (PATHING_CHECK_\w+) = (-?\d+)/g)) state[name] = Number(value);
  for (const [, name] of source.matchAll(/(?:integer|real) array (pathing_check_\w+)/g)) state[name] = zeros();
  const context = vm.createContext(state);
  for (const name of ['RequestPathingCheck', 'GetPathingCheckResult', 'GetPathingCheckDistance',
    'ReleasePathingCheck', 'ProcessPathingChecks', 'AddExpansion', 'AddWaterExpansion',
    'CheckWaterExpansionPaths', 'add_exp', 'ChooseExpansion', 'IsWaterExpansion', 'PathingThread']) {
    vm.runInContext(compile(source, name), context);
  }

  function advance(seconds) {
    state.now += seconds;
    for (const u of probes.filter(u => state.UnitAlive(u))) {
      if (u.routeOpen && u.target) {
        const dx = u.target.x - u.x, dy = u.target.y - u.y, distance = Math.hypot(dx, dy);
        const fraction = distance === 0 ? 0 : Math.min(1, 522 * seconds / distance);
        u.x += dx * fraction;
        u.y += dy * fraction;
      }
    }
    state.onAdvance?.();
  }
  const game = {
    state, probes, locations, groups, neutralChecks, location, advance,
    request(from = state.home_location, target = location(2000, 0), path = state.PATHING_TYPE_WALKABILITY) {
      return state.RequestPathingCheck(from, target, path);
    },
    result: ticket => state.GetPathingCheckResult(ticket),
    release: ticket => state.ReleasePathingCheck(ticket),
    poll: () => state.ProcessPathingChecks(),
    checkMines: () => state.CheckWaterExpansionPaths(),
    tick(seconds = 2) { advance(seconds); game.checkMines(); game.poll(); },
    runFor(seconds) { const end = state.now + seconds; while (state.now < end) game.tick(Math.min(2, end - state.now)); },
    runThread(seconds) {
      const end = state.now + seconds, stopped = {};
      state.StaggerSleep = seconds => { advance(seconds); if (state.now > end) throw stopped; };
      try { state.PathingThread(); } catch (error) { if (error !== stopped) throw error; }
    },
    addWaterMine({ x = 2000, y = 0, gold = 10000, alive = true, creeps = [] } = {}) {
      const mine = { x, y, gold, alive, creeps };
      state.AddWaterExpansion(mine, Math.hypot(x, y));
      return mine;
    },
    chooseMine() { state.ChooseExpansion(); return state.current_expansion; },
  };
  return game;
}
