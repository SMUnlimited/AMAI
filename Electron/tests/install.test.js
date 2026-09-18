const assert = require('assert');
const path = require('path');
const { isMapFile, missingFiles } = require('../AMAI-release/install');

assert.deepStrictEqual(
  ['one.w3m', 'two.W3X', 'notes.txt'].filter(isMapFile),
  ['one.w3m', 'two.W3X']
);

assert.deepStrictEqual(
  missingFiles('REFORGED', 1, file => file === 'MPQEditor.exe'),
  ['Scripts\\REFORGED\\common.ai', 'Scripts\\REFORGED\\Blizzard.j']
);

assert.deepStrictEqual(
  missingFiles('OPTREFORGED', 2, () => false),
  ['Scripts\\OPTREFORGED\\common.ai', 'MPQEditor.exe', 'Scripts\\OPTREFORGED\\vsai\\Blizzard.j']
);

const customScripts = path.resolve('custom scripts');
assert.deepStrictEqual(
  missingFiles('REFORGED', 1, file => file === 'MPQEditor.exe', customScripts),
  [
    path.join(customScripts, 'REFORGED', 'common.ai'),
    path.join(customScripts, 'REFORGED', 'Blizzard.j')
  ]
);
