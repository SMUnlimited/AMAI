import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { ancientGame } from './helpers/ancient-game.mjs';

describe('Ancient expansion progress', () => {
  it('Given a wisp stuck with its build order active, when two minutes pass without movement, then the job stops and the mine cools down', () => {
    const game = ancientGame();
    game.check();

    game.advance(120);
    game.check();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.state.ancient_exp_wisp, null);
    assert.ok(game.orders.some(o => o.unit === game.wisp && o.order === 'stop'));
    assert.equal(game.state.expansion_retry_cooldowns.get('2:0'), 180);
    assert.equal(game.jobs.length, 0);
  });

  it('Given a travelling wisp, when it makes progress before the deadline, then the job keeps waiting for construction', () => {
    const game = ancientGame();
    game.check();
    game.advance(110);
    game.wisp.x = 1000;
    game.check();

    game.advance(110);
    game.check();

    assert.equal(game.state.ancient_expanding, true);
    assert.equal(game.state.ancient_exp_state, 2);
    assert.equal(game.state.expansion_retry_cooldowns.size, 0);
  });

  it('Given a newly started Tree of Life, when its wisp is consumed, then the army waits for construction to finish', () => {
    const game = ancientGame();
    const tree = game.startTree({ completed: false });

    game.check();

    assert.equal(game.state.ancient_exp_unit, tree);
    assert.equal(game.state.ancient_exp_state, 2);
    assert.equal(game.scans.length, 0);
    assert.equal(game.orders.length, 0);
  });

  it('Given a tree still under construction, when its health keeps increasing, then construction can finish after more than two minutes', () => {
    const game = ancientGame();
    const tree = game.startTree({ completed: false });
    game.check();
    game.advance(110);
    tree.life = 600;
    game.check();
    game.advance(110);
    tree.life = tree.maxLife;
    tree.done = true;

    game.check();

    assert.equal(game.state.ancient_exp_state, 3);
    assert.equal(game.state.ancient_expanding, true);
  });

  it('Given an uprooted tree stuck with entangle active, when two minutes pass without movement, then polling ends', () => {
    const game = ancientGame();
    const tree = game.startTree();
    tree.order = 'entangle';
    game.state.ancient_exp_unit = tree;
    game.state.ancient_exp_state = 7;
    game.check();

    game.advance(120);
    game.check();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.jobs.length, 0);
    assert.equal(game.state.expansion_retry_cooldowns.get('2:0'), 180);
  });

  it('Given a living wisp hidden inside its unfinished tree, when construction progresses, then its stationary position cannot trigger a timeout', () => {
    const game = ancientGame();
    const tree = game.startTree({ completed: false });
    game.wisp.alive = true;
    game.wisp.hidden = true;
    game.wisp.x = tree.x;
    game.check();
    game.advance(110);
    tree.life = 600;
    game.check();

    game.advance(110);
    game.check();

    assert.equal(game.state.ancient_expanding, true);
    assert.equal(game.state.ancient_exp_state, 2);
    assert.equal(game.state.ancient_exp_unit, tree);
    assert.equal(game.state.expansion_retry_cooldowns.size, 0);
  });

  it('Given an unfinished tree with no construction progress, when two minutes pass, then the job releases it without cancelling the foundation', () => {
    const game = ancientGame();
    const tree = game.startTree({ completed: false });
    game.check();

    game.advance(120);
    game.check();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(tree.alive, true);
    assert.equal(game.orders.filter(o => o.order === game.state.OrderIdCancel).length, 0);
  });

  it('Given a tree travelling to entangle, when polling repeats, then it does not rescan camp strength', () => {
    const game = ancientGame();
    game.state.ancient_exp_unit = game.startTree();
    game.state.ancient_exp_state = 7;

    game.check();
    game.advance(10);
    game.check();

    assert.equal(game.scans.length, 0);
    assert.equal(game.state.ancient_expanding, true);
  });

  it('Given a successfully entangled mine, when completion is detected, then the job releases its state and location', () => {
    const game = ancientGame();
    const tree = game.startTree();
    tree.activeMine = true;
    game.state.ancient_exp_unit = tree;
    game.state.ancient_exp_state = 7;
    game.check();

    game.check();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.state.ancient_exp_loc, null);
    assert.equal(game.locations.size, 1); // Persistent home location.
    assert.equal(game.state.expansion_retry_cooldowns.size, 0);
  });
});

