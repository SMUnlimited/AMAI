import { ChildProcess, spawnSync } from 'child_process';

type RunCommand = (
  command: string,
  args: string[],
  options: { windowsHide: boolean; stdio: 'ignore' }
) => unknown;

export const stopProcessTree = (
  child: ChildProcess | null,
  platform = process.platform,
  run: RunCommand = spawnSync
): boolean => {
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
