import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { focusFireGame } from './helpers/focus-fire-game.mjs';

describe('Battle micro preserves captain control', () => {
  it('Given a wounded archer chased by melee, when kiting, then it moves away without leaving the captain or scheduling a guard reset', () => {
    const game = focusFireGame();
    const archer = game.addArcher({ life: 60 });
    game.addEnemy({ melee: true, ranged: false });

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: archer, order: 'move', x: -800, y: 0 }]);
    assert.equal(game.captain.has(archer), true);
    assert.deepEqual(game.guardChanges, []);
    assert.deepEqual(game.jobs, [{ delay: 2, id: game.state.FOCUSFIRE_CONTROL, parameter: 0 }]);
  });

  it('Given an army consisting entirely of wounded archers, when all kite, then the captain keeps its complete roster', () => {
    const game = focusFireGame();
    const archers = [0, 10, 20].map(x => game.addArcher({ x, life: 60 }));
    game.addEnemy({ melee: true, ranged: false });

    game.checkBattle();

    assert.equal(game.orders.length, 3);
    assert.ok(game.orders.every(order => order.order === 'move'));
    assert.deepEqual([...game.captain], archers);
    assert.deepEqual(game.guardChanges, []);
  });

  it('Given nearby melee facing away, when assessing a wounded archer, then it attacks instead of needlessly kiting', () => {
    const game = focusFireGame();
    const archer = game.addArcher({ life: 60 });
    const enemy = game.addEnemy({ melee: true, ranged: false, facing: 0 });

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: archer, order: 'attack', target: enemy }]);
  });

  it('Given melee and an archer at the same position, when micro runs, then no zero-distance division occurs', () => {
    const game = focusFireGame();
    const archer = game.addArcher({ life: 60 });
    const enemy = game.addEnemy({ x: 0, melee: true, ranged: false });

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: archer, order: 'attack', target: enemy }]);
  });

  it('Given a Wind Walker preparing an attack, when focus fire casts Wind Walk, then the captain retains the unit', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true });
    game.addEnemy();

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: hero, order: 'windwalk' }]);
    assert.equal(game.captain.has(hero), true);
    assert.deepEqual(game.guardChanges, []);
    assert.equal(game.jobs.length, 1);
  });

  it('Given an invisible Wind Walker, when attacking the chosen target, then its guard is removed before the attack and a reset is queued', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true });
    const enemy = game.addEnemy();

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: hero, order: 'attack', target: enemy }]);
    assert.equal(game.captain.has(hero), false);
    assert.deepEqual(game.guardChanges, [hero]);
    assert.deepEqual(game.jobs[0], { delay: 1.8, id: game.state.RESET_WINDWALKER, parameter: 0, unit: hero });
  });

  it('Given an invisible hero whose current order is still Wind Walk, when a target is chosen, then it can receive the attack that breaks invisibility', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true, order: 'windwalk' });
    const enemy = game.addEnemy();

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: hero, order: 'attack', target: enemy }]);
    assert.deepEqual(game.guardChanges, [hero]);
  });

  it('Given a detached Wind Walker that has landed its attack, when its reset runs, then it returns to the active assault', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true });
    game.addEnemy();
    game.checkBattle();
    hero.windwalking = false;

    game.runGuardReset();

    assert.equal(game.captain.has(hero), true);
    assert.deepEqual(game.guardChanges, [hero, hero]);
    assert.deepEqual(game.assaults, [{ count: 1, id: game.state.GetUnitTypeId(hero) }]);
  });

  it('Given a Wind Walker still approaching its target, when its reset runs early, then control stays detached and the check is rescheduled', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true });
    game.addEnemy();
    game.checkBattle();

    game.runGuardReset();

    assert.equal(game.captain.has(hero), false);
    assert.deepEqual(game.guardChanges, [hero]);
    assert.deepEqual(game.assaults, []);
    assert.deepEqual(game.jobs.at(-1), { delay: 1.8, id: game.state.RESET_WINDWALKER, parameter: 1, unit: hero });
  });

  it('Given a detached Wind Walker when retreat starts, when its reset runs, then native control resumes without assault recruitment', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true });
    game.addEnemy();
    game.checkBattle();
    game.state.isfleeing = true;

    game.runGuardReset();

    assert.deepEqual(game.guardChanges, [hero, hero]);
    assert.deepEqual(game.assaults, []);
    assert.equal(game.jobs.length, 2);
  });

  it('Given a removed Wind Walker, when its deferred reset runs, then no native control or recruitment touches the missing unit', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true });
    game.addEnemy();
    game.checkBattle();
    hero.removed = true;

    game.runGuardReset();

    assert.deepEqual(game.guardChanges, [hero]);
    assert.deepEqual(game.assaults, []);
  });

  it('Given a Wind Walker that never reaches its target, when ten reset checks run, then it returns to native control instead of staying detached indefinitely', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true });
    game.addEnemy();
    game.checkBattle();

    for (let check = 0; check < 10; check++) game.runGuardReset();

    assert.equal(game.captain.has(hero), true);
    assert.deepEqual(game.guardChanges, [hero, hero]);
    assert.equal(game.jobs.filter(job => job.id === game.state.RESET_WINDWALKER).length, 10);
  });

  it('Given an invisible Wind Walker in overlapping scans, when focus-fire checks repeat before its reset, then only one attack and one reset are queued', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true, hero: true });
    game.addEnemy();
    game.state.major_hero = hero;

    game.checkBattle();
    game.checkBattle();

    assert.equal(game.orders.length, 1);
    assert.deepEqual(game.guardChanges, [hero]);
    assert.equal(game.jobs.filter(job => job.id === game.state.RESET_WINDWALKER).length, 1);
  });

  it('Given a full job queue, when an invisible hero would attack, then it stays with the captain because no return job can be secured', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true });
    game.addEnemy();
    game.state.queueFull = true;

    game.checkBattle();

    assert.deepEqual(game.orders, []);
    assert.deepEqual(game.guardChanges, []);
    assert.equal(game.captain.has(hero), true);
    assert.equal(game.state.windwalk_group.size, 0);
  });

  it('Given a hero removed while waiting to enqueue its return, when enqueueing finishes, then no attack or guard removal touches it', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true });
    game.addEnemy();
    game.state.onEnqueue = () => { hero.removed = true; };

    game.checkBattle();
    game.runGuardReset();

    assert.deepEqual(game.orders, []);
    assert.deepEqual(game.guardChanges, []);
    assert.equal(game.state.windwalk_group.size, 0);
  });

  it('Given a detached hero and a full queue, when its reset cannot retry, then native control resumes immediately', () => {
    const game = focusFireGame();
    const hero = game.addArcher({ windwalk: true, windwalking: true });
    game.addEnemy();
    game.checkBattle();
    game.state.queueFull = true;

    game.runGuardReset();

    assert.equal(game.captain.has(hero), true);
    assert.deepEqual(game.guardChanges, [hero, hero]);
    assert.equal(game.state.windwalk_group.size, 0);
    assert.equal(game.jobs.filter(job => job.id === game.state.RESET_WINDWALKER).length, 1);
  });
});

