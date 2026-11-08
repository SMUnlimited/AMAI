import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { creepPlacementGame } from './helpers/creep-placement-game.mjs';

describe('Early Ancient creep placement through the pathing thread', () => {
  it('Given a reachable weak camp, when selecting a site, then it requests reachability and a waypoint and releases both probes', () => {
    const game = creepPlacementGame();
    const camp = game.addCamp();
    game.state.routeOpen = true;

    const built = game.build();

    assert.equal(built, true);
    assert.equal(game.state.rushcreep_target, camp);
    assert.equal(game.probes.length, 2);
    assert.ok(game.probes.every(probe => probe.removed));
    assert.ok(camp.x - game.orders[0].x >= 600 && camp.x - game.orders[0].x < 705);
    assert.equal(game.orders[0].unit, game.worker);
    assert.equal(game.groups.size, 0);
    assert.equal(game.locations.size, 1);
  });

  it('Given a blocked camp before a reachable camp, when selecting a site, then a failed request does not prevent trying the later camp', () => {
    const game = creepPlacementGame();
    const blocked = game.addCamp({ x: 1600 });
    const reachable = game.addCamp({ x: 2800 });
    game.state.onAdvance = () => {
      for (const probe of game.probes) probe.routeOpen = probe.target?.x !== blocked.x;
    };

    const built = game.build();

    assert.equal(built, true);
    assert.equal(game.state.rushcreep_target, reachable);
    assert.ok(game.probes.every(probe => probe.removed));
    assert.equal(game.groups.size, 0);
  });

  it('Given a weak camp beside a gold mine, when selecting a site, then it is rejected before any pathing request', () => {
    const game = creepPlacementGame();
    game.addCamp();
    game.addMine(2100);

    const built = game.build();

    assert.equal(built, false);
    assert.equal(game.probes.length, 0);
    assert.equal(game.groups.size, 0);
  });

  it('Given a full request queue, when early Ancient placement is attempted, then it preserves the opportunity for retry without waiting', () => {
    const game = creepPlacementGame();
    game.addCamp();
    for (let i = 0; i < game.state.PATHING_CHECK_LIMIT; i++) game.request();

    const built = game.build();

    assert.equal(built, false);
    assert.equal(game.state.br_pathing_retry, true);
    assert.equal(game.state.br_rush_built, false);
    assert.equal(game.state.now, 0);
    assert.equal(game.probes.length, 0);
    assert.equal(game.groups.size, 0);
  });
});
