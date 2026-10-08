// Run: node --test --test-reporter=spec TestingScenarios/hero-shopping.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { heroGame } from './helpers/hero-shopping-game.mjs';

// Fresh game for each scenario: setup, action, then expected behavior.
// Warcraft movement and healing effects need the map checklist in HeroShopping.md.
for (const [job, reservation] of [
  ['healing', 'unit_healing'],
  ['rescue', 'unit_rescueing'],
  ['harassment', 'unit_harassing'],
  ['zeppelin transport', 'unit_zepplin_move'],
]) {
  describe('Shopping cleanup preserves ' + job, () => {
    it('Given a reserved hero, when an attack cancels shopping, then its existing job keeps control', () => {
      const game = heroGame(reservation);
      game.state.attack_running = true;
      game.state.distance = 4000;

      game.buyItem();

      assert.deepEqual(game.effects, []);
      assert.ok(game.state[reservation].has(game.hero));
      assert.equal(game.hero.order, 'move-home');
      assert.equal(game.state.unit_buying_item.has(game.hero), false);
      assert.equal(game.state.shop_ordered, false);
      assert.equal(game.state.shop_sent, null);
      assert.equal(game.state.shop_buy_time_large, -1);
      assert.equal(game.state.shop_buy_time_small, -1);
    });

    it('Given a reserved hero, when shopping times out, then its existing job keeps control', () => {
      const game = heroGame(reservation);
      game.state.distance = 100;
      game.state.shop_buy_time_large = 0;
      game.state.now = 100;

      game.buyItem();

      assert.deepEqual(game.effects, []);
      assert.ok(game.state[reservation].has(game.hero));
      assert.equal(game.state.unit_buying_item.has(game.hero), false);
      assert.equal(game.state.shop_ordered, false);
    });

    it('Given a reserved hero with the requested item, when shopping finishes, then its existing job keeps control', () => {
      const game = heroGame(reservation);
      game.state.distance = 100;
      game.state.items = 1;

      game.buyItem();

      assert.deepEqual(game.effects, []);
      assert.ok(game.state[reservation].has(game.hero));
      assert.equal(game.state.unit_buying_item.has(game.hero), false);
      assert.equal(game.state.shop_ordered, false);
    });

    it('Given a reserved hero retreating from shopping, when it reaches home, then its existing job keeps control', () => {
      const game = heroGame(reservation);
      game.state.distance = 100;
      game.state.retreat_home = true;

      game.buyItem();

      assert.deepEqual(game.effects, []);
      assert.ok(game.state[reservation].has(game.hero));
      assert.equal(game.state.retreat_home, false);
      assert.equal(game.state.shop_ordered, false);
    });
  });
}

describe('Healthy shoppers return to normal control', () => {
  it('Given an available hero, when an attack cancels shopping, then it rejoins the assault', () => {
    const game = heroGame();
    game.state.attack_running = true;
    game.state.distance = 4000;

    game.buyItem();

    assert.deepEqual(game.effects, ['recycle', 'assault']);
    assert.equal(game.state.shop_sent, null);
    assert.equal(game.state.shop_ordered, false);
  });

  it('Given an available hero with the requested item, when shopping finishes, then it rejoins the assault', () => {
    const game = heroGame();
    game.state.distance = 100;
    game.state.items = 1;

    game.buyItem();

    assert.deepEqual(game.effects, ['recycle', 'assault']);
    assert.equal(game.state.shop_ordered, false);
  });

  it('Given an available hero, when shopping times out, then only guard control returns', () => {
    const game = heroGame();
    game.state.distance = 100;
    game.state.shop_buy_time_large = 0;
    game.state.now = 100;

    game.buyItem();

    assert.deepEqual(game.effects, ['recycle']);
    assert.equal(game.state.shop_ordered, false);
  });

  it('Given an available hero retreating from shopping, when it reaches home, then only guard control returns', () => {
    const game = heroGame();
    game.state.distance = 100;
    game.state.retreat_home = true;

    game.buyItem();

    assert.deepEqual(game.effects, ['recycle']);
    assert.equal(game.state.retreat_home, false);
    assert.equal(game.state.shop_ordered, false);
  });

  it('Given an available hero at the shop, when buying an item, then it purchases and schedules another check', () => {
    const game = heroGame();
    game.state.distance = 100;

    game.buyItem();

    assert.deepEqual(game.effects, ['remove-guard', 'buy', 'job']);
    assert.equal(game.state.shop_ordered, true);
    assert.equal(game.state.shop_sent, game.hero);
  });

  it('Given the army is fleeing, when an attack cancels shopping, then the original assault request is preserved', () => {
    const game = heroGame();
    game.state.isfleeing = true;

    game.buyItem();

    assert.deepEqual(game.effects, ['recycle', 'assault']);
  });
});

