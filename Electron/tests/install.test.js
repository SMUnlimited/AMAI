const assert = require('assert');
const path = require('path');
const { isMapFile, missingFiles } = require('../AMAI-release/install');

assert.deepStrictEqual(
  ['one.w3m', 'two.W3X', 'notes.txt'].filter(isMapFile),
  ['one.w3m', 'two.W3X']
);

assert.deepStrictEqual(
  missingFiles('REFORGED', 1, file => file === 'MPQEditor.exe'),
  [path.join('Scripts', 'REFORGED', 'common.ai'), path.join('Scripts', 'REFORGED', 'Blizzard.j')]
);

assert.deepStrictEqual(
  missingFiles('OPTREFORGED', 2, () => false),
  [
    path.join('Scripts', 'OPTREFORGED', 'common.ai'),
    'MPQEditor.exe',
    path.join('Scripts', 'OPTREFORGED', 'vsai', 'Blizzard.j')
  ]
);

const customScripts = path.resolve('custom scripts');
assert.deepStrictEqual(
  missingFiles('REFORGED', 1, file => file === 'MPQEditor.exe', customScripts),
  [
    path.join(customScripts, 'REFORGED', 'common.ai'),
    path.join(customScripts, 'REFORGED', 'Blizzard.j')
  ]
);
