const assert = require('assert');
const { isMapFile } = require('../AMAI-release/install');

assert.deepStrictEqual(
  ['one.w3m', 'two.W3X', 'notes.txt'].filter(isMapFile),
  ['one.w3m', 'two.W3X']
);
