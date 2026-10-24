import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { strengthGame } from './helpers/strength-game.mjs';

for (const version of ['ROC', 'TFT', 'REFORGED']) {
  describe(`${version} desperation assault registrations`, () => {
    it('Given a troop returning from harassment, desperation still requests 60 and repeated scans add nothing', () => {
      const game = strengthGame(version);
      const troop = game.addUnit('FOOTMAN');
      game.returnFromHarassment(troop);

      game.state.desperation_assault = true;
      game.reinforce();
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [{ count: 1, id: troop.id }, { count: 60, id: troop.id }]);
      assert.equal(game.state.LoadInteger(game.state.attacktable, game.state.CUSTOM_ATTACK, troop.id), 60);
    });

    it('Given a formation capped at one troop, desperation can raise the requested force to 60', () => {
      const game = strengthGame(version);
      game.addUnit('FOOTMAN');
      game.addUnit('FOOTMAN');
      game.formArmy('FOOTMAN', 1);

      game.state.desperation_assault = true;
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [
        { count: 1, id: game.state.oFOOTMAN },
        { count: 59, id: game.state.oFOOTMAN },
      ]);
    });

    it('Given a custom troop returning from harassment twice, both returns happen and a custom scan requests 60 once', () => {
      const game = strengthGame(version);
      const troop = game.addUnit('x001');

      game.returnFromHarassment(troop);
      game.returnFromHarassment(troop);
      game.attack();
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [
        { count: 1, id: troop.id },
        { count: 1, id: troop.id },
        { count: 60, id: troop.id },
      ]);
    });

    it('Given a full desperation request, smaller bulk requests add nothing until reset', () => {
      const game = strengthGame(version);
      const troop = game.addUnit('FOOTMAN');
      game.reinforce();

      game.state.AddAssaultAM(1, troop.id);
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [{ count: 60, id: troop.id }]);
    });

    it('Given two Footmen ending harassment, both return and a later bulk scan still requests 60', () => {
      const game = strengthGame(version);
      const first = game.addUnit('FOOTMAN');
      const second = game.addUnit('FOOTMAN');

      game.returnFromHarassment(first, second);
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [
        { count: 1, id: first.id },
        { count: 1, id: second.id },
        { count: 60, id: first.id },
      ]);
      assert.equal(game.groups.size, 0);
    });

    it('Given a bulk roster already formed, two returning Footmen rejoin without changing the bulk request', () => {
      const game = strengthGame(version);
      const first = game.addUnit('FOOTMAN');
      const second = game.addUnit('FOOTMAN');
      game.reinforce();

      game.returnFromHarassment(first, second);
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [
        { count: 60, id: first.id },
        { count: 1, id: first.id },
        { count: 1, id: second.id },
      ]);
      assert.equal(game.state.LoadInteger(game.state.attacktable, game.state.CUSTOM_ATTACK, first.id), 60);
    });

    it('Given a failed bulk request, the next scan retries it once for that type and caches only the successful request', () => {
      const game = strengthGame(version);
      const troop = game.addUnit('FOOTMAN');
      game.addUnit('FOOTMAN');
      game.state.assaultSucceeds = false;
      game.reinforce();
      assert.equal(game.state.LoadInteger(game.state.attacktable, game.state.CUSTOM_ATTACK, troop.id), 0);

      game.state.assaultSucceeds = true;
      game.reinforce();
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [{ count: 60, id: troop.id }, { count: 60, id: troop.id }]);
      assert.equal(game.state.LoadInteger(game.state.attacktable, game.state.CUSTOM_ATTACK, troop.id), 60);
    });

    it('Given one accepted unit and a failed larger request, retrying uses the same remaining 59 rather than treating the failure as accepted', () => {
      const game = strengthGame(version);
      const troop = game.addUnit('FOOTMAN');
      game.state.AddAssaultAM(1, troop.id);
      game.state.assaultSucceeds = false;
      game.reinforce();
      assert.equal(game.state.LoadInteger(game.state.attacktable, game.state.CUSTOM_ATTACK, troop.id), 1);

      game.state.assaultSucceeds = true;
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [
        { count: 1, id: troop.id },
        { count: 59, id: troop.id },
        { count: 59, id: troop.id },
      ]);
    });

    it('Given repeated reinforcement scans and more units of an existing type, that type is added only once', () => {
      const game = strengthGame(version);
      game.addUnit('GHOUL');
      game.addUnit('GHOUL');
      game.state.desperation_assault = true;
      game.state.FormGroupAM(0);

      game.addUnit('GHOUL');
      for (let pass = 0; pass < 100; pass++) game.reinforce();

      assert.deepEqual(game.assaultRequests, [{ count: 60, id: game.state.oGHOUL }]);
      assert.equal(game.groups.size, 0);
    });

    it('Given an active desperation army, a new unit type is added once without repeating existing types', () => {
      const game = strengthGame(version);
      game.addUnit('GHOUL');
      game.state.desperation_assault = true;
      game.state.FormGroupAM(0);

      game.addUnit('FOOTMAN');
      game.reinforce();
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [
        { count: 60, id: game.state.oGHOUL },
        { count: 60, id: game.state.oFOOTMAN },
      ]);
    });

    it('Given registered types, resetting and reforming the army adds each type again', () => {
      const game = strengthGame(version);
      game.addUnit('GHOUL');
      game.state.desperation_assault = true;
      game.state.FormGroupAM(0);

      game.state.InitAssaultAM();
      game.reinforce();
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [{ count: 60, id: game.state.oGHOUL }]);
    });

    it('Given an ordinary formation, entering desperation tops up its existing types and adds new types', () => {
      const game = strengthGame(version);
      game.addUnit('FOOTMAN');
      game.formArmy('FOOTMAN');

      game.state.desperation_assault = true;
      game.addUnit('GHOUL');
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [
        { count: 1, id: game.state.oFOOTMAN },
        { count: 59, id: game.state.oFOOTMAN },
        { count: 60, id: game.state.oGHOUL },
      ]);
    });

    it('Given an empty ordinary formation, newly trained troops can still join desperation before a reset', () => {
      const game = strengthGame(version);
      game.formArmy('FOOTMAN');

      game.state.desperation_assault = true;
      game.addUnit('FOOTMAN');
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [
        { count: 60, id: game.state.oFOOTMAN },
      ]);
    });

    it('Given captured troops registered by an ordinary scan, desperation preserves their registration after temporary bookkeeping is cleared', () => {
      const game = strengthGame(version);
      const custom = game.addUnit('x001');
      game.attack();

      game.state.desperation_assault = true;
      game.reinforce();
      game.attack();

      assert.deepEqual(game.assaultRequests, [{ count: 60, id: custom.id }]);
    });

    it('Given a custom type added by the unknown-unit scan, later bulk requests and repeated unknown scans cannot add it again', () => {
      const game = strengthGame(version);
      const troop = game.addUnit('x001');
      game.attack();

      game.state.AddAssaultAM(1, troop.id);
      game.state.AddAssaultAM(60, troop.id);
      game.attack();
      game.reinforce();

      assert.deepEqual(game.assaultRequests, [{ count: 60, id: troop.id }]);
    });

    it('Given overlapping formation entries for two troops, formation requests two troops in total rather than three', () => {
      const game = strengthGame(version);
      game.addUnit('FOOTMAN');
      game.addUnit('FOOTMAN');
      game.formArmy('FOOTMAN', 1);
      game.state.attack_units.push(game.state.uFOOTMAN);
      game.state.attack_max.push(60);
      game.state.attack_length = 2;

      game.state.FormGroupAM(0);

      assert.deepEqual(game.assaultRequests, [
        { count: 1, id: game.state.oFOOTMAN },
        { count: 1, id: game.state.oFOOTMAN },
      ]);
      assert.equal(game.state.LoadInteger(game.state.attacktable, game.state.CUSTOM_ATTACK, game.state.oFOOTMAN), 2);
    });

    it('Given a valid attack target, desperation troops are present at launch after the normal formation reset', () => {
      const game = strengthGame(version);
      game.addUnit('GHOUL');
      const worker = game.addUnit('PEASANT', { peon: true });
      game.state.desperation_assault = true;
      let rosterAtLaunch;
      game.state.AttackMoveKill = () => { rosterAtLaunch = game.assaultRequests.slice(); };

      game.startAttack({ alive: true });

      assert.deepEqual(rosterAtLaunch, [
        { count: 60, id: game.state.oGHOUL },
        { count: 60, id: worker.id },
      ]);
      game.reinforce();
      assert.equal(game.assaultRequests.length, 2);
    });
  });

  describe(`${version} ghoul assault reservations`, () => {
    it('Given more lumber reservations than eligible ghouls, forming the army requests zero ghouls', () => {
      const game = strengthGame(version);
      game.addUnit('GHOUL');
      game.addUnit('GHOUL', { healing: true });
      game.addUnit('GHOUL', { buying: true });
      game.state.harvesting_ghouls = 3;

      game.formArmy('GHOUL');

      assert.deepEqual(game.assaultRequests, []);
      assert.equal(game.state.attacking_ghouls, 0);
      assert.equal(game.groups.size, 0);
    });

    it('Given no surviving ghouls and stale lumber reservations, a tower rush requests zero ghouls', () => {
      const game = strengthGame(version);
      game.addUnit('GHOUL', { alive: false });
      game.state.harvesting_ghouls = 3;
      game.state.towerrush = true;

      game.formArmy('GHOUL');

      assert.deepEqual(game.assaultRequests, []);
      assert.equal(game.state.attacking_ghouls, 0);
    });

    it('Given four eligible ghouls and one lumber reservation, a tower rush keeps two ghouls home', () => {
      const game = strengthGame(version);
      for (let i = 0; i < 4; i++) game.addUnit('GHOUL');
      game.state.harvesting_ghouls = 1;
      game.state.towerrush = true;

      game.formArmy('GHOUL');

      assert.equal(game.assaultRequests[0].count, 2);
      assert.equal(game.state.attacking_ghouls, 2);
    });

    it('Given surplus lumber, forming the army takes the available ghouls despite lumber reservations', () => {
      const game = strengthGame(version);
      game.addUnit('GHOUL');
      game.addUnit('GHOUL');
      game.state.harvesting_ghouls = 3;
      game.state.GetWood = () => 500;

      game.formArmy('GHOUL');

      assert.equal(game.assaultRequests[0].count, 2);
    });

    it('Given no hippo riders yet, forming the army still requests conversions up to the desired count', () => {
      const game = strengthGame(version);

      game.formArmy('HIPPO_RIDER', 6);

      assert.deepEqual(game.merges, [{ count: 6, a: game.state.oARCHER, b: game.state.oHIPPO, id: game.state.oHIPPO_RIDER }]);
      assert.deepEqual(game.assaultRequests, []);
    });
  });
}
