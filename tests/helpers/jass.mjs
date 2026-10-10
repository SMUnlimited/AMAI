// Translate the JASS subset used by the regression tests, never a replacement
// implementation of the AI. Preprocessing and Warcraft natives stay with each game.
import assert from 'node:assert/strict';

export const zeros = () => Array(8192).fill(0);
const rawcode = value => [...value].reduce((code, char) => code * 256 + char.charCodeAt(0), 0);
export const expression = value => value.replace(/\band\b/g, '&&').replace(/\bor\b/g, '||')
  .replace(/\bnot\b/g, '!').replace(/'([^']{4})'/g, (_, code) => rawcode(code));

// Pass globalTypes for tests that model integer assignments and returns.
// Untyped scenarios retain their existing JavaScript arithmetic.
export function compile(source, name, globalTypes) {
  const match = source.match(new RegExp('function ' + name + ' takes (.*?) returns (\\w+)([\\s\\S]*?)endfunction'));
  assert.ok(match, 'Missing production function ' + name);
  const types = new Map(globalTypes);
  const params = match[1] === 'nothing' ? [] : match[1].split(',').map(part => {
    const [type, param] = part.trim().split(/\s+/);
    types.set(param, type);
    return param;
  });
  const assign = (target, value) => globalTypes && types.get(target.split('[')[0]) === 'integer'
    ? 'Math.trunc(' + expression(value) + ')' : expression(value);
  const body = match[3].split(/\r?\n/).map(raw => {
    const line = raw.replace(/\/\/.*$/, '').trim();
    if (!line) return '';
    let part;
    if ((part = line.match(/^local\s+(\w+)\s+array\s+(\w+)$/))) {
      types.set(part[2], part[1]);
      return 'let ' + part[2] + ' = zeros();';
    }
    if ((part = line.match(/^local\s+(\w+)\s+(\w+)(?:\s*=\s*(.*))?$/))) {
      types.set(part[2], part[1]);
      const value = part[3] ?? (globalTypes ? '0' : 'undefined');
      return 'let ' + part[2] + ' = ' + assign(part[2], value) + ';';
    }
    if ((part = line.match(/^set (.+?)\s*=\s*(.+)$/))) return part[1] + ' = ' + assign(part[1], part[2]) + ';';
    if ((part = line.match(/^if (.*?)\s*then$/))) return 'if (' + expression(part[1]) + ') {';
    if ((part = line.match(/^elseif (.*?)\s*then$/))) return '} else if (' + expression(part[1]) + ') {';
    if (line === 'else') return '} else {';
    if (line === 'endif' || line === 'endloop') return '}';
    if (line === 'loop') return 'while (true) {';
    if ((part = line.match(/^exitwhen (.+)$/))) return 'if (' + expression(part[1]) + ') break;';
    if ((part = line.match(/^return(?: (.+))?$/))) {
      if (!part[1]) return 'return;';
      return 'return ' + (globalTypes && match[2] === 'integer' ? 'Math.trunc(' + expression(part[1]) + ')' : expression(part[1])) + ';';
    }
    if (line.startsWith('call ')) return expression(line.slice(5)) + ';';
    throw new Error('Unsupported production JASS in ' + name + ': ' + line);
  }).join('\n');
  return 'function ' + name + '(' + params.join(',') + ') {\n' + body + '\n}';
}
