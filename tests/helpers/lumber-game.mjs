// Execute the source mine roster and manual loading with mocked Warcraft natives.
// HarvestWood scheduling, hidden wisps and accepted unload orders need game checks.
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const source = readFileSync(new URL('../../Jobs/HARVEST_CHECK.eai', import.meta.url), 'utf8');

export function lumberGame(race = 'orc', { gold = 1000, wood = 50 } = {}) {
  const mine = { id: 100, alive: true };
  const workers = Array.from({ length: 5 }, (_, i) => ({ id: i + 1, type: 'worker', order: 'harvest', loaded: race === 'elf' }));
  const assignments = [new Map(workers.map(u => [u.id, mine])), new Map()];
  const orders = [];
  const state = {
    gold, wood, race_manual_loading: race === 'elf', race_manual_loading_wisp: 1,
    race_has_ghouls: race === 'undead', race_uses_mine_expansion: race === 'undead',
    race_no_wood_harvest: false, maximum_peon_wood: 200, ver_optimal_gold: 5,
    racial_peon: 1, racial_militia: 0, old_id: { 1: 'worker' },
    harvest_assignments: assignments, harvestgrp: new Set(), harvest_available_peons: new Set(),
    harvest_mines: new Set([mine]), ai_player: 0, hero_built: [false, true],
    GetGold: () => state.gold, GetWood: () => state.wood, Max: Math.max, Min: Math.min,
    TownCount: () => 10, TownCountDone: () => 10, FoodSpace: () => 10,
    GetUnitTypeId: u => u.type, GetHandleId: u => u.id, GetUnitCurrentOrder: u => u.order,
    UnitAlive: u => u.alive !== false, GetResourceAmount: () => 10000, OrderId: s => s,
    ...groupNatives(),
    CopyGroup: g => new Set(g),
    GroupEnumUnitsOfPlayer: g => workers.forEach(u => g.add(u)),
    IsPeonReadyToHarvest: u => !u.reserved && !state.harvestgrp.has(u),
    SelectByPeons: g => new Set([...g].filter(state.IsPeonReadyToHarvest)),
    SelectByLoaded: (g, loaded) => new Set([...g].filter(u => u.loaded === loaded)),
    GetNearestSubGroupOfGroup: (g, loc, count) => new Set([...g].slice(0, count)),
    DistanceBetweenUnits: () => 0, GetNearestHarvestMine: () => mine,
    IsUnitInTransport: u => u.loaded, GetUnitLoc: () => ({}), RemoveLocation() {},
    SaveUnitHandle: (t, row, id, u) => t[row].set(id, u),
    LoadUnitHandle: (t, row, id) => t[row].get(id) ?? null,
    RemoveSavedHandle: (t, row, id) => t[row].delete(id),
    LoadInteger: (t, row, id) => t[row].get(id) ?? 0,
    SaveInteger: (t, row, id, value) => t[row].set(id, value),
    FlushChildHashtable: (t, row) => t[row].clear(),
    IssueImmediateOrder(u, order) { orders.push({ unit: u, order }); u.order = order; },
    IssueTargetOrder(u, order, target) {
      orders.push({ unit: u, order, target });
      if (order === 'unload') { target.loaded = false; target.order = 'stop'; }
      else { u.order = order; u.loaded = race === 'elf'; }
      return true;
    },
    DisplayToAllJobDebug() {}, Trace() {}, Int2Str: String,
  };
  const context = vm.createContext(state);
  for (const name of ['GetHarvestGoldTarget', 'SetPeonHarvestMine', 'RefreshHarvestPeons',
    'TakeNearestHarvestPeon', 'CountPeonsInMine', 'PeonMineCheck']) {
    vm.runInContext(compile(source, name), context);
  }
  return {
    state, mine, workers, orders,
    checkHarvest() { state.RefreshHarvestPeons(); return state.PeonMineCheck(mine); },
  };
}
