import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { creepingGame } from './helpers/creeping-game.mjs';

describe('Player attacks with missing hero slots', () => {
  it('Given no heroes, a desperation attack without a target can fall back to a normal player attack', () => {
    const game = creepingGame();
    game.state.desperation_assault = true;
    game.state.no_player_attack = false;

    game.checkAttack();

    assert.deepEqual(game.attacks, ['player attack']);
  });

  it('Given one fresh hero and an empty second slot, the army can attack a player', () => {
    const game = creepingGame();
    game.trainHero(1);
    game.state.no_player_attack = false;

    game.checkAttack();

    assert.deepEqual(game.attacks, ['player attack']);
  });

  it('Given one hero in the creeping XP range and low food, the army keeps creeping', () => {
    const game = creepingGame();
    game.trainHero(2).xp = 200;
    game.state.no_player_attack = false;

    game.checkAttack();

    assert.deepEqual(game.attacks, ['idle creep']);
  });

  it('Given an experienced second hero, the army attacks even while the first hero needs creeping', () => {
    const game = creepingGame();
    game.trainHero(2).xp = 200;
    game.trainHero(3).xp = 500;
    game.state.no_player_attack = false;

    game.checkAttack();

    assert.deepEqual(game.attacks, ['player attack']);
  });
});
