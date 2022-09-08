import {app, BrowserWindow, dialog, Menu, screen } from 'electron';
import * as path from 'path';
import * as fs from 'fs';
import * as remote from '@electron/remote/main';
import { InstallModel } from '../commons/models';
const ipcMain = require('electron').ipcMain;
const cp = require('child_process');

let win: BrowserWindow = null;
const args = process.argv.slice(1),
  serve = args.some(val => val === '--serve');

// needed to call remote inside app
remote.initialize();

Menu.setApplicationMenu(null);

function isDev() {
  return require.main.filename.indexOf('app.asar') === -1;
}

function createWindow(): BrowserWindow {

  const size = screen.getPrimaryDisplay().workAreaSize;

  // Create the browser window.
  win = new BrowserWindow({
    x: 0,
    y: 0,
    width: size.width,
    height: size.height,
    webPreferences: {
      nodeIntegration: true,
      allowRunningInsecureContent: (serve),
      contextIsolation: false,  // false if you want to run e2e test with Spectron
    },
  });

  // need to remote work with electron > 14...
  remote.enable(win.webContents);

  if (serve) {
    const debug = require('electron-debug');
    debug();

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

const execInstall = async (signal, isMap: boolean = false) => {
  const controller = new AbortController();
  const response = dialog.showOpenDialogSync(win, {
    // TODO: add i18n here
    title : isMap ? "Open WC3 Map File": "Open AMAI Maps Directory",
    // TODO: Change to let multiples selections when is map
    properties: isMap ? ['openFile'] : ['openDirectory'],
    // TODO: add i18n here
    filters: isMap ? [
      { name: 'WC3 Map File', extensions: ['w3x', 'w3m'] },
    ] : null,
  });

  let child;

  // passing reference to external call back
  signal = controller.signal;

  let currentExecDir = `./AMAI-release/`, relativePath = '../';

  if(!isDev()) {
    currentExecDir = `../resources/AMAI/`;
    relativePath = '';
  }

  /** uncomment to debbug */
  // const ls = cp.spawnSync(
  //   `ls`,
  //   [`./resources`,],
  //   { encoding : `utf8` }
  // );
  // process.send(ls.stdout);
  // win.webContents.send('on-install-message', '__dirname: ' + __dirname);
  // win.webContents.send('on-install-message', 'ls: ' + ls.stdout);
  // win.webContents.send('on-install-message', 'isProd: ' + !isDev());
  // win.webContents.send('on-install-message', 'currentExecDir: ' + currentExecDir);
  // win.webContents.send('on-install-message', 'relativePath: ' + relativePath);

  if(!response || (response?.length === 0)) {
    win.webContents.send('on-install-empty');
    return;
  }

  // open modal on front
  win.webContents.send('on-install-init', <InstallModel>{
    response: response[0],
    isMap
  });

  // Change the relative path from where the script will be executed
  // MPQEditor and AddToMPQ only work when files and folders are in same directory
  try {
     process.chdir(currentExecDir);
  } catch(err) {
    console.log('error:', err.message);
  }


  // init install proccess
  try {
    child = cp.fork(
      require.resolve(`${relativePath}${currentExecDir}install.js`),
      [ response[0] ],
      { signal },
      (err) => {
        win.webContents.send('on-install-error', err);
      }
    );


    // send messages to modal on front
    child.on('message', (message) => {
      win.webContents.send('on-install-message', message);
    });

    // close modal on process finishes
    child.on('exit', () => {
      win.webContents.send('on-install-exit');
    });
  } catch(err) {
    win.webContents.send('on-install-error', err.message);
  }
}

const install = () => {
  let signal = {};

  ipcMain && ipcMain.on('install-folder', async () => {
    execInstall(signal);
  });

  ipcMain && ipcMain.on('install-map', async () => {
    execInstall(signal, true);
  });

  // TODO: stop process with signal
  ipcMain && ipcMain.on('on-stop-process', async () => {
    // stop process here
  });
}

function init() {
  try {
    // This method will be called when Electron has finished
    // initialization and is ready to create browser windows.
    // Some APIs can only be used after this event occurs.
    // Added 400 ms to fix the black background issue while using transparent window. More detais at https://github.com/electron/electron/issues/15947
    app.on('ready', function(){
      setTimeout(function (){
        createWindow();
      }, 400)
    });


    // Quit when all windows are closed.
    app.on('window-all-closed', () => {
      // On OS X it is common for applications and their menu bar
      // to stay active until the user quits explicitly with Cmd + Q
      if (process.platform !== 'darwin') {
        app.quit();
      }
    });

    app.on('activate', () => {
      // On OS X it's common to re-create a window in the app when the
      // dock icon is clicked and there are no other windows open.
      if (win === null) {
        createWindow();
      }
    });

  } catch (e) {
    // Catch Error
    // throw e;
  }
}

init();
install();
