// Execute preprocessed production source, with Warcraft counts, factories and resources mocked.
// Integer assignments/returns truncate as in JASS. No combat, native targeting or pathing simulation.
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import vm from 'node:vm';

const root = new URL('../../', import.meta.url);
const cached = new Map();
const zeros = () => Array(8192).fill(0);
const rawcode = value => [...value].reduce((code, char) => code * 256 + char.charCodeAt(0), 0);
const expression = value => value.replace(/\band\b/g, '&&').replace(/\bor\b/g, '||')
  .replace(/\bnot\b/g, '!').replace(/'([^']{4})'/g, (_, code) => rawcode(code));

function load(version) {
  if (cached.has(version)) return cached.get(version);
  const result = spawnSync('perl', ['ejass.pl', 'common.eai', version, 'VER:' + version], {
    cwd: fileURLToPath(root), encoding: 'utf8', maxBuffer: 32 * 1024 * 1024,
    env: { ...process.env, LC_ALL: 'C', LC_CTYPE: 'C', LANG: 'C' },
  });
  assert.equal(result.error, undefined, 'Perl must run to test actual table-expanded source');
  assert.equal(result.status, 0, result.stderr);
  const source = result.stdout;
  const globals = [...source.slice(source.indexOf('globals'), source.indexOf('endglobals'))
    .matchAll(/^\s*(?:constant )?(\w+)\s+(array\s+)?(\w+)(?:\s*=\s*([^\r\n]+))?/gm)];
  const types = new Map(globals.map(([, type, , name]) => [name, type]));
  const names = [
    'InitArrays', 'GetUnitCountEx', 'isSameUpgradeLine', 'GetUnitCountAlt',
    'TownCountEx', 'TownCountDone', 'TownCount', 'TownCountTown', 'CanBuildUnit',
    'SetBuildAllAMCore', 'SetBuildDependency', 'RefreshNeeded', 'SetBuildAllAM', 'BuildUnit',
    'AddRefresh', 'RefreshAllNeeded', 'CheckNotBuiltFrom', 'StartUnitAM', 'SetBuildFree',
    'OneBuildLoopAM', 'BuildAdaptiveReinforcements', 'ResetDynamicSystem', 'DynamicBuildUnitBase', 'DynamicBuildUnit',
    'FormatAdaptiveCounterReport', 'GetCounterDebugReport', 'GetCurrentDynamicReport',
    'GetCurrentStrategyReport', 'QueueStrategy', 'RefreshAdaptiveReport',
    'DynamicStrategySelector', ...[...source.matchAll(/^function (Adaptive\w+|RemoveAdaptiveRequests|ClearAdaptiveCounters|RefreshAdaptiveCounters|RefreshAdaptiveReservation|BuildAdaptiveCounters|AddUnitToAnti\w+) takes/gm)]
      .map(([, name]) => name),
  ];
  const script = new vm.Script(names.map(name => compile(source, name, types)).join('\n'));
  const data = { globals, script, types };
  cached.set(version, data);
  return data;
}

