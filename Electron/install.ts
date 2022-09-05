const fs = require("fs");
const path = require("path");
const spawnSync = require("child_process").spawnSync;


const arrayOfFiles = [];

const getAllFiles = (dirPath, arrayOfFiles) => {
  const files = fs.readdirSync(dirPath);

  arrayOfFiles = arrayOfFiles || [];

  files.forEach(function(file) {
    if (fs.statSync(dirPath + "/" + file).isDirectory()) {
      arrayOfFiles = getAllFiles(dirPath + "/" + file, arrayOfFiles);
    } else {
      arrayOfFiles.push(path.join(dirPath, "/", file));
    }
  })

  return arrayOfFiles;
}

// export const installOnDirectory = (dirName) => {}
export const installOnDirectory = async () => {
  const args = process.argv.slice(2);
  const dirPath = args[0];

  spawnSync('echo', [`start install processing...`]);

  getAllFiles(dirPath, arrayOfFiles);

  if(arrayOfFiles) {
    for (const file of arrayOfFiles) {
      process.send(`path.extname(file): ${path.extname(file)}`);

      const ext = path.extname(file).toLowerCase();

      if(ext.indexOf('w3m') >= 0 || ext.indexOf('w3x') >= 0) {
        process.send(`installing into file: ${file}`);
      } else {
        process.send(`skip file: ${file}`);
        continue;
      }

      try {
        // exec same way how InstallTFTtoDir.pl

        const mpqEditor = spawnSync(
          `../MPQEditor.exe`,
          ['htsize', file, '64'],
          { encoding : 'utf8' }
        );

        spawnSync('echo', [`MPQEditor ${file}`]);
        process.send(`MPQEditor ${file}`);

        const f1AddToMPQ =  spawnSync(
          `../AddToMPQ.exe`,
          [
            file,
            '..\\Scripts\\TFT\\common.ai',
            '..\\Scripts\\common.ai',
            '..\\Scripts\\Blizzard.j',
            '..\\Scripts\\Blizzard.j',
          ],
          { encoding : 'utf8' }
        );

        spawnSync('echo', [`AddToMPQ 1 ${file}`]);
        process.send(`AddToMPQ 1 ${file}`);

        const f2AddToMPQ =  spawnSync(
          `../AddToMPQ.exe`,
          [
            file,
            '..\\Scripts\\TFT\\elf.ai',
            '..\\Scripts\\elf.ai',
            '..\\Scripts\\TFT\\human2.ai',
            '..\\Scripts\\human2.ai',
            '..\\Scripts\\TFT\\orc2.ai',
            '..\\Scripts\\orc2.ai',
            '..\\Scripts\\TFT\\undead2.ai',
            '..\\Scripts\\undead2.ai',
          ],
          { encoding : 'utf8' }
        );

        spawnSync('echo', [`AddToMPQ 2 ${file}`]);
        process.send(`AddToMPQ 2 ${file}`);

        const f3AddToMPQ =  spawnSync(
          `../AddToMPQ.exe`,
          [
            file,
            '..\\Scripts\\TFT\\elf2.ai',
            '..\\Scripts\\elf2.ai',
            '..\\Scripts\\TFT\\human.ai',
            '..\\Scripts\\human.ai',
            '..\\Scripts\\TFT\\orc.ai',
            '..\\Scripts\\orc.ai',
            '..\\Scripts\\TFT\\undead.ai',
            '..\\Scripts\\undead.ai',
          ],
          { encoding : 'utf8' }
        );

        spawnSync('echo', [`AddToMPQ 3 ${file}`]);
        process.send(`AddToMPQ 3 ${file}`);
      } catch(error) {
        console.log(error);
      }
    }
  }

  spawnSync('echo', [`finish install processing...`]);
}

installOnDirectory();
