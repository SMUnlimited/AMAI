// Run from the repository root: node --test tests/build-recovery.mjs
// Execute the shared .eai queue/refresh/sleep functions; mock Warcraft production.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import vm from 'node:vm';
import { compile } from './helpers/jass.mjs';

const read = path => readFileSync(new URL(`../${path}`, import.meta.url), 'utf8');
const source = read('common.eai');
const names = ['SetBuildAllAMCore', 'SetBuildDependency', 'RefreshNeeded', 'SetBuildAllAM', 'AddRefresh',
  'RefreshAllNeeded', 'OneBuildLoopAM', 'BuildLoopAM', 'StaggerSleep', 'HealArmy'];
const extra = read('TFT/NeededExtra.txt').trim().split(/\r?\n/).slice(1)
  .map(row => row.split('\t'));
const extraIds = Object.fromEntries([...new Set(extra.flatMap(row => [row[0], row[3]]))]
  .map((name, index) => [`u${name}`, index + 100]));
// Expand the production dependency table before translating JASS.
const expanded = source.replace(/#INCLUDETABLE[^\n]+NeededExtra[^\n]*\n[\s\S]*?#ENDINCLUDE/g,
  extra.map(([id, type, qty, needed]) =>
    `if unitid == u${id} then\ncall SetBuildDependency(t, BUILD_${type}, ${qty}, u${needed}, -1, BLOC_STD, prio + prio_n_inc)\nendif`).join('\n'));
const script = new vm.Script(names.map(name => compile(expanded, name)).join('\n'));

test('Satisfied troops, research and items maintain missing infrastructure without requeueing themselves', () => {
  for (const type of [1, 2, 3]) {
    const s = state();
    s.needed1[1] = 2;
    s.counts[1] = s.upgrades[1] = s.items[1] = 3;
    s.SetBuildAllAM(type, 3, 1, -1, 0, 50);
    assert.deepEqual(queue(s), [[2, 1, 80]]);
    // The prerequisite is now under construction: do not request a second copy.
    s.counts[2] = 1;
    s.OneBuildLoopAM();
    assert.equal(s.build_length, 0);
    s.SetBuildAllAM(type, 3, 1, -1, 0, 50);
    assert.equal(s.build_length, 0);
  }
});

test('Unavailable neutrals, invalid requests and blocked quantities do not refresh dependencies', () => {
  const s = state();
  s.needed1[1] = 2;
  s.buy_type[1] = s.BT_RACIAL_ITEM + 1;
  s.counts[1] = 1;
  s.SetBuildAllAM(1, 1, 1, -1, 0, 50);
  assert.equal(s.build_length, 0);
  assert.equal(s.SetBuildAllAMCore(1, 0, 1, -1, 0, 50), false);
  assert.equal(s.SetBuildAllAMCore(1, 1, 0, -1, 0, 50), false);
  s.buy_type[1] = 0;
  s.BlockListCheck = () => 0;
  s.SetBuildAllAM(1, 1, 1, -1, 0, 50);
  assert.equal(s.build_length, 0);
});

test('Fulfilled and in-progress transformations do not request spare sources', () => {
  for (const fulfilled of [true, false]) {
    const s = state();
    s.needed1[1] = 2;
    s.needed3[1] = s.UPGRADED;
    s.counts[1] = fulfilled ? 2 : 0;
    s.available_time[1] = fulfilled ? 0 : s.ai_time + 1;
    s.SetBuildAllAM(1, 2, 1, -1, 0, 50);
    assert.equal(queue(s).some(([id]) => id === 2), false);
  }
});

test('Missing transformations preserve source counting, town, location and interlaced priorities', () => {
  const s = state();
  s.needed1[1] = 2;
  s.needed3[1] = s.UPGRADED;
  s.GetUnitCountAlt = () => -1;
  s.SetBuildAllAM(1, 3, 1, 2, 7, 50);
  assert.deepEqual(queue(s).filter(([id]) => id === 2), [[2, 1, 61], [2, 2, 59]]);
  for (let i = 0; i < s.build_length; i++) {
    assert.equal(s.build_town[i], 2);
    assert.equal(s.build_loc[i], 7);
  }
});

