import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { performanceGame } from './helpers/performance-game.mjs';
import { townGame } from './helpers/town-game.mjs';

describe('Army collection work', () => {
  it('Given 100 troops and 30 configured types, when collecting unknown troops, then each unit is visited once', () => {
    const game = performanceGame();
    game.state.attack_length = 30;
    game.state.attack_units = Array.from({ length: 30 }, (_, i) => i + 1);
    game.state.old_id = Array.from({ length: 31 }, (_, i) => i + 1000);
    for (let i = 0; i < 100; i++) game.addUnit(2000 + i % 5);

    game.collectArmy();

    assert.equal(game.work.visits, 100);
    assert.equal(game.work.groups, 1);
    assert.equal(game.assaults.length, 5);
    assert.ok(game.assaults.every(request => request.qty === 60));
    assert.equal(game.groups.size, 0);
  });

  it('Given configured troops and unsuitable units, when collecting unknown troops, then only eligible foreign types are requested', () => {
    const game = performanceGame();
    game.state.attack_length = 1;
    game.state.attack_units = [1];
    game.state.old_id = [0, 1000];
    game.addUnit(1000);
    for (const changes of [{ worker: true }, { structure: true }, { summoned: true },
      { hidden: true }, { alive: false }, { ground: false }, { owner: 1 }]) game.addUnit(2000, changes);
    game.addUnit(2000);
    game.addUnit(3000, { ground: false, air: true });
    game.addUnit(1852270962); // 'ngir': the existing special-case exclusion.

    game.collectArmy();

    assert.deepEqual(game.assaults, [{ qty: 60, type: 2000 }, { qty: 60, type: 3000 }]);
    assert.equal(game.groups.size, 0);
  });

  it('Given duplicate units including workers and ancients, when reinforcing desperation attacks, then each eligible type is requested once', () => {
    const game = performanceGame();
    for (let i = 0; i < 100; i++) game.addUnit(1000 + i % 5);
    game.addUnit(2000, { worker: true });
    game.addUnit(3000, { ancient: true, structure: true });
    game.addUnit(4000, { structure: true });
    game.addUnit(5000, { alive: false });
    game.addUnit(6000, { hidden: true });

    game.reinforce();

    assert.deepEqual(game.assaults.map(request => request.type), [1000, 1001, 1002, 1003, 1004, 2000, 3000]);
    assert.equal(game.groups.size, 0);
  });

  it('Given a later reinforcement pass without a reset, when new troops are available, then only new types are requested', () => {
    const game = performanceGame();
    game.addUnit(1000);
    game.reinforce();
    game.addUnit(1000);
    game.addUnit(2000);

    game.reinforce();

    assert.deepEqual(game.assaults.map(request => request.type), [1000, 2000]);
  });

  it('Given captured troop types already registered by an army scan, when desperation runs, then only the remaining unregistered type is requested', () => {
    const game = performanceGame();
    game.state.attack_length = 1;
    game.state.attack_units = [1];
    game.state.old_id = [0, 1000];
    for (let i = 0; i < 25; i++) game.addUnit(1000 + i);
    game.collectArmy();
    game.assaults.length = 0;

    game.reinforce();

    assert.deepEqual(game.assaults.map(request => request.type), [1000]);
  });

  it('Given a defeated player, when desperation reinforcements run, then no scan or assault request is made', () => {
    const game = performanceGame();
    game.addUnit(1000);
    game.state.player_defeated = true;

    game.reinforce();

    assert.equal(game.work.groups, 0);
    assert.equal(game.assaults.length, 0);
  });
});

describe('Build request work', () => {
  it('Given three existing towers, when requesting twenty, then town buildings are counted once and missing quantities keep their priorities', () => {
    const game = townGame();
    for (let i = 0; i < 3; i++) game.addUnit(game.ids.tower);
    game.trackTowns();
    let counts = 0;
    const count = game.state.TownCountTown;
    game.state.TownCountTown = (...args) => { counts++; return count(...args); };

    assert.equal(game.state.SetBuildAllAMCore(1, 20, game.ids.tower, 1, 0, 50), true);

    assert.equal(counts, 1);
    assert.equal(game.state.build_length, 17);
    assert.deepEqual(game.state.build_qty.slice(0, 17), Array.from({ length: 17 }, (_, i) => i + 4));
    assert.deepEqual(game.state.build_prio.slice(0, 17), Array.from({ length: 17 }, (_, i) => 82 - i * 2));
  });
});

describe('Job queue capacity', () => {
  it('Given a full queue, when adding another job, then the heap swap slot stays within array bounds', () => {
    const game = performanceGame({ capacity: 8 });
    for (let i = 0; i < 6; i++) game.enqueue(100 - i);

    game.enqueue(1);

    assert.equal(game.state.tq_length, 6);
    const times = [];
    while (game.state.tq_length) {
      times.push(game.state.tq_time[1]);
      game.state.TQRemoveRoot();
    }
    assert.deepEqual(times, [95, 96, 97, 98, 99, 100]);
    assert.equal(game.state.tq_lock, true);
  });

  it('Given the queue fills while waiting for its lock, when adding an expansion check, then it is rejected without marking it pending', () => {
    const game = performanceGame({ capacity: 8 });
    game.state.onLock = () => { game.state.tq_length = 6; };

    game.enqueue(1, game.state.BUILD_EXPANSION, { id: 1 }, { id: 2 });

    assert.equal(game.state.tq_length, 6);
    assert.equal(game.state.expansion_job_pending.size, 0);
    assert.equal(game.state.tq_lock, true);
  });
});

describe('Chat condition termination', () => {
  it('Given an opening brace with no closing brace, when checking the actual character lookup, then chat returns without spinning', () => {
    const game = performanceGame();

    assert.equal(game.checkChat('{'), false);
  });

  it('Given a condition with an unreadable character, when checking chat, then it is rejected', () => {
    const game = performanceGame();
    game.state.GetChar = (s, i) => s[i] === '?' ? '' : s[i] ?? '';

    assert.equal(game.checkChat('{Ready?}'), false);
  });

  it('Given a condition missing its closing brace, when the character reader supplies the text, then it stops at the end', () => {
    const game = performanceGame();
    game.state.GetChar = (s, i) => s[i] ?? '';

    assert.equal(game.checkChat('{Ready'), false);
  });

  it('Given valid conditions, when the character reader supplies them, then comparisons and plain chat retain their results', () => {
    const game = performanceGame();
    game.state.GetChar = (s, i) => s[i] ?? '';

    assert.equal(game.checkChat('{Ready}'), true);
    assert.equal(game.checkChat('{!Ready}'), false);
    assert.equal(game.checkChat('{Gold=100,Ready}'), true);
    assert.equal(game.checkChat('{Gold>90}'), true);
    assert.equal(game.checkChat('{PlayerRace=Orc}'), true);
    assert.equal(game.state.chat_race, 'Orc');
    assert.equal(game.checkChat('Hello'), true);
  });
});
