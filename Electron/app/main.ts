import {app, BrowserWindow, dialog, ipcMain, Menu } from 'electron';
import * as path from 'path';
import * as fs from 'fs';
import * as remote from '@electron/remote/main';
import * as cp from 'child_process';
import { InstallModel } from '../commons/models';
import { stopProcessTree } from './install-process';

let win: BrowserWindow = null;
let activeInstaller: cp.ChildProcess | null = null;
let translations : { [key: string]: string } = {};
let currentLanguage = "English";
const args = process.argv.slice(1),
  serve = args.some(val => val === '--serve');
const isE2E = process.env.AMAI_E2E === 'true';

// needed to call remote inside app
remote.initialize();

// disable default menu
Menu.setApplicationMenu(null);

const isDev = () => {
  return require.main.filename.indexOf('app.asar') === -1;
}

const installerDirectory = () => path.resolve(__dirname, isDev() ? '../AMAI-release' : '../AMAI');
const scriptsDirectory = () => isDev()
  ? path.resolve(__dirname, '../../Scripts')
  : path.join(process.env.PORTABLE_EXECUTABLE_DIR || path.dirname(process.execPath), 'Scripts');
const installerVersions = ['ROC', 'TFT', 'REFORGED', 'OPTROC', 'OPTTFT', 'OPTREFORGED'];
const missingInstallerFiles = () => [
  path.join(installerDirectory(), 'install.js'),
  path.join(installerDirectory(), 'MPQEditor.exe'),
  ...installerVersions.flatMap(version => [
    path.join(scriptsDirectory(), version, 'common.ai'),
    path.join(scriptsDirectory(), version, 'Blizzard.j'),
    path.join(scriptsDirectory(), version, 'vsai', 'Blizzard.j')
  ])
].filter(file => !fs.existsSync(file));

const sendToWindow = (channel: string, ...message: unknown[]) => {
  if (win && !win.isDestroyed()) {
    win.webContents.send(channel, ...message);
  }
};

const reportMissingInstallerFiles = (): boolean => {
  const missing = missingInstallerFiles();
  if (!missing.length) return false;

  dialog.showErrorBox(
    'AMAI installer files missing',
    `The installer is incomplete and cannot run. Missing required files:\n\n${missing.join('\n')}`
  );
  return true;
}

const createWindow = (): BrowserWindow => {

  // Create the browser window.
  win = new BrowserWindow({
    width: 1200,
    height: 900,
    minWidth: 900,
    minHeight: 650,
    center: true,
    webPreferences: {
      devTools: true,
      nodeIntegration: true,
      allowRunningInsecureContent: (serve),
      contextIsolation: false,  // false if you want to run e2e test with Spectron
    },
  });

  // needed to remote work with electron > 14...
  remote.enable(win.webContents);

  if (serve) {
    // Loaded only by the development server.
    // hot reload frontend
    // eslint-disable-next-line @typescript-eslint/no-require-imports
    require('electron-reloader')(module);
    win.loadURL('http://localhost:4200');
  } else {
    // Path when running electron executable
    let pathIndex = './index.html';

    if (fs.existsSync(path.join(__dirname, '../dist/index.html'))) {
       // Path when running electron in local folder
      pathIndex = '../dist/index.html';
    }

    const url = new URL(path.join('file:', __dirname, pathIndex));
    win.loadURL(url.href);
  }

  // Emitted when the window is closed.
  win.on('closed', () => {
    // Dereference the window object, usually you would store window
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    win = null;
  });

  return win;
}

