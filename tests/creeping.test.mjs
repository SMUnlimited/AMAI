import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { creepingGame } from './helpers/creeping-game.mjs';

describe('Idle creeping at hero level five', () => {
  it('stops when the only trained hero is level five, ignoring untrained slots', () => {
    const game = creepingGame();
    game.trainHero(5);

    game.checkAttack();

    assert.deepEqual(game.attacks, []);
  });

  it('keeps creeping when any trained hero is still below level five', () => {
    const game = creepingGame();
    game.trainHero(8);
    game.trainHero(4);

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('resumes creeping after a new low-level hero is trained', () => {
    const game = creepingGame();
    game.trainHero(6);
    game.trainHero(7);
    game.checkAttack();

    game.trainHero(1);
    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('counts a trained low-level hero waiting for revival', () => {
    const game = creepingGame();
    game.trainHero(8);
    game.trainHero(4).alive = false;

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('keeps creeping when no heroes have been trained', () => {
    const game = creepingGame();

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('keeps creeping with high-level heroes when the setting is disabled', () => {
    const game = creepingGame();
    game.state.stop_creeping_after_level_5 = false;
    game.trainHero(10);

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('still clears a needed expansion when all trained heroes are level five or higher', () => {
    const game = creepingGame();
    game.trainHero(5);
    game.trainHero(5);
    game.trainHero(5);

    game.checkAttack(true);

    assert.deepEqual(game.attacks, ['expansion']);
  });
});
