// Run the Ancient expansion state machine with strict handle checks and a game clock.
// Warcraft construction, pathing and captain orders remain native boundaries.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';

const read = path => readFileSync(new URL('../../' + path, import.meta.url), 'utf8');

export function ancientGame() {
  const locations = new Set(), orders = [], jobs = [], scans = [];
  const location = (x, y) => { const l = { x, y }; locations.add(l); return l; };
  const validLocation = l => { assert.ok(locations.has(l), 'Missing or destroyed Ancient location'); return l; };
  const validUnit = u => { assert.ok(u && !u.removed, 'Missing or removed Ancient unit'); return u; };
  const wisp = { id: 1, x: 0, y: 0, alive: true, owner: 0, order: 1000 };
  const mine = { id: 2, x: 5000, y: 0, alive: true, owner: 15, gold: 10000 };
  const creep = { id: 3, x: 4800, y: 0, alive: true, owner: 12 };
  const state = {
    now: 0, ai_time: 0, tq_timer: null, ai_player: 0, player_defeated: false,
    ancient_expanding: true, ancient_exp_state: 2, ancient_exp_check_pending: false,
    ancient_exp_loc: location(4000, 0), ancient_exp_wisp: wisp, ancient_exp_unit: null,
    ancient_exp_mine: mine, ancient_exp_creep: creep, ancient_attack_running: false, anc_retry: 0,
    current_expansion: mine, take_exp: true, exp_time_count: 0,
    racial_expansion: 1, old_id: [0, 1000], ANCIENT_EXPANSION: 6, ANCIENT_EXPANSION_CHECK: 36,
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife', gold_buffer: 0, wood_buffer: 0,
    creep_battle_radius: 750, expansion_radius: 1500, ver_creeps_attack_buildings_dist: 600,
    PLAYER_NEUTRAL_PASSIVE: 15, OrderIdCancel: 851976,
    expansion_retry_state: new Map(), expansion_retry_cooldowns: new Map(), tracked_structures: new Map(),
    own_town_num: 0, groundid: 1, home_location: location(0, 0),
    candidate: wisp, foundation: null, pathProbe: null, pathMoves: true, gold: 1000, wood: 1000, campStrength: 5,
    main_army: -1, army_loc: [], atGoal: true, empty: false, isfleeing: false,
    town_threatened: false, town_threat_break: false,
    race_ancient_expansion_available: true, race_militia_expansion_available: false,
    militia_expanding: false, SaveYourselfMode: -1,
    UnitAlive: u => Boolean(u?.alive && !u.removed),
    IsUnitHidden: u => Boolean(validUnit(u).hidden),
    GetUnitX: u => validUnit(u).x, GetUnitY: u => validUnit(u).y,
    GetUnitLoc: u => location(validUnit(u).x, u.y), GetUnitCurrentOrder: u => validUnit(u).order,
    GetUnitTypeId: u => validUnit(u).type ?? 1000,
    GetUnitState: (u, key) => validUnit(u)[key], GetResourceAmount: u => validUnit(u).gold,
    GetLocationX: l => validLocation(l).x, GetLocationY: l => validLocation(l).y,
    Location: location,
    RemoveLocation(l) { if (l !== null) { validLocation(l); locations.delete(l); } },
    GetHandleId: u => u?.id ?? 0, TimerGetElapsed: () => state.now,
    LoadUnitHandle: (t, p, c) => t.get(`${p}:${c}`) ?? null,
    LoadInteger: (t, p, c) => t.get(`${p}:${c}`) ?? 0,
    LoadReal: (t, p, c) => t.get(`${p}:${c}`) ?? 0,
    SaveUnitHandle: (t, p, c, v) => t.set(`${p}:${c}`, v),
    SaveInteger: (t, p, c, v) => t.set(`${p}:${c}`, v),
    SaveReal: (t, p, c, v) => t.set(`${p}:${c}`, v),
    FlushChildHashtable(t, p) { for (const k of t.keys()) if (k.startsWith(`${p}:`)) t.delete(k); },
    GetGold: () => state.gold, GetWood: () => state.wood, GetUnitGoldCost2: () => 340, GetUnitWoodCost2: () => 185,
    GetExpansionPeon: () => state.candidate, GetExpansionPeon2: () => null,
    GetOneOfIdNearLoc: () => state.foundation,
    GetUnitCount: () => state.foundation ? 2 : 1,
    GetUnitCountDone: () => state.foundation?.done ? 2 : 1,
    GetLocationCreepStrength(x, y) { scans.push({ x, y }); return state.campStrength; },
    GetLocationEnemyStrength: () => 0, GetLocationNonCreepStrength: () => 0,
    CheckExpansionTaken: () => false, GetExpFoe: () => state.UnitAlive(creep) ? creep : null,
    MineHallHasActiveMine: u => Boolean(u.activeMine),
    DistanceBetweenUnits: (a, b) => Math.hypot(validUnit(a).x - validUnit(b).x, a.y - b.y),
    RemoveGuardPosition() {}, RecycleGuardPosition: u => { validUnit(u); orders.push({ unit: u, order: 'recycle' }); },
    IssuePointOrderByIdLoc(u, order, l) { validUnit(u).order = order; validLocation(l); orders.push({ unit: u, order }); },
    IssueImmediateOrder(u, order) { validUnit(u).order = order; orders.push({ unit: u, order }); },
    IssueImmediateOrderById(u, order) { validUnit(u).order = order; orders.push({ unit: u, order }); },
    IssueTargetOrder(u, order, target) { validUnit(target); validUnit(u).order = order; orders.push({ unit: u, order, target }); },
    IssuePointOrderLoc(u, order, l) { validUnit(u).order = order; validLocation(l); orders.push({ unit: u, order }); },
    CreateUnit: (owner, type, x, y) => ({ id: 99, owner, type, x, y, alive: true }),
    RemoveUnit: u => { validUnit(u).removed = true; u.alive = false; },
    CreatePathingUnitFull(u, owner, type, x, y) {
      state.pathProbe = { id: 98, x, y, alive: true, owner, order: 'move' };
      return state.pathProbe;
    },
    IssuePointOrder: (u, order) => { validUnit(u).order = order; },
    Sleep(seconds) {
      state.now += seconds;
      state.ai_time = state.now / 5;
      if (state.pathMoves && state.UnitAlive(state.pathProbe)) state.pathProbe.x -= 800;
      state.onSleep?.();
      assert.ok(state.now < 1000, 'Ancient expansion kept waiting without a timeout');
    },
    FromGroupAndGhoulsAM: seconds => state.Sleep(seconds), CaptainAtGoal: () => state.atGoal,
    CaptainIsEmpty: () => state.empty, CaptainAttack() {},
    AttackMoveKillCreep: target => { assert.ok(state.UnitAlive(target), 'Attacked a dead creep'); state.onAttack?.(); },
    TQAddJob: (delay, job, par) => jobs.push({ delay, job, par }),
    DisplayToAllJobDebug() {}, TraceAll() {}, Trace() {}, CreateDebugTag() {},
    Int2Str: String, Player: p => p, OrderId: order => order, RMax: Math.max, SquareRoot: Math.sqrt,
  };
  const context = vm.createContext(state);
  for (const file of ['Jobs/ANCIENT_EXPANSION.eai', 'Jobs/ANCIENT_EXPANSION_CHECK.eai']) {
    const source = read(file);
    for (const [, name] of source.matchAll(/^function (\w+) takes/gm)) vm.runInContext(compile(source, name), context);
  }
  const common = read('common.eai');
  for (const name of [
    'ExpansionAttemptStalled', 'IsExpansionRebuildCoolingDown', 'TrackedStructureDone',
    'GetLengthOfLoc', 'GetLengthOfLoc_d', 'GetSubtractionLoc', 'GetSubtractionLoc_dk', 'GetSubtractionLoc_kd', 'GetSubtractionLoc_dd',
    'DistanceBetweenPoints', 'DistanceBetweenPoints_dk', 'GetLocationInDistanceFromLoc',
    'GetBuildLocationInDistanceFromLoc_d', 'AncientExpaAttack',
  ]) vm.runInContext(compile(common, name), context);
  vm.runInContext(compile(read('Jobs/DETECT_DEFEAT.eai'), 'SaveYourself'), context);

  return {
    state, wisp, mine, creep, orders, jobs, scans, locations,
    check() { jobs.length = 0; state.AncientExpansionJob(); },
    checkSite: () => state.AncientExpansionCheck(), attack: () => state.AncientExpaAttack(),
    advance(seconds) { state.now += seconds; state.ai_time = state.now / 5; },
    startTree({ completed = true } = {}) {
      wisp.alive = false;
      const tree = { id: 4, x: 4000, y: 0, alive: true, owner: 0, order: 0,
        life: completed ? 1300 : 100, maxLife: 1300, done: completed };
      state.foundation = tree;
      return tree;
    },
  };
}
