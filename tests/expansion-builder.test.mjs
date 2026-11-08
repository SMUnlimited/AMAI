import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { expansionBuilderGame } from './helpers/expansion-builder-game.mjs';

describe('Expansion evaluation during a mine shortage', () => {
  it('waits 30 game seconds after finding no mine and clears the old creep request', () => {
    const game = expansionBuilderGame();

    game.checkExpansion();
    for (let second = 1; second < 30; second++) {
      game.advanceTo(second);
      game.checkExpansion();
    }

    assert.deepEqual(game.choices, [0]);
    assert.equal(game.state.take_exp, false);
    assert.equal(game.scans.length, 0);
    assert.deepEqual(game.builds, []);

    game.advanceTo(30);
    game.checkExpansion();

    assert.deepEqual(game.choices, [0, 30]);
  });

  it('takes its first expansion with only one harvested mine after the backoff expires', () => {
    const game = expansionBuilderGame({ mines: 1 });
    game.checkExpansion();
    game.state.selection = game.sites[0];

    game.advanceTo(30);
    game.checkExpansion();

    assert.equal(game.state.current_expansion, game.sites[0]);
    assert.deepEqual(game.builds, [{ qty: 2, id: 1, priority: 60 }]);
    assert.equal(game.scans.length, 32);
  });

  it('rebuilds with no harvested mines instead of requiring an existing expansion', () => {
    const game = expansionBuilderGame({ mines: 0 });
    game.state.current_expansion = game.sites[0];

    game.checkExpansion();

    assert.deepEqual(game.builds, [{ qty: 1, id: 1, priority: 100 }]);
  });

  it('replaces a taken target immediately when another mine is available', () => {
    const game = expansionBuilderGame();
    game.sites[0].taken = true;
    game.state.current_expansion = game.sites[0];
    game.state.selection = game.sites[1];

    game.checkExpansion();

    assert.equal(game.state.current_expansion, game.sites[1]);
    assert.equal(game.builds.length, 1);
    assert.equal(game.state.expansion_evaluation_retry_time, 0);
  });

  it('backs off when selection returns a target that is already taken', () => {
    const game = expansionBuilderGame();
    game.sites[0].taken = true;
    game.state.selection = game.sites[0];

    game.checkExpansion();
    game.advanceTo(29);
    game.checkExpansion();

    assert.deepEqual(game.choices, [0]);
    assert.equal(game.state.current_expansion, null);
    assert.equal(game.state.take_exp, false);
    assert.deepEqual(game.builds, []);
  });

  it('backs off repeated rebuild scans when reselecting a rebuild finds no mine', () => {
    const game = expansionBuilderGame();
    game.state.current_expansion = game.sites[0];
    game.state.rebuildSite = game.sites[1];
    game.state.foe = {};

    game.checkExpansion();
    game.advanceTo(29);
    game.checkExpansion();

    assert.equal(game.scans.length, 32);
    assert.deepEqual(game.choices, [0]);
    assert.equal(game.state.take_exp, false);
    assert.deepEqual(game.builds, []);
  });
});
