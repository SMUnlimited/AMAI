// Karma configuration file, see link for more information
// https://karma-runner.github.io/0.13/config/configuration-file.html

module.exports = function (config) {
  // Karma must launch the Electron main process even when the parent shell runs Electron as Node.
  delete process.env.ELECTRON_RUN_AS_NODE;

  config.set({
    basePath: '',
    frameworks: ['jasmine', '@angular-devkit/build-angular'],
    plugins: [
      require('karma-jasmine'),
      require('karma-electron'),
      require('karma-jasmine-html-reporter'),
      require('karma-coverage-istanbul-reporter'),
      require('@angular-devkit/build-angular/plugins/karma')
    ],
    client:{
      clearContext: false // leave Jasmine Spec Runner output visible in browser
    },
    coverageIstanbulReporter: {
      dir: require('path').join(__dirname, '../coverage'),
      reports: [ 'html', 'lcovonly' ],
      fixWebpackSourcePaths: true
    },
    reporters: ['progress', 'kjhtml'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    browsers: ['AngularElectron'],
    customLaunchers: {
      AngularElectron: {
        base: 'Electron',
        flags: [
          '--no-sandbox',
          '--remote-debugging-port=9222'
        ],
        browserWindowOptions: {
          webPreferences: {
            nodeIntegration: true,
            nodeIntegrationInSubFrames: true,
            allowRunningInsecureContent: true,
            contextIsolation: false
          }
        }
      }
    }
  });
};
