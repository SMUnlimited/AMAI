import { ChangeDetectorRef, Component } from '@angular/core';
import { ElectronService, MenuService } from './core/services';
import { TranslateService, TranslatePipe, TranslateDirective, _ as t_, LangChangeEvent } from "@codeandweb/ngx-translate";
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
    private readonly electronService: ElectronService,
    private readonly translate: TranslateService,
    private readonly menuService: MenuService,
    private readonly cdr: ChangeDetectorRef,
  ) {
    this.translate.setDefaultLang('en');
    const lang = this.translate.getBrowserLang();
    this.translate.use(lang)
    console.log('APP_CONFIG', APP_CONFIG);

    // Refresh app when language changes
    this.translate.onLangChange.subscribe((event: LangChangeEvent) => {
      const newLang = event.lang;
      this.electronService.ipcRenderer.send('Trans-newlang', newLang);
      this.translate.get([t_('PAGES.HOME.TITLE'),t_('PAGES.ELECTRON.OPEN_MAP'), t_('PAGES.ELECTRON.OPEN_DIR'), t_('PAGES.ELECTRON.MAPFILE')]).subscribe((translations: { [key: string]: string } ) => {
        this.electronService.ipcRenderer.send('Trans', translations);
      })
      this.cdr.detectChanges();
    });
    

    if (electronService.isElectron) {
      this.menuService.createMenu();

      // TODO: add 'push notification'/'notification'
      this.electronService.ipcRenderer.on('on-install-init', (_, args: InstallModel) => {
        console.log('args-install-init', args)
        this.translate.get(t_('PAGES.APP.INSTALLING'), {path: args.response}).subscribe((res: string) => {
          this.title = res
        });
        this.active = true;
        this.couldClose = false;
        this.messages = [];
        this.translate.get(t_('PAGES.APP.INSTALLING_DIR'), {path: args.response}).subscribe((res: string) => {
          !args.isMap && this.messages?.push(res);
        });

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
        this.translate.get(t_('PAGES.APP.INSTALL_DONE')).subscribe((res: string) => {
          this.title = res;
        });
        this.couldClose = true;

        this
          .menuService
          .changeEnabledMenuState(true);

        this.cdr.detectChanges();
      });

      this.electronService.ipcRenderer.on('on-install-message', (_, args) => {
        console.log('args-install-message', args);
        this.messages?.push(args);
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
    if (this.couldClose) { 
      this.active = false;
    }
  }
}
