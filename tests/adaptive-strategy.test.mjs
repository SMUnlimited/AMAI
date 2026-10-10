// Run from the repository root: node --test --test-reporter=spec tests/adaptive-strategy.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { adaptiveGame } from './helpers/adaptive-strategy-game.mjs';

for (const version of ['REFORGED', 'TFT']) {
  describe(version + ' counter allocation', () => {
    for (const race of ['Human', 'Orc', 'Undead', 'Elf']) {
      it('Given ' + race + ' at tier two, when its source counter registrations run, then eligible anti-air units receive bounded targets', () => {
        const game = adaptiveGame({ version, race });
        game.threat('air', 20);

        game.registerRaceCounters();

        assert.ok(game.targets().length > 0);
        assert.ok(game.targets().length <= 2);
        for (const target of game.targets()) {
          assert.ok(game.state.adaptive_weight_air[game.id(target.name)] > 0);
          assert.equal(game.state.AdaptiveCandidateValid(game.id(target.name)), true);
        }
      });
    }

    it('Given two existing riflemen and spare food, when air counters are requested, then production adds to the existing force', () => {
      const game = adaptiveGame({ version });
      game.own('FOOTMAN', 20);
      game.own('RIFLEMAN', 2, { food: 3 });
      game.register('air', 'RIFLEMAN');
      game.threat('air', 8);

      game.plan();
      game.build();

      assert.deepEqual(game.targets(), [{ name: 'RIFLEMAN', quantity: 3 }]);
      assert.deepEqual(game.production, [{ name: 'RIFLEMAN', quantity: 1 }]);
    });

    it('Given air and heavy-armor threats, when allocating counters, then the allowance supports two complementary types', () => {
      const game = adaptiveGame({ version });
      game.own('FOOTMAN', 20);
      game.register('air', 'RIFLEMAN');
      game.register('heavyarmor', 'PRIEST');
      game.threat('air', 8);
      game.threat('heavyarmor', 8);

      game.plan();

      assert.equal(game.state.adaptive_budget, 12);
      assert.deepEqual(game.targets().map(unit => unit.name), ['RIFLEMAN', 'PRIEST']);
      assert.ok(game.targets().every(unit => unit.quantity > 0));
      const allocated = game.targets().reduce((food, unit) =>
        food + unit.quantity * game.state.GetFoodUsed(game.state.old_id[game.id(unit.name)]), 0);
      assert.ok(allocated <= 12);
    });

    it('Given an army at full population, when losses free food, then a missing counter replaces a core unit without switching strategy', () => {
      const game = adaptiveGame({ version, food: 100 });
      game.own('FOOTMAN', 35);
      game.register('air', 'RIFLEMAN');
      game.threat('air', 8);
      game.request('FOOTMAN', 40, 150);

      game.plan();
      game.build();
      assert.equal(game.production.length, 0);

      game.setFood(97);
      game.build();

      assert.deepEqual(game.production, [{ name: 'RIFLEMAN', quantity: 1 }]);
      assert.equal(game.state.strategy, 0);
      assert.ok(game.queue().some(order => order.name === 'FOOTMAN'));
    });
  });
}

