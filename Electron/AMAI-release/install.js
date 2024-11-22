const fs = require("fs");
const path = require("path");
const { takeHeapSnapshot } = require("process");
const spawnSync = require("child_process").spawnSync;
const arrayOfFiles = [];


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
  const installCommander = commander == 1
  const vsAICommander = commander == 2
  let bj = 'Blizzard.j' 
  if (vsAICommander) { bj = 'vsai\\Blizzard.j'}

  const commonAIPath = `Scripts\\${ver}\\common.ai`
  const blizzardPath =`Scripts\\${ver}\\Blizzard.j`

  process.send(`#### Installing AMAI for ${ver} Commander ${commander > 0 ? bj : 'None'} forcing ai language to ${language || 'default'} ####`);

  // TODO: change to receive array of maps
  if (fs.statSync(response).isDirectory()) {
    // on directory
    getAllFiles(response, arrayOfFiles);
  } else {
    // on single map
    arrayOfFiles.push(response);
  }

  if (!fs.existsSync(commonAIPath)) {
    process.send(`ERROR: Cannot find ${process.cwd()}\\${commonAIPath}`)
    return
  }
  if (!fs.existsSync(`MPQEditor.exe`)) {
    process.send(`ERROR: Cannot find ${process.cwd()}\\MPQEditor.exe`)
    return
  }
  if (installCommander && !fs.existsSync(blizzardPath)) {
    process.send(`ERROR: Cannot find ${process.cwd()}\\${blizzardPath}`)
    return
  }
  if (vsAICommander && !fs.existsSync(`Scripts\\${ver}\\vsai\\Blizzard.j`)) {
    process.send(`ERROR: Cannot find ${process.cwd()}\\Scripts\\${ver}\\vsai\\Blizzard.j`)
    return
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
    for (const file of arrayOfFiles) {
      /** uncomment to debbug */
      // process.send(`path.extname(file): ${path.extname(file)}`);

      const ext = path.extname(file).toLowerCase();

      if(ext.indexOf(`w3m`) >= 0 || ext.indexOf(`w3x`) >= 0) {
        process.send(`#### Installing ${ver} into file: ${file} ####`);
      } else {
        process.send(`skip file: ${file}`);
        continue;
      }

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
            `Scripts\\${ver}\\*.ai`,
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
                  `Scripts\\${ver}\\vsai\\*.ai`,
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
              `Scripts\\${ver}\\${bj}`,
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

installOnDirectory();
