// Run: node --test --test-reporter=spec tests/expansion-ownership.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { expansionGame } from '../tests/helpers/expansion-game.mjs';

describe('Undead expansion ownership', () => {
  it('Given an owned Necropolis, when choosing its unhaunted mine, then haunting remains available', () => {
    const game = expansionGame();
    const mine = game.addMine();
    game.addHall();

    const taken = game.isTaken(mine);

    assert.equal(taken, false);
  });

  it('Given a Necropolis and its unfinished Haunted Gold Mine, when checking duplicates, then the mine is kept', () => {
    const game = expansionGame();
    game.addMine('ugol', { owner: 0, life: 100 });
    game.addHall();

    game.checkDuplicates();

    assert.deepEqual(game.orders, []);
  });

  it('Given two unfinished Haunted Gold Mines at one site, when checking duplicates, then only the newer mine is cancelled', () => {
    const game = expansionGame();
    game.addMine('ugol', { owner: 0, life: 100 });
    const newer = game.addMine('ugol', { owner: 0, life: 100 });
    game.addHall();

    game.checkDuplicates();

    assert.deepEqual(game.orders, [{ unit: newer, order: 'cancel' }]);
  });

  it('Given an allied Haunted Gold Mine, when choosing its site, then it remains unavailable', () => {
    const game = expansionGame();
    const mine = game.addMine('ugol', { owner: 3 });

    const taken = game.isTaken(mine);

    assert.equal(taken, true);
  });
});

describe('Night Elf expansion ownership', () => {
  it('Given an owned Entangled Gold Mine, when choosing expansion sites, then that site is taken and another mine stays available', () => {
    const game = expansionGame('elf');
    const owned = game.addMine('egol', { owner: 0 });
    game.addHall();
    const next = game.addMine('ngol', { x: 2500 });

    const taken = [game.isTaken(owned), game.isTaken(next)];

    assert.deepEqual(taken, [true, false]);
  });

  it('Given an Entangled Gold Mine and a duplicate tree foundation, when checking duplicates, then the new tree is cancelled', () => {
    const game = expansionGame('elf');
    game.addMine('egol', { owner: 0 });
    game.addHall();
    const tree = game.addHall({ life: 100 });

    game.checkDuplicates();

    assert.deepEqual(game.orders, [{ unit: tree, order: 'cancel' }]);
  });

  it('Given a worker callback after entangling, when checking the build, then the owned mine completes polling', () => {
    const game = expansionGame('elf');
    const mine = game.addMine('egol', { owner: 0 });
    game.addHall();

    game.checkBuilder({ id: 99, alive: true, x: 0, y: 0 }, mine);

    assert.deepEqual(game.orders, []);
    assert.equal(game.state.current_expansion, mine);
  });

  it('Given a tree without an active mine, when choosing a nearby neutral mine, then relocation remains available', () => {
    const game = expansionGame('elf');
    const mine = game.addMine();
    game.addHall();

    const taken = game.isTaken(mine);

    assert.equal(taken, false);
  });
});

describe('Harvesting previously captured expansion mines', () => {
  it('Given an Orc hall and a destroyed Haunted Gold Mine with residual life, when checking harvesting, then the restored deposit is selected', () => {
    const game = expansionGame('orc');
    const mine = game.addMine();
    game.addMine('ugol', { owner: 1, alive: false, life: 0.4 });
    game.addHall();

    const mines = game.checkHarvest();

    assert.deepEqual(mines, [mine]);
  });

  it('Given a Human hall and a destroyed Entangled Gold Mine with residual life, when checking harvesting, then the restored deposit is selected', () => {
    const game = expansionGame('human');
    const mine = game.addMine();
    game.addMine('egol', { owner: 2, alive: false, life: 0.4 });
    game.addHall();

    const mines = game.checkHarvest();

    assert.deepEqual(mines, [mine]);
  });

  it('Given a live foreign captured mine and its hidden deposit, when checking Orc harvesting, then neither is selected', () => {
    const game = expansionGame('orc');
    game.addMine('ngol', { hidden: true });
    game.addMine('ugol', { owner: 1 });
    game.addHall();

    const mines = game.checkHarvest();

    assert.deepEqual(mines, []);
  });

  it('Given a hidden neutral deposit after its captured building disappears, when checking Human harvesting, then assignments wait for the exposed deposit', () => {
    const game = expansionGame('human');
    game.addMine('ngol', { hidden: true });
    game.addHall();

    const mines = game.checkHarvest();

    assert.deepEqual(mines, []);
  });

  it('Given a hidden deposit during mine restoration, when it becomes exposed, then Orc harvesting resumes', () => {
    const game = expansionGame('orc');
    const mine = game.addMine('ngol', { hidden: true });
    game.addHall();
    assert.deepEqual(game.checkHarvest(), []);

    mine.hidden = false;
    const mines = game.checkHarvest();

    assert.deepEqual(mines, [mine]);
  });
});
