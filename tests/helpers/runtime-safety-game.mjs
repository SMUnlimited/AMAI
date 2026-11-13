import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { heroGame } from './hero-shopping-game.mjs';

export const observerFlags = ['HELP_REQUEST', 'HELP_RESPONSE', 'SHARED_XP', 'SHARED_SPELLS',
  'SHARED_VISION', 'SHARED_CONTROL', 'SHARED_ADVANCED_CONTROL'];

export function observerGame(localPlayer, debugging = 1) {
  const changes = [];
  const state = {
    debugging, ai_player: 0, Player: p => p, GetBJMaxPlayers: () => 24,
    GetLocalPlayer: () => localPlayer, IsPlayerObserver: p => p === 2 || p === 23,
    SetPlayerAlliance: (owner, player, flag, enabled) => changes.push({ owner, player, flag, enabled }),
  };
  for (const flag of observerFlags) state['ALLIANCE_' + flag] = flag;
  const source = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');
  vm.runInContext(compile(source, 'InitDebugObserverAccess'), vm.createContext(state));
  return { changes, grantAccess: () => state.InitDebugObserverAccess() };
}

export function heroTownGame() {
  const game = heroGame();
  const state = game.state;
  game.hero.life = 100;
  for (const name of ['town_loc', 'town_threat', 'town_can_tp']) {
    state[name] = new Proxy(name === 'town_loc' ? [{}] : [100], {
      get(target, key) {
        if (/^-?\d+$/.test(String(key))) {
          assert.ok(Number(key) >= 0 && Number(key) < state.town_num, `Invalid ${name}[${key}]`);
        }
        return target[key];
      },
    });
  }
  Object.assign(state, {
    town_threatened: true, army_loc: [{}], army_strength: [100],
    teleport_min_threat: 1, teleport_low_threat: 1, teleport_high_threat: 100,
    teleport_low_threat_distance: 1000, teleport_high_threat_distance: 3000,
    teleport_army_min_strength: 10, LinearInterpolation: () => 1000,
    GetArmyOfUnit: () => 0, GetItemNumberOnUnit: () => 1,
    DistanceBetweenPoints(a, b) { assert.ok(a && b, 'Read a missing location'); return 5000; },
    TeleportToLoc: () => game.effects.push('teleport-town'),
    TeleportHome: () => game.effects.push('teleport-home'),
  });
  return game;
}
