import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { zeppelinGame } from './helpers/zeppelin-game.mjs';

describe('Zeppelin rescue pickup', () => {
  it('abandons pickup when the Zeppelin already carries army passengers', () => {
    const game = zeppelinGame();
    game.units.push({ transport: game.zeppelin });

    game.rescue();

    assert.deepEqual(game.orders, []);
    assert.equal(game.jobs.at(-1).job, 'home');
    assert.equal(game.state.unit_rescueing.has(game.zeppelin), false);
    assert.equal(game.state.follow_zeppelin, null);
    assert.equal(game.state.zeppelin_trips.size, 0);
  });

  it('releases an unreachable passenger after sixty seconds of unsuccessful pickup', () => {
    const game = zeppelinGame();
    game.state.IssueTargetOrder = () => false;

    for (let retry = 0; retry <= 30; retry++) game.rescue();

    assert.equal(game.jobs.filter(job => job.job === 'transport').length, 30);
    assert.equal(game.jobs.at(-1).job, 'home');
    assert.equal(game.state.unit_rescueing.has(game.zeppelin), false);
    assert.equal(game.state.zeppelin_trips.size, 0);
  });

  it('waits for confirmed unloading before starting the passenger recovery job', () => {
    const game = zeppelinGame();
    game.passenger.loaded = true;
    game.zeppelin.x = 0;

    game.rescue();

    assert.equal(game.orders.at(-1).order, 'unloadall');
    assert.ok(game.jobs.every(job => job.job === 'transport'));
    assert.ok(game.state.unit_rescueing.has(game.zeppelin));

    game.passenger.loaded = false;
    game.rescue();

    assert.equal(game.jobs.at(-1).job, 'home');
    assert.equal(game.state.unit_rescueing.has(game.zeppelin), false);
    assert.equal(game.state.zeppelin_trips.size, 0);
  });

  it('keeps a second rescue travelling while the first rescue unloads', () => {
    const game = zeppelinGame();
    const second = game.addRescue();
    game.passenger.loaded = true;
    game.zeppelin.x = 0;
    second.passenger.transport = second.zeppelin;

    game.rescue();
    game.orders.length = 0;
    second.rescue();

    assert.deepEqual(game.orders, [{ unit: second.zeppelin, order: 'move' }]);
  });

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

describe('Zeppelin follow and expansion ownership', () => {
  it('leaves a reserved expansion Zeppelin alone', () => {
    const game = zeppelinGame();

    game.follow();

    assert.deepEqual(game.orders, []);
    assert.equal(game.state.follow_zeppelin, null);
    assert.deepEqual(game.recycled, []);
  });

  it('returns an occupied follow Zeppelin to native transport without changing its orders', () => {
    const game = zeppelinGame();
    game.state.unit_rescueing.clear();
    game.state.unit_zepplin_move.clear();
    game.passenger.loaded = true;

    game.follow();

    assert.deepEqual(game.orders, []);
    assert.equal(game.state.follow_zeppelin, null);
    assert.deepEqual(game.recycled, [game.zeppelin]);
  });

  it('selects an empty Zeppelin when the nearest candidate is carrying passengers', () => {
    const game = zeppelinGame();
    const empty = { x: 8000, y: 0, life: 100 };
    game.units.push(empty, { transport: game.zeppelin });
    game.state.unit_rescueing.clear();
    game.state.unit_zepplin_move.clear();
    game.state.follow_zeppelin = null;

    game.follow();

    assert.equal(game.state.follow_zeppelin, empty);
    assert.deepEqual(game.orders, [{ unit: empty, order: 'move', target: game.passenger }]);
  });

  it('skips occupied Zeppelins when selecting expansion transport', () => {
    const game = zeppelinGame();
    const empty = { x: 8000, y: 0, life: 100 };
    game.units.push(empty, { transport: game.zeppelin });
    game.state.unit_rescueing.clear();
    game.state.unit_zepplin_move.clear();

    const selected = game.state.GetUnusedZeppelinNearUnit(null, game.passenger);

    assert.equal(selected, empty);
  });

  it('keeps expansion ownership when an unload order fails', () => {
    const game = zeppelinGame();
    game.passenger.loaded = true;
    game.state.IssueTargetOrder = () => false;

    const delivered = game.deliverWorker();

    assert.equal(delivered, false);
    assert.equal(game.state.build_zeppelin, game.zeppelin);
    assert.ok(game.state.unit_zepplin_move.has(game.zeppelin));
    assert.deepEqual(game.recycled, []);
  });

  it('releases expansion ownership only after the worker leaves the Zeppelin', () => {
    const game = zeppelinGame();
    game.passenger.loaded = true;
    game.state.Sleep = () => { game.passenger.loaded = false; };

    const delivered = game.deliverWorker();

    assert.equal(delivered, true);
    assert.equal(game.state.build_zeppelin, null);
    assert.equal(game.state.unit_zepplin_move.has(game.zeppelin), false);
    assert.deepEqual(game.recycled, [game.zeppelin]);
  });
});