test('Resource and construction failures refresh dependencies after unlocking and preserve waiting priority', () => {
  for (const ret of [1, 2]) {
    const s = state();
    s.SetBuildAllAMCore(1, 1, 1, -1, 0, 50);
    s.needed1[1] = 2; // Building was lost after the request entered the queue.
    s.results[1] = ret;
    s.OneBuildLoopAM();
    assert.equal(s.t_build_length, 1);
    assert.deepEqual(queue(s), [[2, 1, 80], [1, 1, 51]]);
    assert.equal(s.build_lock, true);
    assert.ok(s.refreshLocks.every(Boolean));
    s.OneBuildLoopAM();
    assert.equal(queue(s).filter(([id]) => id === 2).length, 1);
  }
});

test('Empty queues and the final available slot never write beyond capacity', () => {
  const single = state(1);
  assert.equal(single.SetBuildAllAMCore(1, 1, 1, -1, 0, 50), true);
  assert.deepEqual(queue(single), [[1, 1, 50]]);
  const s = state(3);
  for (let id = 1; id <= 3; id++) {
    assert.equal(s.SetBuildAllAMCore(1, 1, id, -1, 0, id * 10), true);
  }
  assert.equal(s.build_length, 3);
  assert.deepEqual(queue(s), [[3, 1, 30], [2, 1, 20], [1, 1, 10]]);
  const before = queue(s);
  assert.equal(s.SetBuildAllAMCore(1, 1, 4, -1, 0, 40), false);
  assert.deepEqual(queue(s), before);
  assert.equal(s.build_lock, true);
  assert.equal(s.SetBuildAllAMCore(1, 1, 2, -1, 0, 20), true);
  assert.deepEqual(queue(s), before);
});

test('Capacity is checked after acquiring the lock, including recursive quantity insertion', () => {
  const s = state(2);
  s.onLock = () => { s.build_length = 2; s.onLock = null; };
  assert.equal(s.SetBuildAllAMCore(1, 1, 1, -1, 0, 50), false);
  assert.equal(s.build_lock, true);
  const recursive = state(2);
  assert.equal(recursive.SetBuildAllAMCore(1, 4, 1, -1, 0, 50), true);
  assert.deepEqual(queue(recursive), [[1, 3, 52], [1, 4, 50]]);
  assert.equal(recursive.build_lock, true);
});

test('Repeated refreshes against a full queue remain bounded and retry when space returns', () => {
  const s = state(2);
  s.SetBuildAllAMCore(1, 1, 3, -1, 0, 100);
  s.SetBuildAllAMCore(1, 1, 4, -1, 0, 100);
  s.counts[1] = 1;
  s.needed1[1] = 2;
  const before = queue(s);
  for (let i = 0; i < 20; i++) s.SetBuildAllAM(1, 1, 1, -1, 0, 50);
  assert.deepEqual(queue(s), before);
  assert.equal(s.build_lock, true);
  s.build_length = 0;
  s.SetBuildAllAM(1, 1, 1, -1, 0, 50);
  assert.deepEqual(queue(s), [[2, 1, 80]]);
});

test('Refresh scratch queue also respects its capacity', () => {
  const s = state(2);
  for (let i = 0; i < 3; i++) s.AddRefresh(1, 1, i + 1, -1, 0, 50);
  assert.equal(s.t_build_length, 2);
});

test('StaggerSleep has identical bounds for all 24 slots, with a positive zero-base delay', () => {
  const s = state();
  for (let slot = 0; slot < 24; slot++) {
    s.GetAiPlayer = () => slot;
    s.GetPlayers = () => 24;
    for (const fraction of [0, 0.5, 1]) {
      s.GetRandomReal = (low, high) => low + (high - low) * fraction;
      s.StaggerSleep(5, 6);
      assert.equal(s.slept, 5 + 6 * fraction);
      s.StaggerSleep(0, 2);
      assert.equal(s.slept, Math.max(0.05, 2 * fraction));
    }
  }
});

