import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { blockGame } from './helpers/block-game.mjs';

const rawcode = text => [...text].reduce((n, c) => n * 256 + c.charCodeAt(0), 0);

describe('Blockage probes through the pathing thread', () => {
  it('Given a home escape check, when its job runs, then it queues the original large collision unit without creating a probe itself', () => {
    const game = blockGame();

    game.checkBlock();

    assert.equal(game.probes.length, 0);
    assert.equal(game.state.now, 0);
    assert.equal(game.state.blockstate, game.state.BLOCK_CHECK_HERO_MOVEMENT);
    assert.equal(game.jobs[0].delay, 10);
    game.poll();
    assert.equal(game.probes[0].id, rawcode('hbew'));
    assert.equal(game.probes[0].speed, 522);
    assert.equal(game.probes[0].target.x, 8000);
    assert.ok(game.probes[0].expires < 20);
  });

  it('Given a blocked escape and a nearby tree, when both probes finish, then the final harvest order selects tree removal and releases both probes', () => {
    const game = blockGame();
    game.state.treeFound = true;
    game.state.harvestPoint = { x: 100, y: 50 };

    game.checkBlock();
    game.finishProbe();
    game.checkBlock();
    assert.equal(game.probes.length, 1, 'Tree search stays queued until the thread runs');
    game.finishProbe();
    game.checkBlock();

    assert.deepEqual(game.repairs, [{ action: 'tree', x: 100, y: 50 }]);
    assert.equal(game.probes[1].id, rawcode('ewsp'));
    assert.equal(game.probes[1].speed, 300);
    assert.equal(game.probes[1].issuedOrder, 'autoharvestlumber');
    assert.ok(game.probes.every(probe => probe.removed));
    assert.equal(game.state.blocking_path_request, 0);
    assert.equal(game.locations.size, 1);
  });

  it('Given a tree search that finds no tree, when its result is consumed, then the job investigates structures at the final probe position', () => {
    const game = blockGame();
    game.state.blocked_unit = { id: 99, x: 200, y: 0, alive: true };

    game.checkBlock();
    game.finishProbe();
    game.checkBlock();

    assert.deepEqual(game.repairs, [{ action: 'structure', x: 200, y: 0 }]);
    assert.equal(game.state.blocked_unit, null);
    assert.equal(game.state.blocking_path_request, 0);
  });

  it('Given a probe that can leave the base, when its movement check ends, then no tree or structure repair is attempted', () => {
    const game = blockGame();
    game.state.routeOpen = true;

    game.checkBlock();
    game.finishProbe();
    game.checkBlock();

    assert.equal(game.probes.length, 1);
    assert.deepEqual(game.repairs, []);
    assert.equal(game.state.blocking_path_request, 0);
  });

  it('Given a pending blockage probe and an unrelated request, when the town becomes threatened, then cleanup cancels only the blockage probe', () => {
    const game = blockGame();
    game.checkBlock();
    game.poll();
    const unrelated = game.request();

    game.state.town_threatened = true;
    game.checkBlock();

    assert.equal(game.probes[0].removed, true);
    assert.equal(game.state.blocking_path_request, 0);
    assert.equal(game.result(unrelated), game.state.PATHING_CHECK_PENDING);
    assert.equal(game.jobs[0].delay, 240);
  });

  it('Given a full request queue, when the blockage job retries after a slot is freed, then it retains the home-check state until submission succeeds', () => {
    const game = blockGame();
    const tickets = Array.from({ length: game.state.PATHING_CHECK_LIMIT }, () => game.request());

    game.checkBlock();
    assert.equal(game.state.blockstate, game.state.BLOCK_CHECK_HOME);
    assert.equal(game.state.blocking_path_request, 0);
    game.release(tickets[0]);
    game.checkBlock();

    assert.equal(game.state.blocking_path_request, tickets[0]);
    assert.equal(game.state.blockstate, game.state.BLOCK_CHECK_HERO_MOVEMENT);
    assert.equal(game.probes.length, 0);
  });

  it('Given a queued mine check, when the blockage job polls its own request, then it keeps waiting without inspecting the unrelated probe', () => {
    const game = blockGame();
    const mine = game.request();
    game.checkBlock();
    game.poll();

    game.checkBlock();

    assert.equal(game.state.pathing_check_active, mine);
    assert.equal(game.probes.length, 1);
    assert.deepEqual(game.repairs, []);
    assert.equal(game.jobs[0].delay, 2);
    assert.equal(game.state.blockstate, game.state.BLOCK_CHECK_HERO_MOVEMENT);
  });
});
