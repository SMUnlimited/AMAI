const fs = require("fs");
const path = require("path");
const spawnSync = require("child_process").spawnSync;
const arrayOfFiles = [];
const uninstallAllFiles = [
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
];

const sendLog = (level, key, params = {}) => process.send({ type: 'log', level, key, params });

const isMapFile = file => [`.w3m`, `.w3x`].includes(path.extname(file).toLowerCase());

const requiredFiles = (ver, commander, scriptsDirectory = 'Scripts', mpqEditor = 'MPQEditor.exe') => [
  path.join(scriptsDirectory, ver, 'common.ai'),
  mpqEditor,
  ...(commander == 1 ? [path.join(scriptsDirectory, ver, 'Blizzard.j')] : []),
  ...(commander == 2 ? [path.join(scriptsDirectory, ver, 'vsai', 'Blizzard.j')] : [])
];

const missingFiles = (ver, commander, existsSync = fs.existsSync, scriptsDirectory = 'Scripts', mpqEditor = 'MPQEditor.exe') =>
  requiredFiles(ver, commander, scriptsDirectory, mpqEditor).filter(file => !existsSync(file));

const uninstallFiles = operation => operation === 'uninstall-commander'
  ? ['Scripts\\Blizzard.j']
  : uninstallAllFiles;

const successfulDeleteStatus = status => status === 0 || status === 2;

const setChatting = (data, enabled) => {
  const searchFor = /(^\s*set\s+chatting\s*=\s*)(true|false)(\s*$)/gm;
  const matches = [...data.matchAll(searchFor)];
  if (matches.length !== 1) {
    throw new Error(`Expected one chat initialization setting, found ${matches.length}`);
  }
  return data.replace(searchFor, `$1${enabled ? 'true' : 'false'}$3`);
};

const configureChatting = (file, enabled) => {
  const data = fs.readFileSync(file, 'utf8');
  fs.writeFileSync(file, setChatting(data, enabled), 'utf8');
};

/** uncomment to debbug */
// const ls = spawnSync(
//   `ls`,
//   [`.\\resources`,],
//   { encoding : `utf8` }
// );
// process.send(ls.stdout);

const getAllFiles = (dirPath, arrayOfFiles) => {
  const files = fs.readdirSync(dirPath);

  arrayOfFiles = arrayOfFiles || [];

  files.forEach(function(file) {
    if (fs.statSync(dirPath + "\\" + file).isDirectory()) {
      arrayOfFiles = getAllFiles(dirPath + "\\" + file, arrayOfFiles);
    } else {
      arrayOfFiles.push(path.join(dirPath, "\\", file));
    }
  })

  return arrayOfFiles;
}

