// Run travel and retreat source together; native mocks record captain destinations.
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { armyGame } from './army-game.mjs';
import { compile } from './jass.mjs';

export function transitGame(options) {
  const game = armyGame(options), { state, units, target } = game;
  const orders = [], work = { scans: 0 };
  const enumerate = state.GroupEnumUnitsInRange;
  Object.assign(state, {
    attack_running: true, retreat_controlled: true, retreat_group_refreshed: false,
    canflee: false, player_defeated: false, ancient_expanding: false,
    ancient_attack_running: false, br_rush_attacked: false,
    battle_radius: 1500, creep_battle_radius: 750, RETREAT_CONTROL: 1,
    PLAYER_NEUTRAL_AGGRESSIVE: 12, UNIT_TYPE_MELEE_ATTACKER: 'melee', UNIT_TYPE_RANGED_ATTACKER: 'ranged',
    UNIT_TYPE_ANCIENT: 'ancient', unit_healing: new Set(),
    last_major_hero_loc: state.Location(4000, 4000),
    enemy_loc: state.Location(0, 0), last_enemy_loc: state.Location(0, 0),
    last_ally_loc: state.Location(0, 0),
    ver_flee_multiple1: 1, ver_flee_multiple2: 2, ver_flee_multiple3: 3,
    ver_low_aggression: -15, ver_high_aggression: 45,
    attacking_aggression: 0, added_aggression: 0, added_target_aggression: 0, added_racial_aggression: 0,
    MoveLocation: (l, x, y) => Object.assign(l, { x, y }),
    IsPlayerEnemy: (a, b) => a !== b,
    IsUnitVisible: u => u.visible !== false,
    IsUnitInvisibleAM: u => Boolean(u.invisible), IsUnitHidden: u => Boolean(u.hidden),
    UnitIsSleeping: u => Boolean(u.sleeping), IsUnitTower: u => Boolean(u.tower),
    CaptainRetreating: () => false, GetMajorHeroReplacement_k: () => state.major_hero,
    CaptainGoHome: () => orders.push({ order: 'home' }),
    CaptainAttack: (x, y) => orders.push({ order: 'intercept', x, y }),
    AttackMoveKill: u => orders.push({ order: 'destination', target: u }),
    AttackMoveXY: (x, y) => orders.push({ order: 'destination', x, y }),
    GroupEnumUnitsInRange(g, x, y, radius) {
      work.scans++;
      g.clear();
      enumerate(g, x, y, radius);
    },
    SelectByHidden(g) { for (const u of g) if (u.hidden) g.delete(u); return g; },
    SelectByAlive(g) { for (const u of g) if (!u.alive) g.delete(u); return g; },
    FormGroupAM() {}, SetGroupsFlee() {}, TQAddJob() {}, DisplayToAllJobDebug() {},
    FromGroupAndGhoulsAM() {}, DoAttackJobs() {}, SleepInCombatAM() {}, QueueGetNextCommand() {},
    B2S: String, Real2Str: String,
  });
  const common = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');
  const context = vm.createContext(state);
  for (const name of ['LinearInterpolation', 'ApplyFleeStrengthModifier', 'AttackTransitIntrusion',
    'CommonSleepUntilTargetDeadAM', 'SleepUntilAtGoalAM', 'QueueAttackMoveXY']) {
    vm.runInContext(compile(common, name), context);
  }
  vm.runInContext(compile(readFileSync(new URL('../../Jobs/RETREAT_CONTROL.eai', import.meta.url), 'utf8'), 'RetreatControlJob'), context);
  return {
    ...game, orders, work,
    addEnemy: (changes = {}) => {
      const enemy = { x: 4500, y: 4000, owner: 1, alive: true, strength: 5, melee: true, ...changes };
      units.push(enemy);
      return enemy;
    },
    checkBattle: () => state.RetreatControlJob(),
    attack: () => state.CommonSleepUntilTargetDeadAM(target, false, false, false),
    intercept: () => state.AttackTransitIntrusion(),
  };
}
