// Run: node --test --test-reporter=spec tests/town-construction.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { townGame } from './helpers/town-game.mjs';

describe('Special building placement after losing the starting town', () => {
  it('Given a destroyed main hall and a surviving expansion, when a front tower is ordered, then it builds at the expansion despite cached starting front points', () => {
    const game = townGame('orc');
    const main = game.addUnit(game.ids.hall, { x: 0 });
    game.addUnit(game.ids.hall);
    game.addUnit(game.ids.worker);
    game.trackTowns();

    main.alive = false;
    game.buildAtFront(game.ids.tower);

    assert.equal(game.orders.at(-1).x, 6500);
    assert.equal(game.orders.at(-1).order, game.state.old_id[game.ids.tower]);
    assert.equal(game.production.length, 0);
  });

  it('Given a surviving expansion and no cached mine location, when a mine farm is ordered, then it builds at the expansion', () => {
    const game = townGame();
    game.addUnit(game.ids.hall);
    game.addUnit(game.ids.worker);
    game.trackTowns();
    game.state.mine_loc = null;

    game.buildAtMine(game.ids.farm);

    assert.equal(game.orders.at(-1).x, 6500);
    assert.equal(game.orders.at(-1).order, game.state.old_id[game.ids.farm]);
  });

  it('Given a surviving expansion and no computed front, when a front farm is ordered, then it builds at the expansion', () => {
    const game = townGame('orc');
    game.addUnit(game.ids.hall);
    game.addUnit(game.ids.worker);
    game.trackTowns();
    game.state.front_locs_computed = false;

    game.buildAtFront(game.ids.farm);

    assert.equal(game.orders.at(-1).x, 6500);
  });

  it('Given only an expansion hall survives, when lumber placement searches for trees, then its worker starts at the expansion', () => {
    const game = townGame('human');
    game.addUnit(game.ids.hall);
    game.trackTowns();

    const lumber = game.findLumber();

    assert.equal(lumber.x, 6000);
    assert.equal(lumber.y, 0);
  });

  it('Given living main and expansion halls, when front and lumber locations are selected, then they stay at the starting town', () => {
    const game = townGame('orc');
    game.addUnit(game.ids.hall, { x: 0 });
    game.addUnit(game.ids.hall);
    game.addUnit(game.ids.worker);
    game.trackTowns();

    game.buildAtFront(game.ids.tower);
    const lumber = game.findLumber();

    assert.equal(game.orders.find(order => order.order === game.state.old_id[game.ids.tower]).x, 1500);
    assert.equal(lumber.x, 0);
  });
});

