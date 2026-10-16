// Run from the repository root: node --test tests/strategy-selection.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { strategySelectionGame } from './helpers/strategy-selection-game.mjs';

for (const version of ['REFORGED', 'TFT', 'ROC']) {
  describe(version + ' strategy selection', () => {
    for (const race of ['Undead', 'Human', 'Orc', 'Elf']) {
      it(`Given ${race} starts a game, when weights are calculated, then each strategy receives its configured base weight`, () => {
        const game = strategySelectionGame(version, race);

        game.calculateWeights();

        for (const row of game.rows) {
          assert.equal(game.weight(row[0]), Number(row[12]), row[0]);
        }
      });
    }

    it('Given Undead in a 3v3v3v3 with Human allies and all enemy races, when picking a strategy, then team bonuses use the correct base and every weighted strategy is reachable', () => {
      const game = strategySelectionGame(version, 'Undead');
      game.state.c_ally_total = 2;
      game.state.c_ally[game.state.R_HUMAN] = 2;
      for (const race of ['ELF', 'HUMAN', 'ORC', 'UNDEAD']) {
        game.state.c_enemy[game.state['R_' + race]] = race === 'ELF' ? 3 : 2;
      }

      game.calculateWeights();

      for (const row of game.rows) {
        const expected = Number(row[12]) + Number(row[13]) +
          row.slice(17, 21).reduce((sum, value) => sum + Number(value), 0) + Number(row[22]);
        assert.equal(game.weight(row[0]), Math.max(0, expected), row[0]);
      }
      let cumulative = 0;
      for (let id = 0; id < game.rows.length; id++) {
        const weight = game.state.rp_strat[id];
        if (weight > 0) {
          assert.equal(game.pick(cumulative + 1), id);
          assert.equal(game.pick(cumulative + weight), id);
        }
        cumulative += weight;
      }
    });
  });
}