test('Build polling uses the tuned interval and respects custom AI-count multipliers', () => {
  for (const multiplier of [0.8, 1, 2.9, 3.1, 10]) {
    for (const fraction of [0, 0.5, 1]) {
      const s = state();
      s.sleep_multiplier = multiplier;
      s.GetRandomReal = (low, high) => low + (high - low) * fraction;
      const stopped = new Error('Stop after the first recurring sleep');
      let sleeps = 0;
      s.Sleep = seconds => {
        if (++sleeps === 2) { s.slept = seconds; throw stopped; }
      };
      assert.throws(() => s.BuildLoopAM(), error => error === stopped);
      assert.equal(s.slept, 2 * multiplier + multiplier * fraction);
      if (multiplier <= 3.1) assert.ok(s.slept > 0 && s.slept <= 10);
    }
  }
});

test('Every staggered caller remains within ten seconds at shipped AI-count settings', () => {
  const s = state();
  const calls = [...`${source}\n${read('races.eai')}`.matchAll(/^\s*call (StaggerSleep\(.+\))/gm)];
  assert.ok(calls.length > 10);
  const multipliers = [0.8, 1, ...['ROC', 'TFT', 'REFORGED'].map(version =>
    Number(read(`${version}/GlobalSettings.txt`).match(/^slm_end_mult\t([^\t]+)/m)[1]) + 0.2)];
  for (const multiplier of multipliers) {
    s.sleep_multiplier = multiplier;
    for (const [_, call] of calls) {
      const values = [];
      for (const fraction of [0, 0.5, 1]) {
        s.GetRandomReal = (low, high) => low + (high - low) * fraction;
        new vm.Script(call).runInContext(vm.createContext(s));
        assert.ok(s.slept > 0 && s.slept <= 10, `${call}: ${s.slept}`);
        values.push(s.slept);
      }
      assert.ok(values[2] > values[0], `Staggering collapsed: ${call}`);
    }
  }
});

test('StaggerSleep remains a general helper without an upper limit', () => {
  const s = state();
  s.GetRandomReal = (low, high) => high;
  s.StaggerSleep(25, 5);
  assert.equal(s.slept, 30);
});

test('Healing preserves effect duration without AI throttling and responds to attacks within two seconds', () => {
  for (const [global, duration] of [[false, 10], [true, 25]]) {
    for (const attacked of [false, true]) {
      const s = state();
      Object.assign(s, {
        sleep_multiplier: 10, urgent_healing_count: 4, medium_healing_count: 0,
        ver_heroes: true, town_threatened: false,
        GetArmyHealthState: () => 0.5, CaptainIsHome: () => true,
        GetMassHealingItem: () => global ? 0 : 1,
        GetMerchantMassHealingItem: () => 0, GetGlobalHealingItem: () => 1,
        GetItemOfType: () => ({}), GetItemHero: () => ({}),
      });
      let elapsed = 0;
      let applied = 0;
      s.ApplyMassHealingItem = s.ApplyGlobalItem = () => { applied++; };
      s.Sleep = seconds => {
        assert.ok(seconds > 0 && seconds <= 2);
        elapsed += seconds;
        if (attacked || elapsed >= duration) s.town_threatened = true;
      };
      s.HealArmy();
      assert.equal(elapsed, attacked ? 2 : duration);
      assert.equal(applied, 1);
    }
  }
});

function queue(s) {
  return Array.from({ length: s.build_length }, (_, i) =>
    [s.build_item[i], s.build_qty[i], s.build_prio[i]]);
}

function zeros(capacity = Infinity) {
  return new Proxy({}, {
    get: (target, key) => target[key] ?? 0,
    set(target, key, value) {
      assert.ok(Number.isInteger(Number(key)) && Number(key) >= 0 && Number(key) < capacity,
        `Array write outside capacity: ${key} / ${capacity}`);
      target[key] = value;
      return true;
    },
  });
}