describe('Building at tracked towns independently of Warcraft town numbering', () => {
  it('Given an expansion worker before the early-game locality checks finish, when local harvesting checks run, then its tracked construction is not redirected home', () => {
    const game = townGame();
    game.addMine();
    const worker = game.addUnit(game.ids.worker);
    game.trackTowns();
    game.build(game.ids.hall);
    worker.order = 852679;
    game.state.town_build_type[0] = worker.order;

    game.keepHarvestLocal();

    assert.equal(game.orders.length, 1);
    assert.equal(worker.order, 852679);
  });

  it('Given a stalled builder and no further construction requests, when builder maintenance runs, then the reservation is released', () => {
    const game = townGame();
    game.addMine();
    const worker = game.addUnit(game.ids.worker, { x: 0 });
    game.trackTowns();
    game.build(game.ids.hall);

    game.advance(120);
    game.maintainBuilders();

    assert.equal(game.state.IsReservedHarvestPeon(worker), false);
    assert.equal(worker.order, 0);
  });

  it('Given a reserved builder at a lost mine, when its next construction request is rejected, then the stale order and reservation are released', () => {
    const game = townGame();
    const mine = game.addMine();
    const worker = game.addUnit(game.ids.worker);
    game.trackTowns();
    game.build(game.ids.hall);

    mine.alive = false;
    game.build(game.ids.hall);

    assert.equal(game.state.IsReservedHarvestPeon(worker), false);
    assert.equal(worker.order, 0);
  });

  it('Given a builder stalled for two minutes and no building resources, when construction checks its budget, then the builder is released despite the resource rejection', () => {
    const game = townGame();
    game.addMine();
    const worker = game.addUnit(game.ids.worker, { x: 0 });
    game.trackTowns();
    game.build(game.ids.hall);

    game.advance(120);
    game.state.total_gold = 0;
    game.build(game.ids.hall);

    assert.equal(game.state.IsReservedHarvestPeon(worker), false);
    assert.equal(worker.order, 0);
  });

  it('Given a distant Undead hall and different native town ordering, when defense requests repeat, then its upgraded hall prevents another Necropolis', () => {
    const game = townGame();
    game.addMine();
    game.trackTowns();
    game.addUnit(game.ids.hall3, { x: 8200 });
    game.trackTowns();

    for (let pass = 0; pass < 100; pass++) game.requestDefenses(game.ids.hall);

    assert.equal(game.count(game.ids.hall), 1);
    assert.equal(game.state.build_length, 0);
    assert.equal(game.groups.size, 0);
  });

  it('Given an unfinished Necropolis, when completed-hall defense requests repeat, then its foundation prevents another build request', () => {
    const game = townGame();
    game.addMine();
    game.addUnit(game.ids.hall, { unfinished: true, life: 100 });
    game.trackTowns();

    for (let pass = 0; pass < 100; pass++) game.requestDefenses(game.ids.hall);

    assert.equal(game.count(game.ids.hall, 1, true), 0);
    assert.equal(game.count(game.ids.hall), 1);
    assert.equal(game.state.build_length, 0);
  });

  it('Given an Undead expansion without a hall, when building its support Necropolis, then its worker builds beside the tracked expansion', () => {
    const game = townGame();
    game.addMine();
    const worker = game.addUnit(game.ids.worker, { x: 5900 });
    game.trackTowns();

    const result = game.build(game.ids.hall);

    assert.equal(result, game.state.BUILT_SOME);
    assert.deepEqual(game.orders, [{ unit: worker, order: game.state.old_id[game.ids.hall], x: 6500, y: 0 }]);
    assert.deepEqual(game.production, []);
  });

  it('Given a Human expansion, when building a scout tower, then construction uses that tracked town', () => {
    const game = townGame('human');
    game.state.probeOffset = 0;
    game.addMine();
    game.addUnit(game.ids.hall);
    const worker = game.addUnit(game.ids.worker, { x: 5900 });
    game.trackTowns();

    game.build(game.ids.farm);

    assert.equal(game.orders[0].unit, worker);
    assert.equal(Math.hypot(game.orders[0].x - 6000, game.orders[0].y), 550);
    assert.deepEqual(game.production, []);
  });

  it('Given an Orc expansion, when building a burrow, then construction uses that tracked town', () => {
    const game = townGame('orc');
    game.state.probeOffset = 0;
    game.addMine();
    game.addUnit(game.ids.hall);
    const worker = game.addUnit(game.ids.worker, { x: 5900 });
    game.trackTowns();

    game.build(game.ids.farm);

    assert.equal(game.orders[0].unit, worker);
    assert.equal(Math.hypot(game.orders[0].x - 6000, game.orders[0].y), 550);
    assert.deepEqual(game.production, []);
  });

  it('Given a Night Elf expansion, when building a moon well, then construction uses that tracked town', () => {
    const game = townGame('elf');
    game.state.probeOffset = 0;
    game.addMine();
    game.addUnit(game.ids.hall);
    const worker = game.addUnit(game.ids.worker, { x: 5900 });
    game.trackTowns();

    game.build(game.ids.farm);

    assert.equal(game.orders[0].unit, worker);
    assert.equal(Math.hypot(game.orders[0].x - 6000, game.orders[0].y), 550);
    assert.deepEqual(game.production, []);
  });

  it('Given an expansion centered on its mine, when building successive ziggurats, then their angles and distances vary outward from the cached hall', () => {
    const game = townGame();
    game.addMine();
    const hall = game.addUnit(game.ids.hall, { x: 6500 });
    const worker = game.addUnit(game.ids.worker);
    game.trackTowns();
    game.state.town_loc[0] = { x: 6000, y: 0 };
    game.state.probeOffset = 0;
    game.state.randomValues = [0.25, 0, 0.75, 1];
    const scansBefore = game.state.scans.range;

    game.build(game.ids.farm);
    const first = game.orders[0];
    game.addUnit(game.ids.farm, { x: first.x, y: first.y, unfinished: true, life: 100 });
    worker.order = 0;
    game.advance(10);
    game.build(game.ids.farm, 2);
    const second = game.orders[1];

    assert.ok(first.x > hall.x && second.x > hall.x, 'Support buildings fan away from the mine');
    assert.ok(first.y < 0 && second.y > 0, 'Successive buildings use different directions');
    assert.ok(Math.abs(Math.hypot(first.x - hall.x, first.y) - 350) < 0.001);
    assert.ok(Math.abs(Math.hypot(second.x - hall.x, second.y) - 750) < 0.001);
    assert.equal(game.state.scans.range, scansBefore + 1, 'Only foundation discovery requires a new range scan');
    assert.equal(game.groups.size, 0);
  });

  it('Given a mine without a hall direction, when building a support building, then it spreads around the reserved hall area', () => {
    const game = townGame();
    game.addMine();
    game.addUnit(game.ids.worker);
    game.trackTowns();
    game.state.probeOffset = 0;
    game.state.randomValues = [0.25, 0.5];
    const scansBefore = game.state.scans.range;

    game.build(game.ids.farm);

    assert.ok(game.orders[0].y > 500);
    assert.ok(Math.abs(Math.hypot(game.orders[0].x - 6000, game.orders[0].y) - 550) < 0.001);
    assert.equal(game.state.scans.range, scansBefore);
    assert.equal(game.groups.size, 0);
  });

  it('Given a random support position displaced into another town, when checking its placement, then construction rejects the displaced position', () => {
    const game = townGame();
    game.addMine();
    game.addUnit(game.ids.worker);
    game.trackTowns();
    game.state.probeOffset = -6000;

    const result = game.build(game.ids.farm);

    assert.equal(result, game.state.CANNOT_BUILD);
    assert.deepEqual(game.orders, []);
    assert.equal(game.groups.size, 0);
  });

  it('Given a pending worker order, when construction checks repeat, then no second worker or order is issued', () => {
    const game = townGame();
    game.addMine();
    const worker = game.addUnit(game.ids.worker);
    game.addUnit(game.ids.worker);
    game.trackTowns();
    game.build(game.ids.hall);

    for (let pass = 0; pass < 100; pass++) game.build(game.ids.hall);

    assert.equal(game.orders.length, 1);
    assert.equal(game.state.IsReservedHarvestPeon(worker), true);
    assert.equal(game.state.scans.player, 1);
  });

  it('Given a worker unable to reach its building site, when two minutes pass without movement or a foundation, then its order is stopped for retry', () => {
    const game = townGame();
    game.addMine();
    const worker = game.addUnit(game.ids.worker, { x: 0 });
    game.trackTowns();
    game.build(game.ids.hall);

    game.advance(120);
    const result = game.build(game.ids.hall);

    assert.equal(result, game.state.CANNOT_BUILD);
    assert.equal(game.orders.at(-1).order, 'stop');
    assert.equal(game.state.IsReservedHarvestPeon(worker), false);
  });

  it('Given a worker still constructing while town tracking is paused, when two minutes pass, then discovering its foundation preserves the order', () => {
    const game = townGame();
    game.addMine();
    const worker = game.addUnit(game.ids.worker);
    game.trackTowns();
    game.build(game.ids.hall);
    game.addUnit(game.ids.hall, { x: 6500, unfinished: true, life: 100 });

    game.advance(120);
    game.build(game.ids.hall);

    assert.equal(game.orders.length, 1);
    assert.equal(game.state.IsReservedHarvestPeon(worker), true);
    assert.equal(game.count(game.ids.hall), 1);
  });

  it('Given a killed builder before a foundation starts, when construction checks again, then another worker can take the order', () => {
    const game = townGame();
    game.addMine();
    const worker = game.addUnit(game.ids.worker);
    const replacement = game.addUnit(game.ids.worker, { x: 5500 });
    game.trackTowns();
    game.build(game.ids.hall);

    worker.alive = false;
    game.build(game.ids.hall);

    assert.equal(game.orders.length, 2);
    assert.equal(game.orders.at(-1).unit, replacement);
  });

  it('Given a worker assigned to haunting another mine, when building a support hall, then a different worker is selected', () => {
    const game = townGame();
    game.addMine();
    const expansionWorker = game.addUnit(game.ids.worker);
    const available = game.addUnit(game.ids.worker, { x: 5500 });
    game.state.expansion_peon = expansionWorker;
    game.trackTowns();

    game.build(game.ids.hall);

    assert.equal(game.orders[0].unit, available);
    assert.equal(expansionWorker.order, 0);
  });

  it('Given a new foundation while regular town tracking is paused, when its worker order ends, then construction refreshes once and keeps the foundation', () => {
    const game = townGame();
    game.addMine();
    const worker = game.addUnit(game.ids.worker);
    game.trackTowns();
    game.build(game.ids.hall);
    game.addUnit(game.ids.hall, { x: 6500, unfinished: true, life: 100 });
    worker.order = 0;
    const scansBefore = game.state.scans.range;

    game.advance(10);
    const result = game.build(game.ids.hall);

    assert.equal(result, game.state.BUILT_ALL);
    assert.equal(game.orders.length, 1);
    assert.equal(game.state.scans.range, scansBefore + 1);
    assert.equal(game.state.IsReservedHarvestPeon(worker), false);
  });

  it('Given completed Human towers at two towns, when upgrading an expansion tower, then only its tracked source receives the upgrade', () => {
    const game = townGame('human');
    game.addMine();
    game.addUnit(game.ids.hall);
    const home = game.addUnit(game.ids.farm, { x: 0 });
    const expansion = game.addUnit(game.ids.farm, { x: 8100 });
    game.trackTowns();
    const scansBefore = game.state.scans.range;

    game.upgrade(game.ids.tower);

    assert.deepEqual(game.orders, [{ unit: expansion, order: game.state.old_id[game.ids.tower] }]);
    assert.equal(home.order, 0);
    assert.equal(game.state.scans.range, scansBefore);
  });

  it('Given a moved source and a completed source in the cached expansion group, when upgrading, then only the source still belonging to that town is selected', () => {
    const game = townGame('human');
    game.addMine();
    game.addUnit(game.ids.hall);
    const moved = game.addUnit(game.ids.farm);
    const remaining = game.addUnit(game.ids.farm, { x: 6500 });
    game.trackTowns();
    moved.x = 0;

    game.upgrade(game.ids.tower);

    assert.deepEqual(game.orders, [{ unit: remaining, order: game.state.old_id[game.ids.tower] }]);
    assert.equal(moved.order, 0);
  });

  it('Given an unfinished scout tower followed by a completed tower, when upgrading, then the unfinished foundation receives no upgrade order', () => {
    const game = townGame('human');
    game.addMine();
    game.addUnit(game.ids.hall);
    const foundation = game.addUnit(game.ids.farm, { unfinished: true, life: 100 });
    const completed = game.addUnit(game.ids.farm, { x: 6500 });
    game.trackTowns();

    game.upgrade(game.ids.tower);

    assert.deepEqual(game.orders, [{ unit: completed, order: game.state.old_id[game.ids.tower] }]);
    assert.equal(foundation.order, 0);
  });

  it('Given a finished hall observed before damage and another foundation, when the finished hall is damaged, then it remains completed', () => {
    const game = townGame();
    game.addMine();
    const hall = game.addUnit(game.ids.hall);
    game.trackTowns();
    assert.equal(game.count(game.ids.hall, 1, true), 1);
    game.addUnit(game.ids.hall, { unfinished: true, life: 100 });
    game.trackTowns();

    hall.life = 300;

    assert.equal(game.count(game.ids.hall, 1, true), 1);
    assert.equal(game.count(game.ids.hall), 2);
  });

  it('Given an expansion hall and an allied hall, when the owned hall is destroyed, then stale handles and allied buildings do not satisfy its count', () => {
    const game = townGame();
    game.addMine();
    const hall = game.addUnit(game.ids.hall);
    game.addUnit(game.ids.hall, { owner: 1 });
    game.trackTowns();
    game.count(game.ids.hall, 1, true);

    hall.alive = false;
    game.trackTowns();

    assert.equal(game.count(game.ids.hall), 0);
    assert.equal(game.state.tracked_structures.has(`${hall.id}:1`), false);
    assert.equal(game.groups.size, 0);
  });

  it('Given a placement probe displaced to a different town, when requesting construction, then the worker receives no misplaced order', () => {
    const game = townGame();
    game.addMine();
    game.addUnit(game.ids.worker);
    game.trackTowns();
    game.state.probeOffset = -6000;

    const result = game.build(game.ids.hall);

    assert.equal(result, game.state.CANNOT_BUILD);
    assert.deepEqual(game.orders, []);
  });

  it('Given a tracked home town outside slot zero, when defending expansions, then the tracked home is excluded', () => {
    const game = townGame();
    game.addMine();
    game.addMine({ x: 0 });
    game.state.own_town = [0, 2];
    game.trackTowns();

    game.requestDefenses(game.ids.hall);

    assert.equal(game.state.build_length, 1);
    assert.equal(game.state.build_town[0], 0);
  });
});
