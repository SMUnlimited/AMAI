import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { transitGame } from './helpers/transit-game.mjs';

describe('Captain retreat assistance', () => {
  it('Given permission to flee, when the captain naturally retreats, then assistance does not form a new assault group', () => {
    const game = transitGame();
    game.state.canflee = true;
    game.state.CaptainRetreating = () => true;

    game.checkBattle();

    assert.equal(game.state.isfleeing, true);
    assert.equal(game.unitOrders.length, 2);
    assert.equal(game.work.formations, 0);
  });

  it('Given attackers and idle troops away from home, when stronger enemies force retreat, then one move starts their return and later checks preserve it', () => {
    const game = transitGame();
    game.units[1].order = 0;
    game.addEnemy({ strength: 60 });

    game.checkBattle();
    game.checkBattle();
    game.checkBattle();

    assert.equal(game.state.isfleeing, true);
    assert.equal(game.work.formations, 0, 'Retreat must not recruit reinforcements');
    assert.deepEqual(game.unitOrders, game.units.slice(0, 2).map(unit => ({ unit, order: 'move', x: 0, y: 0 })));
    assert.ok(game.orders.every(order => order.order === 'home'));
    assert.equal(game.state.army_group[0].size, 2, 'Assisting must preserve the tracked army');
  });

  it('Given troops that resume fighting after returning toward home, when retreat checks repeat, then straying troops are recalled again', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.unitOrders.length = 0;
    game.units[0].order = 'attack';

    game.checkBattle();

    assert.equal(game.unitOrders.length, 1);
    assert.equal(game.unitOrders[0].unit, game.units[0]);
    assert.equal(game.state.retreat_controlled, true);
  });

  it('Given home defenders and a separate field group, when retreat starts, then home defenders stay free and the distant group returns', () => {
    const game = transitGame();
    Object.assign(game.units[0], { x: 1200, y: 0 });
    Object.assign(game.units[1], { x: 100, y: 0 });
    const straggler = { x: 5000, y: 5000, owner: 0, alive: true, order: 'move' };
    game.units.push(straggler);
    game.state.main_army = -1;
    game.state.isfleeing = true;

    game.checkBattle();

    assert.deepEqual(game.unitOrders, [{ unit: straggler, order: 'move', x: 0, y: 0 }]);
  });

  it('Given harvesting ghouls and a casting hero, when retreat starts, then harvesting and spell orders continue', () => {
    const game = transitGame();
    const [ghoul, soldier] = game.units;
    ghoul.order = 'harvest';
    soldier.order = 'channel';
    const caster = { ...soldier, order: 'channel' };
    const returningGhoul = { ...ghoul, order: 'resumeharvesting' };
    game.units.push(caster, returningGhoul);
    game.state.isfleeing = true;

    game.checkBattle();

    assert.deepEqual(game.unitOrders, []);
    assert.equal(game.state.unit_healing.size, 0);
  });

  it('Given troops reserved for healing, shopping or harassment, when retreat starts, then those jobs retain control', () => {
    const game = transitGame();
    game.state.unit_healing.add(game.units[0]);
    game.state.unit_buying_item.add(game.units[1]);
    const harasser = { ...game.units[0] };
    game.units.push(harasser);
    game.state.unit_harassing.add(harasser);
    game.state.isfleeing = true;

    game.checkBattle();

    assert.deepEqual(game.unitOrders, []);
  });

  it('Given dead, hidden, loaded, worker, building and allied units, when retreat starts, then none receives a direct order', () => {
    const game = transitGame();
    const soldier = game.units[0];
    game.units.splice(0, game.units.length,
      { ...soldier, alive: false }, { ...soldier, hidden: true },
      { ...soldier, loaded: true }, { ...soldier, peon: true },
      { ...soldier, structure: true }, { ...soldier, owner: 2 },
    );
    game.state.isfleeing = true;

    game.checkBattle();

    assert.deepEqual(game.unitOrders, []);
  });

  it('Given an ongoing town portal, when retreat starts, then direct orders cannot interrupt it', () => {
    const game = transitGame();
    game.state.teleporting = true;
    game.state.isfleeing = true;

    game.checkBattle();

    assert.deepEqual(game.unitOrders, []);
  });

  it('Given an expansion selected as captain home, when retreat starts, then assistance uses that location', () => {
    const game = transitGame();
    game.state.captain_home = game.state.Location(2000, 1000);
    game.state.town_threatened = true;
    game.state.town_threat_break = true;

    game.checkBattle();

    assert.equal(game.unitOrders.length, 2);
    assert.equal(game.work.formations, 0, 'Town recall must not recruit reinforcements');
    assert.ok(game.unitOrders.every(order => order.x === 2000 && order.y === 1000));
  });

  it('Given a captain already home, when stragglers are still returning, then retreat waits for their guard restoration', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.state.CaptainIsHome = () => true;

    game.checkBattle();

    assert.equal(game.unitOrders.length, 2);
    assert.equal(game.state.retreat_controlled, true);
  });

  it('Given a later attack after returning home, when it also retreats, then its troops are recalled again', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.state.CaptainIsHome = () => true;
    for (const unit of game.units) { unit.x = 0; unit.y = 0; }
    game.checkBattle();
    for (const unit of game.units) { unit.x = 4000; unit.y = 4000; }
    game.unitOrders.length = 0;
    game.state.CaptainIsHome = () => false;
    game.state.retreat_controlled = true;
    game.state.isfleeing = true;

    game.checkBattle();

    assert.equal(game.unitOrders.length, 2);
  });
});

