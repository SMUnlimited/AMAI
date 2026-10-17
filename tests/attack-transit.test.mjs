import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { transitGame } from './helpers/transit-game.mjs';

describe('Army interceptions during offensive travel', () => {
  it('Given a weaker nearby enemy, when travel continues, then the captain intercepts and resumes the original destination after the enemy dies', () => {
    const game = transitGame();
    const enemy = game.addEnemy();
    game.checkBattle();
    game.state.StaggerSleep = () => {
      if (++game.state.waits === 1) enemy.alive = false;
      else game.target.alive = false;
    };

    game.attack();

    assert.deepEqual(game.orders, [
      { order: 'intercept', x: 4500, y: 4000 },
      { order: 'destination', target: game.target },
    ]);
    assert.equal(game.state.isfleeing, false);
    assert.equal(game.work.scans, 1, 'Reuse the retreat scan without additional travel scans');
  });

  it('Given equal nearby enemy strength before captain combat starts, when retreat checks run, then standard retreat replaces travel', () => {
    const game = transitGame();
    game.addEnemy({ strength: 20 });

    game.checkBattle();
    game.attack();

    assert.equal(game.state.isfleeing, true);
    assert.equal(game.state.break_attack, true);
    assert.equal(game.state.attack_intrusion, null);
    assert.deepEqual(game.orders, [{ order: 'home' }]);
  });

  it('Given stronger enemies spread around the nearby intruder, when local odds are assessed, then combined enemy strength triggers retreat', () => {
    const game = transitGame();
    game.addEnemy();
    game.addEnemy({ x: 5000, strength: 30 });

    game.checkBattle();

    assert.equal(game.state.enemy_strength_sum, 35);
    assert.equal(game.state.isfleeing, true);
    assert.deepEqual(game.orders, [{ order: 'home' }]);
  });

  it('Given an enemy beyond interception range, when battle checks run, then offensive travel is left alone', () => {
    const game = transitGame();
    game.addEnemy({ x: 5000 });

    game.checkBattle();
    game.attack();

    assert.equal(game.state.attack_intrusion, null);
    assert.ok(game.orders.every(order => order.order === 'destination'));
    assert.equal(game.state.isfleeing, false);
  });

  it('Given hidden, invisible and unseen enemies, when battle checks run, then they cannot divert travel or trigger a transit retreat', () => {
    const game = transitGame();
    game.addEnemy({ hidden: true, strength: 50 });
    game.addEnemy({ invisible: true, strength: 50 });
    game.addEnemy({ visible: false, strength: 50 });

    game.checkBattle();

    assert.equal(game.state.attack_intrusion, null);
    assert.equal(game.state.isfleeing, false);
  });

  it('Given a nearby hostile tower supporting an intruder, when battle checks run, then tower strength prevents an unsafe interception', () => {
    const game = transitGame();
    game.addEnemy();
    game.addEnemy({ structure: true, tower: true, melee: false, strength: 30 });

    game.checkBattle();

    assert.equal(game.state.enemy_strength_sum, 35);
    assert.equal(game.state.isfleeing, true);
  });

  it('Given two weaker intruders, when battle checks run, then the nearest visible enemy becomes the temporary target', () => {
    const game = transitGame();
    game.addEnemy();
    const nearest = game.addEnemy({ x: 4200 });

    game.checkBattle();

    assert.equal(game.state.attack_intrusion, nearest);
  });

  it('Given a previously selected intruder, when it moves away before the next battle scan, then travel immediately resumes', () => {
    const game = transitGame();
    const enemy = game.addEnemy();
    game.checkBattle();
    enemy.x = 5000;

    game.attack();

    assert.ok(game.orders.every(order => order.order === 'destination'));
  });

  it('Given a previous interception, when the army is sent to defend a town, then interception stops immediately', () => {
    const game = transitGame();
    game.addEnemy();
    game.checkBattle();
    game.state.town_threatened = true;

    assert.equal(game.intercept(), false);
    game.checkBattle();

    assert.equal(game.state.attack_intrusion, null);
    assert.deepEqual(game.orders, []);
  });

  it('Given a previous interception, when retreat starts, then no interception order overrides it', () => {
    const game = transitGame();
    game.addEnemy();
    game.checkBattle();
    game.state.isfleeing = true;

    assert.equal(game.intercept(), false);
    game.checkBattle();

    assert.equal(game.state.attack_intrusion, null);
    assert.ok(game.orders.every(order => order.order === 'home'));
  });

  it('Given no tracked army, when the hero encounters weaker troops, then the hero battle scan supplies the interception', () => {
    const game = transitGame();
    const enemy = game.addEnemy();
    game.state.main_army = -1;
    game.state.major_hero = game.units[0];

    game.checkBattle();

    assert.equal(game.state.ally_strength_sum, 20);
    assert.equal(game.state.attack_intrusion, enemy);
    assert.equal(game.intercept(), true);
  });

  it('Given an interception during expansion travel, when progress stalls beyond the usual timeout, then the expansion is preserved', () => {
    const game = transitGame({ expansion: true });
    game.addEnemy();
    game.checkBattle();
    game.state.StaggerSleep = () => { if (++game.state.waits === 15) game.target.alive = false; };

    game.attack();

    assert.equal(game.state.waits, 15);
    assert.equal(game.state.current_expansion, game.target);
    assert.equal(game.state.break_attack, false);
  });

  it('Given a coordinate destination, when an intruder disengages, then the original coordinates are restored before checking arrival', () => {
    const game = transitGame();
    const enemy = game.addEnemy();
    game.checkBattle();
    game.state.lastcaptainx = 9000;
    game.state.lastcaptainy = 4000;
    game.state.CaptainAtGoal = () => game.state.waits >= 6;
    game.state.StaggerSleep = () => { if (++game.state.waits === 7) enemy.x = 5000; };

    game.state.SleepUntilAtGoalAM();

    assert.equal(game.orders.filter(order => order.order === 'intercept').length, 7);
    assert.deepEqual(game.orders.at(-1), { order: 'destination', x: 9000, y: 4000 });
  });

  it('Given a commander coordinate order, when an intruder disengages, then its original destination resumes', () => {
    const game = transitGame();
    const enemy = game.addEnemy();
    game.checkBattle();
    game.state.CaptainAtGoal = () => game.state.waits >= 3;
    game.state.Sleep = () => { if (++game.state.waits === 2) enemy.x = 5000; };

    game.state.QueueAttackMoveXY(9000, 4000);

    assert.deepEqual(game.orders, [
      { order: 'intercept', x: 4500, y: 4000 },
      { order: 'destination', x: 9000, y: 4000 },
    ]);
  });

  it('Given a commander travel order, when retreat starts during its wait, then the destination order cannot override retreat', () => {
    const game = transitGame();
    game.state.Sleep = () => { game.state.isfleeing = true; };

    game.state.QueueAttackMoveXY(9000, 4000);

    assert.deepEqual(game.orders, []);
  });

  it('Given native retreat without AMAI permission, when travel checks run, then the attack continues', () => {
    const game = transitGame();
    game.state.CaptainRetreating = () => true;

    game.attack();

    assert.equal(game.state.waits, 2);
    assert.ok(game.orders.every(order => order.order === 'destination'));
  });

  it('Given native retreat without AMAI permission and a weaker intruder, when retreat control runs, then AMAI still intercepts', () => {
    const game = transitGame();
    const enemy = game.addEnemy();
    game.state.CaptainRetreating = () => true;

    game.checkBattle();
    const intercepted = game.intercept();

    assert.equal(game.state.isfleeing, false);
    assert.equal(game.state.attack_intrusion, enemy);
    assert.equal(intercepted, true);
    assert.deepEqual(game.orders, [{ order: 'intercept', x: 4500, y: 4000 }]);
  });

  it('Given AMAI permission to flee, when the captain naturally retreats, then the retreat controller adopts that retreat', () => {
    const game = transitGame();
    game.addEnemy();
    game.state.canflee = true;
    game.state.CaptainRetreating = () => true;

    game.checkBattle();
    const intercepted = game.intercept();

    assert.equal(game.state.isfleeing, true);
    assert.equal(game.state.break_attack, true);
    assert.equal(intercepted, false);
    assert.equal(game.state.attack_intrusion, null);
  });

  it('Given native retreat without AMAI permission, when waiting for a coordinate destination, then arrival checks continue', () => {
    const game = transitGame();
    game.state.CaptainRetreating = () => true;
    game.state.CaptainAtGoal = () => game.state.waits >= 6;
    game.state.StaggerSleep = () => { game.state.waits++; };

    game.state.SleepUntilAtGoalAM();

    assert.equal(game.state.waits, 6);
  });

  it('Given a weaker enemy during interception, when stronger reinforcements arrive, then the standard retreat cancels the interception', () => {
    const game = transitGame();
    game.addEnemy();
    game.checkBattle();
    game.state.StaggerSleep = () => {
      game.addEnemy({ strength: 30 });
      game.checkBattle();
    };

    game.attack();

    assert.deepEqual(game.orders, [
      { order: 'intercept', x: 4500, y: 4000 },
      { order: 'home' },
    ]);
    assert.equal(game.state.isfleeing, true);
    assert.equal(game.state.attack_intrusion, null);
  });
});
