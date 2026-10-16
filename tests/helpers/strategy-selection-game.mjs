import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import vm from 'node:vm';
import { compile, zeros } from './jass.mjs';

const root = new URL('../../', import.meta.url);
const common = readFileSync(new URL('common.eai', root), 'utf8');

export function strategySelectionGame(version, race) {
  const result = spawnSync('perl', ['ejass.pl', 'races.eai', version, 'VER:' + version,
    race.toUpperCase(), 'RACE:' + race.toUpperCase()], {
    cwd: fileURLToPath(root), encoding: 'utf8', maxBuffer: 8 * 1024 * 1024,
  });
  assert.equal(result.error, undefined, 'Perl must run to expand the production strategy tables');
  assert.equal(result.status, 0, result.stderr);
  const source = result.stdout;
  const rows = readFileSync(new URL(`${version}/${race}/Strategy.txt`, root), 'utf8')
    .trim().split(/\r?\n/).slice(1).map(row => row.split('\t'));
  const state = {
    ai_time: 0, rp_strat: zeros(), rp_strat_length: rows.length,
    c_ally_total: 0, c_enemy: zeros(), c_ally: zeros(),
    game_is_1on1: false, game_is_ffa: false,
    // Isolate table weights from personality and teammate choices.
    AddFavoriteUnitRP() {},
    R_RANDOM: 0, R_ELF: 1, R_HUMAN: 2, R_ORC: 3, R_UNDEAD: 4,
    GetRandomInt: () => state.roll,
  };
  for (const [, name, id] of source.matchAll(/constant integer (STRAT_\w+) = (\d+)/g)) {
    state[name] = Number(id);
  }
  const context = vm.createContext(state);
  vm.runInContext(compile(source, 'chooseStrategyRP') + '\n' +
    ['mult_rp_strat', 'div_rp_strat', 'make_rp_strat_positive', 'sum_rp_strat', 'choose_strategy']
      .map(name => compile(common, name)).join('\n'), context);
  return {
    state, rows,
    calculateWeights: () => state.chooseStrategyRP(),
    weight: name => state.rp_strat[state['STRAT_' + name]],
    pick(roll) {
      state.roll = roll;
      return state.choose_strategy();
    },
  };
}
