import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import vm from 'node:vm';
import { compile, expression, zeros } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const sources = new Map();
export function compiledCommon(version) {
  if (!sources.has(version)) {
    const result = spawnSync('perl', ['ejass.pl', 'common.eai', version, 'VER:' + version], {
      cwd: fileURLToPath(new URL('../../', import.meta.url)), encoding: 'utf8', maxBuffer: 32 * 1024 * 1024,
      env: { ...process.env, LC_ALL: 'C', LC_CTYPE: 'C', LANG: 'C' },
    });
    assert.equal(result.error, undefined);
    assert.equal(result.status, 0, result.stderr);
    sources.set(version, result.stdout);
  }
  return sources.get(version);
}

export function strengthGame(version) {
  const source = compiledCommon(version);
  const units = [], assaults = [], assaultRequests = [], merges = [], messages = [], groups = new Set();
  const state = {
    ...groupNatives(groups), ai_player: 0, ai_time: 100, tier: 1,
    attacktable: new Map(), attack_length: 0, attack_units: [], old_id: zeros(),
    PLAYER_NEUTRAL_AGGRESSIVE: 12, unit_healing: new Set(),
    ver_hero_base_value: 2,
    racial_ghoul: 0, racial_rushcreep: 0, harvesting_ghouls: 0,
    br_rush_attacked: false, ancient_expanding: false,
    attack_max: [], take_all_ghouls_along: false, attacking_ghouls: 0,
    minimum_peon_wood: 200, towerrush: false,
    desperation_assault: false, player_defeated: false, CUSTOM_ATTACK: 1,
    assaultSucceeds: true, unit_harassing: new Set(), RecycleGuardPosition() {},
    race_has_ghouls: false, race_ghouls_attack: false, distraction_group: 0,
    DoAttackJobs() {}, AttackMoveKill() {}, ReformUntilTargetDeadAM() {},
    Chat() {}, C_Done: 0, SleepInCombatAM() {},
    GetWood: () => 0, GetUpgradeLevel: () => 0,
    IsStandardUnit: u => !u.healing, IsUnitBuying: u => Boolean(u.buying),
    Min: Math.min, Max: Math.max, Trace() {}, Int2Str: String, Sleep() {},
    InitAssault() { assaults.length = 0; assaultRequests.length = 0; },
    MergeUnits: (count, a, b, id) => merges.push({ count, a, b, id }),
    UNIT_TYPE_SUMMONED: 'summoned', UNIT_TYPE_HERO: 'hero', UNIT_TYPE_PEON: 'peon',
    UNIT_TYPE_STRUCTURE: 'structure', UNIT_TYPE_ANCIENT: 'ancient',
    UNIT_TYPE_MELEE_ATTACKER: 'melee', UNIT_TYPE_RANGED_ATTACKER: 'ranged',
    UNIT_TYPE_ATTACKS_FLYING: 'attacksFlying', UNIT_TYPE_ATTACKS_GROUND: 'attacksGround',
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife',
    UNIT_STATE_MANA: 'mana', UNIT_STATE_MAX_MANA: 'maxMana',
    UnitAlive: u => u.alive, IsUnitHidden: u => u.hidden,
    IsUnitType: (u, type) => Boolean(u[type]), GetUnitTypeId: u => u.id,
    GetUnitLevel: u => u.level, GetHeroLevel: u => u.level, GetUnitFoodUsed: u => u.food,
    GetUnitAbilityLevel: (u, ability) => u.abilities[ability] ?? 0,
    TownCountDone: () => 0,
    GetOwningPlayer: u => u.owner, Player: p => p, GetPlayerId: p => p,
    GetBJMaxPlayers: () => 12, GetPlayerHandicap: () => 1,
    GetUnitState: (u, field) => u[field],
    GroupEnumUnitsOfPlayer: (g, p) => units.filter(u => u.owner === p).forEach(u => g.add(u)),
    GetPlayerUnitTypeCount: (p, id) => units.filter(u => u.owner === p && u.id === id && u.alive).length,
    SaveBoolean: (table, parent, child, value) => table.set(parent + ':' + child, value),
    LoadBoolean: (table, parent, child) => table.get(parent + ':' + child) ?? false,
    SaveInteger: (table, parent, child, value) => table.set(parent + ':' + child, value),
    LoadInteger: (table, parent, child) => table.get(parent + ':' + child) ?? 0,
    FlushChildHashtable(table, parent) {
      for (const key of table.keys()) if (key.startsWith(parent + ':')) table.delete(key);
    },
    AddAssault(count, id) {
      assaults.push(id);
      assaultRequests.push({ count, id });
      return state.assaultSucceeds;
    },
    R2I: Math.trunc, I2R: Number, RMax: Math.max, RMin: Math.min, SquareRoot: Math.sqrt,
    DisplayToAll: message => messages.push(message),
  };
  for (const [, name, value] of source.matchAll(/^\s*constant integer ([ou]\w+)\s+= (.+)$/gm)) {
    state[name] = Number(expression(value.trim()));
  }
  for (const [, name, value] of source.matchAll(/^\s*constant integer (\w+)\s+= ('[^']{4}')\s*$/gm)) {
    state[name] = Number(expression(value));
  }
  const categories = [...source.matchAll(/^function GetPlayer(\w+)Strength takes player p returns real/gm)]
    .map(([, category]) => category).filter(category => category !== 'AntiAir');
  const names = ['GetHeroAbilityStrength', 'GetHeroStrength', 'GetPlayerHeroStrengthMod',
    'GetUnitStrengthEx', 'IsUnitTower', 'GetPlayerStrengthHandicap', 'GetUnitStrength',
    'GetPlayerStrength', 'GetOwnStrength', 'AttackGroupAddUnknown', 'ConversionsAM',
    'InitAssaultAM', 'AddAssaultAM', 'GroupRecycleHarrassPositionInstant',
    'DesperationAssault', 'FormGroupAM', 'FromGroupAndGhoulsAM', 'AttackMoveKillAAM',
    ...categories.map(c => 'GetPlayer' + c + 'Strength')];
  vm.runInContext([...new Set(names)].map(name => compile(source, name)).join('\n'), vm.createContext(state));
  return {
    state, assaults, assaultRequests, merges, messages, groups,
    addUnit(name, options = {}) {
      const id = state['o' + name] ?? Number(expression("'" + name + "'"));
      const unit = { id, owner: 0, alive: true, hidden: false, food: 0, level: 4,
        life: 100, maxLife: 100, mana: 100, maxMana: 100, abilities: {}, attacksGround: true, ...options };
      units.push(unit);
      return unit;
    },
    counterStrength: () => Object.fromEntries(categories.map(c => [c, state['GetPlayer' + c + 'Strength'](0)])),
    strength: () => state.GetPlayerStrength(0),
    ownStrength: () => state.GetOwnStrength(),
    learnSkill(hero, name, rank = 1) {
      assert.ok(state[name], 'Unknown ability ' + name + ' in ' + version);
      hero.abilities[state[name]] = rank;
    },
    attack: () => state.AttackGroupAddUnknown(),
    reinforce: () => state.DesperationAssault(),
    returnFromHarassment(...troops) {
      const group = state.CreateGroup();
      for (const unit of troops) state.GroupAddUnit(group, unit);
      state.GroupRecycleHarrassPositionInstant(group);
    },
    startAttack: target => state.AttackMoveKillAAM(target, true),
    formArmy(name, maximum = 60) {
      const id = state['u' + name];
      assert.ok(id, 'Unknown army unit ' + name);
      state.racial_ghoul = state.uGHOUL;
      state.old_id[id] = state['o' + name];
      state.attack_units = [id];
      state.attack_max = [maximum];
      state.attack_length = 1;
      state.TownCountDone = unitid => units.filter(u => u.id === state.old_id[unitid] && u.alive).length;
      state.FormGroupAM(0);
    },
  };
}
