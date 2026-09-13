const assert = require('assert');
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
