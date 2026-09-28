import { fork } from 'node:child_process';
import { createRequire } from 'node:module';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';

const require = createRequire(import.meta.url);
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const { isMapFile, missingFiles, setChatting, successfulDeleteStatus, uninstallFiles } = require('../AMAI-release/install');

describe('installer', () => {
  it('recognises Warcraft map files case-insensitively', () => {
    expect(['one.w3m', 'two.W3X', 'notes.txt'].filter(isMapFile)).toEqual(['one.w3m', 'two.W3X']);
  });

  it('exits after a failed preflight', async () => {
    const messages = [];
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
      worker.on('message', message => messages.push(message));
      worker.once('error', reject);
      worker.once('exit', code => {
        clearTimeout(timeout);
        resolve(code);
      });
    })).resolves.toBe(1);
    expect(messages).toContainEqual(expect.objectContaining({
      type: 'log',
      level: 'error',
      key: 'PAGES.APP.INSTALL_LOG.MISSING_FILES'
    }));
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

  it('accepts a custom MPQEditor path for development', () => {
    const mpqEditor = path.resolve('../MPQEditor.exe');
    expect(missingFiles('REFORGED', 0, file => file === mpqEditor, 'missing-scripts', mpqEditor)).toEqual([
      path.join('missing-scripts', 'REFORGED', 'common.ai')
    ]);
  });

  it('changes only the authoritative chat initialization assignment', () => {
    const enabled = `boolean chatting = true\nfunction cmd_misc takes nothing returns nothing\n  set chatting = not chatting\nendfunction\nfunction InitGlobalSettings takes nothing returns nothing\n  set chatting = true\nendfunction`;
    const disabled = setChatting(enabled, false);

    expect(disabled).toContain('boolean chatting = true');
    expect(disabled).toContain('set chatting = not chatting');
    expect(disabled).toContain('set chatting = false');
    expect(setChatting(disabled, true)).toBe(enabled);
  });

  it('rejects missing or duplicate chat initialization settings', () => {
    expect(() => setChatting('set chatting = not chatting', false)).toThrow(/found 0/);
    expect(() => setChatting('set chatting = true\nset chatting = false', false)).toThrow(/found 2/);
  });

  it('selects the correct files for each uninstall operation', () => {
    expect(uninstallFiles('uninstall-commander')).toEqual(['Scripts\\Blizzard.j']);
    expect(uninstallFiles('uninstall-all')).toEqual([
      'Scripts\\common.ai',
      'Scripts\\elf.ai',
      'Scripts\\human.ai',
      'Scripts\\orc.ai',
      'Scripts\\undead.ai',
      'Scripts\\elf2.ai',
      'Scripts\\human2.ai',
      'Scripts\\orc2.ai',
      'Scripts\\undead2.ai',
      'Scripts\\Blizzard.j'
    ]);
    expect(successfulDeleteStatus(0)).toBe(true);
    expect(successfulDeleteStatus(2)).toBe(true);
    expect(successfulDeleteStatus(5)).toBe(false);
  });
});
