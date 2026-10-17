import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile } from './jass.mjs';

const source = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');

export function creepingGame() {
  const attacks = [];
  const state = {
    stop_creeping_after_level_5: true,
    hero_built: [false, false, false, false], hero_unit: [null, null, null, null],
    desperation_assault: false, no_attack: false, town_threatened: false,
    queue_running: false, attack_player: false, attack_point: false, attack_unit: false,
    creeping_only: false, militia_expanding: false, towerrush: false,
    ancient_expanding: false, rushcreep_target: null, double_expansion_target: null,
    no_creep_attack: false, ai_no_creep: false, first_expansion_chosen: true,
    current_expansion: {}, c_ally_total: 0, no_player_attack: true,
    sleep_multiplier: 1, creep_battle_radius: 750,
    h_siege: false, own_strength: 0, battle_radius: 1500,
    attacking_expansion: false, take_exp: true,
    GetHeroLevel: hero => hero.level, UnitAlive: unit => unit.alive,
    Trace() {}, Sleep() {}, set_aggression() {}, Int2Str: String,
    CheckExpansionTaken: () => false,
    GetExpFoe: () => ({ alive: true }),
    SetAllianceTargetIfLeadAndChat() {}, ClearAllianceTarget() {}, C_Expansion: 1,
    CreepAttack: () => attacks.push('idle creep'),
    AttackMoveKillCreep: () => attacks.push('expansion'),
  };
  vm.runInContext(['AllTrainedHeroesAtLeastLevel5', 'SingleMeleeAttackAM']
    .map(name => compile(source, name)).join('\n'), vm.createContext(state));
  return {
    state, attacks,
    trainHero(level) {
      const slot = state.hero_built.indexOf(false, 1);
      const hero = { level, alive: true };
      state.hero_built[slot] = true;
      state.hero_unit[slot] = hero;
      return hero;
    },
    checkAttack: (needsExpansion = false) => state.SingleMeleeAttackAM(needsExpansion, false, 50),
  };
}
