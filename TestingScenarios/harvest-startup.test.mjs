// Run: node --test --test-reporter=spec TestingScenarios/harvest-startup.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { humanGame } from './helpers/harvest-game.mjs';

// Each scenario starts a fresh game: Given (setup), When (action), Then (assertions).
describe('Human gold worker eligibility', () => {
  it('Given starting peasants with Call to Arms, when assigning gold, then all are eligible', () => {
    const game = humanGame(); // Given five peasants, before the first militia check.

    const eligible = game.peasants.map(game.canAssignGold); // When evaluating assignments.

    assert.deepEqual(eligible, [true, true, true, true, true]); // Then abilities reserve nobody.
  });

  it('Given defense is enabled, when no workers have been selected, then default abilities reserve nobody', () => {
    const game = humanGame();
    game.state.militia_allowed = true;

    assert.ok(game.peasants.every(game.canAssignGold));
  });

  it('Given a selected reserve, when Call to Arms is removed, then the worker stays reserved', () => {
    const game = humanGame();
    const reserve = game.peasants[0];
    game.state.militia_reserved_peons.add(reserve);

    reserve.callToArms = false;

    assert.equal(game.canAssignGold(reserve), false);
  });
});

describe('Defense reserves', () => {
  it('Given five nearby peasants and no enemies, when defense checks run, then only one selected worker is reserved', () => {
    const game = humanGame();

    game.checkDefense();

    assert.equal(game.state.militia_reserved_peons.size, 1);
    assert.deepEqual(game.peasants.map(game.canAssignGold), [true, true, false, true, true]);
  });

  it('Given a defense reserve, when it moves too far away, then it becomes eligible and a replacement is selected', () => {
    const game = humanGame();
    game.checkDefense();
    const [previousReserve] = game.state.militia_reserved_peons;

    previousReserve.distance = 2000;
    game.checkDefense();

    assert.equal(game.canAssignGold(previousReserve), true);
    assert.equal(game.state.militia_reserved_peons.size, 1);
    assert.equal(game.state.militia_reserved_peons.has(previousReserve), false);
  });

  it('Given a defense reserve, when defense is disabled, then all workers become eligible', () => {
    const game = humanGame();
    game.checkDefense();

    game.state.use_militia_only_on_bigger_threats = true;
    game.checkDefense();

    assert.equal(game.state.militia_reserved_peons.size, 0);
    assert.ok(game.peasants.every(game.canAssignGold));
  });

  it('Given a defense reserve, when its town hall is lost, then the reservation is released', () => {
    const game = humanGame();
    game.checkDefense();

    game.state.militia_hall = null;
    game.checkDefense();

    assert.equal(game.state.militia_reserved_peons.size, 0);
    assert.ok(game.peasants.every(game.canAssignGold));
  });
});

describe('Militia expansion missions', () => {
  it('Given all peasants have Call to Arms, when two join a mission, then only those two are reserved', () => {
    const game = humanGame();

    game.runMission(2, () => {
      assert.deepEqual([...game.state.militia_reserved_peons], game.peasants.slice(0, 2));
      assert.deepEqual(game.peasants.map(game.canAssignGold), [false, false, true, true, true]);
    });
  });

  it('Given a mission in progress, when the background defense check runs, then mission reservations survive', () => {
    const game = humanGame();

    game.runMission(2, () => {
      game.checkDefense();

      assert.deepEqual([...game.state.militia_reserved_peons], game.peasants.slice(0, 2));
      assert.deepEqual(game.peasants.map(game.canAssignGold), [false, false, true, true, true]);
    });
  });

  it('Given a mission in progress, when it finishes, then workers are released and defense checks resume', () => {
    const game = humanGame();

    game.runMission(2);

    assert.equal(game.state.militia_reserved_peons.size, 0);
    assert.equal(game.state.militia_check_enabled, true);
    assert.ok(game.peasants.every(game.canAssignGold));
  });
});

describe('Other worker jobs stay protected', () => {
  for (const [job, assign] of [
    ['expansion builder', (state, worker) => { state.expansion_peon = worker; }],
    ['militia builder', (state, worker) => { state.militia_builder = worker; }],
    ['remote builder', (state, worker) => state.early_remote_builders.add(worker)],
    ['existing gold assignment', (state, worker) => state.harvestgrp.add(worker)],
    ['tower rush builder', (state, worker) => { state.towerrush = true; state.builder[1] = worker; }],
  ]) {
    it(`Given a worker with the job '${job}', when assigning gold, then its existing job is protected`, () => {
      const game = humanGame();
      const worker = game.peasants[0];
      assign(game.state, worker);

      assert.equal(game.canAssignGold(worker), false);
      assert.ok(game.peasants.slice(1).every(game.canAssignGold));
    });
  }

  for (const order of ['construction', 'repair', 'restoration', 'renew']) {
    it(`Given a worker performing ${order}, when assigning gold, then its work is not interrupted`, () => {
      const game = humanGame();
      const worker = game.peasants[0];
      worker.order = order === 'construction' ? 852679 : game.state.OrderId(order);

      assert.equal(game.canAssignGold(worker), false);
    });
  }
});
