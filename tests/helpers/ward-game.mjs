import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile, expression } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const root = new URL('../../', import.meta.url);

export function orcGame(version = 'REFORGED') {
  const doctor = { type: 1, x: 0, y: 0, life: 100, maxLife: 100, mana: 200, owner: 0, order: 0 };
  const units = [doctor];
  const orders = [];
  const movements = [];
  const jobs = [];
  const released = [];
  const transports = [];
  const groups = new Set();
  const row = readFileSync(new URL(`${version}/Healers.txt`, root), 'utf8')
    .split(/\r?\n/).find(line => line.startsWith('WITCH_DOCTOR\t')).split('\t');
  const state = {
    ...groupNatives(groups),
    ai_player: 0, major_hero: doctor, healer_length: 1, healer_id: [doctor.type],
    healer_spell: [Number(row[3])], healer_mana_cost: [Number(row[4])],
    healer_upg_id: [1], healer_upg_level: [Number(row[6])], upgrades: 2,
    HEALER_TYPE_WARD: 3, HEALER_TYPE_NO_TARGET: 0, HEALER_TYPE_HERO: 4, healer_type: [3], healer_group: new Set([doctor]),
    ward_recovery_healer: null, ward_recovery_patients: new Set(),
    unit_healing: new Set(), unit_rescueing: new Set(), unit_harassing: new Set(), unit_zepplin_move: new Set(),
    unit_buying_item: new Set(), unit_buying_merc: new Set(), unit_buying_tavern: new Set(),
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife', UNIT_STATE_MANA: 'mana',
    UNIT_TYPE_PEON: 'peon', UNIT_TYPE_STRUCTURE: 'structure', UNIT_TYPE_MECHANICAL: 'mechanical', UNIT_TYPE_SUMMONED: 'summoned',
    ward_cast: false, isfleeing: false, flee_health_percentage: 0.25, flee_minimum_health: 10, sleep_multiplier: 1, MICRO_UNITS: 1,
    UnitAlive: u => Boolean(u && u.life > 0), IsUnitType: (u, type) => Boolean(u[type]),
    IsUnitHidden: u => Boolean(u.hidden), IsUnitIllusion: u => Boolean(u.illusion),
    IsUnitLoaded: u => Boolean(u.loaded),
    GetUnitState: (u, property) => u[property], GetUnitTypeId: u => u?.type,
    GetUnitX: u => u.x, GetUnitY: u => u.y, GetOwningPlayer: u => u.owner,
    GetUnitLoc: u => ({ x: u.x, y: u.y }), GetLocationX: l => l.x, GetLocationY: l => l.y,
    DistanceBetweenPoints_dk: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    captain_home: { x: 0, y: 0 }, home_location: { x: 0, y: 0 }, last_enemy_loc: { x: 0, y: 0 },
    GetHealthFountainID: () => 0, GetFloatGameState: () => 12, GAME_STATE_TIME_OF_DAY: 0,
    GetManaFountainID: () => 0, GetUnitUsableAbilityLevel: () => 0,
    GetLocationNonCreepStrength: () => state.homeThreat,
    homeThreat: 0, town_threatened: false, race_use_fountain: false, race_has_moonwells: false, follow_zeppelin: null,
    GetHeroHealingItem: () => 0, GetHeroManaItem: () => 0, shop_ordered: false,
    ACTION_DO_NOTHING: 0, ACTION_TP: 3, ACTION_HEALER: 6,
    I2R: n => n, SEND_HOME: 40, WARD_RECOVERY: 41,
    UNIT_TYPE_FLYING: 'flying',
    UNIT_TYPE_HERO: 'hero', old_id: [99], racial_militia: 0,
    GetUnitAbilityLevel: () => 0, RemoveGuardPosition() {}, RemoveLocation() {}, CreateDebugTag() {},
    DisplayToAllJobDebug() {}, RecycleGuardPosition: unit => released.push(unit),
    GetTimeToReachLoc: () => 1, RESET_GUARD_POSITION: 2, attack_running: true,
    IssuePointOrderLoc: (unit, order, location) => movements.push({ unit, order, x: location.x, y: location.y }),
    IssuePointOrder: (unit, order, x, y) => { movements.push({ unit, order, x, y }); unit.order = order; return true; },
    IssueImmediateOrder: (unit, order) => { orders.push({ unit, order }); unit.order = order; return true; },
    IssueTargetOrderById: (unit, order, target) => { orders.push({ unit, order, target }); return true; },
    TQAddUnitJob: (delay, job, parameter, unit) => jobs.push({ delay, job, parameter, unit }),
    ZEPPELIN_MOVE: 42, ZTARGET_HOME: 0,
    TQAddGroupJob: (delay, job, target, unit, group) => transports.push({ delay, job, target, unit, group }),
    IsPlayerAlly: (owner, player) => owner === player || owner === 2,
    GetUnitCurrentOrder: u => u.order, OrderId: name => name === 'healingward' ? 852109 : name,
    GetUpgradeLevel: () => state.upgrades, RMax: Math.max,
    GroupEnumUnitsOfPlayer: g => units.filter(u => u.owner === 0).forEach(u => g.add(u)),
    GroupEnumUnitsInRange: (g, x, y, radius) => units.filter(u => Math.hypot(u.x - x, u.y - y) <= radius).forEach(u => g.add(u)),
    CopyGroup: g => { const copy = state.CreateGroup(); g.forEach(u => copy.add(u)); return copy; },
    IssuePointOrderById: (unit, order, x, y) => { orders.push({ unit, order, x, y }); unit.order = order; return true; },
    TQAddJob() {},
  };
  const context = vm.createContext(state);
  const common = readFileSync(new URL('common.eai', root), 'utf8');
  for (const name of ['IsStandardUnit', 'IsUnitBuying', 'GetHealerId', 'GetHealer', 'RequestWardRecovery', 'HealUnit']) {
    vm.runInContext(compile(common, name), context);
  }
  const micro = readFileSync(new URL('Jobs/MICRO_UNITS.eai', root), 'utf8')
    .replace(/#INCLUDETABLE[^\r\n]*StandardUnits.txt[\s\S]*?#ENDINCLUDE/g, '');
  for (const name of ['SaveUnit', 'MicroUnitsJob']) {
    vm.runInContext(compile(micro, name), context);
  }
  for (const [file, names] of [
    ['Jobs/RESET_GUARD_POSITION.eai', ['ResetGuardPositionJob']],
    ['Jobs/SEND_HOME.eai', ['SendHomeMoveUnitToLoc', 'SendUnitHomeJob']],
    ['Jobs/WARD_RECOVERY.eai', ['EndWardRecovery', 'WardRecoveryJob']],
    ['Jobs/MICRO_HERO.eai', ['ExecuteSaveHero']],
  ]) {
    const source = readFileSync(new URL(file, root), 'utf8');
    for (const name of names) vm.runInContext(compile(source, name), context);
  }
  function runJob(job, unit, action) {
    const index = jobs.findIndex(entry => entry.job === job && entry.unit === unit);
    if (index !== -1) jobs.splice(index, 1);
    action(unit);
  }
  return {
    state, doctor, units, orders, movements, jobs, groups, released, transports,
    get wards() { return orders.filter(entry => entry.order === 852109); },
    addTroop(options = {}) {
      const unit = { type: 2, x: 200, y: 0, life: 50, maxLife: 100, mana: 0, owner: 0, ...options };
      units.push(unit);
      return unit;
    },
    sendHome(unit) {
      state.unit_healing.add(unit);
      runJob(state.SEND_HOME, unit, u => state.SendUnitHomeJob(u, 0));
    },
    checkHome: unit => runJob(state.SEND_HOME, unit, u => state.SendUnitHomeJob(u, 0)),
    checkRecovery: (unit = state.ward_recovery_healer ?? doctor) => runJob(state.WARD_RECOVERY, unit, u => state.WardRecoveryJob(u)),
    arriveHome(unit) { Object.assign(unit, state.captain_home, { order: 0 }); },
    saveHero(unit) {
      state.hero_unit = [null, unit];
      state.ExecuteSaveHero(1, state.ACTION_HEALER, doctor);
    },
    addWard(options = {}) {
      const ward = { type: Number(expression("'ohwd'")), x: 0, y: 0, life: 100, maxLife: 100, owner: 0, structure: true, ...options };
      units.push(ward);
      return ward;
    },
    checkUnits: () => state.MicroUnitsJob(),
  };
}