describe('Recalling troops during town defense', () => {
  it('Given a captain already home, when new troops arrive and a defender wanders away, then both are recalled throughout defense', () => {
    const game = transitGame();
    game.state.CaptainIsHome = () => true;
    game.state.town_threatened = true;
    Object.assign(game.units[0], { x: 100, y: 0 });
    Object.assign(game.units[1], { x: 200, y: 0 });
    const reinforcement = { x: 5000, y: 0, owner: 0, alive: true, order: 'smart' };
    let waits = 0;

    game.defendTown(() => {
      if (++waits === 1) {
        assert.equal(game.unitOrders.length, 0, 'Local defenders remain free to fight');
        game.units[0].x = 2000;
        game.units[0].order = 'patrol';
        game.units.push(reinforcement);
      } else {
        game.state.town_threatened = false;
      }
    });

    assert.deepEqual(game.unitOrders, [game.units[0], reinforcement].map(unit => ({ unit, order: 'move', x: 0, y: 0 })));
    assert.equal(waits, 2);
  });

  it('Given a portal temporarily blocking orders, when it finishes during retreat, then the next check recalls troops', () => {
    const game = transitGame();
    game.state.teleporting = true;
    game.state.isfleeing = true;
    game.checkBattle();

    game.state.teleporting = false;
    game.checkBattle();

    assert.equal(game.unitOrders.length, 2);
  });
});

describe('Uninterrupted retreat movement', () => {
  it('Given troops moving toward home, when repeated checks run over twenty seconds, then their move is never restarted', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.unitOrders.length = 0;

    for (let time = 2; time <= 20; time += 2) {
      game.state.ai_time = time;
      for (const unit of game.units) { unit.x -= 150; unit.y -= 150; }
      game.checkBattle();
    }

    assert.deepEqual(game.unitOrders, []);
  });

  it('Given troops taking a short detour, when checks see no homeward progress for less than eight seconds, then movement continues', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.unitOrders.length = 0;

    game.units[0].x += 100;
    game.state.ai_time = 6;
    game.checkBattle();

    assert.deepEqual(game.unitOrders, []);
  });

  it('Given a stalled or diverted move, when eight seconds pass without progress, then the homeward order is retried once', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.unitOrders.length = 0;
    game.units[0].x += 500;

    game.state.ai_time = 8;
    game.checkBattle();
    game.checkBattle();

    assert.equal(game.unitOrders.length, 2);
    assert.ok(game.unitOrders.every(order => order.order === 'move'));
  });

  it('Given troops already returning, when another town becomes home, then they immediately receive the new destination', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.unitOrders.length = 0;

    game.state.captain_home = game.state.Location(2000, 1000);
    game.checkBattle();

    assert.equal(game.unitOrders.length, 2);
    assert.ok(game.unitOrders.every(order => order.x === 2000 && order.y === 1000));
  });

  it('Given a rejected move order, when the next check runs, then the unit is retried immediately', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    const issueOrder = game.state.IssuePointOrder;
    game.state.IssuePointOrder = () => false;
    game.checkBattle();

    game.state.IssuePointOrder = issueOrder;
    game.checkBattle();

    assert.equal(game.unitOrders.length, 2);
  });
});

