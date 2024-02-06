import { Injectable } from '@angular/core';
import { ElectronService } from '../electron/electron.service';
import { TranslateService } from '@ngx-translate/core';
import { forkJoin } from 'rxjs';

@Injectable({
  providedIn: 'root'
})


export class MenuService {
  public template: any = [
   {
      label: '',
      role: 'togglefullscreen',
    },
   {
      label: '',
      role: 'toggleDevTools',
    },
  ];

  constructor(
    private electronService: ElectronService,
    private translate: TranslateService,
    ) { }

  public createMenu() {
    if(this.electronService.isElectron) {
      forkJoin({
        fullscreen: this.translate.get('PAGES.MUSE.FULLSCREEN'),
        devTool: this.translate.get('PAGES.MUSE.DEV_TOOL')
      }).subscribe((res) => {
        this.template[0].label = res.fullscreen;
        this.template[1].label = res.devTool;
        // console.log('menu0', res.fullscreen);
        // console.log('menu1', res.devTool);
        const { Menu } = this.electronService;
        const menu = Menu.buildFromTemplate(this.template);
        Menu.setApplicationMenu(menu);
      });
    }
  }

  public changeEnabledMenuState(state: boolean) {
    if(this.electronService.isElectron) {
      const { Menu } = this.electronService;
      const { items } = Menu.getApplicationMenu();

      items?.forEach(item => {
        item?.submenu?.items?.forEach(sub => sub.enabled = state);
      });
    }
  }

  
}
