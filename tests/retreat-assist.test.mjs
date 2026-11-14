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

  it('Given attackers and idle troops away from home, when stronger enemies force retreat, then each retreat check recalls them while preserving the captain roster', () => {
    const game = transitGame();
    game.units[1].order = 0;
    game.addEnemy({ strength: 60 });

    game.checkBattle();
    game.checkBattle();
    game.checkBattle();

    assert.equal(game.state.isfleeing, true);
    assert.equal(game.work.formations, 0, 'Retreat must not recruit reinforcements');
    assert.deepEqual(game.unitOrders, Array.from({ length: 3 }, () => game.units.slice(0, 2).map(unit => ({ unit, order: 'move', x: 0, y: 0 }))).flat());
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

    assert.equal(game.unitOrders.length, 2);
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

  it('Given an army already home, when retreat ends, then stragglers receive a final recall before retreat control ends', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.state.CaptainIsHome = () => true;

    game.checkBattle();

    assert.equal(game.unitOrders.length, 2);
    assert.equal(game.state.retreat_controlled, false);
  });

  it('Given a later attack after returning home, when it also retreats, then its troops are recalled again', () => {
    const game = transitGame();
    game.state.isfleeing = true;
    game.checkBattle();
    game.state.CaptainIsHome = () => true;
    game.checkBattle();
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