describe('Guard ownership during retreat', () => {
  it('Given available field troops, when retreat begins, then guard control is removed before their move and reserved until arrival', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    const issueOrder = game.state.IssuePointOrder;
    game.state.IssuePointOrder = (unit, ...args) => {
      assert.equal(unit.guardRemoved, true, 'Native captain must release the unit before its move');
      return issueOrder(unit, ...args);
    };

    game.checkBattle();
    game.checkBattle();

    assert.equal(game.guardChanges.length, 2, 'Remove guard once per returning unit');
    assert.equal(game.returnJobs.length, 2, 'Keep one queued return check per unit');
    for (const unit of game.units) {
      assert.equal(game.state.unit_retreating.has(unit), true);
      assert.equal(game.state.IsStandardUnit(unit), false, 'Other jobs must leave returning troops alone');
    }
  });

  it('Given detached troops, when each reaches the home radius, then its guard is restored exactly once and retreat can finish', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.state.CaptainIsHome = () => true;
    game.units[0].x = 1200;
    game.units[0].y = 0;

    game.checkBattle();
    assert.equal(game.units[0].guardRemoved, false);
    assert.equal(game.units[1].guardRemoved, true);
    assert.equal(game.state.retreat_controlled, true);
    game.units[1].x = 0;
    game.units[1].y = 0;
    game.checkBattle();
    game.checkReturns();

    assert.equal(game.state.unit_retreating.size, 0);
    assert.equal(game.state.retreat_moves.size, 0);
    assert.equal(game.returnJobs.length, 0);
    assert.equal(game.guardChanges.filter(change => change.action === 'restore').length, 2);
    assert.equal(game.state.retreat_controlled, false);
  });

  it('Given town defense ending before troops arrive, when their queued return checks run later, then guard control is still restored at home', () => {
    const game = transitGame();
    game.state.town_threatened = true;
    game.defendTown(() => { game.state.town_threatened = false; });
    game.state.retreat_controlled = false;

    for (const unit of game.units) { unit.x = 100; unit.y = 0; }
    game.checkReturns();

    assert.equal(game.state.unit_retreating.size, 0);
    assert.ok(game.units.every(unit => unit.guardRemoved === false));
    assert.equal(game.returnJobs.length, 0);
  });

  it('Given detached troops, when one is removed and another starts healing, then cleanup never restores guard over the healing job', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();

    game.units[0].removed = true;
    game.units[0].alive = false;
    game.state.unit_healing.add(game.units[1]);
    game.checkReturns();

    assert.equal(game.state.unit_retreating.size, 0);
    assert.equal(game.state.retreat_moves.size, 0);
    assert.equal(game.returnJobs.length, 0);
    assert.ok(game.guardChanges.every(change => change.action === 'remove'));
  });

  it('Given a full job queue, when retreat is requested, then guard control is retained instead of orphaning the unit', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.state.TQAddUnitJob = () => false;

    game.checkBattle();

    assert.deepEqual(game.guardChanges, []);
    assert.deepEqual(game.unitOrders, []);
    assert.equal(game.state.unit_retreating.size, 0);
  });

  it('Given detached troops, when the return queue fills, then native guard control is restored instead of leaving them reserved forever', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();

    game.state.TQAddUnitJob = () => false;
    game.checkReturns();

    assert.equal(game.state.unit_retreating.size, 0);
    assert.equal(game.state.retreat_moves.size, 0);
    assert.ok(game.units.every(unit => unit.guardRemoved === false));
  });
});

