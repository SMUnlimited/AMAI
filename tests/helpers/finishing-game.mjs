import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';
import { creepingGame } from './creeping-game.mjs';

const source = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');

export function finishingGame() {
  const game = creepingGame();
  const enemies = [], targets = [];
  Object.assign(game.state, {
    difficulty: 1, no_player_attack: false, c_enemy_total: 0, enemy_force: enemies,
    minimum_attack_strength: 4, attacking_aggression: -13,
    added_aggression: 0, added_target_aggression: 0, added_racial_aggression: 0,
    PLAYER_SLOT_STATE_PLAYING: 'playing', ver_tower_check_radius: 2000,
    GetPlayerSlotState: p => p.playing ? 'playing' : 'empty',
    GetUnexactPlayerStrength: p => p.strength,
    GetPlayerAttackTarget: p => p.target,
    GetUnitTypeId: u => u.removed ? 0 : 1,
    IsUnitHidden: u => u.hidden,
    GetOwningPlayer: u => u.owner,
    GetRangePenalty: u => u.distance / 1400,
    GetUnitX: u => enemies.indexOf(u.owner), GetUnitY: () => 0,
    GetLocationTowerStrength: x => enemies[x].towers,
    GetRaceAggression: () => 0, R2I: Math.trunc, Min: Math.min,
    GetRandomReal: () => 0.9,
    ChooseAttackTarget: () => null,
    AttackMoveKillAAM: target => { targets.push(target); game.attacks.push('player attack'); },
  });
  vm.runInContext(['GetTargetStrength', 'GetTowerFactor', 'ChooseFinishingTarget']
    .map(name => compile(source, name)).join('\n'), vm.createContext(game.state));
  game.trainHero(2).xp = 200;
  return {
    ...game, targets,
    addEnemy({ strength = 2, towers = 0, distance = 0, alive = true,
      hidden = false, removed = false, playing = true, building = true } = {}) {
      const enemy = { strength, towers, playing };
      const target = { owner: enemy, distance, alive, hidden, removed };
      enemy.target = building ? target : null;
      enemies.push(enemy);
      game.state.c_enemy_total = enemies.length;
      return target;
    },
    checkAttack: (strength = 50) => game.state.SingleMeleeAttackAM(false, false, strength),
  };
}
