// Run: node --test --test-reporter=spec TestingScenarios/statue-control.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { undeadGame } from './helpers/statue-game.mjs';

describe('Obsidian Statue battle positioning', () => {
  it('Given a solo Undead army, when battle checks run, then statues move behind that army without counting its strength twice', () => {
    const game = undeadGame();

    game.checkBattle();
    game.positionStatue();

    assert.deepEqual(game.state.last_ally_loc, { x: 4000, y: 4000 });
    assert.deepEqual(game.state.last_enemy_loc, { x: 4500, y: 4000 });
    assert.equal(game.state.ally_strength_sum, 11);
    assert.deepEqual(game.orders, [{ unit: game.statue, order: 'move', x: 3700, y: 4000 }]);
    assert.equal(game.locations.size, 0);
  });

  it('Given an old allied regroup point, when the battle moves, then statues follow the new battle and preserve the regroup point', () => {
    const game = undeadGame();
    game.state.ally_loc = { x: 1000, y: 1000 };
    game.checkBattle();
    for (const unit of game.units) unit.x += 1000;
    game.state.army_loc[0].x += 1000;

    game.checkBattle();
    game.positionStatue();

    assert.deepEqual(game.state.last_ally_loc, { x: 5000, y: 4000 });
    assert.deepEqual(game.state.last_enemy_loc, { x: 5500, y: 4000 });
    assert.deepEqual(game.state.ally_loc, { x: 1000, y: 1000 });
    assert.equal(game.orders[0].x, 4700);
  });

  it('Given no tracked main army, when battle checks use the hero, then statues still follow the friendly battle position', () => {
    const game = undeadGame();
    game.state.main_army = -1;

    game.checkBattle();
    game.positionStatue();

    assert.deepEqual(game.state.last_ally_loc, { x: 4000, y: 4000 });
    assert.equal(game.state.ally_strength_sum, 11);
    assert.equal(game.orders[0].x, 3700);
  });

  it('Given allied reinforcements, when battle strength is checked, then their strength is added once', () => {
    const game = undeadGame();
    game.units.push({ x: 4000, y: 4000, owner: 2, strength: 5 });

    game.checkBattle();

    assert.equal(game.state.ally_strength_sum, 16);
  });

  it('Given a retreating army, when statue control runs, then it leaves captain retreat orders alone', () => {
    const game = undeadGame();
    game.checkBattle();
    game.state.isfleeing = true;

    game.positionStatue();

    assert.deepEqual(game.orders, []);
    assert.equal(game.locations.size, 0);
  });

  it('Given combat has ended, when statue control runs, then it leaves the army travel orders alone', () => {
    const game = undeadGame();
    game.checkBattle();
    game.state.inCombat = false;

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given a statue at home, when a distant battle is checked, then it receives no battlefield positioning order', () => {
    const game = undeadGame();
    game.statue.x = 1000;
    game.statue.y = 1000;

    game.checkBattle();
    game.positionStatue();

    assert.deepEqual(game.orders, []);
    assert.equal(game.locations.size, 0);
  });

  it('Given a statue already supporting the army, when positioning runs again, then its current order is preserved', () => {
    const game = undeadGame();
    game.checkBattle();
    game.statue.x = 3700;

    game.positionStatue();

    assert.deepEqual(game.orders, []);
    assert.equal(game.locations.size, 0);
  });

  it('Given the enemy has left, when battle checks run, then the remembered enemy position is cleared immediately', () => {
    const game = undeadGame();
    game.checkBattle();
    game.enemy.x = 9000;

    game.checkBattle();

    assert.deepEqual(game.state.last_enemy_loc, { x: 0, y: 0 });
  });

  it('Given only statues in the army, when positioning runs repeatedly, then they do not pull themselves backward', () => {
    const game = undeadGame();
    game.units.splice(0, game.units.length, game.statue, { ...game.statue, x: 4100 }, game.enemy);

    for (let check = 0; check < 4; check++) {
      game.checkBattle();
      game.positionStatue();
    }

    assert.deepEqual(game.orders, []);
    assert.equal(game.locations.size, 0);
  });

  it('Given many statues beside one combat unit, when a threatened statue moves, then its support target stays anchored to that unit', () => {
    const game = undeadGame();
    game.units.push(...Array.from({ length: 8 }, () => ({ ...game.statue })));
    game.checkBattle();

    game.positionStatue();
    Object.assign(game.statue, { x: game.orders[0].x, y: game.orders[0].y });
    game.checkBattle();
    game.positionStatue();

    assert.equal(game.orders.length, 1);
    assert.equal(game.orders[0].x, 3700);
    assert.equal(game.locations.size, 0);
  });

  it('Given an injured ally in healing range and no close threat, when positioning runs, then the statue keeps its current order', () => {
    const game = undeadGame();
    game.enemy.x = 4800;
    game.statue.x = 4100;
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given a healthy caster missing mana in support range, when positioning runs, then the statue stays to supply mana', () => {
    const game = undeadGame();
    Object.assign(game.hero, { life: 100, mana: 10, maxMana: 100 });
    game.enemy.x = 4800;
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given an injured unit outside support range, when positioning runs, then the statue moves within range of that unit', () => {
    const game = undeadGame();
    game.statue.x = 3000;
    game.checkBattle();

    game.positionStatue();

    assert.equal(game.orders.length, 1);
    assert.ok(Math.hypot(game.orders[0].x - game.hero.x, game.orders[0].y - game.hero.y) <= 600);
    assert.equal(game.locations.size, 0);
  });

  it('Given a healthy unit nearby and an injured unit farther away, when out of support range, then the injured unit anchors the move', () => {
    const game = undeadGame();
    game.hero.x = 4800;
    game.enemy.x = 5200;
    game.units.push({ x: 4000, y: 4000, owner: 0, strength: 1 });
    game.checkBattle();

    game.positionStatue();

    assert.equal(game.orders[0].x, 4500);
  });

  it('Given every nearby unit has full health and mana, when no close threat exists, then the statue does not reposition', () => {
    const game = undeadGame();
    game.hero.life = 100;
    game.enemy.x = 4800;
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given a close enemy on the opposite flank from the enemy average, when positioning runs, then the statue moves away from that nearby threat', () => {
    const game = undeadGame();
    game.units.push({ x: 3800, y: 4000, owner: 1, strength: 1, attacksGround: true });
    game.checkBattle();

    game.positionStatue();

    assert.equal(game.orders[0].x, 4300);
  });

  it('Given a nearby enemy can only attack air, when the statue already supports an ally, then it does not flee that enemy', () => {
    const game = undeadGame();
    game.enemy.attacksGround = false;
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given a Destroyer transformation in progress, when positioning runs, then the transformation order is preserved', () => {
    const game = undeadGame();
    game.statue.order = 'destroyer-transformation';
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
    assert.equal(game.locations.size, 0);
  });

  it('Given a support spell is being cast, when positioning runs, then the cast is preserved', () => {
    const game = undeadGame();
    game.statue.order = 'replenishlife';
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given only a worker and a wounded mechanical unit nearby, when positioning runs, then neither anchors a support move', () => {
    const game = undeadGame();
    game.units.splice(1, 1,
      { x: 4000, y: 4000, owner: 0, strength: 1, peon: true, life: 20 },
      { x: 4000, y: 4000, owner: 0, strength: 1, mechanical: true, life: 20 });
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given the only injured ally is assigned to healing, when positioning runs, then the statue does not follow it out of combat', () => {
    const game = undeadGame();
    game.state.unit_healing.add(game.hero);
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given an injured ally exactly at the support range boundary, when no close threat exists, then the statue remains useful without moving', () => {
    const game = undeadGame();
    game.hero.x = 4600;
    game.enemy.x = 4800;
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given a hidden close enemy and an injured ally in range, when positioning runs, then the hidden enemy does not trigger movement', () => {
    const game = undeadGame();
    game.enemy.invisible = true;
    game.checkBattle();

    game.positionStatue();

    assert.deepEqual(game.orders, []);
  });

  it('Given a large battle scan, when conversion starts during its short wait, then the final move does not interrupt conversion', () => {
    const game = undeadGame();
    game.units.push(...Array.from({ length: 64 }, () => ({ x: 4000, y: 4000, owner: 0, strength: 1 })));
    game.checkBattle();
    game.state.onSleep = () => { game.statue.order = 'destroyer-transformation'; };

    game.positionStatue();

    assert.equal(game.statue.order, 'destroyer-transformation');
    assert.deepEqual(game.orders, []);
    assert.equal(game.locations.size, 0);
  });
});
