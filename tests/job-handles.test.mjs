import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { heroGame, neutralGame } from './helpers/hero-shopping-game.mjs';
import { undeadGame } from './helpers/statue-game.mjs';
import { townGame } from './helpers/town-game.mjs';
import { armyGame } from './helpers/army-game.mjs';

describe('Item shoppers and missing shops', () => {
  it('Given no assigned buyer, when shopping starts, then threats are scanned at the selected hero', () => {
    const game = heroGame(undefined, false);
    game.state.distance = 100;

    game.buyItem();

    assert.deepEqual(game.threatScans, [{ x: 6000, y: 4000 }]);
    assert.ok(game.effects.includes('buy'));
  });

  it('Given a removed buyer and another living hero, when shopping resumes, then the old reservation is released and threats use the replacement', () => {
    const game = heroGame();
    const previous = { alive: false, removed: true };
    game.state.shop_sent = previous;
    game.state.unit_buying_item.add(previous);
    game.state.distance = 100;

    game.buyItem();

    assert.equal(game.state.unit_buying_item.has(previous), false);
    assert.equal(game.state.shop_sent, game.hero);
    assert.deepEqual(game.threatScans, [{ x: 6000, y: 4000 }]);
  });

  it('Given a removed shop and no buyer, when shopping runs, then the request ends before selecting a hero or reading shop coordinates', () => {
    const game = heroGame(undefined, false);
    game.state.shop_unit.removed = true;

    game.buyItem();

    assert.equal(game.state.shop_ordered, false);
    assert.equal(game.state.shop_sent, null);
    assert.deepEqual(game.threatScans, []);
  });

  it('Given a destroyed shop and a healing shopper, when shopping is cancelled, then healing keeps control', () => {
    const game = heroGame('unit_healing');
    game.state.shop_unit = null;

    game.buyItem();

    assert.equal(game.state.shop_ordered, false);
    assert.equal(game.state.unit_buying_item.has(game.hero), false);
    assert.ok(game.state.unit_healing.has(game.hero));
    assert.deepEqual(game.effects, []);
  });

  it('Given no living heroes after the buyer dies, when shopping retries, then it ends without recycling a missing unit', () => {
    const game = heroGame();
    game.hero.alive = false;

    game.buyItem();

    assert.equal(game.state.shop_sent, null);
    assert.equal(game.state.shop_ordered, false);
    assert.equal(game.state.unit_buying_item.size, 0);
    assert.deepEqual(game.threatScans, []);
    assert.deepEqual(game.effects, []);
  });

  it('Given a hero already returning home and a destroyed shop, when shopping checks its return, then it finishes without reading shop coordinates', () => {
    const game = heroGame();
    game.state.retreat_home = true;
    game.state.shop_unit = null;

    game.buyItem();

    assert.equal(game.state.shop_ordered, false);
    assert.equal(game.state.retreat_home, false);
    assert.deepEqual(game.threatScans, []);
    assert.deepEqual(game.effects, ['recycle']);
  });
});

