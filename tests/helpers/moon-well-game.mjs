import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

const source = readFileSync(new URL('../../Jobs/MOON_WELL_CONTROL.eai', import.meta.url), 'utf8');

export function moonWellGame() {
  const wells = [];
  const orders = [];
  const jobs = [];
  const state = {
    ...groupNatives(), ai_player: 0, old_id: [1], racial_farm: 0,
    UNIT_STATE_LIFE: 'life', UNIT_STATE_MAX_LIFE: 'maxLife', UNIT_STATE_MANA: 'mana',
    UNIT_TYPE_SUMMONED: 'summoned', UNIT_TYPE_HERO: 'hero',
    RESET_GUARD_POSITION: 'reset', MOON_WELL_CONTROL: 'heal', SEND_HOME: 'home',
    home_location: { x: 0 },
    GroupEnumUnitsOfPlayer: g => wells.forEach(w => g.add(w)),
    SelectByAlive: g => new Set([...g].filter(u => u.life > 0)),
    UnitAlive: u => u.life > 0, GetUnitTypeId: u => u.id,
    GetUnitState: (u, field) => u[field],
    DistanceBetweenUnits: (a, b) => Math.abs(a.x - b.x),
    DistanceBetweenPoints_dk: (a, b) => Math.abs(a.x - b.x),
    GetUnitLoc: u => u, GetUnitX: u => u.x, GetUnitY: () => 0,
    GetLocationX: l => l.x, GetLocationY: () => 0,
    GetLocationNonCreepStrength: () => 0, GetUnitAbilityLevel: () => 0,
    IsUnitType: (u, type) => !!u[type], I2R: n => n,
    DisplayToAllJobDebug() {},
    IssueTargetOrder: (unit, order, target) => orders.push({ unit, order, target }),
    IssuePointOrder: (unit, order, x, y) => orders.push({ unit, order, x, y }),
    TQAddUnitJob: (delay, job, threshold, unit) => jobs.push({ delay, job, threshold, unit }),
  };
  vm.runInContext(['GetMoonWell', 'HeadtoMoonWell', 'MoonWellJob'].map(n => compile(source, n)).join('\n'), vm.createContext(state));
  return {
    orders, jobs,
    addWell(x, properties = {}) {
      const well = { x, id: 1, mana: 100, life: 500, ...properties };
      wells.push(well);
      return well;
    },
    patient: (x, properties = {}) => ({ x, life: 30, maxLife: 100, ...properties }),
    checkHealing: unit => state.MoonWellJob(unit, 80),
  };
}
