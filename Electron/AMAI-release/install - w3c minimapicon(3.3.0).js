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
  const ver = args[2];
  const icon = (args[2] == "REFORGED")
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
  if (installCommander && !fs.existsSync(`Scripts\\Blizzard_${ver}.j`)) {
    process.send(`ERROR: Cannot find ${process.cwd()}\\Scripts\\blizzard_${ver}.j`)
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
        // execute same way how InstallTFTtoDir.pl

        const mpqEditor = spawnSync(
          `MPQEditor.exe`,
          [`htsize`, file, `64`],
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
            `Scripts\\${ver}\\*.ai`,
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
              `Scripts\\Blizzard_${ver}.j`,
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

              if (icon) {
                const f3AddToMPQ =  spawnSync(
                  `MPQEditor.exe`,
                  [
                    'a',
                    file,
                    `Icons\\Reforged\\MiniMap\\`,
                    `UI\\MiniMap`,
                  ],
                );
                f3AddToMPQ.error ?
                  process.send(f3AddToMPQ.error.message)
                    : process.send(`Add minimap icon ${file}`);
              }

              if (icon) {
                const f4AddToMPQ =  spawnSync(
                  `MPQEditor.exe`,
                  [
                  'a',
                  file,
                  `Icons\\Reforged\\CommandButtons\\*.dds`,
                  `ReplaceableTextures\\CommandButtons`,
                   ],
                );
                f4AddToMPQ.error ?
                process.send(f4AddToMPQ.error.message)
                  : process.send(`Add Reforged item icon ${file}`);
              }else {
                const f4AddToMPQ =  spawnSync(
                    `MPQEditor.exe`,
                    [
                    'a',
                    file,
                    `Icons\\Class\\CommandButtons\\*.blp`,
                    `ReplaceableTextures\\CommandButtons`,
                    ],
                );
                f4AddToMPQ.error ?
                process.send(f4AddToMPQ.error.message)
                  : process.send(`Add Class item icon ${file}`);
              }

              if (icon) {
                const f5AddToMPQ =  spawnSync(
                  `MPQEditor.exe`,
                  [
                    'a',
                    file,
                    `Icons\\Reforged\\CommandButtonsDisabled\\*.dds`,
                    `ReplaceableTextures\\CommandButtonsDisabled`,
                  ],
                );
                f5AddToMPQ.error ?
                process.send(f5AddToMPQ.error.message)
                  : process.send(`Add Reforged item disabled icon ${file}`);
              }else {
                const f5AddToMPQ =  spawnSync(
                  `MPQEditor.exe`,
                  [
                    'a',
                    file,
                    `Icons\\Class\\CommandButtonsDisabled\\*.blp`,
                    `ReplaceableTextures\\CommandButtonsDisabled`,
                  ],
                );
                f5AddToMPQ.error ?
                process.send(f5AddToMPQ.error.message)
                  : process.send(`Add Class item disabled icon ${file}`);
              }

              if (icon) {
                const f6AddToMPQ =  spawnSync(
                  `MPQEditor.exe`,
                  [
                    'a',
                    file,
                    `Icons\\Reforged\\war3map.imp`,
                    `war3map.imp`,
                  ],
                  { encoding : `utf8` }
                );
                f6AddToMPQ.error ?
                  process.send(f6AddToMPQ.error.message)
                    : process.send(`Add Reforged icon list file ${file}`);
              }else {
                const f6AddToMPQ =  spawnSync(
                  `MPQEditor.exe`,
                  [
                    'a',
                    file,
                    `Icons\\Class\\war3map.imp`,
                    `war3map.imp`,
                  ],
                  { encoding : `utf8` }
                );
                f6AddToMPQ.error ?
                  process.send(f6AddToMPQ.error.message)
                    : process.send(`Add Class icon list file ${file}`);
              }

              if (icon) {
                const f7AddToMPQ =  spawnSync(
                  `MPQEditor.exe`,
                  [
                    'a',
                    file,
                    `Icons\\Reforged\\war3map.w3t`,
                    `war3map.w3t`,
                  ],
                  { encoding : `utf8` }
                );
                f7AddToMPQ.error ?
                  process.send(f7AddToMPQ.error.message)
                    : process.send(`Add Reforged item index file ${file}`);
              }else {
                const f7AddToMPQ =  spawnSync(
                  `MPQEditor.exe`,
                  [
                    'a',
                    file,
                    `Icons\\Class\\war3map.w3t`,
                    `war3map.w3t`,
                  ],
                  { encoding : `utf8` }
                );
                f7AddToMPQ.error ?
                  process.send(f7AddToMPQ.error.message)
                    : process.send(`Add Class item index file ${file}`);
               }

        }

        const f8AddToMPQ =  spawnSync(
          `MPQEditor.exe`,
          [
            'f',
            file
          ],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('f8AddToMPQ', f8AddToMPQ.error);

        // spawnSync(`echo`, [`running AddToMPQ 3 ${file}`]);
        f8AddToMPQ.error ?
          process.send(f8AddToMPQ.error.message)
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