describe('Reinforcements after strategy completion', () => {
  for (const version of ['REFORGED', 'TFT']) {
    for (const race of ['Human', 'Orc', 'Undead', 'Elf']) {
      it('Given ' + version + ' ' + race + ' has finished its strategy and sees no threat, when production runs, then registered troops keep filling spare population', () => {
        const game = adaptiveGame({ version, race, food: 80 });
        game.registerRaceCounters();

        game.build();

        assert.equal(game.targets().length, 0);
        assert.ok(game.production.some(unit => unit.quantity > 0));
        assert.ok(game.state.FoodUsed() <= 100);
      });
    }
  }

  it('Given many completed and training riflemen exceed the spare-capacity count, when reinforcing, then the request adds to their total and keeps growing on later passes', () => {
    const game = adaptiveGame({ food: 80 });
    game.own('RIFLEMAN', 20, { training: 2, food: 3 });
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.request('RIFLEMAN', 22);
    game.plan();

    game.build();
    game.build();

    assert.deepEqual(game.targets(), []);
    assert.deepEqual(game.production, [
      { name: 'RIFLEMAN', quantity: 1 },
      { name: 'RIFLEMAN', quantity: 1 },
    ]);
  });

  it('Given unfinished core troops with a destroyed factory, when another reinforcement is ready, then growth waits for the opening to finish', () => {
    const game = adaptiveGame({ food: 80 });
    game.own('FOOTMAN', 0);
    game.own('BARRACKS', 0);
    game.register('air', 'COPTER');
    game.request('FOOTMAN', 4);
    game.plan();

    game.build();

    assert.equal(game.production.some(unit => unit.name === 'COPTER'), false);
  });

  it('Given an optional mercenary request without a nearby shop, when the racial strategy is complete, then that request cannot prevent army growth', () => {
    const game = adaptiveGame({ food: 80 });
    game.own('OGRE_MAGI', 0, { food: 4 });
    game.state.GetNeutralNumber = () => 1;
    game.state.neutral_available[1] = true;
    game.register('air', 'RIFLEMAN');
    game.request('OGRE_MAGI', 1);
    game.plan();

    game.build();

    assert.deepEqual(game.production, [{ name: 'RIFLEMAN', quantity: 1 }]);
    assert.ok(game.queue().some(order => order.name === 'OGRE_MAGI'));
  });

  it('Given completed counter targets and full population, when a loss frees food above 85, then reinforcement production resumes without another replan', () => {
    const game = adaptiveGame({ food: 100 });
    game.own('RIFLEMAN', 20, { food: 3 });
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.plan();
    game.build();

    game.own('RIFLEMAN', 19);
    game.setFood(97);
    game.build();

    assert.deepEqual(game.production, [{ name: 'RIFLEMAN', quantity: 1 }]);
    assert.equal(game.state.FoodUsed(), 100);
  });

  it('Given delayed native counts and missing counter targets, when a counter starts training, then reinforcements wait for a later production pass', () => {
    const game = adaptiveGame({ food: 80 });
    game.own('FOOTMAN', 20);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.deferTrainingCounts();
    game.plan();

    game.build();

    assert.deepEqual(game.production, [{ name: 'RIFLEMAN', quantity: 1 }]);
  });

  it('Given only unavailable reinforcement infrastructure, when counters are covered, then filling the army does not launch extra tech construction', () => {
    const game = adaptiveGame({ food: 80 });
    game.own('BARRACKS', 0);
    game.register('air', 'RIFLEMAN');
    game.plan();

    game.build();

    assert.deepEqual(game.production, []);
    assert.deepEqual(game.queue(), []);
  });

  it('Given spare population but an upkeep boundary, when reinforcing a completed army, then upkeep still prevents production', () => {
    const game = adaptiveGame({ food: 49 });
    game.register('air', 'RIFLEMAN');
    game.setUpkeepLimit(50);
    game.plan();

    game.build();

    assert.deepEqual(game.production, []);
  });
});

