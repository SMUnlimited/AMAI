// Run: node --test --test-reporter=spec tests/harvest-groups.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { expansionGame } from './helpers/expansion-game.mjs';

describe('Harvest group cleanup', () => {
  it('Given two Orc mines, when gold assignment repeats, then both are checked and no temporary groups remain', () => {
    const game = expansionGame('orc');
    const home = game.addMine();
    game.addHall();
    const expansion = game.addMine('ngol', { x: 2500 });
    game.addHall({ x: 2900 });

    for (let pass = 0; pass < 100; pass++) game.assignGold();

    assert.equal(game.checkedMines.length, 200);
    assert.deepEqual(game.checkedMines.slice(-2), [home, expansion]);
    assert.equal(game.activeGroupCount(), 0);
  });

  it('Given a threatened Human town, when assigning gold, then only its home mine is checked and no temporary groups remain', () => {
    const game = expansionGame('human');
    const home = game.addMine();
    game.addHall();
    game.addMine('ngol', { x: 2500 });
    game.addHall({ x: 2900 });
    game.state.town_mine[0] = home;
    game.state.town_threatened = true;

    game.assignGold();

    assert.deepEqual(game.checkedMines, [home]);
    assert.equal(game.activeGroupCount(), 0);
  });
});
