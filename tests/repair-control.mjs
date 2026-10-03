// Run from the repository root: node --test tests/repair-control.mjs
// Scenarios supply worker/resource counts and expect repairs to be enabled or disabled.
// This executes the real .eai policy, but does not simulate Warcraft movement or combat.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import vm from 'node:vm';

const read = path => readFileSync(new URL(`../${path}`, import.meta.url), 'utf8');
const source = read('Jobs/REPAIR_CONTROL.eai');
const script = compileRepairPolicy();

// Worker limits: exact minimum succeeds; one worker below it fails.
for (const [race, flags, normalWorkers, emergencyWorkers] of [
  ['Human', {}, 6, 3],
  ['Orc', {}, 6, 3],
  ['Undead', { race_has_ghouls: true }, 5, 3],
  ['Night Elf', { race_manual_loading: true }, 6, 6],
]) {
  test(`${race}: normal repairs need ${normalWorkers} workers, 150 gold and 75 lumber`, () => {
    assert.equal(policy({ ...flags, peons: normalWorkers, gold: 150, wood: 75 })(), true);
    assert.equal(policy({ ...flags, peons: normalWorkers - 1, gold: 150, wood: 75 })(), false);
  });
  test(`${race}: emergency repairs need ${emergencyWorkers} workers, 50 gold and 20 lumber`, () => {
    const economy = { ...flags, town_threatened: true, gold: 50, wood: 20 };
    assert.equal(policy({ ...economy, peons: emergencyWorkers })(), true);
    assert.equal(policy({ ...economy, peons: emergencyWorkers - 1, repair_enabled: true })(), false);
  });
}

// Independent cases start fresh. repair_enabled means repairs were already on.
for (const [name, economy, expected] of [
  ['Normal repairs cannot start with 149 gold', { gold: 149 }, false],
  ['Normal repairs cannot start with 74 lumber', { wood: 74 }, false],
  ['Normal repairs stay on at 100 gold and 50 lumber', { repair_enabled: true, gold: 100, wood: 50 }, true],
  ['Normal repairs stop below 100 gold', { repair_enabled: true, gold: 99 }, false],
  ['Normal repairs stop below 50 lumber', { repair_enabled: true, wood: 49 }, false],
  ['Emergency repairs cannot start with 49 gold', { town_threatened: true, gold: 49 }, false],
  ['Emergency repairs cannot start with 19 lumber', { town_threatened: true, wood: 19 }, false],
  ['Emergency repairs stay on at 25 gold and 10 lumber', { town_threatened: true, repair_enabled: true, gold: 25, wood: 10 }, true],
  ['Emergency repairs stop below 25 gold', { town_threatened: true, repair_enabled: true, gold: 24 }, false],
  ['Emergency repairs stop below 10 lumber', { town_threatened: true, repair_enabled: true, wood: 9 }, false],
  ['No gold means no emergency repairs', { town_threatened: true, gold: 0 }, false],
  ['No lumber means no emergency repairs', { town_threatened: true, wood: 0 }, false],
  ['Normal repairs respect reserved gold', { gold_buffer: 1 }, false],
  ['Normal repairs respect reserved lumber', { wood_buffer: 1 }, false],
  ['Resources after reserves meet the normal minimum', { gold: 200, wood: 100, gold_buffer: 50, wood_buffer: 25 }, true],
  ['Reserves exceed the stockpile', { gold_buffer: 200, wood_buffer: 100 }, false],
  ['Emergency repairs can spend reserved resources', { town_threatened: true, gold: 50, wood: 20, gold_buffer: 200, wood_buffer: 100 }, true],
  ['Native threat detection enables emergency repairs', { nativeThreat: true, peons: 3, gold: 50, wood: 20 }, true],
  ['Tower rushes immediately disable repairs', { towerrush: true, repair_enabled: true }, false],
  ['Night Elf worker minimum follows mine capacity', { race_manual_loading: true, ver_optimal_gold: 6, peons: 6, town_threatened: true }, false],
  ['Undead worker minimum follows mine capacity', { race_has_ghouls: true, ver_optimal_gold: 4, peons: 4 }, true],
  ['Custom stop thresholds use integer rounding', { repair_enabled: true, gold: 101, wood: 50, repair_gold_threshold: 152 }, true],
]) {
  test(name, () => assert.equal(policy(economy)(), expected));
}

test('Undead attack: repair, run low, recover, then return to the normal budget', () => {
  const update = policy({ race_has_ghouls: true, peons: 5 });
  // Each row gives all changing inputs; only the previous repair state carries forward.
  for (const [stage, threatened, gold, wood, expected] of [
    ['Before attack: save resources', false, 80, 30, false],
    ['Attack detected: start repairs', true, 80, 30, true],
    ['Resources fall: keep repairing at the stop boundary', true, 25, 10, true],
    ['Gold too low: stop repairs', true, 24, 10, false],
    ['Partial recovery: wait for the restart budget', true, 49, 20, false],
    ['Budget recovered: restart repairs', true, 50, 20, true],
    ['Attack ends: normal budget applies', false, 50, 20, false],
  ]) {
    assert.equal(update({ town_threatened: threatened, gold, wood }), expected, stage);
  }
});

