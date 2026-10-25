import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { pathingGame } from './helpers/pathing-game.mjs';

describe('Mid-game pathing requests', () => {
  it('Given caller-owned locations, when a request is queued, then it keeps copied coordinates after the locations are freed', () => {
    const game = pathingGame();
    const from = game.location(100, 0), target = game.location(2000, 0);
    game.state.routeOpen = true;

    const ticket = game.request(from, target);
    game.state.RemoveLocation(from);
    game.state.RemoveLocation(target);
    game.poll();
    game.advance(4);
    game.poll();

    assert.equal(game.result(ticket), game.state.PATHING_CHECK_REACHABLE);
    assert.equal(game.state.GetPathingCheckDistance(ticket), 1900);
    assert.equal(game.probes[0].removed, true);
    game.poll();
    assert.equal(game.result(ticket), game.state.PATHING_CHECK_REACHABLE);
    game.release(ticket);
    assert.equal(game.result(ticket), game.state.PATHING_CHECK_UNUSED);
  });

  it('Given invalid locations or movement types, when requesting a check, then no ticket or probe is allocated', () => {
    const game = pathingGame();
    const target = game.location(1000, 0);

    assert.equal(game.request(null, target), 0);
    assert.equal(game.request(target, null), 0);
    assert.equal(game.request(target, target, 'unsupported'), 0);
    assert.equal(game.result(-1), game.state.PATHING_CHECK_UNUSED);
    assert.equal(game.result(33), game.state.PATHING_CHECK_UNUSED);
    game.release(0);
    game.poll();

    assert.equal(game.probes.length, 0);
  });

  it('Given a moving order that makes no progress, when ten game seconds pass, then the probe fails and is removed', () => {
    const game = pathingGame();
    const ticket = game.request();

    game.poll();
    game.advance(10);
    game.poll();

    assert.equal(game.probes[0].order, 'move');
    assert.equal(game.result(ticket), game.state.PATHING_CHECK_UNREACHABLE);
    assert.equal(game.probes[0].removed, true);
  });

  it('Given a probe moving endlessly away from its goal, when two minutes pass, then the next queued check can run', () => {
    const game = pathingGame();
    const first = game.request(), second = game.request();
    game.poll();

    for (let i = 0; i < 60; i++) {
      game.probes[0].x -= 100;
      game.advance(2);
      game.poll();
    }
    game.poll();

    assert.equal(game.result(first), game.state.PATHING_CHECK_UNREACHABLE);
    assert.equal(game.state.pathing_check_active, second);
    assert.equal(game.probes[0].removed, true);
  });

  it('Given queued and active checks, when each is cancelled, then only the active probe is removed and released slots can be reused', () => {
    const game = pathingGame();
    const active = game.request(), queued = game.request();
    game.poll();

    game.release(queued);
    assert.equal(game.probes[0].removed, undefined);
    game.release(active);
    const replacement = game.request();
    game.poll();

    assert.equal(replacement, active);
    assert.equal(game.probes[0].removed, true);
    assert.equal(game.probes.length, 2);
    assert.equal(game.result(queued), game.state.PATHING_CHECK_UNUSED);
  });

  it('Given all request slots are occupied, when another caller requests a check, then it is rejected until a result is released', () => {
    const game = pathingGame();
    const tickets = Array.from({ length: game.state.PATHING_CHECK_LIMIT }, () => game.request());

    assert.equal(new Set(tickets).size, 32);
    assert.equal(game.request(), 0);
    game.poll();
    game.advance(10);
    game.poll();
    assert.equal(game.request(), 0);
    game.release(tickets[0]);
    assert.equal(game.request(), tickets[0]);
    game.poll();

    assert.equal(game.state.pathing_check_active, tickets[1]);
  });

  it('Given a dead probe, when the thread polls it, then the request fails and frees the active probe', () => {
    const game = pathingGame();
    const ticket = game.request();
    game.poll();

    game.probes[0].alive = false;
    game.poll();

    assert.equal(game.result(ticket), game.state.PATHING_CHECK_UNREACHABLE);
    assert.equal(game.probes[0].removed, true);
    assert.equal(game.state.pathing_check_active, 0);
  });

  it('Given checks for different movement types, when processing them, then each probe uses the requested unit type', () => {
    const game = pathingGame();
    const types = ['walk', 'float', 'amphibious', 'fly'];

    for (const type of types) {
      const ticket = game.request(game.state.home_location, game.state.home_location, type);
      game.poll();
      assert.equal(game.result(ticket), game.state.PATHING_CHECK_REACHABLE);
      game.release(ticket);
    }

    const rawcode = text => [...text].reduce((n, c) => n * 256 + c.charCodeAt(0), 0);
    assert.deepEqual(game.probes.map(u => u.id), [game.state.groundid, ...['hdes', 'nsnp', 'hgyr'].map(rawcode)]);
  });
});