describe('Neutral-unit shoppers', () => {
  it('Given no assigned buyer, when recruiting starts, then threats are scanned at the selected buyer', () => {
    const game = neutralGame();
    game.state.distance = 100;

    game.buyNeutral();

    assert.equal(game.state.neutral_sent[0], game.hero);
    assert.deepEqual(game.threatScans, [{ x: 6000, y: 4000 }]);
    assert.ok(game.effects.includes('buy'));
  });

  it('Given no available buyer, when recruiting retries, then it waits without scanning a missing unit', () => {
    const game = neutralGame();
    game.hero.alive = false;

    game.buyNeutral();

    assert.equal(game.state.neutral_sent[0], null);
    assert.deepEqual(game.threatScans, []);
    assert.deepEqual(game.effects, ['job']);
    assert.equal(game.state.neutral_ordered[0], true);
  });

  it('Given a removed neutral camp and a reserved buyer, when recruiting runs, then the reservation and timers are released', () => {
    const game = neutralGame();
    game.state.nearest_neutral[0].removed = true;
    game.state.neutral_sent[0] = game.hero;
    game.state.unit_buying_merc.add(game.hero);
    game.state.buy_time_large[0] = 5;

    game.buyNeutral();

    assert.equal(game.state.neutral_sent[0], null);
    assert.equal(game.state.neutral_ordered[0], false);
    assert.equal(game.state.unit_buying_merc.size, 0);
    assert.equal(game.state.buy_time_large[0], -1);
    assert.deepEqual(game.threatScans, []);
    assert.deepEqual(game.effects, ['recycle']);
  });

  it('Given a removed buyer and a living replacement, when recruiting resumes, then the old reservation is released', () => {
    const game = neutralGame();
    const previous = { alive: false, removed: true };
    game.state.neutral_sent[0] = previous;
    game.state.unit_buying_merc.add(previous);

    game.buyNeutral();

    assert.equal(game.state.unit_buying_merc.has(previous), false);
    assert.equal(game.state.neutral_sent[0], game.hero);
    assert.deepEqual(game.threatScans, [{ x: 6000, y: 4000 }]);
  });

  it('Given a buyer already returning home and a removed camp, when recruiting checks its return, then it releases the buyer at home', () => {
    const game = neutralGame();
    game.state.neutral_sent[0] = game.hero;
    game.state.unit_buying_merc.add(game.hero);
    game.state.nearest_neutral[0] = null;
    game.state.retreat_home_n = true;

    game.buyNeutral();

    assert.equal(game.state.neutral_ordered[0], false);
    assert.equal(game.state.retreat_home_n, false);
    assert.equal(game.state.unit_buying_merc.size, 0);
    assert.deepEqual(game.threatScans, []);
  });
});

describe('Tracked army location ownership', () => {
  it('Given an army travelling to an enemy, when attack checks repeat and tracking refreshes, then its stored location stays alive', () => {
    const game = armyGame();
    const previous = game.state.army_loc[0];
    const count = game.locations.size;

    game.attack();

    assert.ok(game.locations.has(previous));
    assert.equal(game.locations.size, count);
    assert.equal(game.trackArmy(), true);
    assert.equal(game.state.army_count[0], 2);
    assert.equal(game.locations.size, count);
  });

  it('Given an army clearing an expansion, when attack checks repeat and tracking refreshes, then its stored location stays alive', () => {
    const game = armyGame({ expansion: true });
    const previous = game.state.army_loc[0];
    const count = game.locations.size;

    game.attack();

    assert.ok(game.locations.has(previous));
    assert.equal(game.locations.size, count);
    assert.equal(game.trackArmy(), true);
    assert.equal(game.state.army_count[0], 2);
    assert.equal(game.locations.size, count);
  });
});

describe('Tracking and retreat without living units', () => {
  it('Given a unit removed during a battle-scan wait, when retreat control resumes, then it skips that unit before reading coordinates', () => {
    const game = undeadGame();
    for (let i = 0; i < 198; i++) game.units.push({ x: 4000, y: 4000, owner: 0, strength: 1 });
    let waits = 0;
    game.state.onSleep = () => {
      waits++;
      game.statue.removed = true;
      game.units.at(-1).removed = true;
    };

    game.checkBattle();

    assert.ok(waits > 0);
    assert.deepEqual(game.state.last_ally_loc, { x: 4000, y: 4000 });
  });

  it('Given no main army or replacement hero, when retreat control checks battle, then it avoids reading missing hero coordinates', () => {
    const game = undeadGame();
    game.state.main_army = -1;
    game.state.major_hero = null;
    game.state.GetMajorHeroReplacement_k = () => null;
    game.state.GroupEnumUnitsInRange = () => assert.fail('Scanned around a missing hero');

    game.checkBattle();

    assert.equal(game.state.ally_strength_sum, 0);
    assert.equal(game.state.enemy_strength_sum, 0);
  });

  it('Given removed buildings in a tracked town, when the town is refreshed, then dead handles do not supply coordinates or counts', () => {
    const game = townGame();
    const hall = game.addUnit(game.ids.hall);
    game.trackTowns();
    hall.alive = false;
    hall.removed = true;
    const getX = game.state.GetUnitX;
    game.state.GetUnitX = u => { assert.ok(u && !u.removed); return getX(u); };
    game.state.GetUnitLoc = () => assert.fail('Read coordinates of a removed building');

    game.trackTowns();

    assert.equal(game.state.town_count[0], 0);
    assert.equal(game.state.town_structures[0].size, 0);
  });
});
