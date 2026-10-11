import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';

const source = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');
const script = new vm.Script(['BuildFarms', 'FarmBuilder'].map(name => compile(source, name)).join('\n'));

// Warcraft supplies the counts, selects builders and places normal production.
// These scenarios execute the production request logic, not native construction.
export function farmGame({ done = 2, pending = 1, space = 0, threshold = -4 } = {}) {
  const requests = [];
  const state = {
    ai_time: 0, farm_previous_done: 0, farm_previous_pending: 0,
    farm_recovery_target: 0, farm_recovery_until: 0,
    racial_farm: 1, farm_prio: 400, max_farms: 20,
    farm_food: 8, farm_food2: threshold, ver_food_limit: 100,
    race_farms_at_mine: 0, race_build_farms_front: false,
    race_farms_front_limit: 1, front_locs_computed: true,
    done, pending, space, cap: 40,
    Min: Math.min, Max: Math.max,
    TownCountDone: () => state.done,
    TownCount: () => state.done + state.pending,
    FoodCap: () => state.cap, FoodSpace: () => state.space,
  };
  for (const [name, placement] of [['BuildUnit', 'base'], ['BuildFront', 'front'], ['BuildAtMine', 'mine']]) {
    state[name] = target => requests.push({ target, placement });
  }
  script.runInContext(vm.createContext(state));
  return {
    state, requests,
    checkFarms() { requests.length = 0; state.FarmBuilder(); },
    loseFarm() { state.pending--; },
    completeFarm() { state.pending--; state.done++; },
    startFarm() { state.pending++; },
    advance(seconds) { state.ai_time += seconds / 5; },
  };
}
