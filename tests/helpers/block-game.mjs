// Execute the production FIX_BLOCK request lifecycle. Repair actions are observed
// at their boundaries; Warcraft collision and tree selection need in-game checks.
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { pathingGame } from './pathing-game.mjs';

export function blockGame() {
  const game = pathingGame(), jobs = [], repairs = [];
  const state = game.state;
  Object.assign(state, {
    BLOCK_CHECK_HOME: 0, BLOCK_CHECK_HERO_MOVEMENT: 1, BLOCK_CHECK_HERO_STRUCTURES: 2, BLOCK_CHECK_OTHER: 3,
    blockstate: 0, ancient_move_attempts: 0, blocking_path_request: 0, blocking_tree_check: false,
    blocking_ancient: null, blocked_unit: null, town_threatened: false, attack_running: true,
    teleporting: false, water_map: false, front_base_distance: 2000, enemy_force: [1], hero_unit: [],
    race_no_wood_harvest: false, RACE_NIGHTELF: 'elf', FIX_BLOCK: 7,
    TownThreatened: () => state.town_threatened, GetPlayerStructureCount: () => 10,
    GetPlayerRace: () => 'human', GetPlayerStartLocationLoc: () => game.location(8000, 0),
    DistanceBetweenPoints: (a, b) => Math.hypot(a.x - b.x, a.y - b.y),
    DistanceBetweenPoints_kd(a, b) {
      const distance = state.DistanceBetweenPoints(a, b);
      state.RemoveLocation(b);
      return distance;
    },
    RootAncient: () => { state.blocking_ancient = null; },
    MoveAncient() {}, TryFixBlockMove() {}, CreateDebugTag() {}, DisplayToAllJobDebug() {},
    TryFixBlockRemoveTree: l => repairs.push({ action: 'tree', x: l.x, y: l.y }),
    TryFixBlockStructure: l => repairs.push({ action: 'structure', x: l.x, y: l.y }),
    TQAddJob: (delay, job, par) => jobs.push({ delay, job, par }), Int2Str: String, Min: Math.min,
  });
  const source = readFileSync(new URL('../../Jobs/FIX_BLOCK.eai', import.meta.url), 'utf8');
  const context = vm.createContext(state);
  for (const name of ['RemoveBlockPathCheck', 'FindTree', 'ShouldSkipBlockCheck', 'CleanupBlockFix', 'FixBlockJob']) {
    vm.runInContext(compile(source, name), context);
  }
  return {
    ...game, jobs, repairs,
    checkBlock() { jobs.length = 0; state.FixBlockJob(); },
    finishProbe() {
      game.poll();
      while (game.result(state.blocking_path_request) === state.PATHING_CHECK_PENDING) {
        game.advance(2);
        game.poll();
        if (state.now > 1000) throw new Error('Block probe did not finish');
      }
    },
  };
}
