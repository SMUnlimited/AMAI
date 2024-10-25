const fs = require("fs");
const path = require("path");
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
  // const installCommander = (args[1] == 'true');
  const installCommanderMode1 = (args[1] == '1');
  const installCommanderMode2 = (args[1] == '2');
  const response = args[0];
  const ver = args[2];


  if (args[1] !== '1' && args[1] !== '2' && args[1] !== '0') {
    process.send(`#### AMAI set Scripts Languages ####`);
    const searchFor = /string language = "([^"]*)"/g;
    const replaceWith = `string language = ${args[1]}`;
    process.send(`s ${searchFor}`)
    process.send(`r ${replaceWith}`)
    const filePath = ``;
    const updatedData = ``;

    if (fs.existsSync(`Scripts\\REFORGED\\common.ai`)) {
      filePath = path.join(__dirname, `Scripts\\REFORGED\\common.ai`);
      fs.readFile(filePath, 'utf8', (err, data) => {
       updatedData = data.replace(new RegExp(searchFor, 'g'), replaceWith);
        fs.writeFile(filePath, updatedData, 'utf8', (err) => {
          if (err) {
            process.send(`ERROR: Cannot Set REFORGED common.ai language`)
          }
        });
      });
    }
    if (fs.existsSync(`Scripts\\REFORGED\\Blizzard.j`)) {
      filePath = path.join(__dirname, `Scripts\\REFORGED\\Blizzard.j`);
      fs.readFile(filePath, 'utf8', (err, data) => {
        updatedData = data.replace(new RegExp(searchFor, 'g'), replaceWith);
        fs.writeFile(filePath, updatedData, 'utf8', (err) => {
          if (err) {
            process.send(`ERROR: Cannot Set REFORGED Blizzard.j language`)
          }
        });
      });
    }
    if (fs.existsSync(`Scripts\\REFORGED\\Blizzard_VSAI.j`)) {
      filePath = path.join(__dirname, `Scripts\\REFORGED\\Blizzard_VSAI.j`);
      fs.readFile(filePath, 'utf8', (err, data) => {
        updatedData = data.replace(new RegExp(searchFor, 'g'), replaceWith);
        fs.writeFile(filePath, updatedData, 'utf8', (err) => {
          if (err) {
            process.send(`ERROR: Cannot Set REFORGED Blizzard_VSAI.j language`)
          }
        });
      });
    }

    if (fs.existsSync(`Scripts\\TFT\\common.ai`)) {
      filePath = path.join(__dirname, `Scripts\\TFT\\common.ai`);
      fs.readFile(filePath, 'utf8', (err, data) => {
        updatedData = data.replace(new RegExp(searchFor, 'g'), replaceWith);
        fs.writeFile(filePath, updatedData, 'utf8', (err) => {
          if (err) {
            process.send(`ERROR: Cannot Set TFT common.ai language`)
          }
        });
      });
    }
    if (fs.existsSync(`Scripts\\TFT\\Blizzard.j`)) {
      filePath = path.join(__dirname, `Scripts\\TFT\\Blizzard.j`);
      fs.readFile(filePath, 'utf8', (err, data) => {
        updatedData = data.replace(new RegExp(searchFor, 'g'), replaceWith);
        fs.writeFile(filePath, updatedData, 'utf8', (err) => {
          if (err) {
            process.send(`ERROR: Cannot Set TFT Blizzard.j language`)
          }
        });
      });
    }
    if (fs.existsSync(`Scripts\\TFT\\Blizzard_VSAI.j`)) {
      filePath = path.join(__dirname, `Scripts\\TFT\\Blizzard_VSAI.j`);
      fs.readFile(filePath, 'utf8', (err, data) => {
        updatedData = data.replace(new RegExp(searchFor, 'g'), replaceWith);
        fs.writeFile(filePath, updatedData, 'utf8', (err) => {
          if (err) {
            process.send(`ERROR: Cannot Set TFT Blizzard_VSAI.j language`)
          }
        });
      });
    }

    if (fs.existsSync(`Scripts\\ROC\\common.ai`)) {
      filePath = path.join(__dirname, `Scripts\\ROC\\common.ai`);
      fs.readFile(filePath, 'utf8', (err, data) => {
        updatedData = data.replace(new RegExp(searchFor, 'g'), replaceWith);
        fs.writeFile(filePath, updatedData, 'utf8', (err) => {
          if (err) {
            process.send(`ERROR: Cannot Set ROC common.ai language`)
          }
        });
      });
    }
    if (fs.existsSync(`Scripts\\ROC\\Blizzard.j`)) {
      filePath = path.join(__dirname, `Scripts\\ROC\\Blizzard.j`);
      fs.readFile(filePath, 'utf8', (err, data) => {
        updatedData = data.replace(new RegExp(searchFor, 'g'), replaceWith);
        fs.writeFile(filePath, updatedData, 'utf8', (err) => {
          if (err) {
            process.send(`ERROR: Cannot Set ROC Blizzard.j language`)
          }
        });
      });
    }
    if (fs.existsSync(`Scripts\\ROC\\Blizzard_VSAI.j`)) {
      filePath = path.join(__dirname, `Scripts\\ROC\\Blizzard_VSAI.j`);
      fs.readFile(filePath, 'utf8', (err, data) => {
        updatedData = data.replace(new RegExp(searchFor, 'g'), replaceWith);
        fs.writeFile(filePath, updatedData, 'utf8', (err) => {
          if (err) {
            process.send(`ERROR: Cannot Set ROC Blizzard_VSAI.j language`)
          }
        });
      });
    }

    return
  }

  process.send(`#### Installing AMAI for ${ver} ####`);

  // TODO: change to receive array of maps
  if (fs.statSync(response).isDirectory()) {
    // on directory
    getAllFiles(response, arrayOfFiles);
  } else {
    // on single map
    arrayOfFiles.push(response);
  }

  if (!fs.existsSync(`Scripts\\${ver}\\common.ai`)) {
    process.send(`ERROR: Cannot find ${process.cwd()}\\Scripts\\${ver}\\common.ai`)
    return
  }
  if (!fs.existsSync(`MPQEditor.exe`)) {
    process.send(`ERROR: Cannot find ${process.cwd()}\\MPQEditor.exe`)
    return
  }
  // if (installCommander && !fs.existsSync(`Scripts\\Blizzard_${ver}.j`)) {
  //   process.send(`错误: 找不到 ${process.cwd()}\\Scripts\\blizzard_${ver}.j, 请重新编译后将文件放入以下目录: ${process.cwd()}\\Scripts\\${ver}\\`)
  //   return
  // }
  if (installCommanderMode1 && !fs.existsSync(`Scripts\\${ver}\\Blizzard.j`)) {
    process.send(`ERROR: Cannot find ${process.cwd()}\\Scripts\\${ver}\\Blizzard.j`)
    return
  }

  if (installCommanderMode2 && !fs.existsSync(`Scripts\\${ver}\\Blizzard_VSAI.j`)) {
    process.send(`ERROR: Cannot find ${process.cwd()}\\Scripts\\${ver}\\Blizzard_VSAI.j`)
    return
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

        const f1AddToMPQ = spawnSync(
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

        if (installCommanderMode1 || installCommanderMode2) {

          if (installCommanderMode1 ) {
            const f2AddToMPQ = spawnSync(
              `MPQEditor.exe`,
              [
                'a',
                file,
                `Scripts\\${ver}\\Blizzard.j`,
                `Scripts\\Blizzard.j`
              ],
              { encoding : `utf8` }
            );

            /** uncomment to debbug */
            // console.log('f2AddToMPQ', f2AddToMPQ.error);

            // spawnSync(`echo`, [`running AddToMPQ 2 ${file}`]);
            if (f2AddToMPQ.status == 5) {
              process.send(`WARN: ${file} Failed to add Blizzard.j script, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location`)
              continue;
            } else if (f2AddToMPQ.status > 0) {
              process.send(`WARN: ${file} Possibly failed to add Blizzard.j script, Unknown error occurred: ${f2AddToMPQ.status}`)
              continue;
            }
            f2AddToMPQ.error ?
              process.send(f2AddToMPQ.error.message)
                : process.send(`Add commander script ${file}`);
          } else if (installCommanderMode2) {
            const f2AddToMPQ = spawnSync(
              `MPQEditor.exe`,
              [
                'a',
                file,
                `Scripts\\${ver}\\Blizzard_VSAI.j`,
                `Scripts\\Blizzard.j`
              ],
              { encoding : `utf8` }
            );
            if (f2AddToMPQ.status == 5) {
              process.send(`WARN: ${file} Failed to add Blizzard_VSAI.j script, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location`)
              continue;
            } else if (f2AddToMPQ.status > 0) {
              process.send(`WARN: ${file} Possibly failed to add Blizzard_VSAI.j script, Unknown error occurred: ${f2AddToMPQ.status}`)
              continue;
            }
            f2AddToMPQ.error ?
              process.send(f2AddToMPQ.error.message)
                : process.send(`Add commander VSAI script ${file}`);

            const f2xAddToMPQ = spawnSync(
              `MPQEditor.exe`,
              [
                'a',
                file,
                `Scripts\\Other_AI_${ver}\\*.ai`,
                `Scripts`
              ],
              { encoding : `utf8` }
            );
            if (f2xAddToMPQ.status == 5) {
              process.send(`WARN: ${file} Failed to add Other AI scripts, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location`)
              continue;
            } else if (f2xAddToMPQ.status > 0) {
              process.send(`WARN: ${file} Possibly failed to add Other AI scripts, Unknown error occurred: ${f2xAddToMPQ.status}`)
              continue;
            }
            f2xAddToMPQ.error ?
              process.send(f2xAddToMPQ.error.message)
                : process.send(`Add Other AI scripts ${file}`);
          }
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

  // spawnSync(`echo`, [`finish install processing into folder ${dirPath}`]);
}

installOnDirectory();
