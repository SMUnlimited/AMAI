import { createRequire } from 'node:module';
import { describe, expect, it } from 'vitest';

const require = createRequire(import.meta.url);
const { stopProcessTree } = require('../app/install-process');

describe('stopProcessTree', () => {
  it('uses taskkill for a running Windows child', () => {
    const calls = [];
    const runningChild = { pid: 123, exitCode: null, signalCode: null, kill: () => {} };

    expect(stopProcessTree(runningChild, 'win32', (...args) => calls.push(args))).toBe(true);
    expect(calls[0].slice(0, 2)).toEqual(['taskkill', ['/pid', '123', '/t', '/f']]);
  });

  it('ignores a Windows child that has already exited', () => {
    expect(stopProcessTree(
      { pid: 123, exitCode: 0, signalCode: null, kill: () => {} },
      'win32',
      () => {}
    )).toBe(false);
  });

  it('kills a running child directly on other platforms', () => {
    let killed = false;
    expect(stopProcessTree({ exitCode: null, signalCode: null, kill: () => { killed = true; } }, 'linux')).toBe(true);
    expect(killed).toBe(true);
  });
});
