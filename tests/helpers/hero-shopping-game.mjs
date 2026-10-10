// Exercise production JASS control flow; Warcraft movement still needs an in-game check.
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
    if (/^elseif /.test(line)) return line.replace(/^elseif (.*) then$/, '} else if ($1) {');
    if (/^if /.test(line)) return line.replace(/^if (.*) then$/, 'if ($1) {');
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

export function heroGame(reservation, assigned = true) {
  const hero = { alive: true, type: 'hero', order: 'move-home', slots: 1, life: 20, maxLife: 100, mana: 0 };
  const effects = [];
  const unitJobs = [];
  const state = {
    shop_sent: assigned ? hero : null, shop_ordered: true, retreat_home: false,
    shop_buy_time_large: -1, shop_buy_time_small: -1, shop_distance_limit: 100000,
    shop_unit: { alive: true, type: 'shop' }, shop_wanted: 1,
    unit_buying_item: new Set(assigned ? [hero] : []),
    unit_buying_tavern: new Set(), unit_buying_merc: new Set(),
    unit_healing: new Set(), unit_rescueing: new Set(), unit_harassing: new Set(), unit_zepplin_move: new Set(),
    hero_built: [false, true, false, false], hero_unit: [null, hero],
    buy_type: [1, 0, 1], BT_RACIAL_ITEM: 1, BUY_ITEM: 20, old_id: ['item', 'shop', 'potion'], racial_shop: 1,
    town_threatened: false, attack_running: true, isfleeing: false,
    distance: 4000, now: 10, items: 0, ai_time: 10, regenerate_time: [20], available_time: [],
    buy_timeout_large: 60, buy_timeout_small: 5, buy_distance: 300,
    tq_timer: null, ai_player: 0, GAME_STATE_TIME_OF_DAY: 0, UNIT_TYPE_PEON: 'peon', UNIT_TYPE_STRUCTURE: 'structure',
    home_location: {},
    captain_home: {}, SEND_HOME: 40, RESET_GUARD_POSITION: 16,
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife', UNIT_STATE_MANA: 'mana',
    UNIT_TYPE_HERO: 'hero', UNIT_TYPE_FLYING: 'flying', ITEMTYPE_CONTINUOUS: 1,
    healingItems: 0, continuous: false, homeDistance: 0, purchaseSucceeds: false, otherhero: null,
    GetUnitState: (u, property) => u[property], I2R: n => n, Max: Math.max,
    GetHeroHealingItem: () => 2, GetHeroManaItem: () => 0,
    SomeUnitHasHealingItem: () => state.otherhero,
    GetUnitOfTypeNearUnit: () => state.shop_unit,
    GetItemNumberOnUnit: (id, u) => id === 2 ? (u === hero ? state.healingItems : 1) : 0,
    GetItemInstantType: () => state.continuous ? 1 : 0, GetItemHealingTime: () => state.continuous ? 9 : 0,
    GetItemOfTypeOnUnit: () => ({}),
    UnitUseItem: () => { effects.push('use'); state.healingItems = 0; },
    UnitUseItemTarget() {}, UnitAddItem: () => { effects.push('transfer'); state.healingItems++; },
    DistanceBetweenPoints_dk: () => state.homeDistance,
    TQAddUnitJob: (delay, job, parameter, unit) => unitJobs.push({ delay, job, parameter, unit }),
    GetUnitAbilityLevel: () => 0,
    ACTION_DO_NOTHING: 0, ACTION_GO_HOME: 1, ACTION_FOUNTAIN: 2, ACTION_TP: 3,
    ACTION_ZEPPELIN_HOME: 4, ACTION_ZEPPELIN_FOUNTAIN: 5, ACTION_HEALER: 6,
    ACTION_MANA_FOUNTAIN: 7, ACTION_MOONWELLS: 8, major_hero: null,
    GetHealthFountainID: () => 0, GetManaFountainID: () => 0,
    teleporting: false, MICRO_HERO: 23, sleep_multiplier: 1, flee_health_percentage: 0.25, flee_minimum_health: 10,
    hero_dir: [], hero_loc: [], hero_hp_loss: [], hero_hp: [0, 0.2],
    hero_enemy_density: [], hero_enemy_loc: [], hero_ally_density: [], hero_ally_loc: [],
    hero_radius: 1000, enemy_density: 0, ally_density: 0, enemy_density_loc: {}, ally_density_loc: {},
    town_loc: [{}], most_threatened_town: 0, tp_item: 3,
    GetArmyOfUnit: () => -1, GetDensities() {}, MoveLocation() {}, RMax: Math.max,
    UnitAlive: u => Boolean(u?.alive), GetUnitTypeId: u => u?.type,
    IsUnitType: (u, type) => u.type === type, GetSlotsFreeOnUnit: u => u.slots,
    IsUnitInGroup: (u, g) => g.has(u), GroupAddUnit: (g, u) => g.add(u), GroupRemoveUnit: (g, u) => g.delete(u),
    GetUnitX: () => 0, GetUnitY: () => 0, GetLocationX: () => 0, GetLocationY: () => 0,
    DistanceBetweenUnits: () => state.distance, GetLocationNonCreepStrength: () => 0, GetUnitStrength: () => 100,
    GetFloatGameState: () => 12, TimerGetElapsed: () => state.now,
    GetItemNumber: () => state.items, IsHealingItem: () => true,
    GetUnitCurrentOrder: u => u.order, OrderId: s => s, GetUnitLoc: () => ({}),
    DistanceBetweenPoints: () => 0, RemoveLocation() {},
    DisplayToAllJobDebug() {}, CreateDebugTag() {}, Trace() {},
    RecycleGuardPosition: () => effects.push('recycle'),
    AddAssault: (count, type) => {
      assert.equal(count, 1, 'Keep the original shopping assault count');
      assert.equal(type, 'hero');
      effects.push('assault');
    },
    RemoveGuardPosition: () => effects.push('remove-guard'),
    IssuePointOrder: () => effects.push('move'), IssueImmediateOrder: () => effects.push('order'),
    IssueNeutralImmediateOrderById: () => {
      effects.push('buy');
      if (state.purchaseSucceeds) state.healingItems++;
    }, TQAddJob: () => effects.push('job'),
    IssueTargetOrderById() {},
  };
  if (reservation) state[reservation].add(hero);
  const context = vm.createContext(state);
  for (const [file, name] of [
    ['common.eai', 'IsStandardUnit'], ['common.eai', 'IsUnitBuying'], ['common.eai', 'GetHeroToBuyItem'],
    ['Jobs/BUY_ITEM.eai', 'EndBuyItemJob'], ['Jobs/BUY_ITEM.eai', 'BuyItemJob'],
    ['Jobs/RESET_GUARD_POSITION.eai', 'ResetGuardPositionJob'],
    ['Jobs/SEND_HOME.eai', 'SendHomeMoveUnitToLoc'], ['Jobs/SEND_HOME.eai', 'SendUnitHomeJob'],
    ['Jobs/MICRO_HERO.eai', 'ExecuteSaveHero'], ['Jobs/MICRO_HERO.eai', 'HeroBugFixHealthCheck'],
    ['Jobs/MICRO_HERO.eai', 'MicroHeroJob'],
  ]) vm.runInContext(compile(file, name), context);
  return {
    state, hero, effects, unitJobs,
    buyItem: () => state.BuyItemJob(2),
    sendHome: () => state.SendUnitHomeJob(hero, 0),
    saveHero: () => state.ExecuteSaveHero(1, state.ACTION_GO_HOME, null),
    checkHero: () => state.MicroHeroJob(1),
  };
}

