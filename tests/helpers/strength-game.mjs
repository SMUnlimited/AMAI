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
  const units = [], assaults = [], groups = new Set();
  const state = {
    ...groupNatives(groups), ai_player: 0, ai_time: 100, tier: 1,
    attacktable: new Map(), attack_length: 0, attack_units: [], old_id: zeros(),
    PLAYER_NEUTRAL_AGGRESSIVE: 12, unit_healing: new Set(),
    ver_hero_ultimate_level: 6, ver_hero_base_value: 5, ver_hero_ultimate_value: 3,
    UNIT_TYPE_SUMMONED: 'summoned', UNIT_TYPE_HERO: 'hero', UNIT_TYPE_PEON: 'peon',
    UNIT_TYPE_STRUCTURE: 'structure', UNIT_TYPE_ANCIENT: 'ancient',
    UNIT_TYPE_MELEE_ATTACKER: 'melee', UNIT_TYPE_RANGED_ATTACKER: 'ranged',
    UNIT_TYPE_ATTACKS_FLYING: 'attacksFlying', UNIT_TYPE_ATTACKS_GROUND: 'attacksGround',
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife',
    UnitAlive: u => u.alive, IsUnitHidden: u => u.hidden,
    IsUnitType: (u, type) => Boolean(u[type]), GetUnitTypeId: u => u.id,
    GetUnitLevel: u => u.level, GetHeroLevel: u => u.level, GetUnitFoodUsed: u => u.food,
    GetOwningPlayer: u => u.owner, Player: p => p, GetPlayerId: p => p,
    GetBJMaxPlayers: () => 12, GetPlayerHandicap: () => 1,
    GetUnitState: (u, field) => u[field],
    GroupEnumUnitsOfPlayer: (g, p) => units.filter(u => u.owner === p).forEach(u => g.add(u)),
    GetPlayerUnitTypeCount: (p, id) => units.filter(u => u.owner === p && u.id === id && u.alive).length,
    SaveBoolean: (table, parent, child, value) => table.set(parent + ':' + child, value),
    LoadBoolean: (table, parent, child) => table.get(parent + ':' + child) ?? false,
    FlushChildHashtable(table, parent) {
      for (const key of table.keys()) if (key.startsWith(parent + ':')) table.delete(key);
    },
    AddAssault: (count, id) => assaults.push(id),
    R2I: Math.trunc, I2R: Number, RMax: Math.max, SquareRoot: Math.sqrt,
    DisplayToAll(message) { throw new Error(message); },
  };
  for (const [, name, value] of source.matchAll(/^\s*constant integer ([ou]\w+)\s+= (.+)$/gm)) {
    state[name] = Number(expression(value.trim()));
  }
  const categories = [...source.matchAll(/^function GetPlayer(\w+)Strength takes player p returns real/gm)]
    .map(([, category]) => category).filter(category => category !== 'AntiAir');
  const names = ['GetHeroStrength', 'GetPlayerHeroBonusStrength', 'GetPlayerHeroStrengthMod',
    'GetUnitStrengthEx', 'IsUnitTower', 'GetPlayerStrengthHandicap', 'GetUnitStrength',
    'GetPlayerStrength', 'AttackGroupAddUnknown', ...categories.map(c => 'GetPlayer' + c + 'Strength')];
  vm.runInContext([...new Set(names)].map(name => compile(source, name)).join('\n'), vm.createContext(state));
  return {
    state, assaults, groups,
    addUnit(name, options = {}) {
      const id = state['o' + name] ?? Number(expression("'" + name + "'"));
      const unit = { id, owner: 0, alive: true, hidden: false, food: 0, level: 4,
        life: 100, maxLife: 100, attacksGround: true, ...options };
      units.push(unit);
      return unit;
    },
    counterStrength: () => Object.fromEntries(categories.map(c => [c, state['GetPlayer' + c + 'Strength'](0)])),
    strength: () => state.GetPlayerStrength(0),
    attack: () => state.AttackGroupAddUnknown(),
  };
}
