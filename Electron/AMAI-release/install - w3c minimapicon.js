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
  const installCommander = (args[1] == 'true');
  const response = args[0];

  // TODO: change to receive array of maps
  if (fs.statSync(response).isDirectory()) {
    // on directory
    getAllFiles(response, arrayOfFiles);
  } else {
    // on single map
    arrayOfFiles.push(response);
  }

  if(arrayOfFiles) {
    for (const file of arrayOfFiles) {
      /** uncomment to debbug */
      // process.send(`path.extname(file): ${path.extname(file)}`);

      const ext = path.extname(file).toLowerCase();

      if(ext.indexOf(`w3m`) >= 0 || ext.indexOf(`w3x`) >= 0) {
        process.send(`#### Installing into file: ${file} ####`);
      } else {
        process.send(`skip file: ${file}`);
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
        mpqEditor.error ?
          process.send(mpqEditor.error.message)
            : process.send(`Resize map hashtable size ${file}`);

        const f1AddToMPQ =  spawnSync(
          `MPQEditor.exe`,
          [
            'a',
            file,
            `Scripts\\TFT\\*.ai`,
            `Scripts`
          ],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('f1AddToMPQ', f1AddToMPQ.error);

        // spawnSync(`echo`, [`running AddToMPQ 1 ${file}`]);
        // process.send(`running AddToMPQ 1 ${file}`);

        f1AddToMPQ.error ?
          process.send(f1AddToMPQ.error.message)
            : process.send(`Add ai scripts ${file}`);

        if (installCommander) {

          const f2AddToMPQ =  spawnSync(
            `MPQEditor.exe`,
            [
              'a',
              file,
              `Scripts\\Blizzard.j`,
              `Scripts\\Blizzard.j`,
            ],
            { encoding : `utf8` }
          );

          /** uncomment to debbug */
         // console.log('f2AddToMPQ', f2AddToMPQ.error);

          // spawnSync(`echo`, [`running AddToMPQ 2 ${file}`]);
          f2AddToMPQ.error ?
            process.send(f2AddToMPQ.error.message)
              : process.send(`Add commander script ${file}`);

          const f3AddToMPQ =  spawnSync(
            `MPQEditor.exe`,
            [
              'a',
              file,
              `Icons\\MiniMap\\`,
              `UI\\MiniMap`,
            ],
          );

          f3AddToMPQ.error ?
            process.send(f3AddToMPQ.error.message)
              : process.send(`Add minimap icon ${file}`);

          const f4AddToMPQ =  spawnSync(
            `MPQEditor.exe`,
            [
              'a',
              file,
              `Icons\\teenCommandButtons\\*.dds`,
              `_teen.w3mod\\ReplaceableTextures\\CommandButtons`,
            ],
          );

          f4AddToMPQ.error ?
            process.send(f4AddToMPQ.error.message)
              : process.send(`Add classics item icon ${file}`);

          const f5AddToMPQ =  spawnSync(
            `MPQEditor.exe`,
            [
              'a',
              file,
              `Icons\\teenCommandButtonsDisabled\\*.dds`,
              `_teen.w3mod\\ReplaceableTextures\\CommandButtonsDisabled`,
            ],
          );

          f5AddToMPQ.error ?
            process.send(f5AddToMPQ.error.message)
              : process.send(`Add classics item disabled icon ${file}`);

          const f6AddToMPQ =  spawnSync(
            `MPQEditor.exe`,
            [
              'a',
              file,
              `Icons\\CommandButtons\\*.dds`,
              `ReplaceableTextures\\CommandButtons`,
            ],
          );

          f6AddToMPQ.error ?
            process.send(f6AddToMPQ.error.message)
              : process.send(`Add item icon ${file}`);

          const f7AddToMPQ =  spawnSync(
            `MPQEditor.exe`,
            [
              'a',
              file,
              `Icons\\CommandButtonsDisabled\\*.dds`,
              `ReplaceableTextures\\CommandButtonsDisabled`,
            ],
          );

          f7AddToMPQ.error ?
            process.send(f7AddToMPQ.error.message)
              : process.send(`Add item disabled icon ${file}`);

          const f8AddToMPQ =  spawnSync(
            `MPQEditor.exe`,
            [
              'a',
              file,
              `Icons\\war3mapSkin.w3t`,
              `war3mapSkin.w3t`,
            ],
            { encoding : `utf8` }
          );

          f8AddToMPQ.error ?
            process.send(f8AddToMPQ.error.message)
              : process.send(`Add item file ${file}`);

        }

        const f9AddToMPQ =  spawnSync(
          `MPQEditor.exe`,
          [
            'f',
            file
          ],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('f9AddToMPQ', f9AddToMPQ.error);

        // spawnSync(`echo`, [`running AddToMPQ 3 ${file}`]);
        f9AddToMPQ.error ?
          process.send(f9AddToMPQ.error.message)
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