// Run: node --test --test-reporter=spec tests/send-home-abilities.test.mjs tests/hero-shopping.test.mjs
// Warcraft spell acceptance, corpse pathing, and regeneration need the in-game scenarios.
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { heroGame } from './helpers/hero-shopping-game.mjs';

describe('SendHome ability research', () => {
  it('Given an injured ghoul with unresearched Cannibalize and a corpse, when sent home, then it never moves to the corpse or eats', () => {
    const game = heroGame();
    game.hero.type = 'ghoul';
    game.giveAbility('Acan');
    game.state.corpses.push({ alive: false, type: 'dead' });

    game.sendHome();

    assert.deepEqual(game.effects, []);
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
  });

  it('Given an injured ghoul with researched Cannibalize and a corpse, when sent home, then it approaches the corpse and eats', () => {
    const game = heroGame();
    game.hero.type = 'ghoul';
    game.giveAbility('Acan');
    game.research('Ruac');
    game.state.corpses.push({ alive: false, type: 'dead' });
    game.state.IssueImmediateOrder = (u, order) => game.effects.push(order);

    game.sendHome();

    assert.deepEqual(game.effects, ['remove-guard', 'move', 'cannibalize']);
  });

  it('Given neutral Cannibalize without research, when sent home, then it can still eat a corpse', () => {
    const game = heroGame();
    game.hero.type = 'creep';
    game.giveAbility('ACcn');
    game.state.corpses.push({ alive: false, type: 'dead' });
    game.state.IssueImmediateOrder = (u, order) => game.effects.push(order);

    game.sendHome();

    assert.ok(game.effects.includes('cannibalize'));
  });

  it('Given an adept Druid, when checking healing and transformation, then only Rejuvenation is usable', () => {
    const game = heroGame();
    game.giveAbility('Arej');
    game.giveAbility('Abrf');
    game.research('Redc', 1);

    assert.equal(game.abilityLevel('Arej'), 1);
    assert.equal(game.abilityLevel('Abrf'), 0);
  });

  it('Given a master Druid, when checking healing and transformation, then both abilities are usable', () => {
    const game = heroGame();
    game.giveAbility('Arej');
    game.giveAbility('Abrf');
    game.research('Redc', 2);

    assert.equal(game.abilityLevel('Arej'), 1);
    assert.equal(game.abilityLevel('Abrf'), 1);
  });

  it('Given an adept Witch Doctor, when checking Healing Ward, then it is unavailable', () => {
    const game = heroGame();
    game.giveAbility('Ahwd');
    game.research('Rowd', 1);

    assert.equal(game.abilityLevel('Ahwd'), 0);
  });

  it('Given a master Witch Doctor, when checking Healing Ward, then it is usable', () => {
    const game = heroGame();
    game.giveAbility('Ahwd');
    game.research('Rowd', 2);

    assert.equal(game.abilityLevel('Ahwd'), 1);
  });

  it('Given an injured fiend before Burrow research, when sent home, then it never attempts Burrow', () => {
    const game = heroGame();
    game.hero.type = 'fiend';
    game.giveAbility('Abur');

    game.sendHome();

    assert.deepEqual(game.effects, []);
  });

  it('Given an injured gargoyle before Stone Form research, when sent home, then it never attempts Stone Form', () => {
    const game = heroGame();
    game.hero.type = 'gargoyle';
    game.giveAbility('Astn');

    game.sendHome();

    assert.deepEqual(game.effects, []);
  });

  it('Given a hero with level two Blink, when checking its usable level, then the learned level is preserved', () => {
    const game = heroGame();
    game.giveAbility('AEbl', 2);

    assert.equal(game.abilityLevel('AEbl'), 2);
  });

  it('Given Cannibalize research without the ability, when checking availability, then research does not grant the ability', () => {
    const game = heroGame();
    game.research('Ruac');

    assert.equal(game.abilityLevel('Acan'), 0);
  });
});
