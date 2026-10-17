import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { zeppelinGame } from './helpers/zeppelin-game.mjs';

describe('Zeppelin rescue pickup', () => {
  it('Given a burrowed injured unit, when rescued, then it unburrows before any pickup orders', () => {
    const game = zeppelinGame();
    game.passenger.burrowed = true;

    game.rescue();

    assert.deepEqual(game.orders, [{ unit: game.passenger, order: 'unburrow' }]);
    assert.equal(game.jobs.at(-1).job, 'transport');
    assert.equal(game.jobs.at(-1).wait, 2);
  });

  it('Given a unit already emerging, when pickup retries, then it leaves the transformation uninterrupted', () => {
    const game = zeppelinGame();
    game.passenger.burrowed = true;
    game.passenger.order = 'unburrow';

    game.rescue();

    assert.deepEqual(game.orders, []);
    assert.equal(game.jobs.at(-1).job, 'transport');
  });

  it('Given a unit still executing Burrow, when rescue begins, then it waits before attempting to unburrow or board', () => {
    const game = zeppelinGame();
    game.passenger.order = 'burrow';

    game.rescue();

    assert.deepEqual(game.orders, []);
    assert.equal(game.jobs.at(-1).job, 'transport');
  });

  it('Given a unit that has finished emerging, when pickup retries, then both units receive boarding orders', () => {
    const game = zeppelinGame();

    game.rescue();

    assert.deepEqual(game.orders, [
      { unit: game.zeppelin, order: 'smart', target: game.passenger },
      { unit: game.passenger, order: 'smart', target: game.zeppelin },
    ]);
  });

  it('Given a loaded passenger, when travelling home, then it moves the zeppelin without trying to unburrow', () => {
    const game = zeppelinGame();
    game.passenger.loaded = true;

    game.rescue();

    assert.deepEqual(game.orders, [{ unit: game.zeppelin, order: 'move' }]);
  });

  it('Given a passenger healed before pickup, when rescue runs, then it releases the zeppelin', () => {
    const game = zeppelinGame();
    game.passenger.life = 90;

    game.rescue();

    assert.deepEqual(game.orders, []);
    assert.equal(game.state.unit_rescueing.has(game.zeppelin), false);
    assert.equal(game.state.unit_zepplin_move.has(game.zeppelin), false);
    assert.equal(game.jobs.at(-1).job, 'reset');
  });
});
