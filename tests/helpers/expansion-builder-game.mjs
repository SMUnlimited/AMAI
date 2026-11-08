import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';

const common = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');

// Run the production builder; selection and native scans are observable boundaries.
export function expansionBuilderGame({ mines = 1, mineCount = 32 } = {}) {
  const choices = [];
  const builds = [];
  const scans = [];
  const sites = Array.from({ length: mineCount }, () => ({ taken: false }));
  const state = {
    now: 0, tq_timer: null, expansion_evaluation_retry_time: 0,
    first_expansion_chosen: true, current_expansion: null, take_exp: true,
    ai_time: 100, exp_time_count: 0, exp_first_time: 0, exp_second_time: 0,
    attacking_aggression: 0, specialexpand: false,
    expansion_list_length: mineCount, expansion_list: sites,
    bad_expansion_flag: sites.map(() => 0), expansion_dist: sites.map(() => 0),
    expansion_ancient: sites.map(() => null), water_expansion_list_length: 0,
    rebuild_exp_number: 0, prev_rebuild_exp_count: 0, prefer_rebuild_now: false,
    rebuildSite: null, selection: null, foe: null,
    race_militia_expansion_available: false, race_ancient_expansion_available: false,
    race_item_expansion_available: false, UPKEEP_NUM: 0,
    racial_expansion: 1, expa_emergency_prio: 100, expa_rebuild_prio: 80, expa_prio: 60,
    TimerGetElapsed: () => state.now, GetMinesHarvested: () => mines,
    GetGoldOwned: () => 10000, GetGold: () => 0, GetWood: () => 0,
    IsExpansionRebuildCoolingDown: mine => Boolean(mine.cooling),
    CheckExpansionTaken: mine => mine.taken,
    ChooseExpansion() { choices.push(state.now); state.current_expansion = state.selection; },
    CheckExpansionRebuildAt(mine) { scans.push(mine); return mine === state.rebuildSite; },
    add_rebuild_exp() { state.rebuild_exp_number++; },
    IsWaterExpansion: () => false, CheckFastExpansion() {}, GetExpFoe: () => state.foe,
    FoodUsed: () => 20, GetUnitX: () => 0, GetUnitY: () => 0,
    TownCountDone: () => mines, CreateDebugTagLoc() {}, Trace() {},
    BuildExpa: (qty, id, priority) => builds.push({ qty, id, priority }),
  };
  vm.runInContext(compile(common, 'ExpansionBuilder'), vm.createContext(state));
  return {
    state, sites, choices, builds, scans,
    checkExpansion: () => state.ExpansionBuilder(),
    advanceTo: seconds => { state.now = seconds; },
  };
}