describe('Ancient expansion placement and cleanup', () => {
  it('Given a pathing probe stuck with move active, when checking placement, then the probe is removed and no expansion starts', () => {
    const game = ancientGame();
    game.state.ancient_expanding = false;
    game.state.RemoveLocation(game.state.ancient_exp_loc);
    game.state.ancient_exp_loc = null;
    game.state.pathMoves = false;

    game.checkSite();

    assert.ok(game.state.now <= 11);
    assert.equal(game.state.pathProbe.removed, true);
    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.jobs.length, 0);
  });

  it('Given placement yields while another mine is chosen, when the probe returns, then its old location is discarded', () => {
    const game = ancientGame();
    game.state.ancient_expanding = false;
    game.state.RemoveLocation(game.state.ancient_exp_loc);
    game.state.ancient_exp_loc = null;
    game.state.onSleep = () => { game.state.current_expansion = null; };

    game.checkSite();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.state.current_expansion, null);
    assert.equal(game.locations.size, 1);
    assert.equal(game.jobs.length, 0);
  });

  it('Given a slow but moving placement probe, when reaching the site takes more than ten seconds, then progress keeps the probe alive', () => {
    const game = ancientGame();
    game.state.ancient_expanding = false;
    game.state.pathMoves = false;
    game.state.onSleep = () => { game.state.pathProbe.x -= 5; };

    game.checkSite();

    assert.ok(game.state.now > 20);
    assert.equal(game.state.ancient_expanding, true);
    assert.equal(game.state.ancient_exp_mine, game.mine);
    assert.equal(game.state.pathProbe.removed, true);
  });

  it('Given another player claims the mine during placement, when the probe returns, then no build job is started', () => {
    const game = ancientGame();
    game.state.ancient_expanding = false;
    game.state.CheckExpansionTaken = () => game.state.now > 0;

    game.checkSite();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.jobs.length, 0);
  });

  it('Given an invalid saved mine, when its queued job runs, then cleanup happens before coordinate reads', () => {
    const game = ancientGame();
    game.state.ancient_exp_mine = null;
    game.state.ancient_exp_creep = null;

    game.check();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.jobs.length, 0);
  });

  it('Given an entangling tree destroyed before the next poll, when state six runs, then no order targets the dead tree', () => {
    const game = ancientGame();
    const tree = game.startTree();
    tree.removed = true;
    game.state.ancient_exp_unit = tree;
    game.state.ancient_exp_state = 6;

    game.check();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.orders.filter(o => o.unit === tree).length, 0);
  });

  it('Given a mine claimed while saving construction funds, when building checks resume, then the resource reservation is released', () => {
    const game = ancientGame();
    game.state.ancient_exp_state = 1;
    game.state.gold_buffer = 340;
    game.state.wood_buffer = 185;
    game.state.CheckExpansionTaken = () => true;

    game.check();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.state.gold_buffer, 0);
    assert.equal(game.state.wood_buffer, 0);
    assert.equal(game.jobs.length, 0);
  });

  it('Given a self-rescue request, when no Ancient expansion has been prepared, then it queues the placement check instead of an empty construction job', () => {
    const game = ancientGame();
    game.state.ancient_expanding = false;
    game.state.ancient_exp_loc = null;
    game.state.ancient_exp_mine = null;

    assert.equal(game.state.SaveYourself(), true);

    assert.equal(game.jobs[0].job, game.state.ANCIENT_EXPANSION_CHECK);
    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.state.SaveYourself(), true);
    assert.equal(game.jobs.length, 1);
  });

  it('Given a blocked placement site, when another request arrives during cooldown, then it skips another pathing probe', () => {
    const game = ancientGame();
    game.state.ancient_expanding = false;
    game.state.pathMoves = false;
    game.state.RemoveLocation(game.state.ancient_exp_loc);
    game.state.ancient_exp_loc = null;
    game.checkSite();
    const probe = game.state.pathProbe;

    game.checkSite();

    assert.equal(game.state.pathProbe, probe);
    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.jobs.length, 0);
  });

  it('Given an unguarded saved site after all handles are lost, when camp strength is requested, then it returns zero without a coordinate read', () => {
    const game = ancientGame();
    game.state.ancient_exp_creep = null;
    game.state.ancient_exp_mine = null;

    assert.equal(game.state.GetAncientCampStrength(), 0);

    assert.equal(game.scans.length, 0);
  });
});

