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
        process.send(`installing into file: ${file}`);
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
            : process.send(`running MPQEditor ${file}`);

        const f1AddToMPQ =  spawnSync(
          `AddToMPQ.exe`,
          [
            file,
            `Scripts\\TFT\\common.ai`,
            `Scripts\\common.ai`,
            `Scripts\\Blizzard.j`,
            `Scripts\\Blizzard.j`,
          ],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('f1AddToMPQ', f1AddToMPQ.error);

        // spawnSync(`echo`, [`running AddToMPQ 1 ${file}`]);
        // process.send(`running AddToMPQ 1 ${file}`);

        f1AddToMPQ.error ?
          process.send(f1AddToMPQ.error.message)
            : process.send(`running AddToMPQ 1 ${file}`);

        const f2AddToMPQ =  spawnSync(
          `AddToMPQ.exe`,
          [
            file,
            `Scripts\\TFT\\elf.ai`,
            `Scripts\\elf.ai`,
            `Scripts\\TFT\\human.ai`,
            `Scripts\\human.ai`,
            `Scripts\\TFT\\orc.ai`,
            `Scripts\\orc.ai`,
            `Scripts\\TFT\\undead.ai`,
            `Scripts\\undead.ai`,
          ],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('f2AddToMPQ', f2AddToMPQ.error);

        // spawnSync(`echo`, [`running AddToMPQ 2 ${file}`]);
        f2AddToMPQ.error ?
          process.send(f2AddToMPQ.error.message)
            : process.send(`running AddToMPQ 2 ${file}`);

        const f3AddToMPQ =  spawnSync(
          `AddToMPQ.exe`,
          [
            file,
            `Scripts\\TFT\\elf2.ai`,
            `Scripts\\elf2.ai`,
            `Scripts\\TFT\\human2.ai`,
            `Scripts\\human2.ai`,
            `Scripts\\TFT\\orc2.ai`,
            `Scripts\\orc2.ai`,
            `Scripts\\TFT\\undead2.ai`,
            `Scripts\\undead2.ai`,
          ],
          { encoding : `utf8` }
        );

        /** uncomment to debbug */
       // console.log('f3AddToMPQ', f3AddToMPQ.error);

        // spawnSync(`echo`, [`running AddToMPQ 3 ${file}`]);
        f3AddToMPQ.error ?
          process.send(f3AddToMPQ.error.message)
            : process.send(`running AddToMPQ 3 ${file}`);
      } catch(error) {
        console.log(error);
        process.send(`process install finish with error: ${error}`);
      }
    }
  }

  // spawnSync(`echo`, [`finish install processing into folder ${dirPath}`]);
}

installOnDirectory();
