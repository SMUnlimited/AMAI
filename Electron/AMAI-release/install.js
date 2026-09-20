const fs = require("fs");
const path = require("path");
const { takeHeapSnapshot } = require("process");
const spawnSync = require("child_process").spawnSync;
const arrayOfFiles = [];

const isMapFile = file => [`.w3m`, `.w3x`].includes(path.extname(file).toLowerCase());

const requiredFiles = (ver, commander, scriptsDirectory = 'Scripts') => [
  path.join(scriptsDirectory, ver, 'common.ai'),
  `MPQEditor.exe`,
  ...(commander == 1 ? [path.join(scriptsDirectory, ver, 'Blizzard.j')] : []),
  ...(commander == 2 ? [path.join(scriptsDirectory, ver, 'vsai', 'Blizzard.j')] : [])
];

const missingFiles = (ver, commander, existsSync = fs.existsSync, scriptsDirectory = 'Scripts') =>
  requiredFiles(ver, commander, scriptsDirectory).filter(file => !existsSync(file));

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
  const installCommander = commander == 1
  const vsAICommander = commander == 2
  let bj = 'Blizzard.j' 
  if (vsAICommander) { bj = 'vsai\\Blizzard.j'}

  const commonAIPath = path.join(scriptsDirectory, ver, 'common.ai')
  const blizzardPath = path.join(scriptsDirectory, ver, ...(vsAICommander ? ['vsai', 'Blizzard.j'] : ['Blizzard.j']))

  const missing = missingFiles(ver, commander, fs.existsSync, scriptsDirectory);
  if (missing.length) {
    process.send(`ERROR: Cannot find required installer files:\n${missing.map(file => path.resolve(file)).join('\n')}`);
    process.exitCode = 1;
    return;
  }

  process.send(`#### Installing AMAI for ${ver} Commander ${commander > 0 ? bj : 'None'} forcing ai language to ${language || 'default'} ####`);

  // TODO: change to receive array of maps
  if (fs.statSync(response).isDirectory()) {
    // on directory
    getAllFiles(response, arrayOfFiles);
  } else {
    // on single map
    arrayOfFiles.push(response);
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
    const mapFiles = arrayOfFiles.filter(isMapFile);
    for (const [index, file] of mapFiles.entries()) {
      /** uncomment to debbug */
      // process.send(`path.extname(file): ${path.extname(file)}`);

      process.send({ type: 'progress', current: index + 1, total: mapFiles.length });
      process.send(`#### Installing ${ver} into file: ${file} ####`);

      try {
        fs.accessSync(file, fs.constants.W_OK)
      } catch (e) {
        process.send(`WARN: ${file} does not have write permissions so unable to install`);
        continue;
      }

      try {
        // execute same way how InstallTFTtoDir.pl

        const mpqEditor = spawnSync(
          `MPQEditor.exe`,
          [`htsize`, file, `128`],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('mpqEditor', mpqEditor.error);

        // spawnSync(`echo`, [`running execuMPQEditor ${file}`]);
        if (mpqEditor.status == 5) {
          process.send(`WARN: ${file} Failed to run mpqeditor htsize, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location`)
          continue;
        }
        mpqEditor.error ?
          process.send(mpqEditor.error.message)
            : process.send(`Resize map hashtable size ${file}`);

        const f1AddToMPQ =  spawnSync(
          `MPQEditor.exe`,
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
          process.send(`WARN: ${file} Failed to add ai scripts, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location`)
          continue;
        } else if (f1AddToMPQ.status > 0) {
          process.send(`WARN: ${file} Possibly failed to add ai scripts, Unknown error occurred: ${f1AddToMPQ.status}`)
          continue;
        }
        f1AddToMPQ.error ?
          process.send(f1AddToMPQ.error.message)
            : process.send(`Add ai scripts ${file}`);
 
        if (commander > 0) {
          
          if (vsAICommander) {
                const f1AddVSAIToMPQ =  spawnSync(
                `MPQEditor.exe`,
                [
                  'a',
                  file,
                  path.join(scriptsDirectory, ver, 'vsai', '*.ai'),
                  `Scripts`
                ],
                { encoding : `utf8` }
              );
              if (f1AddVSAIToMPQ.status == 5) {
                process.send(`WARN: ${file} Failed to add vsai scripts, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location`)
                continue;
              } else if (f1AddVSAIToMPQ.status > 0) {
                process.send(`WARN: ${file} Possibly failed to add vsai scripts, Unknown error occurred: ${f1AddVSAIToMPQ.status}`)
                continue;
              }
              f1AddVSAIToMPQ.error ?
                process.send(f1AddVSAIToMPQ.error.message)
                  : process.send(`Installing VS Vanilla AI Scripts ${file}`);
            
          }

          const f2AddToMPQ =  spawnSync(
            `MPQEditor.exe`,
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
            process.send(`WARN: ${file} Failed to add ${bj} script, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location`)
            continue;
          } else if (f2AddToMPQ.status > 0) {
            process.send(`WARN: ${file} Possibly failed to add ${bj} script, Unknown error occurred: ${f2AddToMPQ.status}`)
            continue;
          }
          f2AddToMPQ.error ?
            process.send(f2AddToMPQ.error.message)
              : process.send(installCommander ? `Installing commander ${file}` : `Installing VS Vanilla AI commander ${file}`);

        }

        const f3AddToMPQ =  spawnSync(
          `MPQEditor.exe`,
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
          process.send(`WARN: ${file} Failed to flush scripts, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location`)
          continue;
        } else if (f3AddToMPQ.status > 0) {
            process.send(`WARN: ${file} Possibly failed to flush scripts, Unknown error occurred: ${f3AddToMPQ.status}`)
            continue;
          }
        f3AddToMPQ.error ?
          process.send(f3AddToMPQ.error.message)
            : process.send(`Optimize map MPQ ${file}`);
      } catch(error) {
        console.log(error);
        process.send(`Install failed with error: ${error}`);
      }
    }
  }


  function setLanguage(file, language) {
    let data = fs.readFileSync(file, 'utf8');
    const searchFor = /string language = "([^"]*)"/;
    const replaceWith = `string language = "${language}"`;
    data = data.replace(searchFor, replaceWith);
    fs.writeFileSync(file, data, 'utf8');
  }
  // spawnSync(`echo`, [`finish install processing into folder ${dirPath}`]);
}

if (require.main === module) {
  // Do not outlive Electron if it is terminated before it can clean up the process tree.
  process.on('disconnect', () => process.exit(1));
  installOnDirectory();
}

module.exports = { isMapFile, missingFiles };