function compile(source, name, globalTypes) {
  const match = source.match(new RegExp('function ' + name + ' takes (.*?) returns (\\w+)([\\s\\S]*?)endfunction'));
  assert.ok(match, 'Missing production function ' + name);
  const types = new Map(globalTypes);
  const params = match[1] === 'nothing' ? [] : match[1].split(',').map(part => {
    const [type, param] = part.trim().split(/\s+/);
    types.set(param, type);
    return param;
  });
  const assign = (target, value) => types.get(target.split('[')[0]) === 'integer'
    ? 'Math.trunc(' + expression(value) + ')' : expression(value);
  const body = match[3].split(/\r?\n/).map(raw => {
    const line = raw.replace(/\/\/.*$/, '').trim();
    if (!line) return '';
    let part;
    if ((part = line.match(/^local (\w+) array (\w+)$/))) {
      types.set(part[2], part[1]);
      return 'let ' + part[2] + ' = zeros();';
    }
    if ((part = line.match(/^local (\w+) (\w+)(?: = (.*))?$/))) {
      types.set(part[2], part[1]);
      return 'let ' + part[2] + ' = ' + assign(part[2], part[3] ?? '0') + ';';
    }
    if ((part = line.match(/^set (.+?)\s*=\s*(.+)$/))) return part[1] + ' = ' + assign(part[1], part[2]) + ';';
    if ((part = line.match(/^if (.+) then$/))) return 'if (' + expression(part[1]) + ') {';
    if ((part = line.match(/^elseif (.+) then$/))) return '} else if (' + expression(part[1]) + ') {';
    if (line === 'else') return '} else {';
    if (line === 'endif' || line === 'endloop') return '}';
    if (line === 'loop') return 'while (true) {';
    if ((part = line.match(/^exitwhen (.+)$/))) return 'if (' + expression(part[1]) + ') break;';
    if ((part = line.match(/^return(?: (.+))?$/))) {
      if (!part[1]) return 'return;';
      return 'return ' + (match[2] === 'integer' ? 'Math.trunc(' + expression(part[1]) + ')' : expression(part[1])) + ';';
    }
    if (line.startsWith('call ')) return expression(line.slice(5)) + ';';
    throw new Error('Unsupported production JASS in ' + name + ': ' + line);
  }).join('\n');
  return 'function ' + name + '(' + params.join(',') + ') {\n' + body + '\n}';
}