describe('Adaptive debug text and strategy chat', () => {
  it('Given adaptation has not planned yet, when reading the debug and chat reports, then both identify adaptive planning', () => {
    const game = adaptiveGame();

    assert.equal(game.state.GetCounterDebugReport(), 'Counter:adaptive counters: planning');
    assert.equal(game.state.GetCurrentDynamicReport(), ' adaptive counters: planning');
  });

  for (const version of ['REFORGED', 'TFT']) {
    it('Given ' + version + ' faces mixed threats, when publishing its counter plan, then debug text and queued strategy chat include both types and their targets', () => {
      const game = adaptiveGame({ version });
      game.state.chatting = true;
      game.own('FOOTMAN', 20);
      game.register('air', 'RIFLEMAN');
      game.register('heavyarmor', 'PRIEST');
      game.threat('air', 8);
      game.threat('heavyarmor', 8);

      game.plan();

      for (const target of game.targets()) {
        assert.ok(game.state.GetCounterDebugReport().includes(target.name + ' x' + target.quantity));
        assert.ok(game.state.chat_strategy.includes(target.name + ' x' + target.quantity));
      }
      assert.ok(game.state.GetCounterDebugReport().startsWith('Counter:adaptive counters: '));
      assert.equal(game.state.chat_strategy, 'My strategy.' + game.state.GetCurrentDynamicReport());
    });
  }

  it('Given an announced air counter, when the enemy transitions to heavy armor, then the queued strategy message replaces the obsolete unit choice', () => {
    const game = adaptiveGame();
    game.state.chatting = true;
    game.own('FOOTMAN', 20);
    game.register('air', 'RIFLEMAN');
    game.register('heavyarmor', 'PRIEST');
    game.threat('air', 8);
    game.plan();

    game.threat('air', 0);
    game.threat('heavyarmor', 8);
    game.advance(15);
    game.plan({ force: false });

    assert.ok(game.state.chat_strategy.includes('PRIEST x'));
    assert.equal(game.state.chat_strategy.includes('RIFLEMAN'), false);
    assert.equal(game.state.GetCounterDebugReport().includes('RIFLEMAN'), false);
  });

  it('Given no counter gaps, when ordinary reinforcement production starts, then the reports describe reinforcements instead of a stale threat category', () => {
    const game = adaptiveGame({ food: 80 });
    game.state.chatting = true;
    game.register('air', 'RIFLEMAN');
    game.plan();
    assert.equal(game.state.GetCounterDebugReport(), 'Counter:adaptive counters: threats covered');

    game.build();

    assert.equal(game.state.GetCounterDebugReport(), 'Counter:adaptive reinforcements: RIFLEMAN');
    assert.equal(game.state.chat_strategy, 'My strategy. adaptive reinforcements: RIFLEMAN');
  });

  it('Given an air threat without any eligible counter, when planning, then the report explains the lack of eligible units', () => {
    const game = adaptiveGame();
    game.register('air', 'RIFLEMAN');
    game.block('RIFLEMAN');
    game.threat('air', 8);

    game.plan();

    assert.equal(game.state.GetCounterDebugReport(), 'Counter:adaptive counters: no eligible units');
  });

  it('Given unchanged adaptive targets, when the next refresh occurs, then it does not queue another strategy announcement', () => {
    const game = adaptiveGame();
    game.state.chatting = true;
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.plan();
    game.state.chat_strategy = 'Another pending announcement.';

    game.advance(15);
    game.plan({ force: false });

    assert.equal(game.state.chat_strategy, 'Another pending announcement.');
  });

  it('Given chatting is disabled and native unit names are empty, when planning, then debug text uses the registered names without queueing chat', () => {
    const game = adaptiveGame();
    game.state.chatting = false;
    game.state.GetObjectName = () => '';
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);

    game.plan();

    assert.ok(game.state.GetCounterDebugReport().includes('RIFLEMAN x'));
    assert.equal(game.state.chat_strategy, '');
  });

  it('Given ROC uses legacy counters, when reading the reports, then its existing category-based text is preserved', () => {
    const game = adaptiveGame({ version: 'ROC' });
    game.state.chosen_counter = 0;
    game.state.strengthtext[0] = 'air';
    game.state.no_counter = false;

    assert.equal(game.state.GetCounterDebugReport(), 'Counter:air');
    assert.ok(game.state.GetCurrentDynamicReport().includes('air'));
    assert.equal(game.state.GetCurrentDynamicReport().includes('adaptive'), false);
  });
});

