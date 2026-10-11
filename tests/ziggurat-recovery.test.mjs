// Run: node --test --test-reporter=spec tests/ziggurat-recovery.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { zigguratGame } from './helpers/ziggurat-game.mjs';

describe('Undead sell ziggurats to recover a lost gold mine', () => {
  it('Given a working mine and isolated ziggurats, when sales are checked, then abandoned expansion cleanup still runs', () => {
    const game = zigguratGame({ mines: 1 });
    game.ziggurats.forEach((u, i) => { u.x = (i + 1) * 4000; });

    game.checkSales();

    assert.deepEqual(game.sales, game.ziggurats);
  });

  it('Given no working mine or gold, when sales are checked, then one base ziggurat is unsummoned', () => {
    const game = zigguratGame();

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
    assert.deepEqual(game.jobs, [[30, game.state.SELL_ZIGGURATS, 0]]);
  });

  it('Given a ziggurat still unsummoning, when sales are checked again, then another sale waits for the refund', () => {
    const game = zigguratGame();
    game.ziggurats[2].order = 'unsummon';

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given an insufficient refund, when the sold ziggurat is gone, then the next check sells one more', () => {
    const game = zigguratGame({ gold: 75 });
    game.ziggurats[0].alive = false;

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[1]]);
  });

  it('Given enough gold to haunt a mine, when sales are checked, then base ziggurats are kept', () => {
    const game = zigguratGame({ gold: 225 });

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given a working mine, when gold is low and sales are checked, then base ziggurats are kept', () => {
    const game = zigguratGame({ mines: 1 });

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given a replacement mine under construction, when sales are checked, then base ziggurats are kept', () => {
    const game = zigguratGame({ buildingMine: true });

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given an exhausted expansion with a surplus shop, when recovering, then that shop is sold before base supply', () => {
    const game = zigguratGame();
    game.addUnit('shop');
    game.addUnit('mine', { owner: 15, x: 4000, gold: 0 });
    const shop = game.addUnit('shop', { x: 4000 });

    game.checkSales();

    assert.deepEqual(game.sales, [shop]);
    assert.equal(game.groups.size, 0);
  });

  it('Given an exhausted expansion with an extra idle Necropolis, when recovering, then the extra hall is sold', () => {
    const game = zigguratGame();
    game.addUnit('mine', { owner: 15, x: 4000, gold: 0 });
    const hall = game.addUnit('hall', { x: 4000 });

    game.checkSales();

    assert.deepEqual(game.sales, [hall]);
    assert.notEqual(game.sales[0], game.hall);
  });

  it('Given a destroyed expansion with gold remaining, when recovering, then its extra hall is preserved for rebuilding', () => {
    const game = zigguratGame();
    game.addUnit('mine', { owner: 15, x: 4000, hidden: true });
    const hall = game.addUnit('hall', { x: 4000 });

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
    assert.equal(hall.order, 0);
  });

  it('Given workers at an exhausted expansion, when recovering, then its extra hall is preserved', () => {
    const game = zigguratGame();
    game.addUnit('mine', { owner: 15, x: 4000, gold: 0 });
    game.addUnit('ghoul', { x: 4000 });
    const hall = game.addUnit('hall', { x: 4000 });

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
    assert.equal(hall.order, 0);
  });

  it('Given production at an exhausted expansion, when recovering, then its supporting hall is preserved', () => {
    const game = zigguratGame();
    game.addUnit('mine', { owner: 15, x: 4000, gold: 0 });
    game.addUnit('crypt', { x: 4000 });
    const hall = game.addUnit('hall', { x: 4000 });

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
    assert.equal(hall.order, 0);
  });

  it('Given an exhausted site with the last shop, when recovering, then that shop is preserved', () => {
    const game = zigguratGame();
    game.addUnit('mine', { owner: 15, x: 4000, gold: 0 });
    const shop = game.addUnit('shop', { x: 4000 });

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
    assert.equal(shop.order, 0);
  });

  it('Given a tower enumerated before plain ziggurats, when recovering, then a plain ziggurat is sold first', () => {
    const game = zigguratGame();
    game.ziggurats[0].type = 'tower';

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[1]]);
  });

  it('Given only towers fighting nearby enemies, when recovering, then defense is preserved', () => {
    const game = zigguratGame();
    game.ziggurats.forEach(u => { u.type = 'tower'; });
    game.state.threat = 20;

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given enough gold but insufficient lumber, when recovering, then a sale funds the missing resource', () => {
    const game = zigguratGame({ gold: 225, wood: 0 });

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
  });

  it('Given no acolytes and only the mine cost, when recovering, then the worker cost is also raised', () => {
    const game = zigguratGame({ gold: 225, workers: 0 });

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
    assert.equal(game.state.UndeadRecoveryGoldNeeded(), 300);
  });

  it('Given a missing acolyte and tight supply, when recovering, then supply needed to train it is preserved', () => {
    const game = zigguratGame({ workers: 0 });
    game.state.foodSpace = 1;

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given no free supply or acolyte, when budgeting recovery, then a ziggurat is included with the worker and mine', () => {
    const game = zigguratGame({ workers: 0 });
    game.state.foodSpace = 0;

    const gold = game.state.UndeadRecoveryGoldNeeded();
    const wood = game.state.UndeadRecoveryWoodNeeded();

    assert.equal(gold, 450);
    assert.equal(wood, 260);
    assert.equal(game.canBuild(game.state.BUILD_UNIT, game.state.racial_farm), true);
  });

  it('Given no available rebuilding target, when checking recovery, then base buildings are not liquidated', () => {
    const game = zigguratGame();
    game.state.current_expansion = null;

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given a mine target on rebuild cooldown, when checking recovery, then base buildings are not liquidated', () => {
    const game = zigguratGame();
    game.state.cooldown = true;

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given an existing sale from another building type, when checking recovery, then another refund is awaited', () => {
    const game = zigguratGame();
    game.addUnit('crypt', { order: 'unsummon' });

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given a resource shortage and viable sale, when defeat is checked, then recovery starts before surrender', () => {
    const game = zigguratGame();

    game.checkDefeat();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
    assert.equal(game.state.surrendered, undefined);
  });

  it('Given a refund still pending, when defeat is checked, then the AI waits without surrendering', () => {
    const game = zigguratGame();
    game.ziggurats[0].order = 'unsummon';

    game.checkDefeat();

    assert.equal(game.sales.length, 0);
    assert.equal(game.state.surrendered, undefined);
  });

  it('Given affordable recovery, when build permissions are checked, then troops and research wait for the mine', () => {
    const game = zigguratGame({ gold: 225 });

    const mineAllowed = game.canBuild(game.state.BUILD_EXPAND, game.state.racial_expansion);
    const armyAllowed = game.canBuild(game.state.BUILD_UNIT, 7);
    const upgradeAllowed = game.canBuild(game.state.BUILD_UPGRADE, 8);

    assert.equal(mineAllowed, true);
    assert.equal(armyAllowed, false);
    assert.equal(upgradeAllowed, false);
  });

  it('Given a missing acolyte and mine being rebuilt, when checking build permissions, then worker recovery remains allowed', () => {
    const game = zigguratGame({ workers: 0, buildingMine: true });

    const workerAllowed = game.canBuild(game.state.BUILD_UNIT, game.state.racial_peon);
    const armyAllowed = game.canBuild(game.state.BUILD_UNIT, 7);

    assert.equal(workerAllowed, true);
    assert.equal(armyAllowed, false);
    assert.equal(game.state.UndeadRecoveryGoldNeeded(), 75);
  });

  it('Given a depleted Haunted Gold Mine, when checking recovery, then it is left to Warcraft automatic unsummoning', () => {
    const game = zigguratGame();
    const mine = game.addUnit('haunted', { x: 4000, gold: 0 });

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
    assert.equal(mine.order, 0);
  });

  it('Given base sale candidates, when recovering, then one player scan needs no abandoned-site scans', () => {
    const game = zigguratGame();

    game.checkSales();

    assert.equal(game.state.playerScans, 1);
    assert.equal(game.state.rangeScans, 0);
    assert.equal(game.groups.size, 0);
  });

  it('Given an abandoned shop followed by more sale candidates, when recovering, then scanning stops at the best priority', () => {
    const game = zigguratGame();
    game.addUnit('shop');
    const shop = game.addUnit('shop', { x: 4000 });
    game.addUnit('mine', { owner: 15, x: 4000, gold: 0 });
    game.addUnit('shop', { x: 8000 });

    game.checkSales();

    assert.deepEqual(game.sales, [shop]);
    assert.equal(game.state.rangeScans, 1);
    assert.equal(game.groups.size, 0);
  });

  it('Given a pending refund and remote candidates, when recovering, then no abandoned-site scans run', () => {
    const game = zigguratGame();
    game.addUnit('shop', { order: 'unsummon' });
    game.addUnit('shop', { x: 4000 });

    game.checkSales();

    assert.equal(game.sales.length, 0);
    assert.equal(game.state.rangeScans, 0);
    assert.equal(game.groups.size, 0);
  });

  it('Given troop and item requests before a mine, when building during recovery, then the refund goes to the mine', () => {
    const game = zigguratGame({ gold: 225 });
    game.requestBuild(game.state.BUILD_UNIT, 7);
    game.requestBuild(game.state.BUILD_ITEM, 8);
    game.requestBuild(game.state.BUILD_EXPAND, game.state.racial_expansion);
    let recoveryChecks = 0;
    const checkRecovery = game.state.UndeadMineRecoveryNeeded;
    game.state.UndeadMineRecoveryNeeded = () => { recoveryChecks++; return checkRecovery(); };

    game.checkBuild();

    assert.deepEqual(game.production, [{ qty: 1, id: game.state.racial_expansion, gold: 225 }]);
    assert.equal(game.state.build_length, 3, 'Deferred strategy requests remain queued');
    assert.equal(recoveryChecks, 1, 'Recovery status is checked once for the entire build pass');
  });

  it('Given a missing acolyte and a request for five, when building during recovery, then only one is trained', () => {
    const game = zigguratGame({ gold: 300, workers: 0 });
    game.requestBuild(game.state.BUILD_UNIT, game.state.racial_peon, 5);

    game.checkBuild();

    assert.deepEqual(game.production, [{ qty: 1, id: game.state.racial_peon, gold: 300 }]);
  });

  it('Given a missing acolyte and supply already being built, when budgeting recovery, then another ziggurat is not funded', () => {
    const game = zigguratGame({ workers: 0 });
    game.state.foodSpace = 0;
    game.addUnit('ziggurat', { unfinished: true });

    const gold = game.state.UndeadRecoveryGoldNeeded();
    const farmAllowed = game.canBuild(game.state.BUILD_UNIT, game.state.racial_farm);

    assert.equal(gold, 300);
    assert.equal(farmAllowed, false);
  });

  it('Given queued neutral purchases, when purchase jobs run during recovery, then they retry without spending the refund', () => {
    const game = zigguratGame({ gold: 225 });

    game.checkNeutralPurchases();

    assert.deepEqual(game.jobs, [[5, game.state.BUY_NEUTRAL, 7], [5, game.state.BUY_NEUTRAL_HERO, 8]]);
  });

  it('Given a mine still guarded by creeps, when considering recovery, then army production remains available to clear it', () => {
    const game = zigguratGame();
    game.state.guarded = true;

    const armyAllowed = game.canBuild(game.state.BUILD_UNIT, 7);

    assert.equal(armyAllowed, true);
    assert.equal(game.state.UndeadMineRecoveryNeeded(), false);
  });
});