export function adaptiveGame({ version = 'REFORGED', race = 'Human', tier = 2, food = 50 } = {}) {
  const { globals, script, types } = load(version);
  const state = { zeros, Math };
  for (const [, type, array, name, initial] of globals) {
    state[name] = array ? zeros() : type === 'boolean' ? false : type === 'string' ? '' : 0;
    if (!array && initial) {
      const value = expression(initial.replace(/\/\/.*$/, '').trim());
      if (/^-?\d+(?:\.\d+)?$/.test(value)) state[name] = Number(value);
      else if (value === 'true' || value === 'false') state[name] = value === 'true';
      else if (/^"[^"]*"$/.test(value)) state[name] = value.slice(1, -1);
      else if (/^\w+$/.test(value) && Object.hasOwn(state, value)) state[name] = state[value];
    }
  }
  const rows = readFileSync(new URL(version + '/StandardUnits.txt', root), 'utf8').trim()
    .split(/\r?\n/).slice(1).map(row => row.split('\t'));
  const categories = readFileSync(new URL(version + '/Strengths.txt', root), 'utf8').trim()
    .split(/\r?\n/).map(row => row.split('\t')[0]);
  const records = new Map(rows.map(row => [state['o' + row[0]], row]));
  const translations = new Map(readFileSync(new URL('Languages/English/Translations.txt', root), 'utf8')
    .trim().split(/\r?\n/).slice(1).map(row => row.split('\t')));
  const counts = new Map();
  const training = new Map();
  const foodCosts = new Map();
  const blocked = new Map();
  const production = [];
  const logs = [];
  const sleepLocks = [];
  let elapsed = 0;
  let gold = 10000;
  let wood = 10000;
  let upkeepLimit = Infinity;
  let deferredCounts = false;
  const runtime = name => {
    assert.ok(state['u' + name] > 0, 'Unknown unit ' + version + '/' + name);
    return state.old_id[state['u' + name]];
  };
  const foodCost = id => foodCosts.get(id) ?? (
    records.get(id)?.[4] === 'HERO' ? 5 :
      records.get(id)?.[4] !== 'UNIT' ? 0 :
        /peon|militia/.test(records.get(id)?.[3] ?? '') ? 1 :
          Math.max(1, ...[...records.get(id)?.slice(16) ?? []].map(Number).filter(Number.isFinite)));
  Object.assign(state, {
    IsAMAI: true, ai_player: 0, adaptive_counters: version !== 'ROC', strategy: 0,
    campaign_ai: false, towerrush: false, custom_data_set: false, tier,
    ai_time: 100, ver_food_limit: 100, sleep_multiplier: 1, build_lock: true,
    own_town_num: 1, gold_buffer: 0, wood_buffer: 0, front_locs_computed: true,
    build_qty: zeros(), build_type: zeros(), build_item: zeros(), build_town: zeros(),
    build_length: 0, JASS_MAX_ARRAY_SIZE: 8192,
    UNIT_TYPE_STRUCTURE: 'structure', UNIT_TYPE_HERO: 'hero', UNIT_TYPE_PEON: 'peon',
    GAME_STATE_TIME_OF_DAY: 0, GetFloatGameState: () => 12,
    GetFoodUsed: foodCost, FoodUsed: () => food, FoodCap: () => 100,
    GetUnitCount: id => (counts.get(id) ?? 0) + (training.get(id) ?? 0),
    GetUnitCountDone: id => counts.get(id) ?? 0,
    GetTownUnitCount: (id, town, done) => done ? state.GetUnitCountDone(id) : state.GetUnitCount(id),
    GetUpgradeLevel: id => counts.get(id) ?? 0,
    IsUnitIdType: (id, kind) => kind === 'structure' ? records.get(id)?.[4] === 'BUILDING' :
      kind === 'hero' ? records.get(id)?.[4] === 'HERO' : /peon|militia/.test(records.get(id)?.[3] ?? ''),
    BlockListCheck: (qty, id) => Math.min(qty, blocked.get(id) ?? Infinity),
    RBlockListCheck: qty => qty,
    TimerGetElapsed: () => elapsed, Min: Math.min, Max: Math.max, RMin: Math.min, RMax: Math.max,
    Int2Str: String, I2R: Number, R2I: Math.trunc, Real2Str: String, ModuloInteger: (a, b) => a % b,
    GetBuildLock() { assert.equal(state.build_lock, true); state.build_lock = false; },
    ReleaseBuildLock() { assert.equal(state.build_lock, false); state.build_lock = true; },
    GetNeutralNumber: () => 0, nearest_neutral: Array(8192).fill(null), GetGold: () => gold, GetWood: () => wood,
    GetUnitGoldCost2: () => 10, GetUnitWoodCost2: () => 5, GetUnitBuildTime: () => 20,
    GetItemNumber: () => 0, Get_f_qty: () => 1, TownHasMine: () => true,
    IsRacialHallId: id => state.adaptive_tech_tier[id] > state.tier,
    ApplyUpkeepCheck: (affordable, used, cost) => Math.min(affordable, Math.max(0, Math.floor((upkeepLimit - used) / cost))),
    SetProduce(qty, id) {
      if (qty <= 0) return false;
      production.push({ name: records.get(id)?.[0], quantity: qty });
      if (!deferredCounts) {
        training.set(id, (training.get(id) ?? 0) + qty);
        food += foodCost(id) * qty;
      }
      return true;
    },
    Trace: line => logs.push(line),
    ApplyTrans: key => translations.get(key) ?? key,
    GetObjectName: id => records.get(id)?.[0] ?? '',
    GetStrategyReport: () => 'My strategy.',
    Sleep() { sleepLocks.push(state.build_lock); }, InitLastUpkeep() {}, TimeKeeper() {}, FarmBuilder() {}, PeonBuilder() {},
    ExpansionBuilder() {}, HeroReviver() {}, CheckUpkeepAllowed() {}, ApplyUpkeepSaving() {},
    UpdateLastUpkeep() {}, ResetUpkeepSaveTime() {}, FactoryNumberUpdate() {},
    UpgradeBuilding: () => state.CANNOT_BUILD, BuildAtSpecialLoc: () => state.CANNOT_BUILD,
    BuildLumberMillAtBase: () => false, CreepsOnMap: () => false,
    StartUpgradeAM: () => state.CANNOT_BUILD, StartItem: () => state.CANNOT_BUILD,
  });
  for (const [index, category] of categories.entries()) {
    state['GetPlayer' + category + 'Strength'] = () => rows.reduce((sum, record) => {
      return sum + Number(record[16 + index] || 0) * state.GetUnitCount(state['o' + record[0]]);
    }, 0);
  }
  script.runInContext(vm.createContext(state));
  state.InitArrays();
  const peons = { Human: 'PEASANT', Orc: 'PEON', Undead: 'ACOLYTE', Elf: 'WISP' };
  state.racial_peon = state['u' + peons[race]];
  state.racial_ghoul = race === 'Undead' ? state.uGHOUL : 0;
  for (const row of rows) {
    state.unitNames[state['u' + row[0]]] = row[0];
    if (row[4] === 'BUILDING') state.building[state.building_length++] = state['u' + row[0]];
  }
  const buildings = rows.filter(row => row[4] === 'BUILDING' && row[2].toUpperCase() === race.toUpperCase());
  // Default game has current-tier infrastructure. Scenarios can destroy individual buildings.
  for (const row of buildings) {
    if (!/hall[123]/.test(row[3])) counts.set(runtime(row[0]), 1);
    else if (Number(row[3].match(/hall(\d)/)?.[1]) === tier) counts.set(runtime(row[0]), 1);
  }
  return {
    state, production, logs, sleepLocks,
    id: name => state['u' + name],
    own(name, quantity, { training: pending = 0, food: cost } = {}) {
      counts.set(runtime(name), quantity);
      training.set(runtime(name), pending);
      if (cost !== undefined) foodCosts.set(runtime(name), cost);
    },
    threat(category, strength) { state['enemy_' + category] = strength; },
    ally(category, strength) { state['ally_' + category] = strength; },
    block(name, maximum = 0) { blocked.set(state['u' + name], maximum); },
    setFood(value) { food = value; },
    setUpkeepLimit(value) { upkeepLimit = value; },
    deferTrainingCounts() { deferredCounts = true; },
    advance(seconds) { elapsed += seconds; },
    register(category, name, weight = 10) { state['AddUnitToAnti' + category](state['u' + name], weight); },
    resetCounters() { state.ResetDynamicSystem(); },
    registerRaceCounters() {
      const source = readFileSync(new URL(version + '/' + race + '/BuildSequence.ai', root), 'utf8');
      const lines = source.slice(source.indexOf('call ResetDynamicSystem()')).split(/\r?\n/);
      let depth = 0;
      let end = 0;
      for (let i = 1; i < lines.length; i++) {
        if (/^\s*if .* then/.test(lines[i])) depth++;
        if (/^\s*endif/.test(lines[i]) && --depth === 0) { end = i; break; }
      }
      assert.ok(end > 0, 'Find the actual race tier registration block');
      const block = 'function register_race_counters takes nothing returns nothing\n' +
        lines.slice(0, end + 1).join('\n') + '\nendfunction';
      vm.runInContext(compile(block, 'register_race_counters', types), vm.createContext(state));
      state.register_race_counters();
    },
    plan({ force = true } = {}) {
      if (force) state.adaptive_force_refresh = true;
      state.DynamicBuildUnit(40);
    },
    request(name, quantity, priority = 100) { state.BuildUnit(quantity, state['u' + name], priority); },
    build() { state.OneBuildLoopAM(); },
    targets() {
      return Array.from({ length: state.adaptive_selected_count }, (_, index) => {
        const id = state.adaptive_selected[index];
        return { name: state.unitNames[id], quantity: state.adaptive_target[id] };
      });
    },
    queue() {
      return Array.from({ length: state.build_length }, (_, i) => ({
        name: state.unitNames[state.build_item[i]], type: state.build_type[i],
        quantity: state.build_qty[i], priority: state.build_prio[i],
      }));
    },
  };
}
