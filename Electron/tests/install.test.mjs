import { execFileSync, fork } from 'node:child_process';
import { mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';

const require = createRequire(import.meta.url);
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const { isMapFile, missingFiles, setChatting, successfulDeleteStatus, uninstallFiles } = require('../AMAI-release/install');

describe('installer', () => {
  it('customizes chat and language after optimization without renaming their references', async () => {
    const directory = mkdtempSync(path.join(tmpdir(), 'amai-optimizer-'));
    try {
      const root = path.resolve(__dirname, '../..');
      const scripts = path.join(directory, 'OPTREFORGED');
      const maps = path.join(directory, 'maps');
      mkdirSync(scripts);
      mkdirSync(maps);
      const common = path.join(directory, 'common.j');
      const library = path.join(scripts, 'common.ai');
      const race = path.join(scripts, 'human.ai');
      const commander = path.join(scripts, 'Blizzard.j');
      const editor = path.join(directory, 'MPQEditor.exe');
      writeFileSync(common, '');
      writeFileSync(editor, ''); // No maps: exercise settings without invoking MPQEditor.
      writeFileSync(library, `globals
boolean chatting = true
string language = "English"
endglobals
function ReadSettings takes nothing returns string
  set chatting = true
  if chatting then
    return language
  endif
  return language
endfunction
`);
      writeFileSync(race, `function main takes nothing returns nothing
  local string temporary_language = ReadSettings()
  set language = temporary_language
  if chatting then
    set chatting = not chatting
  endif
endfunction
`);
      writeFileSync(commander, 'globals\nstring language = ""\nendglobals\n');
      execFileSync('perl', ['Optimize.pl', common, library, race], { cwd: root });
      execFileSync('perl', ['Optimize.pl', '-b', commander], { cwd: root });
      const optimized = readFileSync(library, 'utf8');
      expect(optimized).toContain('boolean chatting=true');
      expect(optimized).toContain('string language="English"');
      expect(optimized).toContain('if chatting then');
      expect(optimized).toContain('return language');
      expect(readFileSync(race, 'utf8')).toMatch(/set language=v[0-9a-f]+/);
      expect(readFileSync(race, 'utf8')).toContain('set chatting=not chatting');

      for (const [language, disableChat] of [['French', 'true'], ['-', 'false']]) {
        const worker = fork(path.resolve(__dirname, '../AMAI-release/install.js'),
          [maps, '1', 'OPTREFORGED', language, directory, editor, disableChat], { silent: true });
        await expect(new Promise((resolve, reject) => {
          const timeout = setTimeout(() => {
            worker.kill();
            reject(new Error('Installer did not finish configuring optimized scripts'));
          }, 5000);
          worker.once('error', reject);
          worker.once('exit', code => {
            clearTimeout(timeout);
            resolve(code);
          });
        })).resolves.toBe(0);
        expect(readFileSync(library, 'utf8')).toContain(`set chatting=${disableChat === 'true' ? 'false' : 'true'}`);
        expect(readFileSync(library, 'utf8')).toContain(`string language = "${language === '-' ? 'English' : language}"`);
        expect(readFileSync(commander, 'utf8')).toContain(`string language = "${language === '-' ? '' : language}"`);
      }
    } finally {
      rmSync(directory, { recursive: true, force: true });
    }
  });

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
