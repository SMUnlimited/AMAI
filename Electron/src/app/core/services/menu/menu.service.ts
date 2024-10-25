import { Injectable } from '@angular/core';
import { ElectronService } from '../electron/electron.service';
import { TranslateService, TranslatePipe, TranslateDirective, _ , LangChangeEvent} from "@codeandweb/ngx-translate";


@Injectable({
  providedIn: 'root'
})
export class MenuService {
  constructor(
    private readonly electronService: ElectronService,
    private readonly translate: TranslateService
    ) { }

    private getTemplate(translate : TranslateService) : Array<(Electron.MenuItemConstructorOptions) | (Electron.MenuItem)> { 
      let template : Array<(Electron.MenuItemConstructorOptions) | (Electron.MenuItem)> = [
      // {
      //   label: 'Install',
      //   submenu: [
      //     {
      //       label: 'Install Reforged on Folder',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-folder-1');
      //       }
      //     },
      //     {
      //       label: 'Install Reforged on Folder (VS AI Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-folder-2');
      //       }
      //     },
      //     {
      //       label: 'Install Reforged on Folder (No Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-folder-0');
      //       }
      //     },
      //     {
      //       label: 'Install Reforged on Map',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-map-1');
      //       }
      //     },
      //     {
      //       label: 'Install Reforged on Map (VS AI Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-map-2');
      //       }
      //     },
      //     {
      //       label: 'Install Reforged on Map (No Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-map-0');
      //       }
      //     },
      //     {
      //       label: 'Install classic TFT on Folder',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-folder-1-TFT');
      //       }
      //     },
      //     {
      //       label: 'Install classic TFT on Folder (VS AI Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-folder-2-TFT');
      //       }
      //     },
      //     {
      //     {
      //       label: 'Install classic TFT on Folder (No Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-folder-0-TFT');
      //       }
      //     },
      //     {
      //       label: 'Install classic TFT on Map',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-map-1-TFT');
      //       }
      //     },
      //     {
      //       label: 'Install classic TFT on Map (VS AI Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-map-2-TFT');
      //       }
      //     },
      //     {
      //       label: 'Install classic TFT on Map (No Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-map-0-TFT');
      //       }
      //     },
      //     {
      //       label: 'Install classic ROC on Folder',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-folder-1-ROC');
      //       }
      //     },
      //     {
      //       label: 'Install classic ROC on Folder (VS AI Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-folder-2-ROC');
      //       }
      //     },
      //     {
      //       label: 'Install classic ROC on Folder (No Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-folder-0-ROC');
      //       }
      //     },
      //     {
      //       label: 'Install classic ROC on Map',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-map-1-ROC');
      //       }
      //     },
            //     {
      //       label: 'Install classic ROC on Map (VS AI Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-map-2-ROC');
      //       }
      //     },
      //     {
      //       label: 'Install classic ROC on Map (No Commander)',
      //       click: () => {
      //         this.electronService.ipcRenderer.send('install-map-0-ROC');
      //       }
      //     }
      //     // TODO: recreate MakeTFT script
      //     // FIXME: convert MakeTFTBase.bat to JS script
      //     // FIXME: convert MakeTFT.bat to JS script
      //     // FIXME: convert ejass.pl to JS script
      //     //{
      //     //  label: 'Compile',
      //     //  click: () => {
      //     //    this.electronService.ipcRenderer.send('compile');
      //     //  }
      //     // },
      //     // TODO: recreate MakeOptTFT.bat script
      //     // { label: 'Compile, Optimize' },
      //     // TODO: recreate MakeVAITFT.bat script
      //     // { label: 'Compile AMAI vs Default AI' },
      //   ]
      // },
      ];

      this.translate.get([_('PAGES.MENU.SELECT_LANG'), _('PAGES.MENU.ENGLISH'), _('PAGES.MENU.CHINESE'), _('PAGES.MENU.FRENCH')
        , _('PAGES.MENU.GERMAN'), _('PAGES.MENU.NORWEGIAN'), _('PAGES.MENU.PORTUGUESE'), _('PAGES.MENU.ROMANIAN')
        , _('PAGES.MENU.RUSSIAN'), _('PAGES.MENU.SPANISH'), _('PAGES.MENU.SWEDISH'), _('PAGES.MENU.FULLSCREEN'), _('PAGES.MENU.DEV_TOOL')
      ]).subscribe((translations: { [key: string]: string }) => {
        template.push(
          {
            label: translations['PAGES.MENU.SELECT_LANG'],
            submenu: [
              {
                label: translations['PAGES.MENU.ENGLISH'],
                type: 'radio',
                checked: this.translate.currentLang == 'en',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-English');
                  this.translate.use('en')
                }
              },
              {
                label: translations['PAGES.MENU.CHINESE'],
                type: 'radio',
                checked: this.translate.currentLang == 'zh',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-Chinese');
                  this.translate.use('zh')
                }
              },
              {
                label: translations['PAGES.MENU.FRENCH'],
                type: 'radio',
                checked: this.translate.currentLang == 'fr',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-French');
                  this.translate.use('fr')
                }
              },
              {
                label: translations['PAGES.MENU.GERMAN'],
                type: 'radio',
                checked: this.translate.currentLang == 'de',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-Deutsch');
                  this.translate.use('de')
                }
              },
              {
                label: translations['PAGES.MENU.NORWEGIAN'],
                type: 'radio',
                checked: this.translate.currentLang == 'no',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-Norwegian');
                  this.translate.use('no')
                }
              },
              {
                label: translations['PAGES.MENU.PORTUGUESE'],
                type: 'radio',
                checked: this.translate.currentLang == 'pt',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-Portuguese');
                  this.translate.use('pt')
                }
              },
              {
                label: translations['PAGES.MENU.ROMANIAN'],
                type: 'radio',
                checked: this.translate.currentLang == 'ro',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-Romanian');
                  this.translate.use('ro')
                }
              },
              {
                label: translations['PAGES.MENU.RUSSIAN'],
                type: 'radio',
                checked: this.translate.currentLang == 'ru',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-Russian');
                  this.translate.use('ru')
                }
              },
              {
                label: translations['PAGES.MENU.SPANISH'],
                type: 'radio',
                checked: this.translate.currentLang == 'es',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-Spanish');
                  this.translate.use('es')
                }
              },
              {
                label: translations['PAGES.MENU.SWEDISH'],
                type: 'radio',
                checked: this.translate.currentLang == 'sv',
                click: () => {
                  this.electronService.ipcRenderer.send('setlang-Swedish');
                  this.translate.use('sv')
                }
              },
            ]
          },
          {
            label: translations['PAGES.MENU.FULLSCREEN'],
            role: 'togglefullscreen',
          },
          {
            label: translations['PAGES.MENU.DEV_TOOL'],
            role: 'toggleDevTools'
          }
        );
      });

      console.log(template);

      return template;
    }

  public createMenu() {
    if(this.electronService.isElectron) {
      const { Menu } = this.electronService;
      const menu = Menu.buildFromTemplate(this.getTemplate(this.translate));
      Menu.setApplicationMenu(menu);
      this.translate.onLangChange.subscribe((event: LangChangeEvent) => {
        const menu = Menu.buildFromTemplate(this.getTemplate(this.translate));
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
