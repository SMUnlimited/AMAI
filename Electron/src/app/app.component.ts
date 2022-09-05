import { ChangeDetectorRef, Component } from '@angular/core';
import { ElectronService, MenuService } from './core/services';
import { TranslateService } from '@ngx-translate/core';
import { APP_CONFIG } from '../environments/environment';
// const {ipcRenderer} = require('electron')

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  public active = false;
  public messages = [];

  constructor(
    private electronService: ElectronService,
    private translate: TranslateService,
    private menu: MenuService,
    private cdr: ChangeDetectorRef,
  ) {
    this.translate.setDefaultLang('en');
    console.log('APP_CONFIG', APP_CONFIG);

    if (electronService.isElectron) {
      this.menu.createMenu();

      this.electronService.ipcRenderer.on('on-install-init', (_, args) => {
        this.active = true;
        this.messages = [];
        this.cdr.detectChanges();
        this.messages && this.messages.push(`Installing in directory: ${args}`);
        this.cdr.detectChanges();
      });

      this.electronService.ipcRenderer.on('on-install-empty', (_, args) => {
        console.log('args', args);
        this.active = false;
        this.cdr.detectChanges();
      });

      this.electronService.ipcRenderer.on('on-install-exit', (_, args) => {
        console.log('args', args);
        console.log('exit');
        //this.active = false;
        //this.cdr.detectChanges();
      });

      this.electronService.ipcRenderer.on('on-install-message', (_, args) => {
        console.log('args', args);
        this.messages && this.messages.push(args);
        this.cdr.detectChanges();
      });

      this.electronService.ipcRenderer.on('on-install-error', (_, args) => {
        console.log('args', args);
        this.active = false;
        this.cdr.detectChanges();
      });

    } else {
      console.log('Run in browser');
    }
  }
}