describe('Water mine land access', () => {
  it('Given a water mine whose land route opens, when the pathing thread rechecks it, then it becomes selectable without a Zeppelin and neutral checks continue', () => {
    const game = pathingGame();
    const creep = { alive: true };
    const mine = game.addWaterMine({ creeps: [creep] });
    game.state.current_expansion = mine;
    game.state.current_expansion_iswater = true;
    game.state.routeOpen = true;

    game.runThread(75);
    const selected = game.chooseMine();

    assert.equal(selected, mine);
    assert.equal(game.state.IsWaterExpansion(mine), false);
    assert.equal(game.state.current_expansion_iswater, false);
    assert.equal(game.state.specialexpand, true);
    assert.equal(game.state.expansion_list_length, 1);
    assert.equal(game.state.bad_water_expansion_flag[0], 1);
    assert.equal(game.state.water_map, false);
    assert.deepEqual(game.state.expansion_creeps.get(0), [creep]);
    assert.ok(game.neutralChecks.some(check => check.kind === 'guards'));
    assert.ok(game.neutralChecks.filter(check => check.kind === 'enemies').length > 30);
    assert.equal(game.groups.size, 0);
    assert.equal(game.locations.size, 1);
  });

  it('Given a blocked water mine, when its route later opens, then a later sweep promotes it once', () => {
    const game = pathingGame();
    const mine = game.addWaterMine();

    game.runFor(80);
    assert.equal(game.state.IsWaterExpansion(mine), true);
    assert.equal(game.state.expansion_list_length, 0);
    game.state.routeOpen = true;
    game.runFor(160);

    assert.equal(game.state.IsWaterExpansion(mine), false);
    assert.equal(game.state.expansion_list_length, 1);
    assert.equal(game.probes.length, 2);
    assert.ok(game.probes.every(u => u.removed));
  });

  it('Given two water mines, when the first gains land access, then the second keeps its original water index and creep records', () => {
    const game = pathingGame();
    const first = game.addWaterMine();
    const creep = { alive: true };
    const second = game.addWaterMine({ x: 4000, creeps: [creep] });
    game.state.current_expansion = second;
    game.state.current_expansion_creeps = 1;
    game.state.current_expansion_iswater = true;
    game.state.onAdvance = () => {
      for (const probe of game.probes) probe.routeOpen = probe.target?.x === first.x;
    };

    game.runFor(90);

    assert.equal(game.state.expansion_list[0], first);
    assert.equal(game.state.water_expansion_list[1], second);
    assert.equal(game.state.bad_water_expansion_flag[1], 0);
    assert.equal(game.state.current_expansion_creeps, 1);
    assert.equal(game.state.current_expansion_iswater, true);
    assert.deepEqual(game.state.water_expansion_creeps.get(1), [creep]);
  });

  it('Given a mine depleted during its check, when the thread polls again, then it cancels the probe without promoting the mine', () => {
    const game = pathingGame();
    const mine = game.addWaterMine();
    game.runFor(60);

    mine.gold = 0;
    game.tick();

    assert.equal(game.probes[0].removed, true);
    assert.equal(game.state.water_pathing_request, 0);
    assert.equal(game.state.expansion_list_length, 0);
  });

  it('Given occupied request slots, when a slot becomes free, then the water sweep retries the same mine', () => {
    const game = pathingGame();
    const mine = game.addWaterMine();
    const tickets = Array.from({ length: game.state.PATHING_CHECK_LIMIT }, () => game.request());
    game.advance(60);

    game.checkMines();
    assert.equal(game.state.water_pathing_request, 0);
    assert.equal(game.state.water_pathing_cursor, 0);
    game.release(tickets[0]);
    game.checkMines();

    assert.equal(game.state.water_pathing_mine, mine);
    assert.equal(game.state.water_pathing_request, tickets[0]);
    assert.equal(game.state.water_pathing_cursor, 1);
    assert.equal(game.locations.size, 33);
  });
});