describe('Retreat reservation cleanup', () => {
  it('Given a unit that cannot make homeward progress, when two minutes pass, then its reservation ends and native guard control is restored', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();

    for (let time = 8; time <= 120; time += 8) {
      game.state.ai_time = time;
      game.checkReturns();
    }

    assert.equal(game.state.unit_retreating.size, 0);
    assert.equal(game.returnJobs.length, 0);
    assert.ok(game.units.every(unit => unit.guardRemoved === false));
  });

  it('Given returning ghouls that start harvesting, when their queued checks run, then the return reservation ends without a new move', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.unitOrders.length = 0;

    game.units[0].order = 'harvest';
    game.units[1].order = 'resumeharvesting';
    game.checkReturns();

    assert.equal(game.state.unit_retreating.size, 0);
    assert.deepEqual(game.unitOrders, []);
    assert.ok(game.units.every(unit => unit.guardRemoved === false));
  });
});

describe('Engaging attackers on arrival for town defense', () => {
  it('Given troops recalled to a threatened town, when they enter the home radius, then they regain guard control and attack-move toward home once', () => {
    const game = transitGame();
    game.state.town_threatened = true;
    game.state.town_threat_break = true;
    game.state.captain_home = game.state.Location(2000, 1000);
    game.checkBattle();
    assert.ok(game.unitOrders.every(order => order.order === 'move'), 'Travel from the field uses move');
    game.unitOrders.length = 0;

    Object.assign(game.units[0], { x: 3200, y: 1000 });
    game.checkReturns();
    game.checkReturns();

    assert.deepEqual(game.unitOrders, [{ unit: game.units[0], order: 'attack', x: 2000, y: 1000 }]);
    assert.equal(game.units[0].guardRemoved, false);
    assert.equal(game.state.unit_retreating.has(game.units[0]), false);
    assert.equal(game.units[1].guardRemoved, true, 'Distant troops keep returning under direct control');
  });

  it('Given only a native town threat, when returning troops arrive, then they attack-move to defend', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.state.TownThreatened = () => true;
    game.unitOrders.length = 0;

    Object.assign(game.units[0], { x: 100, y: 0 });
    game.checkReturns();

    assert.equal(game.unitOrders[0].order, 'attack');
    assert.equal(game.units[0].guardRemoved, false);
  });

  it('Given a normal retreat without a town threat, when troops arrive, then guard control returns without an attack-move', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.unitOrders.length = 0;

    for (const unit of game.units) Object.assign(unit, { x: 100, y: 0 });
    game.checkReturns();

    assert.deepEqual(game.unitOrders, []);
    assert.ok(game.units.every(unit => unit.guardRemoved === false));
  });

  it('Given defenders casting or already fighting near home, when return checks run, then their current orders are preserved', () => {
    const game = transitGame();
    game.state.town_threatened = true;
    game.state.town_threat_break = true;
    game.checkBattle();
    game.unitOrders.length = 0;

    Object.assign(game.units[0], { x: 100, y: 0, order: 'channel' });
    Object.assign(game.units[1], { x: 200, y: 0, order: 'attack' });
    game.checkReturns();

    assert.deepEqual(game.unitOrders, []);
    assert.equal(game.units[0].order, 'channel');
    assert.equal(game.units[1].order, 'attack');
    assert.equal(game.state.unit_retreating.size, 0);
  });

  it('Given a portal active when defenders reach home, when return checks run, then no attack-move interrupts it', () => {
    const game = transitGame();
    game.state.town_threatened = true;
    game.state.town_threat_break = true;
    game.checkBattle();
    game.unitOrders.length = 0;

    game.state.teleporting = true;
    for (const unit of game.units) Object.assign(unit, { x: 100, y: 0 });
    game.checkReturns();

    assert.deepEqual(game.unitOrders, []);
  });
});
