import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { townDefenseGame } from './helpers/town-defense-game.mjs';

for (const version of ['ROC', 'TFT', 'REFORGED']) describe(version + ' credible town defense', () => {
  it('Given a passing worker, when it leaves before confirmation, then the main attack continues and defenders stay home', () => {
    const game = townDefenseGame(version);
    const scout = game.addWorker();

    game.checkTown(0);
    scout.x = 1100;
    game.checkTown(4);

    assert.equal(game.state.town_intruder[0], null);
    assert.equal(game.state.town_threatened, false);
    assert.deepEqual(game.captains.get(2), { x: 0, y: 0 });
    assert.equal(game.state.attack_running, true);
    assert.equal(game.state.break_attack, false);
  });

  it('Given the same small intrusion, when four seconds pass, then only local defenders intercept its current position', () => {
    const game = townDefenseGame(version);
    const scout = game.addWorker();

    game.checkTown(0);
    scout.x = 600;
    game.checkTown(3);
    assert.equal(game.state.town_intruder_confirmed[0], false);
    game.checkTown(4);

    assert.equal(game.state.town_intruder_confirmed[0], true);
    assert.deepEqual(game.captains.get(2), { x: 600, y: 0 });
    assert.deepEqual(game.captains.get(1), { x: 0, y: 0 });
    assert.equal(game.state.town_threatened, false);
    assert.equal(game.state.teleporting, false);
    assert.equal(game.state.attack_running, true);
  });

  it('Given a cancelled foundation, when another replaces it, then the new handle starts without confirmation or progress credit', () => {
    const game = townDefenseGame(version);
    const bait = game.addTower({ life: 10 });
    game.checkTown(0);
    bait.alive = false;
    const replacement = game.addTower({ life: 30 });

    game.checkTown(5);

    assert.equal(game.state.town_intruder[0], replacement);
    assert.equal(game.state.town_intruder_confirmed[0], false);
    assert.equal(game.state.town_tower_progress[0], false);
    assert.equal(game.state.town_threatened, false);
  });

  it('Given a growing tower foundation, when it reaches 25 percent with ten percent growth after confirmation, then the main army returns safely', () => {
    const game = townDefenseGame(version);
    const tower = game.addTower({ life: 15 });
    game.checkTown(0);

    tower.life = 24;
    game.checkTown(4);
    assert.equal(game.state.town_threatened, false);
    tower.life = 25;
    game.checkTown(5);

    assert.equal(game.state.town_tower_progress[0], true);
    assert.equal(game.state.town_threatened, true);
    assert.equal(game.state.town_threat[0], 1.5);
    assert.deepEqual(game.captains.get(2), { x: 500, y: 0 });
    assert.deepEqual(game.captains.get(1), { x: 0, y: 0 });
    assert.deepEqual({ ...game.state.captain_home }, { x: 0, y: 0 });
    assert.equal(game.state.captain_tp, true);
  });

  it('Given a completed tower without construction growth, when confirmed, then its presence alone does not recall the assault', () => {
    const game = townDefenseGame(version);
    game.addTower();

    game.checkTown(0);
    game.checkTown(4);

    assert.equal(game.state.town_threat[0], 6);
    assert.equal(game.state.town_tower_progress[0], false);
    assert.equal(game.state.town_threatened, false);
  });

  it('Given a foundation above 25 percent, when its growth is less than ten percent, then confirmation only moves local defenders', () => {
    const game = townDefenseGame(version);
    const tower = game.addTower({ life: 30 });
    game.checkTown(0);

    tower.life = 39;
    game.checkTown(4);

    assert.equal(game.state.town_tower_progress[0], false);
    assert.equal(game.state.town_threatened, false);
    assert.deepEqual(game.captains.get(2), { x: 500, y: 0 });
  });

  it('Given nearby enemy towers outside the economy boundary, when a foundation grows, then local emergency confirmation stays unset', () => {
    const game = townDefenseGame(version);
    const tower = game.addTower({ x: 1100, life: 10 });
    game.checkTown(0);

    tower.life = 50;
    game.checkTown(4);

    assert.equal(game.state.town_intruder[0], null);
    assert.equal(game.state.town_tower_progress[0], false);
    assert.equal(game.state.town_threatened, false);
    assert.equal(game.state.town_threat[0], 3);
  });

  it('Given six attacking workers, when the same local threat is confirmed, then their pressure recalls a capable army', () => {
    const game = townDefenseGame(version);
    for (let i = 0; i < 6; i++) game.addWorker();

    game.checkTown(0);
    assert.equal(game.state.town_threat[0], 0);
    game.checkTown(4);

    assert.ok(game.state.town_threat[0] > 10);
    assert.equal(game.state.town_threatened, true);
  });

  it('Given harvesting or unarmed workers, when several scans pass, then they never create intrusion pressure', () => {
    const game = townDefenseGame(version);
    game.addWorker({ order: 'harvest' });
    game.addWorker({ order: 'resumeharvesting' });
    game.addWorker({ attacksGround: false });

    game.checkTown(0);
    game.checkTown(4);

    assert.equal(game.state.town_intruder[0], null);
    assert.equal(game.state.town_threat[0], 0);
  });

  it('Given a worker, Ancient and towers, when selecting and refreshing defense, then rank, strength and distance decide without oscillation', () => {
    const game = townDefenseGame(version);
    game.addWorker({ x: 100 });
    game.addAncient({ x: 200 });
    game.addTower({ x: 100, life: 5 });
    game.addTower({ x: 800, life: 10 });
    const chosen = game.addTower({ x: 700, life: 10 });

    game.checkTown(0);
    game.addTower({ x: 300 });
    game.checkTown(4);

    assert.equal(game.state.town_intruder[0], chosen);
    assert.deepEqual(game.captains.get(2), { x: 700, y: 0 });
  });

  it('Given melee Ancients alone, when confirmed, then their strength is included once and local defenders intercept', () => {
    const game = townDefenseGame(version);
    const ancient = game.addAncient();

    game.checkTown(0);
    game.checkTown(4);

    assert.equal(game.state.town_intruder[0], ancient);
    assert.equal(game.state.town_threat[0], 540 / Math.pow(1000, 0.8));
    assert.equal(game.state.town_threatened, false);
    assert.deepEqual(game.captains.get(2), { x: 500, y: 0 });
  });

  for (const [reason, change] of [
    ['withdraws', u => { u.x = 1100; }], ['dies', u => { u.alive = false; }],
    ['becomes hidden', u => { u.hidden = true; }], ['leaves vision', u => { u.visible = false; }],
    ['becomes invisible', u => { u.invisible = true; }], ['changes ownership', u => { u.owner = 2; }],
  ]) it('Given a confirmed worker, when it ' + reason + ', then confidence ends and the defense captain returns home', () => {
    const game = townDefenseGame(version);
    const worker = game.addWorker();
    game.checkTown(0);
    game.checkTown(4);

    change(worker);
    game.checkTown(5);

    assert.equal(game.state.town_intruder_confirmed[0], false);
    assert.deepEqual(game.captains.get(2), { x: 0, y: 0 });
    assert.equal(game.state.town_threatened, false);
  });

  it('Given expired observations, when the same tower is seen again, then it must establish fresh evidence', () => {
    const game = townDefenseGame(version);
    const tower = game.addTower({ life: 10 });
    game.checkTown(0);

    tower.life = 50;
    game.checkTown(13);

    assert.equal(game.state.town_intruder_confirmed[0], false);
    assert.equal(game.state.town_tower_progress[0], false);
  });

  it('Given no tracked field army, when an intrusion is confirmed, then local defense works without a negative army read or recall', () => {
    const game = townDefenseGame(version);
    game.state.main_army = -1;
    game.state.army_num = 0;
    game.addTower({ life: 10 });

    game.checkTown(0);
    game.checkTown(4);

    assert.equal(game.state.town_threatened, false);
    assert.deepEqual(game.captains.get(2), { x: 500, y: 0 });
  });

  it('Given confirmed local threats at own and allied towns, when choosing defense, then the own town takes priority', () => {
    const game = townDefenseGame(version);
    game.addTown({ x: 5000, owner: 2 });
    game.addWorker({ x: 5500 });
    game.addWorker();

    game.checkTown(0);
    game.checkTown(4);

    assert.deepEqual(game.captains.get(2), { x: 500, y: 0 });
    assert.deepEqual(game.captains.get(1), { x: 0, y: 0 });
  });

  it('Given confirmed town evidence, when town entries are copied, then the candidate and its timing stay with that town', () => {
    const game = townDefenseGame(version);
    const tower = game.addTower({ life: 10 });
    game.checkTown(0);
    game.checkTown(4);

    game.copyTown(0, 1);

    assert.equal(game.state.town_intruder[1], tower);
    assert.equal(game.state.town_intruder_anchor[1], game.hall);
    assert.equal(game.state.town_intruder_confirmed[1], true);
    assert.equal(game.state.town_intruder_since[1], 0);
  });

  it('Given a minor intrusion at an expansion, when local defenders respond, then the fighting army retains its main-base retreat anchor', () => {
    const game = townDefenseGame(version);
    game.addTown({ x: 6000 });
    game.addWorker({ x: 6500 });

    game.checkTown(0);
    game.checkTown(4);

    assert.equal(game.state.town_threatened, false);
    assert.deepEqual(game.captains.get(2), { x: 6500, y: 0 });
    assert.deepEqual(game.captains.get(1), { x: 0, y: 0 });
  });

  it('Given only a small allied intrusion, when confirmed, then defenders intercept without redirecting the main army retreat', () => {
    const game = townDefenseGame(version);
    game.addTown({ x: 6000, owner: 2 });
    game.addWorker({ x: 6500 });

    game.checkTown(0);
    game.checkTown(4);

    assert.equal(game.state.town_threatened, false);
    assert.deepEqual(game.captains.get(2), { x: 6500, y: 0 });
    assert.deepEqual(game.captains.get(1), { x: 0, y: 0 });
  });

  it('Given a higher-scoring minor threat and a progressing expansion tower, when recalling, then defenders target the tower at the selected expansion', () => {
    const game = townDefenseGame(version);
    game.addTown({ x: 6000 });
    game.addTower();
    const tower = game.addTower({ x: 6500, life: 10 });
    game.checkTown(0);

    tower.life = 25;
    game.checkTown(4);

    assert.equal(game.state.town_threatened, true);
    assert.equal(game.state.most_threatened_town, 1);
    assert.deepEqual(game.captains.get(2), { x: 6500, y: 0 });
    assert.deepEqual(game.captains.get(1), { x: 6000, y: 0 });
  });

  it('Given a recalled army and a cancelled tower, when the next scan finds no pressure, then recall ends without extending the bait', () => {
    const game = townDefenseGame(version);
    const tower = game.addTower({ life: 10 });
    game.checkTown(0);
    tower.life = 30;
    game.checkTown(4);
    assert.equal(game.state.town_threatened, true);

    tower.alive = false;
    game.checkTown(5);

    assert.equal(game.state.town_threatened, false);
    assert.deepEqual(game.captains.get(2), { x: 0, y: 0 });
  });

  it('Given a scout that leaves and returns, when observed again, then its previous confirmation cannot be reused', () => {
    const game = townDefenseGame(version);
    const scout = game.addWorker();
    game.checkTown(0);
    game.checkTown(4);
    scout.x = 1100;
    game.checkTown(5);

    scout.x = 500;
    game.checkTown(6);

    assert.equal(game.state.town_intruder_confirmed[0], false);
    assert.deepEqual(game.captains.get(2), { x: 0, y: 0 });
  });

  it('Given a foundation transferred between enemies, when its owner changes, then the same handle must establish fresh construction evidence', () => {
    const game = townDefenseGame(version);
    const tower = game.addTower({ life: 10 });
    game.checkTown(0);

    tower.owner = 3;
    tower.life = 30;
    game.checkTown(4);

    assert.equal(game.state.town_intruder[0], tower);
    assert.equal(game.state.town_intruder_confirmed[0], false);
    assert.equal(game.state.town_tower_progress[0], false);
  });

  it('Given a substantial tracked army inside town, when defense is selected, then its position receives defenders and the town remains the retreat anchor', () => {
    const game = townDefenseGame(version);
    const soldier = game.addSoldier({ level: 20, food: 20 });
    game.state.army_owner[1] = 1;
    game.state.army_loc[1] = game.state.Location(500, 0);
    game.state.army_dir[1] = game.state.Location(0, 0);
    game.state.army_future[1] = game.state.Location(500, 0);
    game.state.army_group[1] = new Set([soldier]);
    game.trackArmy(1);
    game.state.army_num = 2;

    game.checkTown(0);

    assert.equal(game.state.town_threatened, true);
    assert.equal(game.state.town_threat[0], 20 * 540 / Math.pow(500, 0.8));
    assert.deepEqual(game.captains.get(2), { x: 500, y: 0 });
    assert.deepEqual(game.captains.get(1), { x: 0, y: 0 });
  });

  it('Given an intruder lost during a staggered scan, when evaluation resumes, then the dead candidate supplies no target or strength', () => {
    const game = townDefenseGame(version);
    const scout = game.addWorker();
    for (let i = 0; i < 62; i++) game.addSoldier();
    let waits = 0;
    game.state.Sleep = () => { if (++waits === 2) scout.alive = false; };

    game.checkTown(0);

    assert.ok(waits >= 2);
    assert.equal(game.state.town_intruder[0], null);
    assert.equal(game.state.town_threat[0], 0);
  });

  it('Given a destroyed economic town, when threat checks run, then its old intrusion evidence is cleared', () => {
    const game = townDefenseGame(version);
    game.addWorker();
    game.checkTown(0);
    game.checkTown(4);

    game.hall.alive = false;
    game.checkTown(5);

    assert.equal(game.state.town_intruder[0], null);
    assert.equal(game.state.town_threat[0], 0);
    assert.deepEqual(game.captains.get(2), { x: 0, y: 0 });
  });

  it('Given unchanged captain targets, when scans repeat, then native positions match the caches without redundant orders', () => {
    const game = townDefenseGame(version);
    game.addWorker();
    game.checkTown(0);
    game.checkTown(4);
    const count = game.orders.length;
    const locations = game.locations.size;

    game.checkTown(5);

    assert.equal(game.orders.length, count);
    assert.equal(game.locations.size, locations);
    assert.deepEqual(game.captains.get(1), { ...game.state.captain_home });
    assert.deepEqual(game.captains.get(2), { ...game.state.defense_captain_home });
    assert.ok(game.orders.every(o => o.which !== 3));
  });

  it('Given a lone combat unit, when armies are tracked, then it remains a tracked threat', () => {
    const game = townDefenseGame(version);
    const soldier = game.addSoldier();
    game.state.army_owner[1] = 1;
    game.state.army_loc[1] = game.state.Location(500, 0);
    game.state.army_dir[1] = game.state.Location(0, 0);
    game.state.army_future[1] = game.state.Location(500, 0);
    game.state.army_group[1] = new Set([soldier]);

    const tracked = game.trackArmy(1);

    assert.equal(tracked, true);
    assert.equal(game.state.army_count[1], 1);
    assert.equal(game.state.army_strength[1], 2);
  });

  it('Given a progressing tower but an incapable army, when confirmed, then it never forces an unwinnable return', () => {
    const game = townDefenseGame(version);
    const tower = game.addTower({ life: 10 });
    game.state.army_strength[0] = 0.1;
    game.checkTown(0);

    tower.life = 30;
    game.checkTown(4);

    assert.equal(game.state.town_tower_progress[0], true);
    assert.equal(game.state.town_threatened, false);
  });

  it('Given hostile towers and Ancients in battle, when assessing retreat, then static strength counts without shifting the enemy army position', () => {
    const game = townDefenseGame(version);
    game.addTower({ x: 5200 });
    game.addAncient({ x: 5300 });
    game.addTower({ x: 5100, owner: 0 });
    game.addSoldier({ x: 5400 });

    game.checkBattle();

    assert.equal(game.state.enemy_strength_sum, 6);
    assert.equal(game.state.ally_strength_sum, 100);
    assert.deepEqual({ ...game.state.enemy_loc }, { x: 5400, y: 0 });
  });
});
