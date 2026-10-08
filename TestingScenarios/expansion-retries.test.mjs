// Run: node TestingScenarios/expansion-retries.test.mjs
// Exercise the actual JASS control flow with mocked Warcraft natives.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const common = readFileSync(new URL('common.eai', root), 'utf8');
const doubles = readFileSync(new URL('Jobs/DETECT_DOUBLE_EXP.eai', root), 'utf8');
const build = readFileSync(new URL('Jobs/BUILD_EXPANSION.eai', root), 'utf8');

// Translate the small JASS control-flow subset used by these functions.
function compile(source, name) {
  const match = source.match(new RegExp(`function ${name} takes (.*?) returns \\w+([\\s\\S]*?)endfunction`));
  assert.ok(match, `Missing ${name}`);
  const parameters = match[1] === 'nothing' ? '' : match[1].split(',').map(p => p.trim().split(/\s+/)[1]).join(',');
  const body = match[2].split(/\r?\n/).map(line => line.replace(/\/\/.*$/, '').trim()).filter(Boolean).map(line => {
    if (/^local /.test(line)) line = line.replace(/^local \w+ /, 'let ');
    else if (/^elseif /.test(line)) line = line.replace(/^elseif (.*) then$/, '} else if ($1) {');
    else if (/^if /.test(line)) line = line.replace(/^if (.*) then$/, 'if ($1) {');
    else if (line === 'else') line = '} else {';
    else if (line === 'endif') line = '}';
    else if (line === 'loop') line = 'while (true) {';
    else if (line === 'endloop') line = '}';
    else if (/^exitwhen /.test(line)) line = `if (${line.slice(9)}) break`;
    else if (/^(set|call) /.test(line)) line = line.replace(/^(set|call) /, '');
    else assert.match(line, /^return\b/, `Unsupported JASS: ${line}`);
    return line.replace(/\band\b/g, '&&').replace(/\bor\b/g, '||').replace(/\bnot\b/g, '!');
  }).join('\n');
  return `function ${name}(${parameters}) {\n${body}\n}`;
}

const table = () => new Map();
const key = (parent, child) => `${parent}:${child}`;
const env = {
  now: 0, BUILD_EXPANSION: 46, JASS_MAX_ARRAY_SIZE: 8192, expansion_taken_radius: 1500,
  UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife',
  expansion_job_pending: table(), expansion_retry_state: table(), expansion_retry_cooldowns: table(),
  tq_length: 0, tq_time: [], tq_jid: [], tq_par: [], tq_unit_par: [], tq_group_par: [], tq_unit_par2: [],
  tq_timer: null, debugging: 0, current_expansion: null, ai_player: 0, sleep_multiplier: 1,
  GetHandleId: u => u?.id ?? 0, GetOwningPlayer: u => u.owner, GetPlayerId: p => p,
  GetUnitState: (u, state) => u[state], UnitAlive: u => Boolean(u?.alive),
  GetResourceAmount: u => u.gold,
  TimerGetElapsed: () => env.now,
  GetTQLock() {}, ReleaseTQLock() {}, TQUpHeap() {}, Trace() {}, TraceAll() {},
  LoadBoolean: (t, p, c) => t.get(key(p, c)) ?? false,
  LoadReal: (t, p, c) => t.get(key(p, c)) ?? 0,
  LoadInteger: (t, p, c) => t.get(key(p, c)) ?? 0,
  LoadUnitHandle: (t, p, c) => t.get(key(p, c)) ?? null,
  SaveBoolean: (t, p, c, v) => t.set(key(p, c), v),
  SaveReal: (t, p, c, v) => t.set(key(p, c), v),
  SaveInteger: (t, p, c, v) => t.set(key(p, c), v),
  SaveUnitHandle: (t, p, c, v) => t.set(key(p, c), v),
  RemoveSavedBoolean: (t, p, c) => t.delete(key(p, c)),
  FlushChildHashtable(t, p) { for (const k of t.keys()) if (k.startsWith(`${p}:`)) t.delete(k); },
};
const context = vm.createContext(env);
for (const [source, name] of [[common, 'ExpansionAttemptStalled'], [common, 'TQAddJobEx'], [common, 'TQHandleOnce'], [common, 'ConstructExpansion'], [common, 'CheckExpansionRebuildAt'], [doubles, 'PreferExpansionClaimant'], [build, 'BuildExpansionJob']]) {
  vm.runInContext(compile(source, name), context);
}
const worker = { id: 1, alive: true };
const mine = { id: 2, alive: true, gold: 10000 };
const otherMine = { id: 3, alive: true, gold: 10000 };
const enqueue = () => env.TQAddJobEx(env.now, env.BUILD_EXPANSION, 0, worker, null, mine);
for (let i = 0; i < 100; i++) enqueue();
assert.equal(env.tq_length, 1, 'Repeated producers must not multiply pending jobs');
env.TQRemoveRoot = () => { env.tq_length--; };
env.TQDoJob = () => {
  assert.equal(env.LoadBoolean(env.expansion_job_pending, worker.id, mine.id), false);
  enqueue(); // Running job can schedule exactly one successor.
};
assert.equal(env.TQHandleOnce(), true);
assert.equal(env.tq_length, 1);
enqueue();
assert.equal(env.tq_length, 1);

