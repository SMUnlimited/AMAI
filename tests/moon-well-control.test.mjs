import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { moonWellGame } from './helpers/moon-well-game.mjs';

describe('Moon well healing', () => {
  it('Given two distant wells, when a soldier and hero seek healing, then each targets its nearest well', () => {
    const game = moonWellGame();
    const left = game.addWell(0);
    const right = game.addWell(2000);
    const soldier = game.patient(100);
    const hero = game.patient(1900, { hero: true });

    game.checkHealing(soldier);
    game.checkHealing(hero);
    game.checkHealing(soldier);

    assert.deepEqual(game.orders.map(o => o.target), [left, right, left]);
    assert.ok(game.orders.every(o => o.order === 'smart'));
  });

  it('Given equally distant wells, when healing checks repeat, then the destination stays consistent', () => {
    const game = moonWellGame();
    const first = game.addWell(0);
    game.addWell(200);
    const hero = game.patient(100, { hero: true });

    game.checkHealing(hero);
    game.checkHealing(hero);

    assert.deepEqual(game.orders.map(o => o.target), [first, first]);
  });

  it('Given a depleted destination, when another unit changes wells and the first refills, then patients choose independently', () => {
    const game = moonWellGame();
    const left = game.addWell(0);
    const right = game.addWell(2000);
    const soldier = game.patient(100);
    const hero = game.patient(1900, { hero: true });
    game.checkHealing(soldier);

    left.mana = 29;
    game.checkHealing(hero);
    left.mana = 30;
    game.checkHealing(soldier);

    assert.deepEqual(game.orders.map(o => o.target), [left, right, left]);
  });

  it('Given a destroyed destination with mana remaining, when healing resumes, then a living well is targeted', () => {
    const game = moonWellGame();
    const left = game.addWell(0);
    const right = game.addWell(200);
    const soldier = game.patient(10);
    game.checkHealing(soldier);

    left.life = 0;
    game.checkHealing(soldier);

    assert.equal(game.orders.at(-1).target, right);
  });

  it('Given no charged wells near home, when a hero seeks healing, then it falls back to home recovery', () => {
    const game = moonWellGame();
    game.addWell(0, { mana: 29 });
    const hero = game.patient(100, { hero: true });

    game.checkHealing(hero);

    assert.equal(game.orders.length, 0);
    assert.equal(game.jobs.at(-1).job, 'home');
  });

  it('Given a patient at the recovery threshold, when checked, then healing releases it without another order', () => {
    const game = moonWellGame();
    game.addWell(0);
    const hero = game.patient(100, { hero: true, life: 80 });

    game.checkHealing(hero);

    assert.equal(game.orders.length, 0);
    assert.equal(game.jobs.at(-1).job, 'reset');
  });
});
