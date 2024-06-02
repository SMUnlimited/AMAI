import { ChangeDetectorRef, Component } from '@angular/core';
import { ElectronService, MenuService } from './core/services';
import { TranslateService } from '@ngx-translate/core';
import { APP_CONFIG } from '../environments/environment';
import { InstallModel } from '../../commons/models';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  public title = '';
  public active = false;
  public couldClose = false;
  public messages = [];

  constructor(
    private electronService: ElectronService,
    private translate: TranslateService,
    private menuService: MenuService,
    private cdr: ChangeDetectorRef,
  ) {
    this.translate.setDefaultLang('en');
    console.log('APP_CONFIG', APP_CONFIG);

    if (electronService.isElectron) {
      this.menuService.createMenu();

      // TODO: add 'push notification'/'notification'
      this.electronService.ipcRenderer.on('on-install-init', (_, args: InstallModel) => {
        console.log('args-install-init', args)
        // TODO: use i18n to translate
        this.title = `Installing into ${args.response}`;
        this.active = true;
        this.couldClose = false;
        this.messages = [];
        // TODO: use i18n to translate
        !args.isMap && this.messages && this.messages.push(`Installing in directory: ${args.response}`);

        // disable the menu while the script is running
        this
          .menuService
          .changeEnabledMenuState(false);

        // force update in angular view after update any variable
        // because we are in a IPC async
        this.cdr.detectChanges();
      });

      // TODO: add 'push notification'/'notification'
      this.electronService.ipcRenderer.on('on-install-empty', (_, args) => {
        console.log('args-install-empty', args);
        this.active = false;
        this.couldClose = true;
        this.cdr.detectChanges();
      });

      // TODO: add 'push notification'/'notification'
      this.electronService.ipcRenderer.on('on-install-exit', (_, args) => {
        // TODO: use i18n to translate
        this.title = 'Installation finished...';
        this.couldClose = true;

        this
          .menuService
          .changeEnabledMenuState(true);

        this.cdr.detectChanges();
      });

      this.electronService.ipcRenderer.on('on-install-message', (_, args) => {
        console.log('args-install-message', args);
        this.messages && this.messages.push(args);
        this.cdr.detectChanges();
      });

      // TODO: add 'push notification'/'notification'
      this.electronService.ipcRenderer.on('on-install-error', (_, args) => {
        console.log('args-install-error', args);
        this.couldClose = true;

        this
          .menuService
          .changeEnabledMenuState(true);

        this.cdr.detectChanges();
      });

    } else {
      console.log('Run in browser');
    }
  }

  public closeCmd() {
    this.couldClose ? (this.active = false) : null;
  }
}
