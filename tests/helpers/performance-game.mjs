// Count work in production JASS; native combat behavior still needs a Warcraft game.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { groupNatives } from './warcraft-natives.mjs';

// Exclude the commented-out older parser, and preserve integer heap division.
const source = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8')
  .replace(/^\s*\/\/.*$/gm, '').replace(/\bpos\/2/g, 'Math.trunc(pos/2)');

export function performanceGame({ capacity = 8192 } = {}) {
  const units = [], assaults = [], groups = new Set();
  const work = { visits: 0, groups: 0 };
  const natives = groupNatives(groups);
  const state = {
    ai_player: 0, player_defeated: false, attacktable: new Map(),
    attack_length: 0, attack_units: [], old_id: [],
    UNIT_TYPE_PEON: 'worker', UNIT_TYPE_STRUCTURE: 'structure', UNIT_TYPE_SUMMONED: 'summoned',
    UNIT_TYPE_ANCIENT: 'ancient', UNIT_TYPE_ATTACKS_FLYING: 'air', UNIT_TYPE_ATTACKS_GROUND: 'ground',
    ...natives,
    CreateGroup() { work.groups++; return natives.CreateGroup(); },
    GroupRemoveUnit(g, u) { work.visits++; natives.GroupRemoveUnit(g, u); },
    GroupEnumUnitsOfPlayer: (g, owner) => units.filter(u => u.owner === owner).forEach(u => g.add(u)),
    UnitAlive: u => Boolean(u?.alive), IsUnitHidden: u => u.hidden,
    IsUnitType: (u, kind) => Boolean(u[kind]), GetUnitTypeId: u => u.type,
    AddAssault: (qty, type) => { assaults.push({ qty, type }); return true; },
    LoadBoolean: (table, parent, child) => table.get(`${parent}:${child}`) ?? false,
    SaveBoolean: (table, parent, child, value) => table.set(`${parent}:${child}`, value),
    FlushChildHashtable(table, parent) {
      for (const key of table.keys()) if (key.startsWith(`${parent}:`)) table.delete(key);
    },
    Trace() {},
    tq_length: 0, tq_lock: true, JASS_MAX_ARRAY_SIZE: capacity, BUILD_EXPANSION: 46,
    expansion_job_pending: new Map(),
    GetHandleId: u => u?.id ?? 0,
    GetTQLock() { state.onLock?.(); assert.equal(state.tq_lock, true); state.tq_lock = false; },
    ReleaseTQLock() { assert.equal(state.tq_lock, false); state.tq_lock = true; },
    ModuloInteger: (a, b) => a % b, Sleep() { assert.fail('Unexpected sleep'); },
    chat_eq: 0, chat_race: '', char_table_length: 1, char_bug_table: ['{'], char_table: ['{'],
    COMPARE_TRUE: 0, COMPARE_EQ: 1, COMPARE_UNEQ: 2,
    COMPARE_GREATER: 3, COMPARE_LESS: 4, COMPARE_GREATER_EQ: 5, COMPARE_LESS_EQ: 6,
    StringLength: s => s.length,
    GetChatVar: key => key === 'Gold' ? '100' : '',
    GetChatVarB: key => key === 'Ready', GetChatVarR: () => 100, S2R: Number,
  };
  // Strict bounds expose JASS array overflow instead of silently growing a JS array.
  for (const suffix of ['time', 'jid', 'par', 'unit_par', 'group_par', 'unit_par2']) {
    const values = Array(capacity).fill(suffix.includes('par') && suffix !== 'par' ? null : 0);
    state['tq_' + suffix] = new Proxy(values, {
      get(target, index) {
        assert.ok(Number.isInteger(Number(index)) && Number(index) >= 0 && Number(index) < capacity, `Queue read outside capacity: ${index}`);
        return target[index];
      },
      set(target, index, value) {
        assert.ok(Number.isInteger(Number(index)) && Number(index) >= 0 && Number(index) < capacity, `Queue write outside capacity: ${index}`);
        target[index] = value;
        return true;
      },
    });
  }
  const context = vm.createContext(state);
  const types = new Map([['tq_length', 'integer'], ['tq_jid', 'integer'], ['tq_par', 'integer']]);
  for (const name of [
    'SelectUnittype', 'SelectByHidden', 'SelectByAlive', 'SelectById',
    'AttackGroupAddUnknown', 'DesperationAssault', 'LookupCT', 'GetChar', 'CompareReal', 'CheckChatCondition',
    'TQCopy', 'TQExchange', 'TQUpHeap', 'TQFillPos', 'TQRemoveRoot', 'TQAddJobEx',
  ]) vm.runInContext(compile(source, name, types), context);

  return {
    state, units, assaults, groups, work,
    addUnit(type, changes = {}) {
      const u = { type, owner: 0, alive: true, hidden: false, ground: true, ...changes };
      units.push(u);
      return u;
    },
    collectArmy: () => state.AttackGroupAddUnknown(),
    reinforce: () => state.DesperationAssault(),
    enqueue: (time, jid = 1, worker = null, mine = null) => state.TQAddJobEx(time, jid, 0, worker, null, mine),
    checkChat(text) {
      state.text = text;
      return vm.runInContext('CheckChatCondition(text)', context, { timeout: 100 });
    },
  };
}
