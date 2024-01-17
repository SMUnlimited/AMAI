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
  process.send(`#### 正在安装 AMAI ${ver} ####`);

  // TODO: change to receive array of maps
  if (fs.statSync(response).isDirectory()) {
    // on directory
    getAllFiles(response, arrayOfFiles);
  } else {
    // on single map
    arrayOfFiles.push(response);
  }

  if (!fs.existsSync(`Scripts\\${ver}\\common.ai`)) {
    process.send(`错误: 找不到 ${process.cwd()}\\Scripts\\${ver}\\common.ai, 请重新编译后将文件放入以下目录: ${process.cwd()}\\Scripts\\${ver}\\`)
    return
  }
  if (!fs.existsSync(`MPQEditor.exe`)) {
    process.send(`错误: 找不到 ${process.cwd()}\\MPQEditor.exe, 请百度下载 MPQEditor.exe 并放入以下目录: ${process.cwd()}`)
    return
  }
  if (installCommander && !fs.existsSync(`Scripts\\Blizzard_${ver}.j`)) {
    process.send(`错误: 找不到 ${process.cwd()}\\Scripts\\blizzard_${ver}.j, 请重新编译后将文件放入以下目录: ${process.cwd()}\\Scripts\\${ver}\\`)
    return
  }

  if(arrayOfFiles) {
    for (const file of arrayOfFiles) {
      /** uncomment to debbug */
      // process.send(`path.extname(file): ${path.extname(file)}`);

      const ext = path.extname(file).toLowerCase();

      if(ext.indexOf(`w3m`) >= 0 || ext.indexOf(`w3x`) >= 0) {
        process.send(`#### 安装 ${ver} 到: ${file} ####`);
      } else {
        process.send(`跳过: ${file}`);
        continue;
      }

      try {
        fs.accessSync(file, fs.constants.W_OK)
      } catch (e) {
        process.send(`警告: ${file} 没有写入权限，安装失败，请尝试以管理员身份运行`);
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
          process.send(`警告: ${file} 设置最大写入文件数失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
          continue;
        }
        mpqEditor.error ?
          process.send(mpqEditor.error.message)
            : process.send(`设置最大写入文件数到 ${file}`);

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
          process.send(`警告: ${file} 写入AI脚本失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
          continue;
        }
        f1AddToMPQ.error ?
          process.send(f1AddToMPQ.error.message)
            : process.send(`写入 AI 脚本到 ${file}`);

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
          if (f2AddToMPQ.status == 5) {
            process.send(`警告: ${file} 写入控制台失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
            continue;
          }
          f2AddToMPQ.error ?
            process.send(f2AddToMPQ.error.message)
              : process.send(`写入控制台到 ${file}`);

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
            if (f3AddToMPQ.status == 5) {
              process.send(`警告: ${file} 写入迷你小地图图标失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
              continue;
            }
            f3AddToMPQ.error ?
              process.send(f3AddToMPQ.error.message)
                : process.send(`写入迷你小地图图标到 ${file}`);
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
            if (f4AddToMPQ.status == 5) {
              process.send(`警告: ${file} 写入重置版物品图标失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
              continue;
            }
            f4AddToMPQ.error ?
            process.send(f4AddToMPQ.error.message)
              : process.send(`写入重置版物品图标到 ${file}`);
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
            if (f4AddToMPQ.status == 5) {
              process.send(`警告: ${file} 写入经典版物品图标失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
              continue;
            }
            f4AddToMPQ.error ?
            process.send(f4AddToMPQ.error.message)
              : process.send(`写入经典版物品图标到 ${file}`);
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
            if (f5AddToMPQ.status == 5) {
              process.send(`警告: ${file} 写入重置版物品阴影图标失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
              continue;
            }
            f5AddToMPQ.error ?
            process.send(f5AddToMPQ.error.message)
              : process.send(`写入重置版物品阴影图标到 ${file}`);
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
            if (f5AddToMPQ.status == 5) {
              process.send(`警告: ${file} 写入经典版阴影物品图标失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
              continue;
            }
            f5AddToMPQ.error ?
            process.send(f5AddToMPQ.error.message)
              : process.send(`写入经典版物品阴影图标到 ${file}`);
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
            if (f6AddToMPQ.status == 5) {
              process.send(`警告: ${file} 写入重置版导入列表失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
              continue;
            }
            f6AddToMPQ.error ?
              process.send(f6AddToMPQ.error.message)
                : process.send(`写入重置版导入列表到 ${file}`);
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
            if (f6AddToMPQ.status == 5) {
              process.send(`警告: ${file} 写入经典版导入列表失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
              continue;
            }
            f6AddToMPQ.error ?
              process.send(f6AddToMPQ.error.message)
                : process.send(`写入经典版导入列表到 ${file}`);
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
            if (f7AddToMPQ.status == 5) {
              process.send(`警告: ${file} 写入重置版物品图标索引失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
              continue;
            }
            f7AddToMPQ.error ?
              process.send(f7AddToMPQ.error.message)
                : process.send(`写入重置版物品图标索引到 ${file}`);
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
            if (f7AddToMPQ.status == 5) {
              process.send(`警告: ${file} 写入经典版物品图标索引失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
              continue;
            }
            f7AddToMPQ.error ?
              process.send(f7AddToMPQ.error.message)
                : process.send(`写入经典版物品图标索引到 ${file}`);
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
        if (f8AddToMPQ.status == 5) {
          process.send(`警告: ${file} MPQ 压缩失败, 您可能不具备权限，或被 UAC 阻止。请确保地图文件不在受 UAC 保护的目录`)
          continue;
        }
        f8AddToMPQ.error ?
          process.send(f8AddToMPQ.error.message)
            : process.send(`压缩 ${file} MPQ`);
      } catch(error) {
        console.log(error);
        process.send(`安装失败: ${error}`);
      }
    }
  }

  // spawnSync(`echo`, [`finish install processing into folder ${dirPath}`]);
}

installOnDirectory();