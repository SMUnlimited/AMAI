const fs = require('fs');
const dir = './release';

exports.default = async function(context) {
  try {
    if (!fs.existsSync(dir)){
      fs.mkdirSync(dir);

      console.log(`Folder ${dir} created.`);
    }

    fs.copyFileSync("../MPQEditor.exe", `${dir}/MPQEditor.exe`, fs.constants.COPYFILE_FICLONE);
    fs.copyFileSync("../AddToMPQ.exe", `${dir}/AddToMPQ.exe`, fs.constants.COPYFILE_FICLONE);
    // fs.copyFileSync("../../MPQEditor.exe", "MPQEditor.exe", fs.constants.COPYFILE_EXCL);
    // fs.copyFileSync("../../MPQEditor.exe", "MPQEditor.exe", fs.constants.COPYFILE_EXCL);
  }
  catch (err) {
    console.log(err);
  }
}