assert.equal(env.ExpansionAttemptStalled(worker, mine, 1000, 2), false);
env.now = 119;
assert.equal(env.ExpansionAttemptStalled(worker, mine, 1000, 2), false);
env.now = 120;
assert.equal(env.ExpansionAttemptStalled(worker, mine, 1000, 2), true);
assert.equal(env.LoadReal(env.expansion_retry_cooldowns, mine.id, 0), 180);
env.now = 200;
env.ExpansionAttemptStalled(worker, mine, 1000, 2);
env.now = 319;
assert.equal(env.ExpansionAttemptStalled(worker, mine, 960, 2), false, 'Progress resets timeout');
env.now = 400;
assert.equal(env.ExpansionAttemptStalled(worker, mine, 960, 2), false);
assert.equal(env.ExpansionAttemptStalled(worker, otherMine, 1000, 2), false, 'New target resets timeout');
env.now = 519;
assert.equal(env.ExpansionAttemptStalled(worker, otherMine, 1000, 1), false, 'Transport phase resets timeout');
env.now = 639;
assert.equal(env.ExpansionAttemptStalled(worker, otherMine, 1000, 1), true, 'Stalled transport is bounded too');

const older = { id: 10, owner: 0, life: 100, maxLife: 1000 };
const newer = { id: 11, owner: 0, life: 500, maxLife: 1000 };
assert.equal(env.PreferExpansionClaimant(older, newer), true);
assert.equal(env.PreferExpansionClaimant(newer, older), false);
newer.life = 1000;
assert.equal(env.PreferExpansionClaimant(newer, older), true, 'Full-health hall wins');
newer.owner = 1;
newer.life = 500;
assert.equal(env.PreferExpansionClaimant(older, newer), true, 'Allies agree on player priority');
assert.equal(env.PreferExpansionClaimant(newer, older), false);

env.current_expansion = otherMine;
env.IssueImmediateOrder = () => assert.fail('Stale callback stopped a worker');
env.BuildExpansionJob(worker, mine);
assert.equal(env.current_expansion, otherMine, 'Stale callback must preserve the new mine');
env.current_expansion = mine;
env.IsExpansionRebuildCoolingDown = () => false;
env.DistanceBetweenUnits = () => 100;
env.GetExpansionMineClaimant = () => ({ owner: env.ai_player });
env.BuildExpansionJob(worker, mine);
assert.equal(env.LoadUnitHandle(env.expansion_retry_state, worker.id, 0), null, 'Foundation ends retry tracking');
env.GetExpansionMineClaimant = () => null;
env.racial_expansion = 1;
env.old_id = [0, 123];
env.GetUnitCurrentOrder = () => 123;
env.CreateDebugTagLoc = () => {};
env.GetUnitX = u => u.id * 100;
env.GetUnitY = () => 0;
let scheduled = 0;
env.TQAddUnit2Job = () => { scheduled++; };
env.IssueImmediateOrder = () => {};
env.now = 700;
env.BuildExpansionJob(worker, mine);
env.now = 819;
env.BuildExpansionJob(worker, mine);
assert.equal(scheduled, 2);
env.now = 820;
env.BuildExpansionJob(worker, mine);
assert.equal(scheduled, 2, 'Stalled worker stops rescheduling');
assert.equal(env.current_expansion, null);
assert.equal(env.LoadReal(env.expansion_retry_cooldowns, mine.id, 0), 880);

let probes = 0;
env.expansion_job_pending.clear();
env.ai_time = 100;
env.exp_loc_cache_timeout = 0;
env.exp_loc_cache = null;
env.exp_loc_cache_mine = null;
env.exp_loc_cache_id = 0;
env.race_max_expa_mine_distance = 500;
env.CreateUnit = () => { probes++; return { id: 99 }; };
env.Player = p => p;
env.PLAYER_NEUTRAL_PASSIVE = 15;
env.GetUnitLoc = u => ({ x: u.id * 100, y: 0 });
env.RemoveLocation = env.RemoveUnit = () => {};
env.IssuePointOrderByIdLoc = () => true;
env.current_expansion = mine;
env.ConstructExpansion(worker, 123);
env.current_expansion = otherMine;
env.ConstructExpansion(worker, 123);
env.ConstructExpansion(worker, 456);
assert.equal(probes, 3, 'Mine and hall changes invalidate placement cache');
env.SaveBoolean(env.expansion_job_pending, worker.id, otherMine.id, true);
env.ConstructExpansion(worker, 456);
assert.equal(probes, 3, 'Pending construction does not repeat placement work');

