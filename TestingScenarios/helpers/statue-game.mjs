// Execute production JASS; mocks cannot verify Warcraft captain control or pathing.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';

const root = new URL('../../', import.meta.url);
function compile(file, name) {
  const source = readFileSync(new URL(file, root), 'utf8');
  const match = source.match(new RegExp(`function ${name} takes (.*?) returns \\w+([\\s\\S]*?)endfunction`));
  assert.ok(match, `Missing ${name}`);
  const args = match[1] === 'nothing' ? '' : match[1].split(',').map(p => p.trim().split(/\s+/)[1]).join(',');
  const body = match[2].split(/\r?\n/).map(line => line.replace(/\/\/.*$/, '').trim()).filter(Boolean).map(line => {
    if (/^local /.test(line)) return line.replace(/^local \w+ /, 'let ');
    if (/^elseif /.test(line)) return line.replace(/^elseif (.*?)\s*then$/, '} else if ($1) {');
    if (/^if /.test(line)) return line.replace(/^if (.*?)\s*then$/, 'if ($1) {');
    if (line === 'else') return '} else {';
    if (line === 'endif' || line === 'endloop') return '}';
    if (line === 'loop') return 'while (true) {';
    if (/^exitwhen /.test(line)) return `if (${line.slice(9)}) break`;
    if (/^(set|call) /.test(line)) return line.replace(/^(set|call) /, '');
    assert.match(line, /^return\b/, `Unsupported JASS: ${line}`);
    return line;
  }).join('\n').replace(/\band\b/g, '&&').replace(/\bor\b/g, '||').replace(/\bnot\b/g, '!');
  return `function ${name}(${args}) {\n${body}\n}`;
}

export function undeadGame() {
  const statue = { x: 4000, y: 4000, owner: 0, strength: 1, mechanical: true, order: 'attack' };
  const hero = { x: 4000, y: 4000, owner: 0, strength: 10, life: 50 };
  const enemy = { x: 4500, y: 4000, owner: 1, strength: 2, attacksGround: true };
  const units = [statue, hero, enemy];
  const orders = [];
  const locations = new Set();
  const state = {
    major_hero: hero, main_army: 0, army_loc: [{ x: 4000, y: 4000 }], army_strength: [11],
    ai_player: 0, PLAYER_NEUTRAL_AGGRESSIVE: 12, UNIT_TYPE_STRUCTURE: 'structure',
    UNIT_TYPE_MECHANICAL: 'mechanical', UNIT_TYPE_PEON: 'peon', UNIT_TYPE_ATTACKS_GROUND: 'attacksGround',
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife', UNIT_STATE_MANA: 'mana', UNIT_STATE_MAX_MANA: 'maxMana',
    unit_rescueing: new Set(), unit_harassing: new Set(), unit_zepplin_move: new Set(),
    unit_buying_item: new Set(), unit_buying_merc: new Set(), unit_buying_tavern: new Set(),
    unit_healing: new Set(), battle_radius: 1500, normal_battle_radius: 1500, creep_battle_radius: 750,
    statue_distance: 300, retreat_controlled: true, attack_running: true, isfleeing: false,
    canflee: false, retreat_group_refreshed: false, town_threatened: false, town_threat_break: false,
    player_defeated: false, ancient_expanding: false, ancient_attack_running: false,
    br_rush_attacked: false, desperation_assault: false, sleep_multiplier: 1, RETREAT_CONTROL: 1,
    ally_loc: { x: 0, y: 0 }, last_ally_loc: { x: 0, y: 0 },
    enemy_loc: { x: 0, y: 0 }, last_enemy_loc: { x: 0, y: 0 },
    inCombat: true, bj_PI: Math.PI,
    Player: p => p, GetOwningPlayer: u => u.owner,
    IsPlayerAlly: (a, b) => a === b || a === 2, IsPlayerEnemy: (a, b) => a !== b && a !== 2,
    UnitAlive: u => Boolean(u) && (u.life ?? 100) > 0, IsUnitHidden: u => Boolean(u.hidden), IsUnitInvisibleAM: u => Boolean(u.invisible),
    IsUnitVisible: u => u.visible !== false, UnitIsSleeping: u => Boolean(u.sleeping), IsUnitType: (u, type) => Boolean(u[type]),
    GetUnitState: (u, property) => u[property] ?? (property === 'life' || property === 'maxLife' ? 100 : 0),
    GetUnitCurrentOrder: u => u.order ?? 0, OrderId: order => order,
    DistanceBetweenUnits: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    IsUnitInGroup: (u, g) => g.has(u), GetUnitStrength: u => u.strength,
    GetUnitX: u => u.x, GetUnitY: u => u.y, GetLocationX: l => l.x, GetLocationY: l => l.y,
    Location: (x, y) => { const l = { x, y }; locations.add(l); return l; },
    RemoveLocation: l => locations.delete(l), MoveLocation: (l, x, y) => Object.assign(l, { x, y }),
    GetUnitLoc: u => state.Location(u.x, u.y),
    DistanceBetweenPoints_dk: (a, b) => {
      const distance = Math.hypot(a.x - b.x, a.y - b.y);
      state.RemoveLocation(a);
      return distance;
    },
    CreateGroup: () => new Set(), DestroyGroup() {}, FirstOfGroup: g => g.values().next().value ?? null,
    GroupRemoveUnit: (g, u) => g.delete(u),
    GroupEnumUnitsInRange: (g, x, y, radius) => units.filter(u => Math.hypot(u.x - x, u.y - y) <= radius).forEach(u => g.add(u)),
    SelectUnittype: g => g, SelectByHidden: g => g, SelectByAlive: g => g,
    CaptainInCombat: () => state.inCombat, CaptainRetreating: () => false, CaptainIsHome: () => false,
    SetGroupsFlee() {}, CaptainGoHome() {}, FormGroupAM() {},
    ApplyFleeStrengthModifier: strength => strength * 2,
    DisplayToAllJobDebug() {}, Trace() {}, Sleep: () => state.onSleep?.(), TQAddJob() {},
    B2S: String, Real2Str: String, I2R: n => n, Max: Math.max, RMax: Math.max,
    ModuloInteger: (a, b) => a % b, SquareRoot: Math.sqrt,
    IssuePointOrderLoc: (unit, order, location) => orders.push({ unit, order, x: location.x, y: location.y }),
  };
  const context = vm.createContext(state);
  for (const name of ['IsStandardUnit', 'IsUnitBuying', 'GetSubtractionLoc', 'GetSubtractionLoc_kd', 'GetLengthOfLoc', 'GetDivisionLoc', 'GetNormalisedLoc', 'GetMultipleLoc_d', 'GetSumLoc_kd', 'GetProjectedLoc']) {
    vm.runInContext(compile('common.eai', name), context);
  }
  vm.runInContext(compile('Jobs/RETREAT_CONTROL.eai', 'RetreatControlJob'), context);
  vm.runInContext(compile('Jobs/MICRO_UNITS.eai', 'StatueControl'), context);
  return {
    state, statue, hero, enemy, units, orders, locations,
    checkBattle: () => state.RetreatControlJob(),
    positionStatue: () => state.StatueControl(statue),
  };
}
