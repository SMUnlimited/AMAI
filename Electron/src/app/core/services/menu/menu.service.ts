import { Injectable } from '@angular/core';
import { ElectronService } from '../electron/electron.service';


@Injectable({
  providedIn: 'root'
})
export class MenuService {
  public template: any = [
    {
      label: 'Files',
      submenu: [
        {
          label: 'Install on Folder',
          click: () => {
            this.electronService.ipcRenderer.send('install-folder');
          }
        },
        {
          label: 'Install on Folder (No Commander)',
          click: () => {
            this.electronService.ipcRenderer.send('install-folder-noc');
          }
        },
        {
          label: 'Install on Map',
          click: () => {
            this.electronService.ipcRenderer.send('install-map');
          }
        },
        {
          label: 'Install on Map (No Commander)',
          click: () => {
            this.electronService.ipcRenderer.send('install-map-noc');
          }
        },
        // TODO: recreate MakeTFT script
        // FIXME: convert MakeTFTBase.bat to JS script
        // FIXME: convert MakeTFT.bat to JS script
        // FIXME: convert ejass.pl to JS script
        //{
        //  label: 'Compile',
        //  click: () => {
        //    this.electronService.ipcRenderer.send('compile');
        //  }
        // },
        // TODO: recreate MakeOptTFT.bat script
        // { label: 'Compile, Optimize' },
        // TODO: recreate MakeVAITFT.bat script
        // { label: 'Compile AMAI vs Default AI' },
      ]
    },
    {
      label: 'View',
      submenu: [
        { role: 'reload' },
        { role: 'forceReload' },
        { role: 'toggleDevTools' },
        { type: 'separator' },
        { role: 'resetZoom' },
        { role: 'zoomIn' },
        { role: 'zoomOut' },
        { type: 'separator' },
        { role: 'togglefullscreen' }
      ]
    },
  ]

  constructor(
    private electronService: ElectronService
    ) { }

  public createMenu() {
    if(this.electronService.isElectron) {
      const { Menu } = this.electronService;
      const menu = Menu.buildFromTemplate(this.template);
      Menu.setApplicationMenu(menu);
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
