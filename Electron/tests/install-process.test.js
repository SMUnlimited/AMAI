const assert = require('assert');
const { stopProcessTree } = require('../app/install-process');

const calls = [];
const runningChild = { pid: 123, exitCode: null, signalCode: null, kill: () => {} };

assert.strictEqual(stopProcessTree(runningChild, 'win32', (...args) => calls.push(args)), true);
assert.deepStrictEqual(calls[0].slice(0, 2), ['taskkill', ['/pid', '123', '/t', '/f']]);
assert.strictEqual(
  stopProcessTree({ pid: 123, exitCode: 0, signalCode: null, kill: () => {} }, 'win32', () => {}),
  false
);

let killed = false;
assert.strictEqual(stopProcessTree({ exitCode: null, signalCode: null, kill: () => { killed = true; } }, 'linux'), true);
assert.strictEqual(killed, true);
