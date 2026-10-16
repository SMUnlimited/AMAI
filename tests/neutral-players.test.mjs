import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { neutralGame } from './helpers/neutral-game.mjs';

for (const playerCount of [12, 24]) {
  describe(`${playerCount}-player neutral boundaries`, () => {
    it('Neutral owners skip player data and have no racial aggression or army strength', () => {
      const game = neutralGame(playerCount);
      game.race_aggression[0] = 99;
      game.race_aggression[1] = 99;

      for (let owner = playerCount; owner < playerCount + 4; owner++) {
        game.player_race[owner] = 1;
        game.p_str_cache[owner] = 100;
        assert.equal(game.GetPlayerStrengthHandicap(owner), 1);
        assert.equal(game.GetPlayerStrength(owner), 0);
        assert.equal(game.GetUnexactPlayerStrength(owner), 0);
        assert.equal(game.GetRace(owner), 0);
        assert.equal(game.GetRaceAggression({ owner }), 0);
        game.SetChatVarsAttack({ owner });
      }

      assert.deepEqual(game.chat, {});
    });

    it('An injured creep keeps its individual strength without a player handicap query', () => {
      const game = neutralGame(playerCount);
      const creep = { owner: playerCount, level: 6, life: 50, maxLife: 100 };

      const strength = game.GetUnitStrength(creep);

      assert.equal(strength, 3);
    });

    it('The last playable slot retains its handicap, race, aggression and attack chat', () => {
      const game = neutralGame(playerCount);
      const owner = playerCount - 1;
      game.player_race[owner] = 1;
      game.race_aggression[1] = 7;
      game.GetPlayerHandicap = () => 0.64;
      game.CreateGroup = () => [];
      game.GroupEnumUnitsOfPlayer = () => {};
      game.FirstOfGroup = () => null;
      game.DestroyGroup = () => {};
      game.GetPlayerHeroStrengthMod = () => 25;
      game.I2R = Number;
      game.R2I = Math.trunc;

      game.SetChatVarsAttack({ owner });

      assert.equal(game.GetPlayerStrengthHandicap(owner), 0.8);
      assert.equal(game.GetRace(owner), 1);
      assert.equal(game.GetRaceAggression({ owner }), 7);
      assert.equal(game.GetUnexactPlayerStrength(owner), 25);
      assert.deepEqual(game.chat, { TargetRace: 'Human', TargetColor: String(owner), TargetStrength: 25 });
    });
  });
}