const installOnDirectory = async () => {
  const args = process.argv.slice(2);
  const response = args[0];
  const commander = args[1];
  const ver = args[2]
  const language =  args[3]
  const scriptsDirectory = args[4] || 'Scripts'
  const mpqEditorExecutable = args[5] || 'MPQEditor.exe'
  const disableChat = args[6] === 'true'
  const operation = args[7] || 'install'
  const installCommander = commander == 1
  const vsAICommander = commander == 2
  let bj = 'Blizzard.j' 
  if (vsAICommander) { bj = 'vsai\\Blizzard.j'}

  const commonAIPath = path.join(scriptsDirectory, ver, 'common.ai')
  const blizzardPath = path.join(scriptsDirectory, ver, ...(vsAICommander ? ['vsai', 'Blizzard.j'] : ['Blizzard.j']))

  const missing = operation === 'install'
    ? missingFiles(ver, commander, fs.existsSync, scriptsDirectory, mpqEditorExecutable)
    : [mpqEditorExecutable].filter(file => !fs.existsSync(file));
  if (missing.length) {
    sendLog('error', 'PAGES.APP.INSTALL_LOG.MISSING_FILES', { files: missing.map(file => path.resolve(file)).join('\n') });
    process.exitCode = 1;
    return;
  }

  // TODO: change to receive array of maps
  if (fs.statSync(response).isDirectory()) {
    // on directory
    getAllFiles(response, arrayOfFiles);
  } else {
    // on single map
    arrayOfFiles.push(response);
  }

  const mapFiles = arrayOfFiles.filter(isMapFile);
  if (operation !== 'install') {
    sendLog('info', 'PAGES.APP.INSTALL_LOG.UNINSTALL_START', { count: mapFiles.length });
    for (const [index, file] of mapFiles.entries()) {
      process.send({ type: 'progress', current: index + 1, total: mapFiles.length });
      sendLog('info', 'PAGES.APP.INSTALL_LOG.UNINSTALL_MAP_START', { file });
      try {
        fs.accessSync(file, fs.constants.W_OK);
      } catch {
        sendLog('warning', 'PAGES.APP.INSTALL_LOG.NO_WRITE_PERMISSION', { file });
        continue;
      }

      let failed = false;
      for (const archiveFile of uninstallFiles(operation)) {
        const result = spawnSync(mpqEditorExecutable, ['d', file, archiveFile], { encoding: 'utf8' });
        if (result.error) {
          sendLog('error', 'PAGES.APP.INSTALL_LOG.SYSTEM_ERROR', { detail: result.error.message });
          failed = true;
          break;
        }
        if (result.status === 5) {
          sendLog('warning', 'PAGES.APP.INSTALL_LOG.PERMISSION_FAILURE', { file, operation: archiveFile });
          failed = true;
          break;
        }
        if (!successfulDeleteStatus(result.status)) {
          sendLog('warning', 'PAGES.APP.INSTALL_LOG.UNKNOWN_FAILURE', { file, operation: archiveFile, status: result.status });
          failed = true;
          break;
        }
      }
      if (failed) continue;

      const flush = spawnSync(mpqEditorExecutable, ['f', file], { encoding: 'utf8' });
      if (flush.error) {
        sendLog('error', 'PAGES.APP.INSTALL_LOG.SYSTEM_ERROR', { detail: flush.error.message });
      } else if (flush.status === 5) {
        sendLog('warning', 'PAGES.APP.INSTALL_LOG.PERMISSION_FAILURE', { file, operation: 'MPQ flush' });
      } else if (flush.status !== 0) {
        sendLog('warning', 'PAGES.APP.INSTALL_LOG.UNKNOWN_FAILURE', { file, operation: 'MPQ flush', status: flush.status });
      } else {
        sendLog('info', operation === 'uninstall-commander'
          ? 'PAGES.APP.INSTALL_LOG.COMMANDER_REMOVED'
          : 'PAGES.APP.INSTALL_LOG.ALL_REMOVED', { file });
      }
    }
    return;
  }

  sendLog('info', 'PAGES.APP.INSTALL_LOG.START', {
    version: ver,
    commander: commander > 0 ? bj : 'None',
    language: language || 'default'
  });

  try {
    configureChatting(commonAIPath, !disableChat);
  } catch (error) {
    sendLog('error', 'PAGES.APP.INSTALL_LOG.CHAT_SETTING_FAILURE', { error: String(error) });
    process.exitCode = 1;
    return;
  }

  if (language !== '-') {
    setLanguage(commonAIPath, language);
    if (installCommander) {
      setLanguage(blizzardPath, language);
    }
  } else {
    setLanguage(commonAIPath, "English");
    if (installCommander) {
      setLanguage(blizzardPath, ""); // Select at game start
    }
  }


  if(arrayOfFiles) {
    for (const [index, file] of mapFiles.entries()) {
      /** uncomment to debbug */
      // process.send(`path.extname(file): ${path.extname(file)}`);

      process.send({ type: 'progress', current: index + 1, total: mapFiles.length });
      sendLog('info', 'PAGES.APP.INSTALL_LOG.MAP_START', { version: ver, file });

      try {
        fs.accessSync(file, fs.constants.W_OK)
      } catch {
        sendLog('warning', 'PAGES.APP.INSTALL_LOG.NO_WRITE_PERMISSION', { file });
        continue;
      }

      try {
        // execute same way how InstallTFTtoDir.pl

        const mpqEditor = spawnSync(
          mpqEditorExecutable,
          [`htsize`, file, `128`],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('mpqEditor', mpqEditor.error);

        // spawnSync(`echo`, [`running execuMPQEditor ${file}`]);
        if (mpqEditor.status == 5) {
          sendLog('warning', 'PAGES.APP.INSTALL_LOG.PERMISSION_FAILURE', { file, operation: 'MPQEditor htsize' })
          continue;
        }
        mpqEditor.error ?
          sendLog('error', 'PAGES.APP.INSTALL_LOG.SYSTEM_ERROR', { detail: mpqEditor.error.message })
            : sendLog('info', 'PAGES.APP.INSTALL_LOG.RESIZE_SUCCESS', { file });

        const f1AddToMPQ =  spawnSync(
          mpqEditorExecutable,
          [
            'a',
            file,
            path.join(scriptsDirectory, ver, '*.ai'),
            `Scripts`
          ],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('f1AddToMPQ', f1AddToMPQ.error);

        // spawnSync(`echo`, [`running AddToMPQ 1 ${file}`]);
        // process.send(`running AddToMPQ 1 ${file}`);
        if (f1AddToMPQ.status == 5) {
          sendLog('warning', 'PAGES.APP.INSTALL_LOG.PERMISSION_FAILURE', { file, operation: 'AI scripts' })
          continue;
        } else if (f1AddToMPQ.status > 0) {
          sendLog('warning', 'PAGES.APP.INSTALL_LOG.UNKNOWN_FAILURE', { file, operation: 'AI scripts', status: f1AddToMPQ.status })
          continue;
        }
        f1AddToMPQ.error ?
          sendLog('error', 'PAGES.APP.INSTALL_LOG.SYSTEM_ERROR', { detail: f1AddToMPQ.error.message })
            : sendLog('info', 'PAGES.APP.INSTALL_LOG.AI_SUCCESS', { file });
 
        if (commander > 0) {
          
          if (vsAICommander) {
                const f1AddVSAIToMPQ =  spawnSync(
                mpqEditorExecutable,
                [
                  'a',
                  file,
                  path.join(scriptsDirectory, ver, 'vsai', '*.ai'),
                  `Scripts`
                ],
                { encoding : `utf8` }
              );
              if (f1AddVSAIToMPQ.status == 5) {
                sendLog('warning', 'PAGES.APP.INSTALL_LOG.PERMISSION_FAILURE', { file, operation: 'VS AI scripts' })
                continue;
              } else if (f1AddVSAIToMPQ.status > 0) {
                sendLog('warning', 'PAGES.APP.INSTALL_LOG.UNKNOWN_FAILURE', { file, operation: 'VS AI scripts', status: f1AddVSAIToMPQ.status })
                continue;
              }
              f1AddVSAIToMPQ.error ?
                sendLog('error', 'PAGES.APP.INSTALL_LOG.SYSTEM_ERROR', { detail: f1AddVSAIToMPQ.error.message })
                  : sendLog('info', 'PAGES.APP.INSTALL_LOG.VSAI_SUCCESS', { file });
            
          }

          const f2AddToMPQ =  spawnSync(
            mpqEditorExecutable,
            [
              'a',
              file,
              blizzardPath,
              `Scripts\\Blizzard.j`,
            ],
            { encoding : `utf8` }
          );

          /** uncomment to debbug */
         // console.log('f2AddToMPQ', f2AddToMPQ.error);

          // spawnSync(`echo`, [`running AddToMPQ 2 ${file}`]);
          if (f2AddToMPQ.status == 5) {
            sendLog('warning', 'PAGES.APP.INSTALL_LOG.PERMISSION_FAILURE', { file, operation: bj })
            continue;
          } else if (f2AddToMPQ.status > 0) {
            sendLog('warning', 'PAGES.APP.INSTALL_LOG.UNKNOWN_FAILURE', { file, operation: bj, status: f2AddToMPQ.status })
            continue;
          }
          f2AddToMPQ.error ?
            sendLog('error', 'PAGES.APP.INSTALL_LOG.SYSTEM_ERROR', { detail: f2AddToMPQ.error.message })
              : sendLog('info', installCommander
                ? 'PAGES.APP.INSTALL_LOG.COMMANDER_SUCCESS'
                : 'PAGES.APP.INSTALL_LOG.VSAI_COMMANDER_SUCCESS', { file });

        }

        const f3AddToMPQ =  spawnSync(
          mpqEditorExecutable,
          [
            'f',
            file
          ],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('f3AddToMPQ', f3AddToMPQ.error);

        // spawnSync(`echo`, [`running AddToMPQ 3 ${file}`]);
        if (f3AddToMPQ.status == 5) {
          sendLog('warning', 'PAGES.APP.INSTALL_LOG.PERMISSION_FAILURE', { file, operation: 'MPQ flush' })
          continue;
        } else if (f3AddToMPQ.status > 0) {
            sendLog('warning', 'PAGES.APP.INSTALL_LOG.UNKNOWN_FAILURE', { file, operation: 'MPQ flush', status: f3AddToMPQ.status })
            continue;
          }
        f3AddToMPQ.error ?
          sendLog('error', 'PAGES.APP.INSTALL_LOG.SYSTEM_ERROR', { detail: f3AddToMPQ.error.message })
            : sendLog('info', 'PAGES.APP.INSTALL_LOG.OPTIMIZE_SUCCESS', { file });
      } catch(error) {
        console.log(error);
        sendLog('error', 'PAGES.APP.INSTALL_LOG.INSTALL_FAILURE', { error: String(error) });
      }
    }
  }


  function setLanguage(file, language) {
    let data = fs.readFileSync(file, 'utf8');
    const searchFor = /\bstring\s+language\s*=\s*"([^"]*)"/;
    const replaceWith = `string language = "${language}"`;
    data = data.replace(searchFor, replaceWith);
    fs.writeFileSync(file, data, 'utf8');
  }
  // spawnSync(`echo`, [`finish install processing into folder ${dirPath}`]);
}

if (require.main === module) {
  installOnDirectory().finally(() => {
    // Close the fork IPC channel after queued progress/log messages have been delivered.
    if (process.connected) process.disconnect();
  });
}

module.exports = { isMapFile, missingFiles, setChatting, successfulDeleteStatus, uninstallFiles };
