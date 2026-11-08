import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { pathingGame, towerGame } from './helpers/pathing-game.mjs';

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

describe('Pathing polling cadence', () => {
  it('Given a timed tree search and long staggered waits, when the thread polls its result, then it retains the harvest order without rapid sampling or early expiry', () => {
    const game = pathingGame();
    game.state.sleep_multiplier = 2;
    game.state.GetRandomReal = (min, max) => max;
    game.state.treeFound = true;
    const ticket = game.state.RequestPathingProbe(game.state.home_location, game.state.home_location,
      game.state.groundid, 'autoharvestlumber', 300, 1);

    game.runThread(9);

    assert.equal(game.result(ticket), game.state.PATHING_CHECK_REACHABLE);
    assert.equal(game.state.GetPathingProbeOrder(ticket), 'harvest');
    assert.equal(game.probes[0].speed, 300);
    assert.equal(game.probes[0].removed, true);
    assert.ok(game.sleeps.slice(1).every(sleep => sleep.seconds === 6));
  });

  it('Given no pathing requests, when the pathing thread runs, then it sleeps for the full staggered interval', () => {
    const game = pathingGame();
    game.state.sleep_multiplier = 2;
    game.state.GetRandomReal = (min, max) => max;

    game.runThread(19);

    assert.equal(game.probes.length, 0);
    assert.ok(game.sleeps.slice(1).every(sleep => sleep.seconds === 6));
    assert.equal(game.neutralChecks.filter(check => check.kind === 'enemies').length, 3);
  });

  it('Given an automatic mine reachability check, when its route stays blocked, then the probe times out using slow polling', () => {
    const game = pathingGame();
    const mine = game.addWaterMine();

    game.runThread(85);

    assert.equal(game.probes.length, 1);
    assert.equal(game.probes[0].removed, true);
    assert.equal(game.state.IsWaterExpansion(mine), true);
    assert.ok(game.sleeps.some(sleep => sleep.active !== 0));
    assert.ok(game.sleeps.slice(1).every(sleep => sleep.seconds === 2));
  });

  it('Given a waypoint queued after a reachability check, when each request runs, then only the active waypoint uses rapid polling', () => {
    const game = pathingGame();
    game.state.routeOpen = true;
    const reachability = game.request();
    const waypoint = game.state.RequestPathingPoint(game.location(8000, 0), game.state.home_location, 600);

    game.runThread(9);

    assert.equal(game.result(reachability), game.state.PATHING_CHECK_REACHABLE);
    assert.equal(game.result(waypoint), game.state.PATHING_CHECK_REACHABLE);
    const reachabilitySleeps = game.sleeps.filter(sleep => sleep.active === reachability);
    const waypointSleeps = game.sleeps.filter(sleep => sleep.active === waypoint);
    assert.ok(reachabilitySleeps.length > 0 && reachabilitySleeps.every(sleep => sleep.seconds === 2));
    assert.ok(waypointSleeps.length > 0 && waypointSleeps.every(sleep => sleep.seconds <= 0.2));
    const lastWaypointTime = waypointSleeps.at(-1).time;
    assert.ok(game.sleeps.some(sleep => sleep.time > lastWaypointTime && sleep.seconds === 2));
    assert.ok(game.sleeps.filter(sleep => sleep.time > lastWaypointTime).every(sleep => sleep.seconds > 0.2));
  });
});

