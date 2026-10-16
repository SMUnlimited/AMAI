import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { compile, zeros } from './jass.mjs';

const source = readFileSync(new URL('../../common.eai', import.meta.url), 'utf8');
export function neutralGame(playerCount) {
  const unexpected = () => { throw new Error('Neutral player data was queried'); };
  const state = {
    player_race: zeros(), race_aggression: zeros(), race_name: ['Unknown', 'Human'],
    p_str_cache: zeros(), p_str_cache_timeout: zeros(), ai_time: 10, p_str_cache_valid_time: 5,
    difficulty: 2, HARD: 2, tiernum: 3, tier: 2,
    GetBJMaxPlayers: () => playerCount, GetPlayerId: p => p,
    GetOwningPlayer: u => u.owner, SquareRoot: Math.sqrt, Max: Math.max,
    GetPlayerHandicap: unexpected, CreateGroup: unexpected,
    UNIT_STATE_LIFE: 0, UNIT_STATE_MAX_LIFE: 1,
    UNIT_TYPE_ANCIENT: 2, UNIT_TYPE_MELEE_ATTACKER: 3,
    IsUnitTower: () => false, IsUnitType: () => false,
    GetUnitStrengthEx: u => u.level,
    GetUnitState: (u, field) => field === 0 ? u.life : u.maxLife,
    GetPlayerColor: p => p, ColorText: p => String(p),
    chat: {}, SetChatVar: (key, value) => { state.chat[key] = value; },
    SetChatVarR: (key, value) => { state.chat[key] = value; },
  };
  vm.runInContext(['GetPlayerStrengthHandicap', 'GetPlayerStrength', 'GetUnexactPlayerStrength',
    'GetUnitStrength', 'GetRace', 'GetRaceAggression', 'SetChatVarsAttack'].map(name => compile(source, name)).join('\n'), vm.createContext(state));
  return state;
}