let scans = 0;
env.own_town_num = 0;
env.GetUnitGoldCost2 = () => 100;
env.CreateGroup = () => ({ units: [] });
env.GroupEnumUnitsInRange = () => { scans++; };
env.FirstOfGroup = g => g.units[0] ?? null;
env.DestroyGroup = () => {};
env.CheckExpansionTaken = () => assert.fail('Untouched rebuild site performed claim scans');
env.GetLocationCreepStrength = () => assert.fail('Untouched rebuild site performed creep scans');
assert.equal(env.CheckExpansionRebuildAt(mine), false);
assert.equal(scans, 1, 'Untouched rebuild site needs only one range scan');
// Early worker demand must follow an eligible expansion order, not site selection.
const expansion = {
  BUILT_ALL: 1, BUILT_SOME: 2, CANNOT_BUILD: 3, NOT_ENOUGH_RES: 4,
  racial_peon: 1, race_manual_loading: false, race_manual_loading_mine: 2,
  race_item_expansion_item_id: 0, ITEM_EXPANSION: 1,
  count: 1, done: 10, mines: 1, foe: null, cooldown: false, taken: false,
  relocating: false, town_threatened: false, current_expansion: mine,
  item_expanding: false, item_job_running: false,
  ancient_expanding: false, militia_expanding: false,
  expansion_peon: null, build_zeppelin: null, take_exp: false,
  pendingExpansionPeons: 0, total_gold: 100, total_wood: 100,
  TownCount: () => expansion.count, TownCountDone: () => expansion.done,
  GetMinesHarvested: () => expansion.mines, GetWood: () => 100,
  GetPeonBuilderShredderCount: () => 0,
  GetPeonTargetForMines: mines => mines * 10,
  GetUnitGoldCost2: () => 400, GetUnitWoodCost2: () => 200,
  IsExpansionRebuildCoolingDown: () => expansion.cooldown,
  CheckExpansionTaken: () => expansion.taken,
  GetExpFoe: () => expansion.foe,
  GetOwnStrength: () => 0, GetExpansionStrength: () => 100,
  BeginMineHallRelocation: () => expansion.relocating,
  far_expansion: null, race_uses_mine_expansion: false, old_id: { 3: 123 },
  GetExpansionPeon: () => worker, UnitAlive: u => Boolean(u?.alive),
  IsUnitInGroup: () => false, IsWaterExpansion: () => false,
  constructions: 0, ConstructExpansion() { expansion.constructions++; },
  Max: Math.max, Int2Str: String, Trace() {},
};
const expansionContext = vm.createContext(expansion);
for (const name of ['QueueExpansionPeonsIfNeeded', 'StartExpansionAM']) {
  vm.runInContext(compile(common, name), expansionContext);
}
for (const overrides of [
  { count: 2 }, { town_threatened: true }, { current_expansion: null },
  { cooldown: true }, { taken: true }, { foe: {} },
  { ancient_expanding: true }, { militia_expanding: true }, { relocating: true },
]) {
  const previous = Object.fromEntries(Object.keys(overrides).map(k => [k, expansion[k]]));
  Object.assign(expansion, overrides, { pendingExpansionPeons: 0, total_gold: 100, total_wood: 100 });
  expansion.StartExpansionAM(2, 3);
  assert.equal(expansion.pendingExpansionPeons, 0, `Blocked expansion queued peons: ${JSON.stringify(overrides)}`);
  Object.assign(expansion, previous, { current_expansion: mine });
}
expansion.total_gold = 100;
expansion.total_wood = 100;
assert.equal(expansion.StartExpansionAM(2, 3), expansion.NOT_ENOUGH_RES);
assert.equal(expansion.pendingExpansionPeons, 20, 'Cleared requested expansion pre-trains workers before hall resources are ready');
expansion.done = 5;
expansion.total_gold = 1000;
expansion.total_wood = 1000;
expansion.pendingExpansionPeons = 0;
assert.equal(expansion.StartExpansionAM(2, 3), expansion.BUILT_SOME);
assert.equal(expansion.pendingExpansionPeons, 20, 'Request extra workers while the expansion proceeds');
assert.equal(expansion.constructions, 1, 'An understaffed current mine must not block the expansion worker');
const expansionBuilder = common.match(/function ExpansionBuilder takes[\s\S]*?endfunction/)[0];
assert.ok(!expansionBuilder.includes('QueueExpansionPeonsIfNeeded'), 'Site selection must leave worker requests to eligible construction orders');
console.log('Expansion queue, timeouts, duplicate priority, stale callbacks, placement cache, rebuild scans, and early worker intent passed.');