describe('Route waypoint requests', () => {
  it('Given a waypoint request during a staggered wait, when the route is walked, then sampling stops within one short step of the requested distance', () => {
    const game = pathingGame();
    const origin = game.location(8000, 0);
    game.state.routeOpen = true;
    const ticket = game.state.RequestPathingPoint(origin, game.state.home_location, 600);

    game.runThread(5);
    const point = game.state.GetPathingCheckLocation(ticket);
    game.release(ticket);

    assert.ok(origin.x - point.x >= 600);
    assert.ok(origin.x - point.x <= 600 + 522 * 0.2);
    assert.equal(point.y, 0);
    assert.ok(game.locations.has(point), 'Result is owned by the caller after release');
    assert.equal(game.state.GetPathingCheckLocation(ticket), null);
    assert.ok(game.neutralChecks.filter(check => check.kind === 'enemies').length <= 2);
  });

  it('Given a waypoint beyond the destination, when the probe reaches the destination first, then destination proximity does not produce a false waypoint', () => {
    const game = pathingGame();
    game.state.routeOpen = true;
    const ticket = game.state.RequestPathingPoint(game.state.home_location, game.location(100, 0), 600);

    game.poll();
    game.runFor(14);

    assert.equal(game.result(ticket), game.state.PATHING_CHECK_UNREACHABLE);
    assert.equal(game.state.GetPathingCheckLocation(ticket), null);
    assert.equal(game.probes[0].removed, true);
  });

  it('Given existing synchronous location callers, when finding a point from either end of a route, then the thread creates and cleans up both probes', () => {
    const game = pathingGame();
    const target = game.location(8000, 0);
    game.state.routeOpen = true;

    const towardHome = game.state.GetLocationInDistanceFromLoc(target, 600, false);
    const fromHome = game.state.GetLocationInDistanceFromBaseToLoc(target, 600);

    assert.ok(target.x - towardHome.x >= 600 && target.x - towardHome.x < 705);
    assert.ok(fromHome.x >= 600 && fromHome.x < 705);
    assert.ok(game.probes.every(probe => probe.removed));
    assert.ok(game.state.pathing_check_state.every(result => result === game.state.PATHING_CHECK_UNUSED));
    assert.equal(game.state.RequestPathingPoint(target, target, -1), 0);
  });
});

describe('Tower rush background positioning', () => {
  it('Given an approved tower rush, when positioning begins, then its job returns before creating a probe and resumes without repeating target selection', () => {
    const game = towerGame();
    game.state.routeOpen = true;

    game.checkRush();
    assert.equal(game.state.now, 0);
    assert.equal(game.probes.length, 0);
    assert.equal(game.jobs[0].job, game.state.TOWER_RUSH_CHECK);
    game.state.race_towerrush_probability = 0;
    game.finishPositioning();

    assert.equal(game.state.towerrush, true);
    assert.equal(game.state.racial_rushcreep, 0);
    assert.equal(game.distanceChecks.length, 1);
    assert.ok(8000 - game.state.tower_target_loc.x >= 2000);
    assert.ok(8000 - game.state.tower_target_loc.x < 2105);
    assert.equal(game.jobs[0].job, game.state.TOWER_RUSH);
    assert.equal(game.probes[0].removed, true);
  });

  it('Given an early Night Elf target, when its waypoint completes, then positioning retains the closer 780-unit distance', () => {
    const game = towerGame();
    game.state.enemyRace = game.state.RACE_NIGHTELF;
    game.state.routeOpen = true;

    game.checkRush();
    game.finishPositioning();

    assert.ok(8000 - game.state.tower_target_loc.x >= 780);
    assert.ok(8000 - game.state.tower_target_loc.x < 885);
  });

  it('Given a blocked route, when the background probe times out, then the tower rush is abandoned and its request is released', () => {
    const game = towerGame();

    game.checkRush();
    game.finishPositioning();

    assert.equal(game.state.towerrush, false);
    assert.equal(game.state.toweringplayerloc, null);
    assert.equal(game.state.tower_pathing_request, 0);
    assert.equal(game.jobs.length, 0);
    assert.equal(game.locations.size, 1);
    assert.equal(game.probes[0].removed, true);
  });

  it('Given a pending positioning probe, when the target changes, then the old request is cancelled without clearing the new target', () => {
    const game = towerGame();
    game.checkRush();
    const ticket = game.state.tower_pathing_request;
    game.poll();
    game.state.RemoveLocation(game.state.toweringplayerloc);
    const nextTarget = game.location(6000, 3000);

    game.state.toweringplayerloc = nextTarget;
    game.checkRush();

    assert.equal(game.state.toweringplayerloc, nextTarget);
    assert.equal(game.state.tower_pathing_pending, false);
    assert.equal(game.result(ticket), game.state.PATHING_CHECK_UNUSED);
    assert.equal(game.probes[0].removed, true);
  });

  it('Given a full pathing queue, when a ticket becomes available, then positioning retries without rerolling its rush decision', () => {
    const game = towerGame();
    const tickets = Array.from({ length: game.state.PATHING_CHECK_LIMIT }, () => game.request());

    game.checkRush();
    assert.equal(game.state.tower_pathing_request, 0);
    assert.equal(game.state.tower_pathing_pending, true);
    game.release(tickets[0]);
    game.checkRush();

    assert.equal(game.state.tower_pathing_request, tickets[0]);
    assert.equal(game.distanceChecks.length, 1);
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
