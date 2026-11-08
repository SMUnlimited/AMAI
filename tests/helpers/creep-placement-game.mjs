// Execute the production early Ancient placement using the shared pathing queue.
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { pathingGame } from './pathing-game.mjs';

export function creepPlacementGame() {
  const game = pathingGame(), camps = [], mines = [], orders = [];
  const worker = { id: 90, x: 0, y: 0, alive: true, order: 'harvest' };
  const state = game.state;
  const filter = (g, predicate) => { for (const u of g) if (!predicate(u)) g.delete(u); return g; };
  Object.assign(state, {
    PLAYER_NEUTRAL_AGGRESSIVE: 12, PLAYER_NEUTRAL_PASSIVE: 15, UNIT_TYPE_FLYING: 'flying', UNIT_TYPE_PEON: 'peon',
    uGOLD_MINE: 1, racial_rushcreep: 2, old_id: [0, 100, 200],
    br_rush_built: false, br_pathing_retry: false, rushcreep_target: null,
    ver_creeps_attack_buildings_dist: 600,
    GroupEnumUnitsInRange(g, x, y, r) {
      for (const u of [...camps, ...mines]) if (Math.hypot(u.x - x, u.y - y) <= r) g.add(u);
    },
    SelectByPlayer: (g, p) => filter(g, u => u.owner === p),
    SelectUnittype: (g, type, matches) => filter(g, u => Boolean(u[type]) === matches),
    SelectByAlive: g => filter(g, u => state.UnitAlive(u)),
    SelectById: (g, id) => filter(g, u => u.id === id),
    GetCreepCampStrength: u => u.strength, GetUnitLevel: () => 3,
    DistanceBetweenPoints: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    GetLocationCreepStrength: () => 0, GetExpansionPeon2: () => worker,
    Player: p => p, RemoveGuardPosition() {},
    CreateUnit: (owner, id, x, y) => ({ owner, id, x, y, alive: true }),
    IssuePointOrderByIdLoc: (u, id, l) => orders.push({ unit: u, id, x: l.x, y: l.y }),
  });
  const source = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');
  const context = vm.createContext(state);
  for (const name of ['BuildBRAtCreep', 'GetBuildLocationAtPoint', 'GetBuildLocationInDistanceFromLoc_d']) {
    vm.runInContext(compile(source, name), context);
  }
  return {
    ...game, orders, worker,
    addCamp(properties = {}) {
      const camp = { id: 500 + camps.length, x: 2000, y: 0, owner: 12, alive: true, strength: 5, ...properties };
      camps.push(camp);
      return camp;
    },
    addMine: (x, y = 0) => mines.push({ id: 100, x, y, owner: 15, alive: true }),
    build: () => state.BuildBRAtCreep(),
  };
}
