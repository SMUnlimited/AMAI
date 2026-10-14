// Run production ghoul return jobs and allocation with Warcraft orders mocked.
// Actual tree selection, pathing and acceptance of autoharvest need in-game checks.
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const read = path => readFileSync(new URL('../../' + path, import.meta.url), 'utf8');
export function ghoulGame() {
  const units = [], orders = [], jobs = [], groups = new Set();
  const state = {
    ai_player: 0, racial_ghoul: 1, old_id: [0, 'ugho'], home_location: { x: 0, y: 0 },
    returning_ghouls: new Map(), harvesting_ghouls: 1, GHOUL_RETURN_HOME: 20, acceptsHarvest: true,
    ...groupNatives(groups),
    GetOwningPlayer: u => u.owner, GetUnitTypeId: u => u.type,
    UnitAlive: u => Boolean(u?.alive), GetUnitCurrentOrder: u => u.order, OrderId: order => order,
    IsStandardUnit: u => !u.healing, IsUnitBuying: u => u.buying,
    GetUnitLoc: u => ({ x: u.x, y: u.y }), GetLocationX: l => l.x, GetLocationY: l => l.y,
    DistanceBetweenPoints_dk: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    GetTimeToReachLoc: () => 1, Min: Math.min, Max: Math.max,
    GroupEnumUnitsOfPlayer: (g, p) => units.filter(u => u.owner === p).forEach(u => g.add(u)),
    BlzGroupAddGroupFast: (source, target) => source.forEach(u => target.add(u)),
    GetNearestSubGroupOfGroup(g, loc, count) {
      const selected = state.CreateGroup();
      [...g].sort((a, b) => Math.hypot(a.x - loc.x, a.y - loc.y) - Math.hypot(b.x - loc.x, b.y - loc.y))
        .slice(0, count).forEach(u => selected.add(u));
      state.DestroyGroup(g);
      return selected;
    },
    LoadInteger: (table, parent, child) => table.get(`int:${parent}:${child}`) ?? 0,
    SaveInteger: (table, parent, child, value) => table.set(`int:${parent}:${child}`, value),
    LoadUnitHandle: (table, parent, child) => table.get(`unit:${parent}:${child}`) ?? null,
    SaveUnitHandle: (table, parent, child, value) => table.set(`unit:${parent}:${child}`, value),
    RemoveSavedHandle: (table, parent, child) => table.delete(`unit:${parent}:${child}`),
    RemoveGuardPosition() {}, RecycleGuardPosition() {},
    IssuePointOrder(u, order, x, y) { orders.push({ unit: u, order, x, y }); u.order = order; return true; },
    IssueImmediateOrder(u, order) {
      orders.push({ unit: u, order });
      if (state.acceptsHarvest) u.order = 'harvest';
      return state.acceptsHarvest;
    },
    TQAddUnitJob: (delay, job, parameter, unit) => jobs.push({ delay, job, parameter, unit }),
  };
  const context = vm.createContext(state);
  const common = read('common.eai');
  for (const name of ['CopyGroup', 'UnitHashtableSize', 'AddUnitsToHashtable', 'ReturnUnitsOfHashtable',
    'ReturnLivingUnitsOfHashtable', 'FlushUnitHashtable', 'RemoveUnitFromHashtable']) {
    vm.runInContext(compile(common, name), context);
  }
  vm.runInContext(compile(read('races.eai'), 'ReturnGhoulsToHarvest'), context);
  vm.runInContext(compile(read('Jobs/GHOUL_RETURN_HOME.eai'), 'GhoulReturnHomeJob'), context);
  return {
    state, units, orders, jobs, groups,
    addGhoul(changes = {}) {
      const u = { type: 'ugho', owner: 0, alive: true, healing: false, buying: false, order: 0, x: 0, y: 0, ...changes };
      units.push(u);
      return u;
    },
    sendHome(u) {
      const g = state.CreateGroup();
      state.GroupAddUnit(g, u);
      state.AddUnitsToHashtable(state.returning_ghouls, 0, 0, g);
      state.DestroyGroup(g);
    },
    isReturning(u) {
      const g = state.ReturnLivingUnitsOfHashtable(state.returning_ghouls, 0, 0, state.CreateGroup());
      const returning = g.has(u);
      state.DestroyGroup(g);
      return returning;
    },
    checkHome: u => state.GhoulReturnHomeJob(u),
    assignLumber: () => state.ReturnGhoulsToHarvest(),
  };
}