const execInstall = async (commander = 1, isMap = false, ver = "REFORGED", forceLang: boolean) => {
  const response = dialog.showOpenDialogSync(win, {
    // TODO: add i18n here
    title : isMap ? translations["PAGES.ELECTRON.OPEN_MAP"] || '': translations["PAGES.ELECTRON.OPEN_DIR"] || '',
    // TODO: Change to let multiples selections when is map
    properties: isMap ? ['openFile'] : ['openDirectory'],
    // TODO: add i18n here
    filters: isMap ? [
      { name: translations["PAGES.ELECTRON.MAPFILE"] || '', extensions: ['w3x', 'w3m'] },
    ] : null,
  });

  let child: cp.ChildProcess;

  const currentScriptDir = installerDirectory();

  /** uncomment to debbug */
  // const ls = cp.spawnSync(
  //   `ls`,
  //   [`./resources`,],
  //   { encoding : `utf8` }
  // );
  // // process.send(ls.stdout);
  // win.webContents.send('on-install-message', '__dirname: ' + __dirname);
  // win.webContents.send('on-install-message', 'ls: ' + ls.stdout);
  // win.webContents.send('on-install-message', 'isProd: ' + !isDev());
  // win.webContents.send('on-install-message', 'currentExecDir: ' + currentExecDir);
  // win.webContents.send('on-install-message', `install js path: ../${currentExecDir}install.js`);

  if(!response || (response?.length === 0)) {
    sendToWindow('on-install-empty');
    return;
  }

  // open modal on front
  sendToWindow('on-install-init', <InstallModel>{
    response: response[0],
    commander,
    isMap
  });

  // Change the relative path from where the script will be executed
  // MPQEditor and AddToMPQ only work when files and folders are in same directory
  try {
     process.chdir(currentScriptDir);
  } catch(err) {
    sendToWindow('on-install-error', err.message);
    return;
  }


  // init install proccess
  try {
    stopProcessTree(activeInstaller);
    child = cp.fork(
      require.resolve(
        path.join(currentScriptDir, 'install.js')
      ),
      [ response[0], String(commander), ver, forceLang ? currentLanguage : '-', scriptsDirectory() ]
    );
    activeInstaller = child;

    child.on('error', (err) => {
      stopProcessTree(child);
      sendToWindow('on-install-error', err.message);
    });

    // send messages to modal on front
    child.on('message', (message) => {
      sendToWindow(
        message && typeof message === 'object' && 'type' in message && message.type === 'progress'
          ? 'on-install-progress'
          : 'on-install-message',
        message
      );
    });

    // close modal on process finishes
    child.on('exit', (code) => {
      if (activeInstaller === child) {
        activeInstaller = null;
      }
      if (code) {
        sendToWindow('on-install-error', `Installer exited with code ${code}`);
      } else {
        sendToWindow('on-install-exit');
      }
    });
  } catch(err) {
    sendToWindow('on-install-error', err.message);
  }
}

const installProcess = () => {
  ipcMain?.on('install', async (_event, ver: string, toFolder: boolean, commander: number, optimize: boolean, forceLang : boolean) => {
    execInstall(commander, !toFolder, optimize ? `OPT${ver}` : ver, forceLang);
  });

  ipcMain?.on('on-stop-process', async () => {
    stopProcessTree(activeInstaller);
  });
}

const init = () => {
  try {
    // This method will be called when Electron has finished
    // initialization and is ready to create browser windows.
    // Some APIs can only be used after this event occurs.
    // Added 400 ms to fix the black background issue while using transparent window. More detais at https://github.com/electron/electron/issues/15947
    app.on('ready', () => {
      if (!isE2E && reportMissingInstallerFiles()) {
        app.quit();
        return;
      }
      setTimeout(() => {
        createWindow();
      }, 400)
    });


    // Quit when all windows are closed.
    app.on('window-all-closed', () => {
      stopProcessTree(activeInstaller);
      // On OS X it is common for applications and their menu bar
      // to stay active until the user quits explicitly with Cmd + Q
      if (process.platform !== 'darwin') {
        app.quit();
      }
    });

    app.on('before-quit', () => stopProcessTree(activeInstaller));

    app.on('activate', () => {
      // On OS X it's common to re-create a window in the app when the
      // dock icon is clicked and there are no other windows open.
      if (win === null) {
        createWindow();
      }
    });

  } catch {
    // Catch Error
    // throw e;
  }
}

const installTrans = () => {
  ipcMain?.on('Trans', (_event, currentLang: string, data) => {
    console.log(`Setting language to:${currentLang}`);
    switch (currentLang) {
      case 'en':
        currentLanguage = "English";
        break;
      case 'zh':
        currentLanguage = "Chinese";
        break;
      case 'fr':
        currentLanguage = "French";
        break;
      case 'de':
        currentLanguage = "Deutsch";
        break;
      case 'no':
        currentLanguage = "Norwegian";
        break;
      case 'pt':
        currentLanguage = "Portuguese";
        break;
      case 'ro':
        currentLanguage = "Romanian";
        break;
      case 'ru':
        currentLanguage = "Russian";
        break;
      case 'es':
        currentLanguage = "Spanish";
        break;
      case 'sv':
        currentLanguage = "Swedish";
        break;
      default:
        currentLanguage = "English";
        console.log('Current Language: Unknown so change to English');
    }
    translations = data as { [key: string]: string };
    if (win != null) {
      win.setTitle(translations['PAGES.HOME.TITLE'] || '')
    }
  });
}

init();
installTrans();
installProcess();
