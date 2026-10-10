// Execute production JASS control flow with mocked Warcraft natives.
// Checks worker eligibility and reservation lifecycles, not in-game pathing.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';

const root = new URL('../../', import.meta.url);
const harvest = readFileSync(new URL('Jobs/HARVEST_CHECK.eai', root), 'utf8');
const militia = readFileSync(new URL('Jobs/MILITIA_CHECK.eai', root), 'utf8');
const common = readFileSync(new URL('common.eai', root), 'utf8');

export function compile(source, name) {
  const match = source.match(new RegExp(`function ${name} takes (.*?) returns \\w+([\\s\\S]*?)endfunction`));
  assert.ok(match, `Missing ${name}`);
  const parameters = match[1] === 'nothing' ? '' : match[1].split(',').map(p => p.trim().split(/\s+/)[1]).join(',');
  const body = match[2].split(/\r?\n/).map(line => line.replace(/\/\/.*$/, '').trim()).filter(Boolean).map(line => {
    if (line.startsWith('local ')) return line.replace(/^local \w+ /, 'let ');
    if (line.startsWith('elseif ')) return line.replace(/^elseif (.*) then$/, '} else if ($1) {');
    if (line.startsWith('if ')) return line.replace(/^if (.*) then$/, 'if ($1) {');
    if (line === 'else') return '} else {';
    if (line === 'endif' || line === 'endloop') return '}';
    if (line === 'loop') return 'while (true) {';
    if (line.startsWith('exitwhen ')) return `if (${line.slice(9)}) break`;
    if (/^(set|call) /.test(line)) return line.replace(/^(set|call) /, '');
    assert.match(line, /^return\b/, `Unsupported JASS: ${line}`);
    return line;
  }).join('\n').replace(/\band\b/g, '&&').replace(/\bor\b/g, '||').replace(/\bnot\b/g, '!');
  return `function ${name}(${parameters}) {\n${body}\n}`;
}

export function humanGame() {
  const peasants = Array.from({ length: 5 }, () => ({ callToArms: true, order: 852018 }));
  const state = {
    race_militia_available: true, race_militia_ability: 'Amil',
    militia_allowed: false, militia_check_enabled: true, militia_reserved_peons: new Set(),
    expansion_peon: null, militia_builder: null, early_remote_builders: new Set(),
    towerrush: false, race_tower_peon: 1, builder: [], harvestgrp: new Set(),
    militia_hall: { life: 1000 }, UNIT_STATE_LIFE: 'life', MILITIA_CHECK: 33,
    use_militia_only_on_bigger_threats: false, town_threat: [0], most_threatened_town: 0,
    race_militia_unitstring: 'militia', race_militiaworker_unitstring: 'peasant',
    race_militia_max_distance: 1500, ai_player: 0, home_location: {},
    current_expansion: {}, water_expansion: new Set(), old_id: [], racial_peon: 0,
    race_militia_id: 1, militia_expansion_chat: '', C_Done: 0,
    GetUnitAbilityLevel: u => u.callToArms ? 1 : 0,
    GetUnitCurrentOrder: u => u.order,
    IsUnitInGroup: (u, g) => g.has(u),
    IsStandardUnit: () => true, IsUnitBuying: () => false,
    OrderId: order => ({ harvest: 852018, repair: 852024, restoration: 852202, renew: 852161 })[order],
    CreateGroup: () => new Set(), DestroyGroup() {}, GroupClear: g => g.clear(),
    GroupAddUnit: (g, u) => g.add(u), GroupRemoveUnit: (g, u) => g.delete(u),
    FirstOfGroup: g => g.values().next().value ?? null,
    GroupEnumUnitsOfType(g, type) { if (type === 'peasant') peasants.forEach(u => g.add(u)); },
    SelectByPlayer: g => g, SelectByAlive: g => g,
    GetUnitState: (u, property) => u?.[property] ?? 0,
    GetMilitiaHall: () => null, GetUnitX: () => 0, GetUnitY: () => 0,
    GetUnitLoc: () => ({}), DistanceBetweenPoints_dk: () => 0,
    DistanceBetweenUnits: u => u.distance ?? 0,
    GetLocationNonCreepStrength: () => 0, Max: Math.max,
    UnitAddAbility: u => { u.callToArms = true; },
    UnitRemoveAbility: u => { u.callToArms = false; },
    DisplayToAllJobDebug() {}, TQAddJob() {}, IssueImmediateOrder() {},
    GetExpFoe: () => ({}),
    GroupEnumUnitsOfPlayer: g => peasants.forEach(u => g.add(u)),
    SelectNumberOfId: g => g,
    GetNearestSubGroupOfGroup: (g, location, count) => new Set([...g].slice(0, count)),
    GroupAddGroup: (target, units) => units.forEach(u => target.add(u)),
    CopyGroup: g => new Set(g), AreUnitsOfType: () => true,
    AddAbilityToGroup() {}, GroupImmediateOrder() {}, GroupPointOrder() {},
    DisplayToAlliesChat() {}, RemoveInjuries() {}, FromGroupAndGhoulsAM() {},
    AttackMoveKill() {}, Chat() {}, SleepInCombatAM() {}, Trace() {}, Sleep() {},
    SleepUntilTargetDeadAM() {},
  };
  const context = vm.createContext(state);
  for (const [source, name] of [
    ...['IsConstructionOrder', 'IsReservedHarvestPeon', 'IsPeonReadyToHarvest'].map(name => [harvest, name]),
    [militia, 'IsMilitiaAllowed'], [militia, 'MilitiaCheckJob'], [common, 'Militia_Expansion'],
  ]) {
    vm.runInContext(compile(source, name), context);
  }
  return {
    peasants, state,
    canAssignGold: peasant => state.IsPeonReadyToHarvest(peasant),
    checkDefense: () => state.MilitiaCheckJob(),
    runMission(count, duringMission = () => {}) {
      let reachedMission = false;
      state.SleepUntilTargetDeadAM = () => {
        reachedMission = true;
        duringMission();
      };
      state.Militia_Expansion(count);
      assert.ok(reachedMission, 'The scenario must reach the mission before checking its behavior');
    },
  };
}
