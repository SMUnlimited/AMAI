import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { harassGame } from './helpers/harass-game.mjs';

describe('Harass recruitment', () => {
  it('Given busy units before an available unit, starting harassment selects the available unit', () => {
    const game = harassGame();
    game.state.unit_buying_item.add(game.addUnit(1));
    game.state.unit_healing.add(game.addUnit(1));
    game.state.unit_harassing.add(game.addUnit(1));
    const available = game.addUnit(1);
    game.request(1, 1);

    game.start();

    assert.equal(game.get('START_STRENGTH'), 2);
    assert.ok(game.state.unit_harassing.has(available));
    assert.equal(game.jobs.length, 1);
    assert.equal(game.groups.size, 0);
  });

  it('Given missing troops of the first type, later types can fill the remaining group slots', () => {
    const game = harassGame();
    game.request(10, 1);
    game.request(10, 2);
    for (let i = 0; i < 10; i++) game.addUnit(2);

    game.start();

    assert.equal(game.state.unit_harassing.size, 10);
    assert.equal(game.get('START_STRENGTH'), 20);
  });

  it('Given more than twelve available troops, recruitment respects the group limit', () => {
    const game = harassGame();
    game.request(10, 1);
    game.request(10, 2);
    for (let i = 0; i < 10; i++) { game.addUnit(1); game.addUnit(2); }

    game.start();

    assert.equal(game.state.unit_harassing.size, 12);
    assert.equal(game.get('START_STRENGTH'), 24);
    assert.equal(game.strength(), 24);
  });

  it('Given an eight-unit distraction group, its strength includes all eight units', () => {
    const game = harassGame();
    game.request(8, 1);
    for (let i = 0; i < 8; i++) game.addUnit(1, { food: 3 });

    const strength = game.strength();

    assert.equal(strength, 24);
  });
});

describe('Harass lifecycle', () => {
  it('Given a group that loses every unit, its next harassment can start with fresh troops', () => {
    const game = harassGame();
    const lost = game.addUnit(1);
    game.request(1, 1);
    game.start();
    lost.alive = false;

    game.checkHarass();
    const replacement = game.addUnit(1);
    game.start();

    assert.equal(game.jobs.length, 2);
    assert.ok(game.state.unit_harassing.has(replacement));
    assert.equal(game.groups.size, 0);
  });

  it('Given a retreating group still marked attacking, arriving home allows a new launch', () => {
    const game = harassGame();
    game.addUnit(1);
    game.request(1, 1);
    game.start();
    game.set('STATE_RETREAT', 1);

    game.checkHarass();
    assert.equal(game.get('STATE_ATTACKING'), false);
    assert.equal(game.get('STATE_RETREAT'), 2);
    game.start();

    assert.equal(game.jobs.length, 2);
    assert.equal(game.state.unit_harassing.size, 1);
    assert.equal(game.groups.size, 0);
  });

  it('Given an active group and a strategy change, a new definition leaves the running job intact', () => {
    const game = harassGame();
    const original = game.addUnit(1);
    game.request(1, 1);
    game.start();
    const replacement = game.addUnit(2);

    game.state.InitHarass();
    game.request(1, 2);
    game.start();

    assert.equal(game.jobs.length, 1);
    assert.ok(game.state.unit_harassing.has(original));
    assert.ok(!game.state.unit_harassing.has(replacement));
  });

  it('Given a group still retreating, another launch waits for its return', () => {
    const game = harassGame();
    game.addUnit(1);
    game.request(1, 1);
    game.start();
    game.set('STATE_RETREAT', 1);
    game.set('STATE_ATTACKING', false);

    game.start();

    assert.equal(game.jobs.length, 1);
  });
});
