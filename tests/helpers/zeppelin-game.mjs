import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const source = readFileSync(new URL('../../Jobs/ZEPPELIN_MOVE.eai', import.meta.url), 'utf8');

// Exercise the rescue job itself; Warcraft order acceptance and morph timing need an in-game check.
export function zeppelinGame() {
  const passenger = { x: 4000, y: 0, life: 20, maxLife: 100, burrowed: false, order: 0 };
  const zeppelin = { x: 4000, y: 0, life: 100 };
  const orders = [];
  const jobs = [];
  const state = {
    ...groupNatives(),
    home_location: { x: 0, y: 0 }, zepdropping: false,
    ZTARGET_HOME: 0, ZTARGET_FOUNTAIN: 1, ZTARGET_MOONWELLS: 2,
    ZEPPELIN_MOVE: 'transport', SEND_HOME: 'home', RESET_GUARD_POSITION: 'reset',
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife',
    unit_rescueing: new Set([zeppelin]), unit_zepplin_move: new Set([zeppelin]),
    GetUnitState: (u, field) => u[field], UnitAlive: u => u.life > 0,
    GetUnitLoc: u => ({ x: u.x, y: u.y }), GetLocationX: l => l.x, GetLocationY: l => l.y,
    Location: (x, y) => ({ x, y }), RemoveLocation() {},
    DistanceBetweenPoints: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    IsUnitInTransport: u => !!u.loaded,
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
    RecycleGuardPosition() {}, DisplayToAllJobDebug() {}, CreateDebugTag() {},
  };
  const context = vm.createContext(state);
  vm.runInContext(['GetZTargetLocation', 'AddZepFinishingJob', 'ZeppelinMoveJob']
    .map(name => compile(source, name)).join('\n'), context);
  const group = new Set([zeppelin]);
  return { passenger, zeppelin, orders, jobs, state,
    rescue: () => state.ZeppelinMoveJob(state.ZTARGET_HOME, passenger, group),
  };
}
