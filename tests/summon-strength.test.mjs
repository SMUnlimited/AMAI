import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { strengthGame } from './helpers/strength-game.mjs';

for (const version of ['ROC', 'TFT', 'REFORGED']) {
  describe(`${version} temporary threats and attack groups`, () => {
    it('Summons, including raised ordinary troops, do not change counter strengths', () => {
      const game = strengthGame(version);
      game.addUnit('FOOTMAN', { food: 2 });
      const baseline = game.counterStrength();

      game.addUnit('ELEMENTAL', { summoned: true });
      game.addUnit('FOOTMAN', { summoned: true });
      game.addUnit('hphx', { summoned: true, attacksFlying: true });
      if (version !== 'ROC') {
        game.addUnit('ELEMENTAL2', { summoned: true });
        game.addUnit('ELEMENTAL3', { summoned: true });
        game.addUnit('CARRION_BEETLE3', { summoned: true });
        game.addUnit('LAVASPAWN3', { summoned: true });
      }

      assert.deepEqual(game.counterStrength(), baseline);
      assert.ok(baseline.normal > 0);
      assert.equal(game.groups.size, 0);
    });

    it('Summons absent from the table still add level-based, health-adjusted combat strength', () => {
      const game = strengthGame(version);
      const phoenix = game.addUnit('hphx', { summoned: true, level: 6, life: 50 });
      const beast = game.addUnit('nqb1', { summoned: true, level: 3 });

      const strength = game.strength();

      assert.equal(game.state.GetUnitStrength(phoenix), 3);
      assert.equal(game.state.GetUnitStrength(beast), 3);
      assert.equal(strength, 6);
      assert.equal(game.groups.size, 0);
    });

    it('Mercenaries and custom troops retain general combat strength', () => {
      const game = strengthGame(version);
      game.addUnit('GNOLL_WARDEN', { food: 2, level: 4 });
      game.addUnit('x001', { food: 4, level: 6 });

      const strength = game.strength();

      assert.equal(strength, 8);
    });

    it('Only living permanent troops contribute their usual counter ratings', () => {
      const game = strengthGame(version);
      game.addUnit('FOOTMAN');
      game.addUnit('FOOTMAN', { alive: false });
      game.addUnit('FOOTMAN', { summoned: true });

      const strength = game.counterStrength();

      assert.equal(strength.normal, 2);
      assert.equal(strength.heavyarmor, 2);
    });

    it('Captured and custom attackers join once while explicit exclusions and summons stay out', () => {
      const game = strengthGame(version);
      const captured = game.addUnit('RIFLEMAN');
      const custom = game.addUnit('x001');
      game.addUnit('x001');
      game.addUnit('MILITIA');
      game.addUnit('SHREDDER');
      game.addUnit('FOOTMAN', { summoned: true });
      game.addUnit('x002', { summoned: true });
      game.addUnit('x003', { alive: false });
      game.addUnit('x004', { hidden: true });
      game.addUnit('x005', { peon: true });
      game.addUnit('x006', { structure: true });
      game.addUnit('x007', { attacksGround: false });

      game.attack();

      assert.deepEqual(game.assaults, [captured.id, custom.id]);
      assert.equal(game.groups.size, 0);
      assert.equal([...game.state.attacktable.keys()].some(key => key.startsWith('0:')), false);
      assert.equal(game.state.LoadInteger(game.state.attacktable, game.state.CUSTOM_ATTACK, captured.id), 60);
      assert.equal(game.state.LoadInteger(game.state.attacktable, game.state.CUSTOM_ATTACK, custom.id), 60);
    });

    it('An attacker already configured for the wave is not added again', () => {
      const game = strengthGame(version);
      const unit = game.addUnit('RIFLEMAN');
      game.state.attack_length = 1;
      game.state.attack_units = [1];
      game.state.old_id[1] = unit.id;

      game.attack();

      assert.deepEqual(game.assaults, []);
    });
  });
}
