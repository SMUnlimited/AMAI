const { spawnSync } = require('child_process');

/**
 * @param {{ pid?: number, exitCode: number | null, signalCode: string | null, kill: () => unknown } | null} child
 * @param {string} platform
 * @param {(command: string, args: string[], options: object) => unknown} run
 * @returns {boolean}
 */
const stopProcessTree = (child, platform = process.platform, run = spawnSync) => {
  if (!child || child.exitCode !== null || child.signalCode !== null) {
    return false;
  }

  if (platform === 'win32' && child.pid) {
    run('taskkill', ['/pid', String(child.pid), '/t', '/f'], {
      windowsHide: true,
      stdio: 'ignore'
    });
  } else {
    child.kill();
  }

  return true;
};

module.exports = { stopProcessTree };
