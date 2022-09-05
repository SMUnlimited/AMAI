import { Component } from '@angular/core';
import { ElectronService, MenuService } from './core/services';
import { TranslateService } from '@ngx-translate/core';
import { APP_CONFIG } from '../environments/environment';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  constructor(
    private electronService: ElectronService,
    private translate: TranslateService,
    private menu: MenuService,
  ) {
    this.translate.setDefaultLang('en');
    console.log('APP_CONFIG', APP_CONFIG);

    if (electronService.isElectron) {
      this.menu.createMenu();

      this.electronService.ipcRenderer.on('on-install-init', (event, args) => {
        console.log('args', args);
      });

      this.electronService.ipcRenderer.on('on-install-empty', (event, args) => {
        console.log('args', args);
      });

      this.electronService.ipcRenderer.on('on-install-exit', (event, args) => {
        console.log('args', args);
      });

      this.electronService.ipcRenderer.on('on-install-message', (event, args) => {
        console.log('args', args);
      });

      this.electronService.ipcRenderer.on('on-install-error', (event, args) => {
        console.log('args', args);
      });

    } else {
      console.log('Run in browser');
    }
  }
}