describe('Counter coverage and preferences', () => {
  it('Given lumber-harvesting ghouls, when planning a melee counter, then workers are excluded and the request includes their existing count', () => {
    const game = adaptiveGame({ race: 'Undead', tier: 1, food: 30 });
    game.own('GHOUL', 3, { food: 2 });
    game.state.harvesting_ghouls = 3;
    game.register('mediumarmor', 'GHOUL');
    game.threat('mediumarmor', 8);

    game.plan();
    game.build();

    assert.equal(game.state.adaptive_have[game.id('GHOUL')], 0);
    assert.equal(game.state.adaptive_cover_mediumarmor, 0);
    assert.equal(game.state.adaptive_budget, 5);
    assert.deepEqual(game.targets(), [{ name: 'GHOUL', quantity: 2 }]);
    assert.deepEqual(game.production, [{ name: 'GHOUL', quantity: 1 }]);
  });

  it('Given fiends without Web, when the real Undead registration runs, then fiends gain anti-air coverage only after Web research', () => {
    const game = adaptiveGame({ race: 'Undead', tier: 2 });
    game.own('CRYPT_FIEND', 10, { food: 3 });
    game.threat('air', 20);
    game.registerRaceCounters();
    assert.equal(game.state.adaptive_weight_air[game.id('CRYPT_FIEND')], 0);
    assert.equal(game.state.adaptive_cover_air, 0);

    game.own('UPG_FIEND_WEB', 1);
    game.state.adaptive_force_refresh = true;
    game.registerRaceCounters();

    assert.ok(game.state.adaptive_weight_air[game.id('CRYPT_FIEND')] > 0);
    assert.ok(game.state.adaptive_cover_air >= 20);
    assert.deepEqual(game.targets(), []);
  });

  it('Given enough completed and training counters, when adapting, then the AI requests no extras', () => {
    const game = adaptiveGame();
    game.own('RIFLEMAN', 1, { training: 2, food: 3 });
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);

    game.plan();

    assert.deepEqual(game.targets(), []);
    assert.equal(game.queue().some(order => order.type === game.state.BUILD_ADAPTIVE), false);
  });

  it('Given duplicate registrations and upgraded headhunters, when measuring coverage, then each physical unit counts once', () => {
    const game = adaptiveGame({ race: 'Orc', tier: 3, food: 80 });
    game.own('HEAD_HUNTER', 2, { training: 1, food: 2 });
    game.own('BERSERKER', 2, { food: 2 });
    game.register('air', 'HEAD_HUNTER', 20);
    game.register('air', 'BERSERKER', 10);
    game.register('air', 'HEAD_HUNTER', 5);
    game.threat('air', 11);

    game.plan();

    assert.equal(game.state.adaptive_unit_count, 1);
    assert.equal(game.state.adaptive_have[game.id('HEAD_HUNTER')], 5);
    assert.equal(game.state.adaptive_cover_air, 10);
    assert.equal(game.state.adaptive_weight_air[game.id('HEAD_HUNTER')], 20);
  });

  it('Given druids in both forms, when counting heavy-armor counters, then transformed druids are credited once', () => {
    const game = adaptiveGame({ race: 'Elf', tier: 3, food: 80 });
    game.own('DRUID_CLAW', 1, { food: 4 });
    game.own('DRUID_CLAW_M', 2, { food: 4 });
    game.register('heavyarmor', 'DRUID_CLAW');
    game.register('heavyarmor', 'DRUID_CLAW_M');
    game.threat('heavyarmor', 12);

    game.plan();

    assert.equal(game.state.adaptive_cover_heavyarmor, 12);
    assert.deepEqual(game.targets(), []);
  });

  it('Given own riflemen in allied strength totals, when assessing coverage, then their contribution is not deducted twice', () => {
    const game = adaptiveGame();
    game.own('RIFLEMAN', 1, { food: 3 });
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.ally('piercing', 3);

    game.plan();

    assert.equal(game.state.adaptive_cover_air, 3);
    assert.deepEqual(game.targets(), [{ name: 'RIFLEMAN', quantity: 1 }]);
    assert.equal(game.state.no_counter, false);
    assert.match(game.logs.find(line => line.startsWith('Adaptive unmet air:')), /5$/);
  });

  it('Given another ally with piercing strength, when evaluating air needs, then that ally receives the existing discount', () => {
    const game = adaptiveGame();
    game.own('RIFLEMAN', 1, { food: 3 });
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.ally('piercing', 23);

    game.plan();

    assert.match(game.logs.find(line => line.startsWith('Adaptive unmet air:')), /4$/);
  });

  it('Given equally preferred counters with different armor, when magic attacks threaten the army, then the less exposed candidate leads', () => {
    const game = adaptiveGame();
    game.register('heavyarmor', 'FOOTMAN');
    game.register('heavyarmor', 'RIFLEMAN');
    game.threat('heavyarmor', 8);
    game.threat('magic', 20);

    game.plan();

    assert.equal(game.targets()[0].name, 'RIFLEMAN');
    assert.equal(game.state.AdaptiveVulnerability(game.id('FOOTMAN')), 0.25);
    assert.equal(game.state.AdaptiveVulnerability(game.id('RIFLEMAN')), 0);
  });

  it('Given equivalent ready and unbuilt counter factories, when selecting counters, then completed infrastructure is preferred', () => {
    const game = adaptiveGame();
    game.own('FOOTMAN', 20);
    game.own('WORKSHOP', 0);
    game.register('air', 'RIFLEMAN');
    game.register('air', 'COPTER');
    game.threat('air', 8);

    game.plan();

    assert.equal(game.targets()[0].name, 'RIFLEMAN');
    assert.equal(game.state.CanBuildUnit(game.id('COPTER')), false);
  });

  it('Given only a current-tier counter with missing infrastructure, when adapting, then its prerequisites are requested without reserving food prematurely', () => {
    const game = adaptiveGame();
    game.own('WORKSHOP', 0);
    game.register('air', 'COPTER');
    game.threat('air', 8);

    game.plan();
    game.state.RefreshAdaptiveReservation();

    assert.equal(game.targets()[0].name, 'COPTER');
    assert.ok(game.queue().some(order => order.name === 'WORKSHOP'));
    assert.equal(game.state.adaptive_reserved_food, 0);
  });

  it('Given future-tier, delayed and neutral candidates, when adapting, then none can take the counter allowance', () => {
    const game = adaptiveGame({ tier: 2 });
    game.state.available_time[game.id('RIFLEMAN')] = 101;
    game.state.buy_type[game.id('FOOTMAN')] = game.state.BT_MERC;
    game.register('air', 'GRYPHON');
    game.register('air', 'RIFLEMAN');
    game.register('air', 'FOOTMAN');
    game.threat('air', 30);

    game.plan();

    assert.deepEqual(game.targets(), []);
    assert.equal(game.state.AdaptivePrerequisitesInTier(game.id('GRYPHON'), 8), false);
  });

  it('Given a severe uncovered air threat, when allocating food, then the allowance rises from 25 to 40 percent', () => {
    const game = adaptiveGame();
    game.own('FOOTMAN', 20);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.plan();
    assert.equal(game.state.adaptive_budget, 12);

    game.threat('air', 30);
    game.plan();

    assert.equal(game.state.adaptive_budget, 20);
    assert.ok(game.targets()[0].quantity * 3 <= 20);
  });

  it('Given equivalent candidates, when the alternative improves by less than 20 percent, then the existing choice persists', () => {
    const game = adaptiveGame();
    game.own('FOOTMAN', 20);
    game.register('air', 'RIFLEMAN', 10);
    game.register('air', 'COPTER', 9);
    game.threat('air', 8);
    game.plan();
    assert.equal(game.targets()[0].name, 'RIFLEMAN');

    game.resetCounters();
    game.register('air', 'RIFLEMAN', 10);
    game.register('air', 'COPTER', 11);
    game.plan();
    assert.equal(game.targets()[0].name, 'RIFLEMAN');

    game.resetCounters();
    game.register('air', 'RIFLEMAN', 10);
    game.register('air', 'COPTER', 13);
    game.plan();

    assert.equal(game.targets()[0].name, 'COPTER');
  });
});

