import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { orcGame } from './helpers/ward-game.mjs';

describe('Ward healing recovery assignments', () => {
  it('sends a critically injured troop and one Doctor home instead of casting beside the enemy', () => {
    const game = orcGame();
    game.doctor.x = 4500;
    const troop = game.addTroop({ x: 4000, life: 20 });

    game.checkUnits();
    game.checkHome(troop);
    game.checkRecovery();

    assert.equal(game.state.ward_recovery_healer, game.doctor);
    assert.ok(game.state.unit_healing.has(troop));
    assert.ok(game.state.unit_healing.has(game.doctor));
    assert.deepEqual(game.movements.map(({ unit, x, y }) => ({ unit, x, y })), [
      { unit: troop, x: 0, y: 0 }, { unit: game.doctor, x: 0, y: 0 },
    ]);
    assert.deepEqual(game.wards, []);
    assert.ok(!game.jobs.some(job => job.job === game.state.RESET_GUARD_POSITION));
    assert.equal(game.groups.size, 0);
  });

  it('keeps a healthy Doctor at home while waiting for its patient to arrive', () => {
    const game = orcGame();
    const troop = game.addTroop({ x: 4000 });

    game.sendHome(troop);
    game.checkRecovery();

    assert.deepEqual(game.wards, []);
    assert.equal(game.doctor.order, 'holdposition');
    assert.ok(game.state.unit_healing.has(game.doctor));
    assert.equal(game.jobs.filter(job => job.job === game.state.WARD_RECOVERY).length, 1);
  });

  it('casts at the recovery point once a patient arrives and keeps the patient assigned while hurt', () => {
    const game = orcGame();
    const troop = game.addTroop({ x: 4000 });
    game.sendHome(troop);

    game.arriveHome(troop);
    game.checkRecovery();
    game.checkHome(troop);

    assert.deepEqual(game.wards, [{ unit: game.doctor, order: 852109, x: 0, y: 0 }]);
    assert.ok(game.state.unit_healing.has(troop));
    assert.ok(game.state.ward_recovery_patients.has(troop));
    assert.ok(!game.jobs.some(job => job.job === game.state.RESET_GUARD_POSITION));
    assert.equal(game.groups.size, 0);
  });

  it('releases the patient and Doctor when the patient reaches the existing 60 percent recovery threshold', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.sendHome(troop);

    troop.life = 60;
    game.checkHome(troop);
    game.checkRecovery();

    assert.equal(game.state.ward_recovery_healer, null);
    assert.equal(game.state.unit_healing.size, 0);
    assert.equal(game.state.ward_recovery_patients.size, 0);
    assert.deepEqual(game.released, [troop, game.doctor]);
    assert.ok(!game.jobs.some(job => job.job === game.state.WARD_RECOVERY));
  });

  it('shares one Doctor between patients without reserving another Doctor or duplicating recovery jobs', () => {
    const game = orcGame();
    const spare = { ...game.doctor, x: 600 };
    game.units.push(spare);
    const first = game.addTroop({ life: 20 });
    const second = game.addTroop({ life: 20, x: 500 });

    game.checkUnits();

    assert.equal(game.state.ward_recovery_healer, game.doctor);
    assert.equal(game.state.ward_recovery_patients.size, 2);
    assert.ok(game.state.ward_recovery_patients.has(first));
    assert.ok(game.state.ward_recovery_patients.has(second));
    assert.ok(!game.state.unit_healing.has(spare));
    assert.equal(game.jobs.filter(job => job.job === game.state.WARD_RECOVERY).length, 1);
    assert.equal(game.jobs.filter(job => job.job === game.state.SEND_HOME).length, 2);
  });

  it('brings a healthy Doctor back for a unit already recovering at home', () => {
    const game = orcGame();
    game.doctor.x = 4000;
    const troop = game.addTroop();

    game.sendHome(troop);
    game.checkRecovery();
    game.arriveHome(game.doctor);
    game.checkRecovery();

    assert.equal(game.movements[0].unit, game.doctor);
    assert.equal(game.movements[0].x, 0);
    assert.equal(game.wards.length, 1);
  });

  it('keeps the Doctor assigned until the last patient recovers', () => {
    const game = orcGame();
    const first = game.addTroop();
    const second = game.addTroop();
    game.sendHome(first);
    game.sendHome(second);

    first.life = 60;
    game.checkHome(first);
    game.checkRecovery();

    assert.ok(!game.state.unit_healing.has(first));
    assert.ok(game.state.unit_healing.has(second));
    assert.equal(game.state.ward_recovery_healer, game.doctor);
    assert.ok(game.state.unit_healing.has(game.doctor));
  });

  it('moves the Doctor and patients together when the recovery location changes', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.addWard();
    game.sendHome(troop);

    game.state.captain_home = { x: 2000, y: 1000 };
    game.checkHome(troop);
    game.checkRecovery();
    game.arriveHome(troop);
    game.arriveHome(game.doctor);
    game.checkRecovery();

    assert.deepEqual(game.movements.map(({ unit, x, y }) => ({ unit, x, y })), [
      { unit: troop, x: 2000, y: 1000 }, { unit: game.doctor, x: 2000, y: 1000 },
    ]);
    assert.deepEqual(game.wards, [{ unit: game.doctor, order: 852109, x: 2000, y: 1000 }]);
  });

  it('reuses an allied ward at the recovery point', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.addWard({ owner: 2 });

    game.sendHome(troop);
    game.checkRecovery();

    assert.deepEqual(game.wards, []);
    assert.equal(game.doctor.order, 'holdposition');
    assert.ok(game.state.unit_healing.has(troop));
    assert.equal(game.groups.size, 0);
  });

  it('does not let a ward elsewhere on the map block recovery', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.addWard({ x: 4000 });
    game.state.ward_cast = true;

    game.sendHome(troop);
    game.checkRecovery();

    assert.equal(game.wards.length, 1);
  });

  it('replaces a dead ward at the recovery point', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.addWard({ life: 0 });

    game.sendHome(troop);
    game.checkRecovery();

    assert.equal(game.wards.length, 1);
  });

  it('does not recruit a Doctor before master research', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.state.upgrades = 1;

    game.sendHome(troop);

    assert.equal(game.state.ward_recovery_healer, null);
    assert.ok(!game.jobs.some(job => job.job === game.state.WARD_RECOVERY));
  });

  it('requires the full Reforged mana cost before recruiting a Doctor', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.doctor.mana = 149;

    game.sendHome(troop);

    assert.equal(game.state.ward_recovery_healer, null);
  });

  it('respects the higher classic mana cost', () => {
    const game = orcGame('TFT');
    const troop = game.addTroop();
    game.doctor.mana = 150;

    game.sendHome(troop);

    assert.equal(game.state.ward_recovery_healer, null);
  });

  it('finishes an existing spell before moving the assigned Doctor', () => {
    const game = orcGame();
    game.doctor.x = 4000;
    game.doctor.order = 'stasistrap';
    const troop = game.addTroop();
    game.sendHome(troop);

    game.checkRecovery();

    assert.deepEqual(game.movements, []);
    assert.deepEqual(game.wards, []);
    assert.equal(game.doctor.order, 'stasistrap');
  });

  it('does not restart a pending ward cast', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.sendHome(troop);

    game.checkRecovery();
    game.checkRecovery();

    assert.equal(game.wards.length, 1);
  });

  it('releases a lost Doctor and lets the patients request a replacement', () => {
    const game = orcGame();
    const spare = { ...game.doctor, x: 100 };
    game.units.push(spare);
    const troop = game.addTroop();
    game.checkUnits();
    game.sendHome(troop);

    game.doctor.life = 0;
    game.state.major_hero = spare;
    game.checkRecovery();
    game.checkUnits();
    game.checkHome(troop);
    game.checkRecovery(game.doctor);

    assert.equal(game.state.ward_recovery_healer, spare);
    assert.ok(!game.state.unit_healing.has(game.doctor));
    assert.ok(game.state.ward_recovery_patients.has(troop));
    assert.equal(game.jobs.filter(job => job.job === game.state.WARD_RECOVERY).length, 1);
    assert.equal(game.groups.size, 0);
  });

  it('does not assign a Doctor to a recovery location under attack', () => {
    const game = orcGame();
    const troop = game.addTroop({ x: 4000 });
    game.state.homeThreat = 10;

    game.sendHome(troop);

    assert.equal(game.state.ward_recovery_healer, null);
    assert.deepEqual(game.wards, []);
    assert.equal(game.movements[0].unit, troop);
  });

  it('stops controlling a Doctor captured by the enemy', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.sendHome(troop);

    game.doctor.owner = 1;
    game.checkRecovery();

    assert.equal(game.state.ward_recovery_healer, null);
    assert.ok(!game.state.unit_healing.has(game.doctor));
    assert.deepEqual(game.released, []);
    assert.ok(!game.orders.some(order => order.unit === game.doctor));
  });

  it('abandons the assignment when enemies attack the recovery location', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.sendHome(troop);

    game.state.homeThreat = 10;
    game.checkRecovery();

    assert.equal(game.state.ward_recovery_healer, null);
    assert.ok(game.state.unit_healing.has(troop));
    assert.ok(!game.state.unit_healing.has(game.doctor));
    assert.deepEqual(game.wards, []);
  });

  it('ends the assignment when its last patient dies', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.sendHome(troop);

    troop.life = 0;
    game.checkRecovery();

    assert.equal(game.state.ward_recovery_healer, null);
    assert.ok(!game.state.unit_healing.has(game.doctor));
    assert.equal(game.groups.size, 0);
  });

  it('keeps the existing zeppelin transport available to a distant patient', () => {
    const game = orcGame();
    const troop = game.addTroop({ x: 4000 });
    const zeppelin = game.addTroop({ x: 3800, flying: true });
    game.state.follow_zeppelin = zeppelin;

    game.sendHome(troop);

    assert.equal(game.transports.length, 1);
    assert.equal(game.transports[0].unit, troop);
    assert.equal(game.transports[0].target, game.state.ZTARGET_HOME);
    assert.ok(game.state.unit_rescueing.has(zeppelin));
    assert.ok(game.state.ward_recovery_patients.has(troop));
  });

  it('waits for a patient aboard a transport instead of releasing its Doctor', () => {
    const game = orcGame();
    const troop = game.addTroop({ x: 4000 });
    game.sendHome(troop);

    troop.loaded = true;
    game.checkRecovery();

    assert.equal(game.state.ward_recovery_healer, game.doctor);
    assert.ok(game.state.ward_recovery_patients.has(troop));
    assert.deepEqual(game.wards, []);
  });

  it('keeps an injured Doctor in its own healing job after the patients recover', () => {
    const game = orcGame();
    const troop = game.addTroop();
    game.sendHome(troop);

    troop.life = 60;
    game.doctor.life = 40;
    game.checkRecovery();

    assert.equal(game.state.ward_recovery_healer, null);
    assert.ok(game.state.unit_healing.has(game.doctor));
    assert.ok(game.jobs.some(job => job.job === game.state.SEND_HOME && job.unit === game.doctor));
  });

  it('sends a hero assigned to a ward healer home without an arrival-based release timer', () => {
    const game = orcGame();
    const hero = game.addTroop({ x: 4000, life: 45, hero: true });

    game.saveHero(hero);
    game.checkHome(hero);

    assert.ok(game.state.ward_recovery_patients.has(hero));
    assert.ok(game.state.unit_healing.has(hero));
    assert.equal(game.movements[0].unit, hero);
    assert.equal(game.movements[0].x, 0);
    assert.ok(!game.jobs.some(job => job.job === game.state.RESET_GUARD_POSITION));
  });

  it('preserves ordinary healer assignments for non-ward healers', () => {
    const game = orcGame();
    game.state.healer_type[0] = 1;
    game.state.healer_spell[0] = 852063;
    game.state.attack_running = false;
    const troop = game.addTroop({ life: 20 });

    game.checkUnits();

    assert.equal(game.state.ward_recovery_healer, null);
    assert.deepEqual(game.orders, [{ unit: game.doctor, order: 852063, target: troop }]);
    assert.ok(game.jobs.some(job => job.job === game.state.RESET_GUARD_POSITION && job.unit === troop));
  });

  it('sends a critically injured leading hero home and lets another hero lead the army', () => {
    const game = orcGame();
    const hero = game.addTroop({ x: 4000, life: 20, hero: true });
    game.state.major_hero = hero;

    game.saveHero(hero);

    assert.equal(game.state.major_hero, null);
    assert.ok(game.state.ward_recovery_patients.has(hero));
    assert.ok(game.jobs.some(job => job.job === game.state.SEND_HOME && job.unit === hero));
    assert.ok(!game.jobs.some(job => job.job === game.state.RESET_GUARD_POSITION));
  });
});
