import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { strengthGame } from './helpers/strength-game.mjs';

for (const version of ['ROC', 'TFT', 'REFORGED']) {
  describe(`${version} learned hero abilities and combat readiness`, () => {
    it('A fresh hero has base strength without a food or unlearned skill allowance', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hpal', { hero: true, level: 1, food: 5 });

      const strength = game.state.GetHeroStrength(hero);

      assert.equal(strength, 2);
      assert.equal(game.strength(), 2);
    });

    it('A learned damage spell adds its current rank rather than all previous ranks', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 3 });

      game.learnSkill(hero, 'THUNDER_BOLT', 2);

      assert.equal(game.state.GetHeroStrength(hero), 4);
    });

    it('A rank-three spell and reduced level growth retain fractional strength', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 5 });

      game.learnSkill(hero, 'THUNDER_BOLT', 3);

      assert.equal(game.state.GetHeroStrength(hero), 5.5);
    });

    it('An empty-mana caster keeps a quarter of its active skill bonus', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 1, mana: 0 });

      game.learnSkill(hero, 'THUNDER_BOLT');

      assert.equal(game.state.GetHeroStrength(hero), 2.125);
    });

    it('Half mana scales active bonuses while the passive bonus stays intact', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 3, mana: 50 });

      game.learnSkill(hero, 'THUNDER_BOLT', 2);
      game.learnSkill(hero, 'BASH', 2);

      assert.equal(game.state.GetHeroStrength(hero), 4.125);
    });

    it('A passive skill retains its full bonus without mana', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 1, mana: 0 });

      game.learnSkill(hero, 'BASH');

      assert.equal(game.state.GetHeroStrength(hero), 2.25);
    });

    it('Zero maximum mana uses the empty-mana allowance even with an invalid positive current value', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 1, mana: 100, maxMana: 0 });

      game.learnSkill(hero, 'THUNDER_BOLT');

      assert.equal(game.state.GetHeroStrength(hero), 2.125);
    });

    it('Mana above maximum cannot increase the bonus beyond its full rating', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 1, mana: 150 });

      game.learnSkill(hero, 'THUNDER_BOLT');

      assert.equal(game.state.GetHeroStrength(hero), 2.5);
    });

    it('Negative mana cannot reduce the bonus below its empty-mana allowance', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 1, mana: -50 });

      game.learnSkill(hero, 'THUNDER_BOLT');

      assert.equal(game.state.GetHeroStrength(hero), 2.125);
    });

    it('An unknown custom ability leaves base strength and stat growth available', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('x001', { hero: true, level: 4 });

      hero.abilities[0x41303031] = 3; // Custom ability A001.

      assert.equal(game.state.GetHeroStrength(hero), 3.5);
    });

    it('Scouting and strategic utility do not grant direct combat strength', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Ofar', { hero: true, level: 6 });

      game.learnSkill(hero, 'FAR_SIGHT', 3);
      game.learnSkill(hero, 'EARTHQUAKE');

      assert.equal(game.state.GetHeroStrength(hero), 4.5);
    });

    it('Reaching level six grants stat growth without an unlearned ultimate bonus', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 6 });

      const strength = game.state.GetHeroStrength(hero);

      assert.equal(strength, 4.5);
    });

    it('Learning a combat ultimate adds its rating instead of a level-triggered allowance', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hmkg', { hero: true, level: 6 });

      game.learnSkill(hero, 'AVATAR');

      assert.equal(game.state.GetHeroStrength(hero), 6);
    });

    it('Reincarnation keeps its full learned ultimate bonus without mana', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Otch', { hero: true, level: 6, mana: 0 });

      game.learnSkill(hero, 'REINCARNATION');

      assert.equal(game.state.GetHeroStrength(hero), 6);
    });

    it('Summoning readiness counts before any creature has been summoned', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hamg', { hero: true, level: 1 });

      game.learnSkill(hero, 'WATER_ELEMENTAL');

      assert.equal(game.strength(), 2.75);
      assert.equal(game.ownStrength(), 2);
    });

    it('An active summon adds its own strength alongside the unchanged readiness allowance', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hamg', { hero: true, level: 1 });
      game.learnSkill(hero, 'WATER_ELEMENTAL');

      game.addUnit('ELEMENTAL', { summoned: true, level: 4 });

      assert.equal(game.state.GetHeroStrength(hero), 2.75);
      assert.equal(game.strength(), 6.75);
      assert.equal(game.ownStrength(), 6);
    });

    it('A depleted summoner retains only a small readiness bonus', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hamg', { hero: true, level: 1, mana: 0 });

      game.learnSkill(hero, 'WATER_ELEMENTAL');

      assert.equal(game.strength(), 2.1875);
    });

    it('A summoning ultimate receives a smaller readiness allowance than a combat ultimate', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Udre', { hero: true, level: 6 });

      game.learnSkill(hero, 'INFERNO');

      assert.equal(game.state.GetHeroStrength(hero), 5.25);
    });

    it('The two Endurance Aura names count the same learned ability once', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Otch', { hero: true, level: 3 });

      game.learnSkill(hero, 'ENDURANE_AURA', 2);

      assert.equal(game.state.ENDURANE_AURA, game.state.ENDURANCE_AURA);
      assert.equal(game.state.GetHeroStrength(hero), 3.5);
    });

    it('Health and handicap each scale hero strength once in local and player evaluations', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hamg', { hero: true, level: 1, life: 50 });
      game.state.GetPlayerHandicap = () => 0.25;

      game.learnSkill(hero, 'WATER_ELEMENTAL');

      assert.equal(game.state.GetUnitStrength(hero), 0.6875);
      assert.equal(game.strength(), 0.6875);
    });

    it('Own healing heroes contribute zero while enemy heroes keep their combat value', () => {
      const game = strengthGame(version);
      const ownHero = game.addUnit('Hamg', { hero: true, level: 1 });
      const enemyHero = game.addUnit('Hamg', { hero: true, level: 1, owner: 1 });

      game.learnSkill(ownHero, 'WATER_ELEMENTAL');
      game.learnSkill(enemyHero, 'WATER_ELEMENTAL');
      game.state.unit_healing.add(ownHero);
      game.state.unit_healing.add(enemyHero);

      assert.equal(game.strength(), 0);
      assert.equal(game.state.GetUnitStrength(ownHero), 0);
      assert.equal(game.state.GetPlayerStrength(1), 2.75);
      assert.equal(game.state.GetUnitStrength(enemyHero), 2.75);
    });

    it('Fractional hero and troop contributions combine before the own-strength integer boundary', () => {
      const game = strengthGame(version);
      const firstHero = game.addUnit('Hmkg', { hero: true, level: 1 });
      const secondHero = game.addUnit('Hmkg', { hero: true, level: 1 });
      game.addUnit('FOOTMAN', { food: 2, level: 2, life: 75 });

      game.learnSkill(firstHero, 'BASH');
      game.learnSkill(secondHero, 'BASH');

      assert.equal(game.state.GetPlayerHeroStrengthMod(0), 4.5);
      assert.equal(game.strength(), 6);
      assert.equal(game.ownStrength(), 6);
      assert.equal(game.groups.size, 0);
    });

    it('Dead heroes do not contribute player or own combat strength', () => {
      const game = strengthGame(version);
      const hero = game.addUnit('Hamg', { hero: true, level: 6, alive: false });

      game.learnSkill(hero, 'WATER_ELEMENTAL', 3);

      assert.equal(game.strength(), 0);
      assert.equal(game.ownStrength(), 0);
    });

    if (version !== 'ROC') {
      it('Tinker replacement families retain only the strongest learned bonus in each family', () => {
        const game = strengthGame(version);
        const hero = game.addUnit('Ntin', { hero: true, level: 10 });

        game.learnSkill(hero, 'POCKETFACTORY');
        game.learnSkill(hero, 'POCKETFACTORY2', 3);
        game.learnSkill(hero, 'ROCKETS', 1);
        game.learnSkill(hero, 'ROCKETS3', 2);
        game.learnSkill(hero, 'ROBOGOBLIN');
        game.learnSkill(hero, 'ROBOGOBLIN1');

        assert.equal(game.state.GetHeroStrength(hero), 10.25);
      });
    }
  });
}
