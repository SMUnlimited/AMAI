// Execute production JASS with mocked Warcraft natives. The mocks cannot
// reproduce mine replacement, hidden-unit enumeration, construction or pathing.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';

const root = new URL('../../', import.meta.url);
const common = readFileSync(new URL('common.eai', root), 'utf8');
const doubles = readFileSync(new URL('Jobs/DETECT_DOUBLE_EXP.eai', root), 'utf8');
const harvest = readFileSync(new URL('Jobs/HARVEST_CHECK.eai', root), 'utf8');
const build = readFileSync(new URL('Jobs/BUILD_EXPANSION.eai', root), 'utf8');

function compile(source, name) {
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

export function expansionGame(race = 'undead') {
  const units = [];
  const orders = [];
  const races = { elf: 1, human: 2, orc: 3, undead: 4 };
  const state = {
    ai_player: 0, own_race: races[race], R_RANDOM: 0, RACE_NUMBER: 4,
    player_race: [races[race], 4, 1, 2], race_mine_style: [0, 2, 1, 1, 0],
    MINE_STYLE_EXCLUSIVE: 0, MINE_STYLE_SHARED: 1, MINE_STYLE_ENTANGLE: 2,
    race_uses_mine_expansion: race === 'undead',
    race_max_expa_mine_distance: 850, expansion_taken_radius: 1000,
    PLAYER_NEUTRAL_PASSIVE: 15, PLAYER_NEUTRAL_AGGRESSIVE: 12,
    UNIT_TYPE_STRUCTURE: 'structure', UNIT_TYPE_TOWNHALL: 'hall',
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife',
    gold_mines_ids: ['ngol', 'ugol', 'egol'], gold_mine_ids_size: 3,
    racial_expansion: 1, old_id: { 1: race === 'undead' ? 'ugol' : 'tree' },
    current_expansion: null, shared_expansion_target: null, double_expansion_target: null,
    harvest_mines: new Set(), harvest_mine_count: 0, expansion_retry_state: new Map(),
    Player: p => p, GetPlayerId: p => p, GetHandleId: u => u?.id ?? 0,
    GetOwningPlayer: u => u.owner, GetUnitTypeId: u => u.type,
    UnitAlive: u => Boolean(u?.alive), IsUnitHidden: u => u.hidden,
    IsUnitType: (u, type) => Boolean(u?.[type]), GetUnitState: (u, property) => u[property],
    GetResourceAmount: u => u.gold, GetUnitX: u => u.x, GetUnitY: u => u.y,
    DistanceBetweenUnits: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    IsPlayerAlly: (a, b) => a === b || b === 3,
    IsPlayerEnemy: (a, b) => a !== b && a !== 3 && b !== 3 && a !== 15 && b !== 15,
    CreateGroup: () => new Set(), DestroyGroup() {}, GroupClear: g => g.clear(),
    GroupAddUnit: (g, u) => g.add(u), GroupRemoveUnit: (g, u) => g.delete(u),
    FirstOfGroup: g => g.values().next().value ?? null, IsUnitInGroup: (u, g) => g.has(u),
    GroupEnumUnitsOfPlayer: (g, p) => units.filter(u => u.owner === p).forEach(u => g.add(u)),
    // Include lingering corpses and hidden deposits so production must filter them.
    GroupEnumUnitsInRange: (g, x, y, radius) => units.filter(u => Math.hypot(u.x - x, u.y - y) <= radius).forEach(u => g.add(u)),
    SelectNumberOfId: (g, count, id) => new Set([...g].filter(u => u.type === id).slice(0, count)),
    SelectUnittype: (g, type, matches) => new Set([...g].filter(u => Boolean(u[type]) === matches)),
    SelectByAlive2: g => new Set([...g].filter(u => u.alive)),
    order_cancel: 'cancel', IssueImmediateOrderById: (u, order) => orders.push({ unit: u, order }),
    IssueImmediateOrder: (u, order) => orders.push({ unit: u, order }),
    IsExpansionRebuildCoolingDown: () => false, FlushChildHashtable: t => t.clear(), Trace() {},
    ExpansionAttemptStalled: () => false, GetUnitCurrentOrder: () => 0,
    CreateDebugTagLoc() {}, GetLocationNonCreepStrength: () => 0,
  };
  const context = vm.createContext(state);
  for (const name of [
    'IsUnitGoldMine', 'GetPlayerMineStyle', 'MineClaimPolicy', 'MineHallRelocationPolicy',
    'GetNearestGoldMineToUnit', 'GetMineClaimantEx', 'GetMineClaimant', 'MineHallHasActiveMine',
    'IsAlliedSharedMineHall', 'IsSharedExpansionMine', 'GetExpansionMineClaimantEx',
    'GetExpansionMineClaimant', 'CheckExpansionTaken',
  ]) vm.runInContext(compile(common, name), context);
  for (const [source, names] of [[doubles, ['PreferExpansionClaimant', 'CheckDoubleExpansion']],
    [harvest, ['RefreshHarvestMines']], [build, ['BuildExpansionJob']]]) {
    for (const name of names) vm.runInContext(compile(source, name), context);
  }

  function addUnit(type, properties = {}) {
    const unit = { id: units.length + 1, type, owner: 0, alive: true, hidden: false,
      structure: true, hall: false, life: 1000, maxLife: 1000, gold: 0, x: 0, y: 0, ...properties };
    units.push(unit);
    return unit;
  }
  return {
    state, orders,
    addMine: (type = 'ngol', properties = {}) => addUnit(type, { owner: 15, gold: 10000, ...properties }),
    addHall: (properties = {}) => addUnit(race === 'elf' ? 'tree' : 'hall', { hall: true, x: 400, ...properties }),
    checkDuplicates: () => state.CheckDoubleExpansion(),
    isTaken: mine => state.CheckExpansionTaken(mine),
    checkBuilder: (worker, mine) => { state.current_expansion = mine; state.BuildExpansionJob(worker, mine); },
    checkHarvest: () => { state.RefreshHarvestMines(); return [...state.harvest_mines]; },
  };
}