describe('Undead sell surplus buildings to fund troops when mines are unavailable', () => {
  it('Given exhausted mines and a queued fiend, when sales are checked, then one surplus ziggurat funds normal production', () => {
    const game = zigguratGame({ exhausted: true });
    game.requestBuild(game.state.BUILD_UNIT, 7);

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
    assert.equal(game.canBuild(game.state.BUILD_UNIT, 7), true);
    assert.equal(game.state.playerScans, 1);
    assert.equal(game.state.rangeScans, 0);
    assert.equal(game.groups.size, 0);
  });

  it('Given exhausted mines and an abandoned surplus shop, when funding a fiend, then the shop is sold before base supply', () => {
    const game = zigguratGame({ exhausted: true });
    game.requestBuild(game.state.BUILD_UNIT, 7);
    game.addUnit('shop');
    game.addUnit('mine', { owner: 15, x: 4000, gold: 0 });
    const shop = game.addUnit('shop', { x: 4000 });

    game.checkSales();

    assert.deepEqual(game.sales, [shop]);
    assert.equal(game.state.rangeScans, 1);
  });

  it('Given exhausted mines but only active defensive towers, when funding troops, then those towers are kept even without enemies nearby', () => {
    const game = zigguratGame({ exhausted: true });
    game.requestBuild(game.state.BUILD_UNIT, 7);
    game.ziggurats.forEach(u => { u.type = 'tower'; });

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given exhausted mines and only nineteen spare supply, when funding troops, then a ten-supply ziggurat is kept for recruitment', () => {
    const game = zigguratGame({ exhausted: true });
    game.state.foodSpace = 19;
    game.requestBuild(game.state.BUILD_UNIT, 7);

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given an endgame sale still pending, when checking defeat, then no additional sale or surrender occurs', () => {
    const game = zigguratGame({ exhausted: true });
    game.requestBuild(game.state.BUILD_UNIT, 7);
    game.ziggurats[0].order = 'unsummon';

    game.checkDefeat();

    assert.equal(game.sales.length, 0);
    assert.equal(game.state.surrendered, undefined);
    assert.equal(game.state.rangeScans, 0);
    assert.equal(game.groups.size, 0);
  });

  it('Given enough refunded gold for a fiend and the normal buffer, when sales and production run, then the troop uses the refund without further sales', () => {
    const game = zigguratGame({ exhausted: true, gold: 315 });
    game.requestBuild(game.state.BUILD_UNIT, 7);

    game.checkSales();
    game.checkBuild();

    assert.equal(game.sales.length, 0);
    assert.deepEqual(game.production[0], { qty: 1, id: 7, gold: 215 });
    assert.equal(game.production.includes('reinforcements'), true);
  });

  it('Given exhausted mines but no troop request, when sales are checked, then unused funds are not raised', () => {
    const game = zigguratGame({ exhausted: true });

    game.checkSales();

    assert.equal(game.sales.length, 0);
    assert.equal(game.state.playerScans, 0);
  });

  it('Given an already trained fiend satisfying its request, when checking endgame funding, then no sale is needed', () => {
    const game = zigguratGame({ exhausted: true });
    game.requestBuild(game.state.BUILD_UNIT, 7);
    game.addUnit('fiend', { structure: false });

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given an untrainable troop request, when checking endgame funding, then buildings are kept until production becomes possible', () => {
    const game = zigguratGame({ exhausted: true });
    game.requestBuild(game.state.BUILD_UNIT, 7);
    game.state.unbuildable = true;

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given no selected target but a neutral mine still containing gold, when checking funding, then the temporary lack of a target is preserved for recovery', () => {
    const game = zigguratGame();
    game.state.current_expansion = null;
    game.state.cooldown = true;
    game.state.guarded = true;
    game.requestBuild(game.state.BUILD_UNIT, 7);

    game.checkSales();

    assert.equal(game.sales.length, 0);
    assert.equal(game.state.UndeadMinesUnavailable(), false);
  });

  it('Given exhausted land mines but an available island mine, when checking funding, then endgame selling waits', () => {
    const game = zigguratGame({ exhausted: true });
    game.requestBuild(game.state.BUILD_UNIT, 7);
    game.state.water_expansion_list = [game.addUnit('mine', { owner: 15, x: 8000 })];
    game.state.water_expansion_list_length = 1;

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given an allied mine that can be shared, when checking funding, then the sharing opportunity prevents endgame selling', () => {
    const game = zigguratGame();
    game.state.current_expansion = null;
    game.mine.claimed = true;
    game.mine.shareable = true;
    game.requestBuild(game.state.BUILD_UNIT, 7);

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given the remaining mine claimed by an enemy, when checking funding, then surplus supply can fund troops to fight for it', () => {
    const game = zigguratGame();
    game.state.current_expansion = null;
    game.mine.claimed = true;
    game.requestBuild(game.state.BUILD_UNIT, 7);

    game.checkSales();

    assert.deepEqual(game.sales, [game.ziggurats[0]]);
  });

  it('Given owned gold but no currently tracked harvesters, when checking endgame funding, then a temporary harvest interruption does not trigger a sale', () => {
    const game = zigguratGame({ exhausted: true });
    game.addUnit('haunted', { gold: 500 });
    game.requestBuild(game.state.BUILD_UNIT, 7);

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given mine discovery still running, when checking endgame funding, then unfinished discovery cannot trigger a sale', () => {
    const game = zigguratGame({ exhausted: true });
    game.state.pathing_done = false;
    game.requestBuild(game.state.BUILD_UNIT, 7);

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });

  it('Given a replacement mine under construction, when checking troop funding, then endgame selling stays off', () => {
    const game = zigguratGame({ exhausted: true, buildingMine: true });
    game.requestBuild(game.state.BUILD_UNIT, 7);

    game.checkSales();

    assert.equal(game.sales.length, 0);
  });
});
