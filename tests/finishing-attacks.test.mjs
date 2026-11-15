import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { finishingGame } from './helpers/finishing-game.mjs';

describe('Finishing clearly outmatched enemies', () => {
  it('attacks a weak enemy instead of creeping with low food, creeping XP and a zero native target rate', () => {
    const game = finishingGame();
    const target = game.addEnemy({ strength: 4 });

    game.checkAttack();

    assert.deepEqual(game.targets, [target]);
    assert.deepEqual(game.attacks, ['player attack']);
  });

  it('keeps creeping when the enemy army exceeds half its strength', () => {
    const game = finishingGame();
    game.addEnemy({ strength: 26 });

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('keeps creeping when a weak enemy has too much tower defense without siege', () => {
    const game = finishingGame();
    game.addEnemy({ strength: 2, towers: 6 });

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('includes travel distance when judging whether the enemy is clearly outmatched', () => {
    const game = finishingGame();
    game.addEnemy({ strength: 20, distance: 8400 });

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('checks other enemies after rejecting a weak player protected by towers', () => {
    const game = finishingGame();
    game.addEnemy({ strength: 0, towers: 9 });
    const target = game.addEnemy({ strength: 5 });

    game.checkAttack();

    assert.deepEqual(game.targets, [target]);
  });

  it('can finish a player with no remaining army or town hall but a surviving structure', () => {
    const game = finishingGame();
    const target = game.addEnemy({ strength: 0 });

    game.checkAttack();

    assert.deepEqual(game.targets, [target]);
  });

  it('skips dead, removed, hidden and missing targets and inactive players', () => {
    const game = finishingGame();
    game.addEnemy({ alive: false });
    game.addEnemy({ removed: true });
    game.addEnemy({ hidden: true });
    game.addEnemy({ building: false });
    game.addEnemy({ playing: false });

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('keeps the minimum army strength requirement even against an undefended structure', () => {
    const game = finishingGame();
    game.addEnemy({ strength: 0 });

    game.checkAttack(3);

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('respects the command disabling player attacks', () => {
    const game = finishingGame();
    game.addEnemy();
    game.state.no_player_attack = true;

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('preserves Easy difficulty creeping preferences', () => {
    const game = finishingGame();
    game.addEnemy();
    game.state.difficulty = game.state.EASY;

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });
});
