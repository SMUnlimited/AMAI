import { fork } from 'node:child_process';
import { createRequire } from 'node:module';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';

const require = createRequire(import.meta.url);
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const { isMapFile, missingFiles } = require('../AMAI-release/install');

describe('installer', () => {
  it('recognises Warcraft map files case-insensitively', () => {
    expect(['one.w3m', 'two.W3X', 'notes.txt'].filter(isMapFile)).toEqual(['one.w3m', 'two.W3X']);
  });

  it('exits after a failed preflight', async () => {
    const worker = fork(
      path.resolve(__dirname, '../AMAI-release/install.js'),
      ['unused-map-path', '1', 'REFORGED', '-', 'missing-scripts'],
      { silent: true }
    );

    await expect(new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        worker.kill();
        reject(new Error('Installer worker did not exit after completing its failed preflight'));
      }, 5000);
      worker.once('error', reject);
      worker.once('exit', code => {
        clearTimeout(timeout);
        resolve(code);
      });
    })).resolves.toBe(1);
  });

  it('reports missing default script files', () => {
    expect(missingFiles('REFORGED', 1, file => file === 'MPQEditor.exe')).toEqual([
      path.join('Scripts', 'REFORGED', 'common.ai'),
      path.join('Scripts', 'REFORGED', 'Blizzard.j')
    ]);
    expect(missingFiles('OPTREFORGED', 2, () => false)).toEqual([
      path.join('Scripts', 'OPTREFORGED', 'common.ai'),
      'MPQEditor.exe',
      path.join('Scripts', 'OPTREFORGED', 'vsai', 'Blizzard.j')
    ]);
  });

  it('reports missing files from a custom scripts directory', () => {
    const customScripts = path.resolve('custom scripts');
    expect(missingFiles('REFORGED', 1, file => file === 'MPQEditor.exe', customScripts)).toEqual([
      path.join(customScripts, 'REFORGED', 'common.ai'),
      path.join(customScripts, 'REFORGED', 'Blizzard.j')
    ]);
  });
});
