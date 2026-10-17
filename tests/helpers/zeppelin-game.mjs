import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const source = readFileSync(new URL('../../Jobs/ZEPPELIN_MOVE.eai', import.meta.url), 'utf8');
const common = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');
const follow = readFileSync(new URL('../../Jobs/ZEPPELIN_FOLLOW.eai', import.meta.url), 'utf8');
const reset = readFileSync(new URL('../../Jobs/RESET_GUARD_POSITION.eai', import.meta.url), 'utf8');

// Exercise the rescue job itself; Warcraft order acceptance and morph timing need an in-game check.
export function zeppelinGame() {
  const passenger = { x: 4000, y: 0, life: 20, maxLife: 100, burrowed: false, order: 0 };
  const zeppelin = { x: 4000, y: 0, life: 100 };
  const orders = [];
  const jobs = [];
  const units = [passenger, zeppelin];
  const recycled = [];
  const state = {
    ...groupNatives(),
    home_location: { x: 0, y: 0 }, zeppelin_trips: new Map(),
    follow_zeppelin: zeppelin, major_hero: passenger, zeppelin_following: false,
    ai_player: 0, old_id: [0], neutral_zeppelin: 0, ZEPPELIN_FOLLOW: 'follow',
    max_follow_dist: 1000, sleep_multiplier: 1,
    order_cancel: 'cancel',
    unit_healing: new Set(), unit_harassing: new Set(),
    unit_buying_item: new Set(), unit_buying_merc: new Set(), unit_buying_tavern: new Set(),
    ZTARGET_HOME: 0, ZTARGET_FOUNTAIN: 1, ZTARGET_MOONWELLS: 2,
    ZEPPELIN_MOVE: 'transport', SEND_HOME: 'home', RESET_GUARD_POSITION: 'reset',
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife',
    unit_rescueing: new Set([zeppelin]), unit_zepplin_move: new Set([zeppelin]),
    GetUnitState: (u, field) => u[field], UnitAlive: u => !!u && u.life > 0,
    GetHandleId: handle => handle,
    LoadBoolean: (table, key, child) => table.get(key)?.[child] ?? false,
    LoadInteger: (table, key, child) => table.get(key)?.[child] ?? 0,
    SaveBoolean(table, key, child, value) { table.set(key, { ...table.get(key), [child]: value }); },
    SaveInteger(table, key, child, value) { table.set(key, { ...table.get(key), [child]: value }); },
    FlushChildHashtable: (table, key) => table.delete(key),
    GetUnitLoc: u => ({ x: u.x, y: u.y }), GetLocationX: l => l.x, GetLocationY: l => l.y,
    Location: (x, y) => ({ x, y }), RemoveLocation() {},
    DistanceBetweenPoints: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    IsUnitInTransport: (u, zep) => u.transport === zep || (u === passenger && !!u.loaded && zep === zeppelin),
    IsUnitLoaded: u => !!u.loaded || !!u.transport,
    GroupEnumUnitsOfPlayer: group => units.forEach(unit => group.add(unit)),
    GroupEnumUnitsOfType: group => units.filter(unit => unit !== passenger && unit.maxLife === undefined).forEach(unit => group.add(unit)),
    SelectById: group => new Set([...group].filter(unit => unit.maxLife === undefined)),
    SelectByPlayer: group => group, SelectByAlive: group => new Set([...group].filter(unit => unit.life > 0)),
    SelectByOrderOr: group => group,
    GetUnitX: u => u.x, GetUnitY: u => u.y, GetUnitMoveSpeed: () => 300, RMax: Math.max,
    DistanceBetweenUnits: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    DistanceBetweenPoints_dk: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    GetUnitCurrentOrder: u => u.order, OrderId: order => order,
    IssueImmediateOrder(u, order) {
      if (order === 'unburrow' && !u.burrowed) return false;
      orders.push({ unit: u, order });
      u.order = order;
      return true;
    },
    IssueTargetOrder(u, order, target) { orders.push({ unit: u, order, target }); return true; },
    IssuePointOrderLoc(u, order) { orders.push({ unit: u, order }); return true; },
    IssuePointOrder(u, order) { orders.push({ unit: u, order }); return true; },
    GetRandomReal: () => 0,
    TQAddUnitJob: (wait, job, target, unit) => jobs.push({ wait, job, target, unit }),
    TQAddGroupJob: (wait, job, target, unit) => jobs.push({ wait, job, target, unit }),
    TQAddJob: (wait, job) => jobs.push({ wait, job }),
    RecycleGuardPosition: unit => recycled.push(unit), RemoveGuardPosition() {},
    DisplayToAllJobDebug() {}, CreateDebugTag() {},
    build_zeppelin: zeppelin, race_max_expa_mine_distance: 500,
    ExpansionAttemptStalled: () => false,
    Sleep() {
      for (const job of jobs.splice(0)) {
        if (job.job === state.RESET_GUARD_POSITION) state.ResetGuardPositionJob(job.unit);
      }
    },
  };
  const context = vm.createContext(state);
  for (const name of ['IsStandardUnit', 'IsUnitBuying', 'SelectByUnitStandard', 'SelectByUnitFree',
    'HasTransportCargo', 'SelectEmptyTransports', 'GetNearestOfGroup', 'GetUnusedZeppelinNearUnit', 'BuildMovePeonZeppelin']) {
    vm.runInContext(compile(common, name), context);
  }
  vm.runInContext(compile(follow, 'ZeppelinFollowJob'), context);
  vm.runInContext(compile(reset, 'ResetGuardPositionJob'), context);
  vm.runInContext(['GetZTargetLocation', 'AddZepFinishingJob', 'ZeppelinMoveJob']
    .map(name => compile(source, name)).join('\n'), context);
  const group = new Set([zeppelin]);
  return { passenger, zeppelin, orders, jobs, state, units, recycled,
    rescue: () => state.ZeppelinMoveJob(state.ZTARGET_HOME, passenger, group),
    follow: () => state.ZeppelinFollowJob(),
    deliverWorker: () => state.BuildMovePeonZeppelin(passenger, { x: 4000, y: 0 }),
    addRescue() {
      const patient = { ...passenger, loaded: false, transport: null };
      const transport = { ...zeppelin };
      const trip = new Set([transport]);
      units.push(patient, transport);
      state.unit_rescueing.add(transport);
      return { passenger: patient, zeppelin: transport,
        rescue: () => state.ZeppelinMoveJob(state.ZTARGET_HOME, patient, trip) };
    },
  };
}
