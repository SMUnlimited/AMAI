// Run: node --test --test-reporter=spec tests/ghoul-harvest.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { ghoulGame } from './helpers/ghoul-game.mjs';

describe('Ghouls returning home to gather lumber', () => {
  it('Given a ghoul at home whose harvest order fails, when its return job runs, then it remains pending with a retry scheduled', () => {
    const game = ghoulGame();
    const ghoul = game.addGhoul();
    game.sendHome(ghoul);
    game.state.acceptsHarvest = false;

    game.checkHome(ghoul);

    assert.equal(ghoul.order, 0);
    assert.equal(game.isReturning(ghoul), true);
    assert.equal(game.jobs.length, 1);
    assert.equal(game.jobs[0].unit, ghoul);
    assert.equal(game.groups.size, 0);
  });

  it('Given a ghoul that has started harvesting, when its return job checks again, then it leaves the return registry without interrupting harvest', () => {
    const game = ghoulGame();
    const ghoul = game.addGhoul({ order: 'harvest' });
    game.sendHome(ghoul);

    game.checkHome(ghoul);

    assert.equal(game.isReturning(ghoul), false);
    assert.deepEqual(game.orders, []);
    assert.deepEqual(game.jobs, []);
  });

  it('Given a returning ghoul recovering through healing, when its job runs, then healing is preserved and the return checks later', () => {
    const game = ghoulGame();
    const ghoul = game.addGhoul({ healing: true, order: 'cannibalize' });
    game.sendHome(ghoul);

    game.checkHome(ghoul);

    assert.equal(ghoul.order, 'cannibalize');
    assert.deepEqual(game.orders, []);
    assert.equal(game.jobs.length, 1);
  });

  it('Given a rejected lumber order followed by an accepted order, when return checks run again, then harvesting starts and returning status is cleared', () => {
    const game = ghoulGame();
    const ghoul = game.addGhoul();
    game.sendHome(ghoul);
    game.state.acceptsHarvest = false;
    game.checkHome(ghoul);

    game.state.acceptsHarvest = true;
    game.checkHome(ghoul);
    game.checkHome(ghoul);

    assert.equal(ghoul.order, 'harvest');
    assert.equal(game.isReturning(ghoul), false);
    assert.equal(game.jobs.length, 2);
    assert.equal(game.groups.size, 0);
  });

  it('Given a ghoul whose return was cancelled, when a stale job runs, then it issues no orders or successor job', () => {
    const game = ghoulGame();
    const ghoul = game.addGhoul();

    game.checkHome(ghoul);

    assert.deepEqual(game.orders, []);
    assert.deepEqual(game.jobs, []);
    assert.equal(game.groups.size, 0);
  });

  it('Given a returning ghoul that is killed, when its job runs, then the dead handle leaves the return registry', () => {
    const game = ghoulGame();
    const ghoul = game.addGhoul();
    game.sendHome(ghoul);

    ghoul.alive = false;
    game.checkHome(ghoul);

    assert.equal(game.state.UnitHashtableSize(game.state.returning_ghouls, 0, 0), 0);
    assert.deepEqual(game.orders, []);
  });

  it('Given a returning ghoul now harvesting and no further lumber demand, when allocation runs, then return tracking stays empty without leaking groups', () => {
    const game = ghoulGame();
    const ghoul = game.addGhoul({ order: 'harvest' });
    game.sendHome(ghoul);
    game.checkHome(ghoul);

    game.assignLumber();

    assert.equal(game.isReturning(ghoul), false);
    assert.deepEqual(game.orders, []);
    assert.equal(game.groups.size, 0);
  });

  it('Given one ghoul still returning, when lumber allocation repeats, then its unit table remains one entry and temporary groups are released', () => {
    const game = ghoulGame();
    const ghoul = game.addGhoul({ x: 1500, order: 'move' });
    game.sendHome(ghoul);

    for (let pass = 0; pass < 100; pass++) game.assignLumber();

    assert.equal(game.state.UnitHashtableSize(game.state.returning_ghouls, 0, 0), 1);
    assert.equal(game.isReturning(ghoul), true);
    assert.equal(game.groups.size, 0);
  });

  it('Given two returning ghouls, when one starts harvesting, then removing it preserves the other in one compact entry', () => {
    const game = ghoulGame();
    const harvesting = game.addGhoul({ order: 'harvest' });
    const returning = game.addGhoul({ x: 1500, order: 'move' });
    game.sendHome(harvesting);
    game.sendHome(returning);

    game.checkHome(harvesting);

    assert.equal(game.isReturning(harvesting), false);
    assert.equal(game.isReturning(returning), true);
    assert.equal(game.state.UnitHashtableSize(game.state.returning_ghouls, 0, 0), 1);
    assert.equal(game.groups.size, 0);
  });

  it('Given one living and one dead returner, when the allocation list is flushed, then only the living ghoul remains in the table', () => {
    const game = ghoulGame();
    const living = game.addGhoul({ x: 1500, order: 'move' });
    const dead = game.addGhoul({ alive: false });
    game.sendHome(living);
    game.sendHome(dead);

    game.assignLumber();

    assert.equal(game.state.UnitHashtableSize(game.state.returning_ghouls, 0, 0), 1);
    assert.equal(game.isReturning(living), true);
    assert.equal(game.groups.size, 0);
  });
});