describe('SendHome and shopping cooperate', () => {
  it('Given an injured hero already shopping, when micro sends it home, then healing reserves it', () => {
    const game = heroGame();

    game.saveHero();

    assert.ok(game.state.unit_healing.has(game.hero));
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
  });

  it('Given an unassigned healing hero at its racial shop, when shopping starts, then it can buy the healing item', () => {
    const game = heroGame('unit_healing', false);
    game.state.distance = 100;

    game.buyItem();

    assert.deepEqual(game.effects, ['remove-guard', 'buy', 'job']);
    assert.equal(game.state.shop_sent, game.hero);
    assert.ok(game.state.unit_healing.has(game.hero));
  });

  it('Given a healing hero away from the shop, when shopping runs, then it leaves movement to SendHome', () => {
    const game = heroGame('unit_healing');
    game.state.distance = 2000;
    game.hero.order = 'holdposition';

    game.buyItem();

    assert.deepEqual(game.effects, ['remove-guard', 'job']);
    assert.equal(game.hero.order, 'holdposition');
  });

  it('Given a healing hero away from the shop, when SendHome runs, then it moves toward the healing shop', () => {
    const game = heroGame('unit_healing');
    game.state.distance = 2000;

    game.sendHome();

    assert.deepEqual(game.effects, ['move']);
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
  });

  it('Given shopping is active at the healing shop, when SendHome runs, then it waits without buying twice', () => {
    const game = heroGame('unit_healing');
    game.state.distance = 100;

    game.sendHome();

    assert.deepEqual(game.effects, []);
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
  });

  it('Given shopping has bought the healing item, when SendHome runs, then it ends shopping and uses the item', () => {
    const game = heroGame('unit_healing');
    game.state.distance = 100;
    game.state.purchaseSucceeds = true;
    game.buyItem();
    game.effects.length = 0;

    game.sendHome();

    assert.deepEqual(game.effects, ['use']);
    assert.equal(game.state.shop_ordered, false);
    assert.ok(game.state.unit_healing.has(game.hero));
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
  });

  it('Given shopping is inactive, when SendHome buys an item, then it schedules healing rather than releasing the hero', () => {
    const game = heroGame('unit_healing');
    game.state.EndBuyItemJob(false);
    game.state.distance = 100;
    game.state.purchaseSucceeds = true;

    game.sendHome();

    assert.ok(game.effects.includes('buy'));
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
    assert.ok(game.state.unit_healing.has(game.hero));
  });

  it('Given another hero has a healing item, when SendHome receives it, then healing continues', () => {
    const game = heroGame('unit_healing');
    game.state.EndBuyItemJob(false);
    game.state.otherhero = {};

    game.sendHome();

    assert.deepEqual(game.effects, ['transfer']);
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
    assert.ok(game.state.unit_healing.has(game.hero));
  });

  it('Given an injured hero owns a healing item, when SendHome runs, then it uses the item and stays reserved', () => {
    const game = heroGame('unit_healing');
    game.state.healingItems = 1;

    game.sendHome();

    assert.deepEqual(game.effects, ['use']);
    assert.ok(game.state.unit_healing.has(game.hero));
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
  });

  it('Given a continuous healing item away from home, when SendHome runs, then it retreats before using the item', () => {
    const game = heroGame('unit_healing');
    game.state.healingItems = 1;
    game.state.continuous = true;
    game.state.homeDistance = 2000;

    game.sendHome();

    assert.deepEqual(game.effects, ['move']);
    assert.equal(game.state.shop_ordered, false);
    assert.equal(game.state.healingItems, 1);
  });

  it('Given a continuous healing item at home, when SendHome uses it, then the hero stays reserved during the healing wait', () => {
    const game = heroGame('unit_healing');
    game.state.healingItems = 1;
    game.state.continuous = true;
    game.state.homeDistance = 0;

    game.sendHome();

    assert.deepEqual(game.effects, ['use']);
    assert.equal(game.unitJobs.at(-1).delay, 9);
    assert.ok(game.state.unit_healing.has(game.hero));
  });

  it('Given a hero recovered above the 60% threshold, when SendHome runs, then it ends shopping and releases healing', () => {
    const game = heroGame('unit_healing');
    game.hero.life = 65;

    game.sendHome();

    assert.deepEqual(game.effects, ['recycle']);
    assert.equal(game.state.shop_ordered, false);
    assert.equal(game.state.unit_healing.has(game.hero), false);
  });

  it('Given shopping was cancelled for an attack, when SendHome runs again, then the injured hero continues retreating', () => {
    const game = heroGame('unit_healing');
    game.state.distance = 4000;
    game.buyItem();
    game.state.distance = 2000;

    game.sendHome();

    assert.deepEqual(game.effects, ['move']);
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
    assert.ok(game.state.unit_healing.has(game.hero));
  });

  it('Given shopping timed out, when SendHome runs again, then the injured hero continues retreating', () => {
    const game = heroGame('unit_healing');
    game.state.distance = 100;
    game.state.shop_buy_time_large = 0;
    game.state.now = 100;
    game.buyItem();
    game.state.distance = 2000;

    game.sendHome();

    assert.deepEqual(game.effects, ['move']);
    assert.equal(game.unitJobs.at(-1).job, game.state.SEND_HOME);
    assert.ok(game.state.unit_healing.has(game.hero));
  });
});

describe('Hero micro respects healing and shopping', () => {
  it('Given a healing hero at 85% health still shopping, when micro checks recovery, then shopping keeps guard control', () => {
    const game = heroGame('unit_healing');
    game.hero.life = 85;

    game.checkHero();

    assert.deepEqual(game.effects, ['job']);
    assert.ok(game.state.unit_healing.has(game.hero));
  });

  it('Given a healing hero with a town portal, when a town is threatened, then micro does not send it into battle', () => {
    const game = heroGame('unit_healing');
    game.state.GetArmyOfUnit = () => 0;
    game.state.GetItemNumberOnUnit = id => id === 3 ? 1 : 0;
    game.state.town_threatened = true;
    game.state.army_loc = [{}];
    game.state.army_strength = [100];
    game.state.teleport_army_min_strength = 1;

    game.checkHero();

    assert.deepEqual(game.effects, ['job']);
    assert.ok(game.state.unit_healing.has(game.hero));
  });
});
