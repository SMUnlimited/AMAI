// Run: node --test --test-reporter=spec tests/farm-harassment.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { farmGame } from './helpers/farm-game.mjs';

describe('Supply construction loss detection', () => {
  it('Given an unfinished farm, when it completes, then recovery stays inactive', () => {
    const game = farmGame();
    game.checkFarms();

    game.completeFarm();
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 0);
  });

  it('Given an unfinished farm, when it disappears, then two unfinished farms are requested', () => {
    const game = farmGame();
    game.checkFarms();

    game.loseFarm();
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 2);
    assert.deepEqual(game.requests, [{ target: 4, placement: 'base' }]);
  });

  it('Given recovery, when another foundation is lost, then the target rises to three and stays capped', () => {
    const game = farmGame();
    game.checkFarms();
    game.loseFarm();
    game.checkFarms();

    game.startFarm();
    game.checkFarms();
    game.loseFarm();
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 3);
    assert.deepEqual(game.requests, [{ target: 5, placement: 'base' }]);

    game.startFarm();
    game.checkFarms();
    game.loseFarm();
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 3);
    assert.deepEqual(game.requests, [{ target: 5, placement: 'base' }]);
  });

  it('Given three foundations, when one completes and another is lost, then only the loss escalates recovery', () => {
    const game = farmGame({ pending: 3 });
    game.checkFarms();

    game.completeFarm();
    game.loseFarm();
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 2);
    assert.deepEqual(game.requests, [{ target: 5, placement: 'base' }]);
  });

  it('Given several foundations, when two are lost together, then recovery immediately requests three', () => {
    const game = farmGame({ pending: 3 });
    game.checkFarms();

    game.loseFarm();
    game.loseFarm();
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 3);
    assert.deepEqual(game.requests, [{ target: 5, placement: 'base' }]);
  });

  it('Given completed supply, when a sale or upgrade lowers its count, then recovery stays inactive', () => {
    const game = farmGame();
    game.checkFarms();

    game.state.done--;
    game.checkFarms();
    game.state.done++;
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 0);
  });
});

describe('Bounded supply recovery', () => {
  it('Given normal Orc supply thresholds, when supply reaches minus four, then the usual two-building target applies', () => {
    const game = farmGame();
    game.checkFarms();
    assert.deepEqual(game.requests, [{ target: 3, placement: 'base' }]);

    game.state.space = -4;
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 0);
    assert.deepEqual(game.requests, [{ target: 4, placement: 'base' }]);
  });

  it('Given one surviving foundation, when another is lost, then it counts toward the target of two', () => {
    const game = farmGame({ pending: 2 });
    game.checkFarms();

    game.loseFarm();
    game.checkFarms();

    assert.equal(game.state.pending, 1);
    assert.deepEqual(game.requests, [{ target: 4, placement: 'base' }]);
  });

  it('Given recovery, when 60 quiet seconds pass, then normal construction resumes', () => {
    const game = farmGame();
    game.checkFarms();
    game.loseFarm();
    game.checkFarms();

    game.advance(55);
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 2);

    game.advance(5);
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 0);
    assert.deepEqual(game.requests, [{ target: 3, placement: 'base' }]);
  });

  it('Given an expired recovery window, when a fresh loss occurs, then escalation restarts at two', () => {
    const game = farmGame();
    game.checkFarms();
    game.loseFarm();
    game.checkFarms();
    game.startFarm();
    game.checkFarms();

    game.advance(60);
    game.loseFarm();
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 2);
  });

  it('Given ongoing recovery, when another loss occurs, then the quiet period restarts from that loss', () => {
    const game = farmGame();
    game.checkFarms();
    game.loseFarm();
    game.checkFarms();
    game.startFarm();
    game.checkFarms();

    game.advance(55);
    game.loseFarm();
    game.checkFarms();
    game.advance(5);
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 3);

    game.advance(55);
    game.checkFarms();

    assert.equal(game.state.farm_recovery_target, 0);
  });

  it('Given sufficient spare supply, when a foundation is lost, then recovery does not overbuild', () => {
    const game = farmGame({ space: 20 });
    game.checkFarms();

    game.loseFarm();
    game.checkFarms();

    assert.deepEqual(game.requests, []);
  });

  it('Given the supply cap, when foundations are lost, then no construction is requested', () => {
    const game = farmGame();
    game.state.cap = 100;
    game.checkFarms();

    game.loseFarm();
    game.checkFarms();

    assert.deepEqual(game.requests, []);
  });

  it('Given the farm count limit, when recovery requests more buildings, then the target stays bounded', () => {
    const game = farmGame();
    game.state.max_farms = 3;
    game.checkFarms();

    game.loseFarm();
    game.checkFarms();

    assert.deepEqual(game.requests, [{ target: 3, placement: 'base' }]);
  });

  it('Given front placement, when a farm is lost, then recovery switches to normal base production', () => {
    const game = farmGame();
    game.state.race_build_farms_front = true;
    game.checkFarms();
    assert.equal(game.requests[0].placement, 'front');

    game.loseFarm();
    game.checkFarms();

    assert.deepEqual(game.requests, [{ target: 4, placement: 'base' }]);
  });

  it('Given mine placement, when recovery expires, then normal mine construction resumes', () => {
    const game = farmGame();
    game.state.race_farms_at_mine = 4;
    game.checkFarms();
    assert.equal(game.requests[0].placement, 'mine');

    game.loseFarm();
    game.checkFarms();

    assert.equal(game.requests[0].placement, 'base');

    game.advance(60);
    game.checkFarms();

    assert.deepEqual(game.requests, [{ target: 3, placement: 'mine' }]);
  });
});
