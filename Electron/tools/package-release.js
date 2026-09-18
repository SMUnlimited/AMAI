const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const { path7za } = require('7zip-bin');
const packageJson = require('../package.json');

if (process.platform !== 'win32') {
  console.log('Skipping Windows release ZIP on this platform.');
  process.exit(0);
}

const releaseDirectory = path.resolve(__dirname, '../release');
const scriptsDirectory = path.resolve(__dirname, '../../Scripts');
const artifactName = `${packageJson.name} ${packageJson.version}`;
const executable = path.join(releaseDirectory, `${artifactName}.exe`);
const archive = path.join(releaseDirectory, `${artifactName}.zip`);

if (!fs.existsSync(executable)) throw new Error(`Portable executable not found: ${executable}`);
if (!fs.existsSync(scriptsDirectory)) throw new Error(`Compiled scripts not found: ${scriptsDirectory}`);

const temporaryDirectory = fs.mkdtempSync(path.join(os.tmpdir(), 'amai-installer-release-'));

try {
  fs.copyFileSync(executable, path.join(temporaryDirectory, path.basename(executable)));
  fs.cpSync(scriptsDirectory, path.join(temporaryDirectory, 'Scripts'), { recursive: true });
  fs.rmSync(archive, { force: true });

  const result = spawnSync(path7za, ['a', '-tzip', '-mx=9', archive, '.'], {
    cwd: temporaryDirectory,
    encoding: 'utf8'
  });

  if (result.status !== 0) throw new Error(result.stderr || result.stdout || '7-Zip failed');
  console.log(`Created ${archive}`);
} finally {
  fs.rmSync(temporaryDirectory, { recursive: true, force: true });
}