describe('Adaptive queue lifecycle', () => {
  it('Given a hero request and reserved counter food, when only the hero fits, then hero production remains protected', () => {
    const game = adaptiveGame({ food: 95 });
    game.own('FOOTMAN', 35);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.request('ARCHMAGE', 1, 200);

    game.plan();
    game.build();

    assert.deepEqual(game.production, [{ name: 'ARCHMAGE', quantity: 1 }]);
  });

  it('Given planning yields to other AI work, when publishing targets and taking reservation snapshots, then both operations hold the build lock', () => {
    const game = adaptiveGame();
    game.own('FOOTMAN', 20);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    const refreshReservation = game.state.RefreshAdaptiveReservation;
    game.state.RefreshAdaptiveReservation = () => {
      assert.equal(game.state.build_lock, false);
      refreshReservation();
    };

    game.plan();
    const planningLocks = [...game.sleepLocks];
    game.build();

    assert.ok(planningLocks.length > 0);
    assert.ok(planningLocks.every(lock => lock === false));
    assert.equal(game.state.build_lock, true);
    assert.deepEqual(game.production, [{ name: 'RIFLEMAN', quantity: 1 }]);
  });

  it('Given counter-only infrastructure and research, when that threat disappears, then obsolete prerequisites leave the queue too', () => {
    const game = adaptiveGame({ race: 'Undead', tier: 3 });
    game.register('casters', 'BLK_SPHINX');
    game.threat('casters', 20);
    game.plan();
    assert.ok(game.queue().some(order => order.name === 'UPG_BLK_SPHINX' && order.type === game.state.BUILD_ADAPTIVE_UPGRADE));
    assert.ok(game.queue().some(order => order.name === 'OBSIDIAN_STATUE' && order.type === game.state.BUILD_ADAPTIVE));

    game.threat('casters', 0);
    game.plan();

    assert.equal(game.queue().some(order => order.type >= game.state.BUILD_ADAPTIVE), false);
  });

  it('Given adaptive requests for a unit, when its core strategy also requests it, then both origins remain independently queued', () => {
    const game = adaptiveGame();
    game.own('FOOTMAN', 20);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.plan();

    game.request('RIFLEMAN', 1, 40);

    assert.ok(game.queue().some(order => order.name === 'RIFLEMAN' && order.type === game.state.BUILD_UNIT));
    assert.ok(game.queue().some(order => order.name === 'RIFLEMAN' && order.type === game.state.BUILD_ADAPTIVE));
  });

  it('Given an enemy transition above 85 food, when the independent refresh expires, then obsolete counters leave the queue and core orders remain', () => {
    const game = adaptiveGame({ food: 90 });
    game.own('FOOTMAN', 30);
    game.register('air', 'RIFLEMAN');
    game.register('heavyarmor', 'PRIEST');
    game.threat('air', 8);
    game.request('FOOTMAN', 40, 150);
    game.plan();

    game.threat('air', 0);
    game.threat('heavyarmor', 8);
    game.plan({ force: false });
    assert.equal(game.targets()[0].name, 'RIFLEMAN');
    game.advance(15);
    game.plan({ force: false });

    assert.equal(game.targets()[0].name, 'PRIEST');
    assert.equal(game.queue().some(order => order.name === 'RIFLEMAN'), false);
    assert.ok(game.queue().some(order => order.name === 'FOOTMAN'));
  });

  it('Given a counter becomes unavailable before its refresh, when production is checked, then an eligible replacement is selected immediately', () => {
    const game = adaptiveGame();
    game.own('FOOTMAN', 20);
    game.register('air', 'RIFLEMAN', 10);
    game.register('air', 'COPTER', 5);
    game.threat('air', 8);
    game.plan();

    game.block('RIFLEMAN');
    game.plan({ force: false });

    assert.equal(game.targets()[0].name, 'COPTER');
    assert.equal(game.queue().some(order => order.type === game.state.BUILD_ADAPTIVE && order.name === 'RIFLEMAN'), false);
  });

  it('Given a reserved counter and aging core requests, when workers and buildings also need production, then they proceed before the counter without queue starvation', () => {
    const game = adaptiveGame({ food: 96 });
    game.own('FOOTMAN', 35);
    game.own('HOUSE', 0);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.request('PEASANT', 1, 200);
    game.request('HOUSE', 1, 180);
    game.request('FOOTMAN', 40, 150);

    game.plan();
    game.build();

    assert.deepEqual(game.production.map(unit => unit.name), ['PEASANT', 'HOUSE', 'RIFLEMAN']);
    assert.ok(game.queue().some(order => order.name === 'FOOTMAN'));
  });

  it('Given Warcraft delays reflecting new training counts, when a counter order succeeds, then its reservation is consumed immediately', () => {
    const game = adaptiveGame({ food: 97 });
    game.own('FOOTMAN', 35);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.deferTrainingCounts();

    game.plan();
    game.build();

    assert.deepEqual(game.production, [{ name: 'RIFLEMAN', quantity: 1 }]);
    assert.equal(game.state.adaptive_reserved_food, 6);
    assert.equal(game.state.adaptive_started[game.id('RIFLEMAN')], 1);
  });

  it('Given an upkeep boundary below the counter food cost, when attempting production, then reserved food cannot bypass upkeep', () => {
    const game = adaptiveGame({ food: 49 });
    game.own('FOOTMAN', 20);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.setUpkeepLimit(50);

    game.plan();
    game.build();

    assert.deepEqual(game.production, []);
  });

  it('Given threats become covered, when replanning, then ordinary core production can use free food again', () => {
    const game = adaptiveGame({ food: 97 });
    game.own('FOOTMAN', 35);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.request('FOOTMAN', 40, 150);
    game.plan();

    game.threat('air', 0);
    game.plan();
    game.build();

    assert.deepEqual(game.targets(), []);
    assert.deepEqual(game.production, [{ name: 'FOOTMAN', quantity: 1 }]);
    assert.equal(game.state.adaptive_reserved_food, 0);
  });

  it('Given queued adaptive counters, when a tower rush disables adaptation, then only ordinary production proceeds', () => {
    const game = adaptiveGame({ food: 97 });
    game.own('FOOTMAN', 35);
    game.register('air', 'RIFLEMAN');
    game.threat('air', 8);
    game.plan();
    game.request('FOOTMAN', 40, 150);

    game.state.towerrush = true;
    game.build();

    assert.deepEqual(game.production, [{ name: 'FOOTMAN', quantity: 1 }]);
    assert.equal(game.queue().some(order => order.type >= game.state.BUILD_ADAPTIVE), false);
  });

  it('Given campaign, custom dataset or tower-rush modes, when checking adaptation, then the new allocator is disabled', () => {
    for (const mode of ['campaign_ai', 'custom_data_set', 'towerrush']) {
      const game = adaptiveGame();
      game.state[mode] = true;

      assert.equal(game.state.AdaptiveCountersEnabled(), false);
    }
  });

  it('Given ROC, when registering counters, then legacy behavior remains enabled and the adaptive allocator stays off', () => {
    const game = adaptiveGame({ version: 'ROC' });
    game.register('air', 'RIFLEMAN');

    assert.equal(game.state.AdaptiveCountersEnabled(), false);
    assert.equal(game.state.adaptive_unit_count, 0);
    assert.equal(game.state.totalanti_air, 1);
  });
});