function state(capacity = 32) {
  const s = {
    ...extraIds, BUILD_UNIT: 1, BUILD_ADAPTIVE: 5, BUILD_ADAPTIVE_UPGRADE: 6, BUILD_UPGRADE: 2, BUILD_ITEM: 3, BUILD_EXPAND: 4,
    BUILT_ALL: 0, NOT_ENOUGH_RES: 1, CANNOT_BUILD: 2, BUILT_SOME: 3,
    BT_RACIAL_ITEM: 5, BT_ML_UPGRADE: 6, BT_HERO: 3, BT_NEUTRAL_HERO: 7,
    UPGRADED: -1, BLOC_STD: 0, JASS_MAX_ARRAY_SIZE: capacity,
    build_length: 0, t_build_length: 0, building_length: 0, build_lock: true,
    prio_q_inc: 2, prio_n_inc: 10, prio_t_inc: 1, ai_time: 10,
    gold_buffer: 0, wood_buffer: 0, ver_food_limit: 100, water_expansion_list_length: 0,
    campaign_ai: true, tier: 1, OBJECT_NUM: 1000, slept: 0, refreshLocks: [],
    player_defeated: false, build_array_reset_time: 100, sleep_multiplier: 1,
    counts: zeros(), upgrades: zeros(), items: zeros(), results: zeros(),
    zeros, Max: Math.max, Min: Math.min, RMax: Math.max, RMin: Math.min,
    Int2Str: String, Real2Str: String, I2R: Number,
    BlockListCheck: qty => qty, RBlockListCheck: qty => qty, RefreshAdaptiveReservation() {}, BuildAdaptiveReinforcements() {},
    Get_f_qty: () => 1, GetUnitCountAlt: () => 0, GetNeutralNumber: id => id,
    GetGold: () => 100, GetWood: () => 100, FoodUsed: () => 0,
    IsRacialHallId: () => false, IsUnitIdType: () => false,
    UNIT_TYPE_STRUCTURE: 1, ModuloInteger: (a, b) => a % b,
  };
  for (const prefix of ['build', 't_build']) {
    for (const suffix of ['qty', 'type', 'item', 'town', 'loc', 'prio']) {
      s[`${prefix}_${suffix}`] = zeros(capacity);
    }
  }
  for (const name of ['old_id', 'buy_type', 'needed1', 'needed2', 'needed3',
    'neutral_available', 'available_time', 'hero', 'hero_built', 'unitNames',
    'bl_tier_lockactive', 'bl_tier_expansionblock', 'bl_tier_unitlock', 'bl_tier_foodlock']) {
    s[name] = zeros();
  }
  for (const name of ['InitLastUpkeep', 'TimeKeeper', 'SetBuildFree', 'FarmBuilder',
    'PeonBuilder', 'ExpansionBuilder', 'HeroReviver', 'CheckUpkeepAllowed',
    'ResetUpkeepSaveTime', 'FactoryNumberUpdate', 'Trace']) s[name] = () => {};
  Object.assign(s, {
    TownCountTown: id => s.counts[id], GetUpgradeLevel: id => s.upgrades[id],
    GetItemNumber: id => s.items[id], Sleep: seconds => { s.slept = seconds; },
    GetBuildLock: () => {
      assert.equal(s.build_lock, true);
      s.onLock?.();
      s.build_lock = false;
    },
    ReleaseBuildLock: () => { assert.equal(s.build_lock, false); s.build_lock = true; },
    StartUnitAM: (qty, id) => s.counts[id] >= qty ? s.BUILT_ALL : s.results[id],
  });
  // These scenarios use identity runtime IDs.
  for (let id = 0; id < 200; id++) s.old_id[id] = id;
  script.runInContext(vm.createContext(s));
  const refresh = s.RefreshNeeded;
  s.RefreshNeeded = (...args) => { s.refreshLocks.push(s.build_lock); return refresh(...args); };
  return s;
}
