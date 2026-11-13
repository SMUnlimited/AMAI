import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { observerGame, observerFlags, heroTownGame } from './helpers/runtime-safety-game.mjs';

describe('Debug observer access across clients', () => {
  it('Given a player client and an observer client, when debug access starts, then both grant the same seven alliances to every observer', () => {
    const player = observerGame(1), observer = observerGame(2);

    player.grantAccess();
    observer.grantAccess();

    assert.deepEqual(player.changes, observer.changes);
    assert.deepEqual(player.changes, [2, 23].flatMap(player => observerFlags.map(flag =>
      ({ owner: 0, player, flag, enabled: true }))));
  });

  it('Given debugging is disabled, when observer access is initialized, then no alliances change', () => {
    const game = observerGame(2, 0);

    game.grantAccess();

    assert.deepEqual(game.changes, []);
  });
});

describe('Hero checks without a valid town target', () => {
  it('Given no selected town, when a hero carries a teleport scroll, then town arrays are not read and hero checks continue', () => {
    const game = heroTownGame();
    game.state.most_threatened_town = -1;

    game.checkHero();

    assert.deepEqual(game.effects, ['job']);
  });

  it('Given a town index beyond the tracked towns, when checking a hero, then town arrays are not read and hero checks continue', () => {
    const game = heroTownGame();
    game.state.most_threatened_town = game.state.town_num;

    game.checkHero();

    assert.deepEqual(game.effects, ['job']);
  });

  it('Given a town with no location, when checking a hero, then no distance or teleport uses the missing location', () => {
    const game = heroTownGame();
    game.state.town_loc[0] = null;

    game.checkHero();

    assert.deepEqual(game.effects, ['job']);
  });

  it('Given a valid threatened town and a strong army, when a distant hero has a scroll, then town defense still teleports', () => {
    const game = heroTownGame();

    game.checkHero();

    assert.deepEqual(game.effects, ['teleport-town', 'job']);
  });

  it('Given no town target during retreat, when a distant hero has a scroll, then teleporting home remains available', () => {
    const game = heroTownGame();
    game.state.most_threatened_town = -1;
    game.state.isfleeing = true;

    game.checkHero();

    assert.deepEqual(game.effects, ['teleport-home', 'job']);
  });
});