describe('Focus-fire selection and bounded order batches', () => {
  it('Given overlapping hero and army scans, when choosing focus fire, then each troop receives one order', () => {
    const game = focusFireGame();
    const archer = game.addArcher();
    const hero = game.addArcher({ hero: true });
    const enemy = game.addEnemy();
    game.state.major_hero = hero;
    game.state.army_num = 2;
    game.state.army_loc.push({ x: 0, y: 0 });
    game.state.army_owner.push(0);

    game.checkBattle();

    assert.deepEqual(game.orders, [
      { unit: archer, order: 'attack', target: enemy },
      { unit: hero, order: 'attack', target: enemy },
    ]);
  });

  it('Given workers, allied troops, channeling and recovering units, when focus fire runs, then it controls only free combat troops', () => {
    const game = focusFireGame();
    game.addArcher({ worker: true });
    game.addArcher({ owner: 2 });
    game.addArcher({ structure: true, ranged: false });
    game.addArcher({ order: 'blizzard', life: 60 });
    game.state.unit_healing.add(game.addArcher({ life: 60 }));
    game.state.unit_buying_item.add(game.addArcher());
    const archer = game.addArcher();
    const enemy = game.addEnemy({ melee: true, ranged: false });

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: archer, order: 'attack', target: enemy }]);
  });

  it('Given a flying target and troops with different ranges and attack capabilities, when selecting attackers, then only nearby anti-air troops receive orders', () => {
    const game = focusFireGame();
    const archer = game.addArcher();
    game.addArcher({ ranged: false, melee: true, attacksAir: false });
    game.addArcher({ x: -600 });
    const enemy = game.addEnemy({ flying: true });

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: archer, order: 'attack', target: enemy }]);
  });

  it('Given a damaged defensive tower beside melee, when focus fire runs, then it can attack without receiving a move order', () => {
    const game = focusFireGame();
    const tower = game.addArcher({ structure: true, life: 60 });
    const enemy = game.addEnemy({ melee: true, ranged: false });

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: tower, order: 'attack', target: enemy }]);
    assert.deepEqual(game.guardChanges, []);
  });

  it('Given a threatened town and overlapping scans, when ignoring neutral creeps, then the borrowed scan group remains usable', () => {
    const game = focusFireGame();
    const archer = game.addArcher();
    game.state.major_hero = game.addArcher({ hero: true, ranged: false });
    game.addEnemy({ owner: 12, life: 1 });
    const enemy = game.addEnemy();
    game.state.town_threatened = true;

    game.checkBattle();

    assert.deepEqual(game.orders, [{ unit: archer, order: 'attack', target: enemy }]);
  });

  it('Given a large troop scan, when its target disappears during a yield, then no attack uses the missing target', () => {
    const game = focusFireGame();
    for (let i = 0; i < 70; i++) game.addArcher();
    const enemy = game.addEnemy();
    game.state.onSleep = () => { enemy.removed = true; };

    game.checkBattle();

    assert.deepEqual(game.orders, []);
    assert.ok(game.sleeps.length > 0);
  });

  it('Given troops collected before a yield, when one disappears, then execution revalidates it and controls only survivors', () => {
    const game = focusFireGame();
    const removed = game.addArcher();
    for (let i = 0; i < 69; i++) game.addArcher();
    game.addEnemy();
    game.state.onSleep = () => { removed.removed = true; };

    game.checkBattle();

    assert.equal(game.orders.length, 69);
    assert.ok(game.orders.every(order => order.unit !== removed));
  });

  it('Given twenty attackers, when retreat begins after the first order batch, then the remaining troops receive no focus-fire override', () => {
    const game = focusFireGame();
    for (let i = 0; i < 20; i++) game.addArcher();
    game.addEnemy();
    game.state.onSleep = () => { game.state.isfleeing = true; };

    game.checkBattle();

    assert.equal(game.orders.length, 16);
    assert.deepEqual(game.sleeps, [0.05]);
    assert.equal(game.captain.size, 20);
    assert.deepEqual(game.guardChanges, []);
  });
});