describe('Ancient attack handoff', () => {
  it('Given no tracked army and a captain that never arrives, when regrouping runs, then it times out and returns the tree to entangling', () => {
    const game = ancientGame();
    const tree = game.startTree();
    game.state.ancient_exp_unit = tree;
    game.state.ancient_exp_state = 3;
    game.state.atGoal = false;

    game.attack();

    assert.ok(game.state.now <= 125);
    assert.equal(game.state.ancient_attack_running, false);
    assert.equal(game.state.ancient_exp_state, 7);
    assert.ok(game.orders.some(o => o.order === 'entangle'));
  });

  it('Given the tree is lost while forming the army, when cleanup runs during the wait, then the old attack cannot restore its state', () => {
    const game = ancientGame();
    const tree = game.startTree();
    game.state.ancient_exp_unit = tree;
    game.state.ancient_exp_state = 3;
    game.state.onSleep = () => { tree.removed = true; game.check(); };

    game.attack();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.state.ancient_exp_state, 0);
    assert.equal(game.state.ancient_attack_running, false);
    assert.equal(game.orders.filter(o => o.order === 'entangle').length, 0);
  });

  it('Given the mine is lost during creeping, when the attack returns, then it cannot issue an entangle order to that removed mine', () => {
    const game = ancientGame();
    const tree = game.startTree();
    game.state.ancient_exp_unit = tree;
    game.state.ancient_exp_state = 3;
    game.state.onAttack = () => { game.mine.removed = true; game.check(); };

    game.attack();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.state.ancient_attack_running, false);
    assert.equal(game.orders.filter(o => o.order === 'entangle').length, 0);
  });

  it('Given a new Ancient operation starts while an old attack yields, when that attack returns, then it leaves the new operation alone', () => {
    const game = ancientGame();
    game.state.ancient_exp_unit = game.startTree();
    game.state.ancient_exp_state = 3;
    const nextTree = { id: 5, x: 8000, y: 0, alive: true, order: 0 };
    game.state.onAttack = () => {
      game.state.ancient_exp_state = 4;
      game.check();
      game.state.ancient_exp_unit = nextTree;
      game.state.ancient_exp_mine = game.mine;
      game.state.ancient_exp_state = 3;
      game.state.ancient_expanding = true;
      game.state.ancient_attack_running = true;
    };

    game.attack();

    assert.equal(game.state.ancient_exp_state, 3);
    assert.equal(game.state.ancient_exp_unit, nextTree);
    assert.equal(game.state.ancient_attack_running, true);
    assert.equal(game.orders.filter(o => o.unit === nextTree).length, 0);
  });
});

describe('Ancient expansion completes normally', () => {
  it('Given a guarded mine and a reachable build site, when the tree finishes and helps clear creeps, then it entangles and releases the operation', () => {
    const game = ancientGame();
    game.state.ancient_expanding = false;
    game.state.ancient_exp_state = 0;

    game.checkSite();
    game.check();
    game.check();
    assert.equal(game.state.ancient_exp_state, 2);
    const tree = game.startTree();
    game.check();
    assert.equal(game.state.ancient_exp_state, 3);
    game.attack();
    assert.equal(game.state.ancient_exp_state, 7);
    tree.activeMine = true;
    game.check();
    game.check();

    assert.equal(game.state.ancient_expanding, false);
    assert.equal(game.state.ancient_attack_running, false);
    assert.ok(game.orders.some(o => o.unit === tree && o.order === 'entangle'));
    assert.equal(game.locations.size, 1);
    assert.equal(game.state.expansion_retry_state.size, 0);
    assert.equal(game.state.expansion_retry_cooldowns.size, 0);
  });
});