test('Ending a tower rush requires the full emergency restart budget', () => {
  const update = policy({ race_has_ghouls: true, peons: 3, town_threatened: true, wood: 20 });
  assert.equal(update({ towerrush: true, gold: 50 }), false, 'During tower rush');
  assert.equal(update({ towerrush: false, gold: 49 }), false, 'Rush ended but gold is insufficient');
  assert.equal(update({ towerrush: false, gold: 50 }), true, 'Full restart budget recovered');
});

for (const version of ['REFORGED', 'TFT', 'ROC']) {
  const settings = read(`${version}/GlobalSettings.txt`);
  for (const [key, value] of Object.entries({
    repair_threshold: 6, repair_threshold_threatened: 3,
    repair_gold_threshold: 150, repair_wood_threshold: 75,
    repair_gold_threshold_threatened: 50, repair_wood_threshold_threatened: 20,
  })) {
    assert.match(settings, new RegExp(`^${key}\\t${value}\\t`, 'm'));
    assert.match(read('common.eai'), new RegExp(`integer ${key} = ${value}\\b`));
  }
}
assert.match(read('Jobs.txt'), /^REPAIR_CONTROL\t5\t/m);
assert.match(source, /TQAddJob\(5, REPAIR_CONTROL, 0\)/);
for (const path of ['Jobs/TOWER_RUSH.eai', 'Jobs/TOWER_RUSH_CHECK.eai']) {
  assert.match(read(path), /call UpdateRepairControl\(\)/);
  assert.doesNotMatch(read(path), /call SetPeonsRepair\(/);
}
const harvestBody = read('Jobs/HARVEST_CHECK.eai').match(/function IsPeonReadyToHarvest[^\n]*\n\s*return ([^\r\n]+)/)[1];
const harvestScript = new vm.Script(expression(harvestBody).replace(/\bnot\b/g, '!'));
const orders = { repair: 1, restoration: 2, renew: 3, harvest: 4 };
for (const [order, expected] of [['repair', false], ['restoration', false], ['renew', false], ['harvest', true], ['idle', true]]) {
  const context = vm.createContext({
    peon: {}, harvestgrp: {},
    IsReservedHarvestPeon: () => false, IsConstructionOrder: () => false,
    GetUnitCurrentOrder: () => orders[order] ?? 0, OrderId: name => orders[name],
    IsStandardUnit: () => true, IsUnitBuying: () => false, IsUnitInGroup: () => false,
  });
  test(`Worker using ${order} ${expected ? 'can' : 'cannot'} be reassigned to mining`, () => {
    assert.equal(harvestScript.runInContext(context), expected);
  });
}

// Simulation plumbing: translate the real JASS policy and mock Warcraft natives.
// Read the scenarios above first; this section only makes them executable in Node.
function expression(value) {
  return value.replace(/\band\b/g, '&&').replace(/\bor\b/g, '||');
}

function compileRepairPolicy() {
  const body = source.match(/function UpdateRepairControl takes nothing returns nothing\s+([\s\S]*?)endfunction/)[1];
  const integers = new Set();
  
  // Translate only the statement forms used by this policy; reject unfamiliar syntax.
  const translated = body.split(/\r?\n/).map(raw => {
    const line = raw.replace(/\/\/.*$/, '').trim();
    if (!line) return '';
    let match;
    if ((match = line.match(/^local (integer|boolean) (\w+) = (.+)$/))) {
      if (match[1] === 'integer') integers.add(match[2]);
      return `let ${match[2]} = ${expression(match[3])};`;
    }
    if ((match = line.match(/^set (\w+) = (.+)$/))) {
      const value = expression(match[2]);
      return `${match[1]} = ${integers.has(match[1]) ? `Math.trunc(${value})` : value};`;
    }
    if ((match = line.match(/^if (.+) then$/))) return `if (${expression(match[1])}) {`;
    if ((match = line.match(/^elseif (.+) then$/))) return `} else if (${expression(match[1])}) {`;
    if (line === 'else') return '} else {';
    if (line === 'endif') return '}';
    if ((match = line.match(/^call (\w+\(.*\))$/))) return `${match[1]};`;
    throw new Error(`Unsupported JASS: ${line}`);
  }).join('\n');
  return new vm.Script(`function update() { ${translated} } update();`);
}

function policy(overrides = {}) {
  const state = {
    peons: 6, gold: 150, wood: 75, nativeThreat: false,
    town_threatened: false, towerrush: false, repair_enabled: false,
    race_has_ghouls: false, race_manual_loading: false, ver_optimal_gold: 5,
    repair_threshold: 6, repair_threshold_threatened: 3,
    repair_gold_threshold: 150, repair_wood_threshold: 75,
    repair_gold_threshold_threatened: 50, repair_wood_threshold_threatened: 20,
    gold_buffer: 0, wood_buffer: 0, racial_peon: 1,
    Min: Math.min, Max: Math.max, ...overrides,
  };
  Object.assign(state, {
    TownCountDone: () => state.peons, TownThreatened: () => state.nativeThreat,
    GetGold: () => state.gold, GetWood: () => state.wood,
    SetPeonsRepair: enabled => { state.nativeEnabled = enabled; },
  });
  const context = vm.createContext(state);
  return (changes = {}) => {
    Object.assign(state, changes);
    script.runInContext(context);
    assert.equal(state.nativeEnabled, state.repair_enabled);
    return state.nativeEnabled;
  };
}

