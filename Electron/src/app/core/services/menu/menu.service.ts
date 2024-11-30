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
      {
        label: 'Install',
        submenu: [
          {
            label: 'Install Opt Reforged on Folder with Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'REFORGED', true, 1, true, true);
            }
          },
          {
            label: 'Install Opt Reforged on Folder with VS AI Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'REFORGED', true, 2, true, true);
            }
          },
          {
            label: 'Install Opt Reforged on Folder (No Commander)',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'REFORGED', true, 0, true, true);
            }
          },
          {
            label: 'Install Opt Reforged on Map with Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install','REFORGED', false, 1, true, true);
            }
          },
          {
            label: 'Install Opt Reforged on Map with VS AI Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install','REFORGED', false, 2, true, true);
            }
          },
          {
            label: 'Install Opt Reforged on Map (No Commander)',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'REFORGED', false, 0, true, true);
            }
          },
          {
            label: 'Install Opt TFT on Folder with Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'TFT', true, 1, true, true);
            }
          },
          {
            label: 'Install Opt TFT on Folder with VS AI Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'TFT', true, 2, true, true);
            }
          },
          {
            label: 'Install Opt TFT on Folder (No Commander)',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'TFT', true, 0, true, true);
            }
          },
          {
            label: 'Install Opt TFT on Map with Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install','TFT', false, 1, true, true);
            }
          },
          {
            label: 'Install Opt TFT on Map with VS AI Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install','TFT', false, 2, true, true);
            }
          },
          {
            label: 'Install Opt TFT on Map (No Commander)',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'TFT', false, 0, true, true);
            }
          },
          {
            label: 'Install Opt ROC on Folder with Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'ROC', true, 1, true, true);
            }
          },
          {
            label: 'Install Opt ROC on Folder with VS AI Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'ROC', true, 2, true, true);
            }
          },
          {
            label: 'Install Opt ROC on Folder (No Commander)',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'ROC', true, 0, true, true);
            }
          },
          {
            label: 'Install Opt ROC on Map with Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install','ROC', false, 1, true, true);
            }
          },
          {
            label: 'Install Opt ROC on Map with VS AI Commander',
            click: () => {
              this.electronService.ipcRenderer.send('install','ROC', false, 2, true, true);
            }
          },
          {
            label: 'Install Opt ROC on Map (No Commander)',
            click: () => {
              this.electronService.ipcRenderer.send('install', 'ROC', false, 0, true, true);
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
      ];

      this.translate.get([_('PAGES.MENU.SELECT_LANG'), _('PAGES.MENU.ENGLISH'), _('PAGES.MENU.CHINESE'), _('PAGES.MENU.FRENCH')
        , _('PAGES.MENU.GERMAN'), _('PAGES.MENU.NORWEGIAN'), _('PAGES.MENU.PORTUGUESE'), _('PAGES.MENU.ROMANIAN')
        , _('PAGES.MENU.RUSSIAN'), _('PAGES.MENU.SPANISH'), _('PAGES.MENU.SWEDISH'), _('PAGES.MENU.ABOUT')
      ]).subscribe((translations: { [key: string]: string }) => {
        template.push(
          {
            label: translations['PAGES.MENU.SELECT_LANG'],
            submenu: [
              {
                label: translations['PAGES.MENU.ENGLISH'],
                type: 'radio',
                checked: this.translate.currentLang == 'en' ,
                click: () => {
                  this.translate.use('en')
                }
              },
              {
                label: translations['PAGES.MENU.CHINESE'],
                type: 'radio',
                checked: this.translate.currentLang == 'zh',
                click: () => {
                  this.translate.use('zh')
                }
              },
              {
                label: translations['PAGES.MENU.FRENCH'],
                type: 'radio',
                checked: this.translate.currentLang == 'fr',
                click: () => {
                  this.translate.use('fr')
                }
              },
              {
                label: translations['PAGES.MENU.GERMAN'],
                type: 'radio',
                checked: this.translate.currentLang == 'de',
                click: () => {
                  this.translate.use('de')
                }
              },
              {
                label: translations['PAGES.MENU.NORWEGIAN'],
                type: 'radio',
                checked: this.translate.currentLang == 'no',
                click: () => {
                  this.translate.use('no')
                }
              },
              {
                label: translations['PAGES.MENU.PORTUGUESE'],
                type: 'radio',
                checked: this.translate.currentLang == 'pt',
                click: () => {
                  this.translate.use('pt')
                }
              },
              {
                label: translations['PAGES.MENU.ROMANIAN'],
                type: 'radio',
                checked: this.translate.currentLang == 'ro',
                click: () => {
                  this.translate.use('ro')
                }
              },
              {
                label: translations['PAGES.MENU.RUSSIAN'],
                type: 'radio',
                checked: this.translate.currentLang == 'ru',
                click: () => {
                  this.translate.use('ru')
                }
              },
              {
                label: translations['PAGES.MENU.SPANISH'],
                type: 'radio',
                checked: this.translate.currentLang == 'es',
                click: () => {
                  this.translate.use('es')
                }
              },
              {
                label: translations['PAGES.MENU.SWEDISH'],
                type: 'radio',
                checked: this.translate.currentLang == 'sv',
                click: () => {
                  this.translate.use('sv')
                }
              }
            ]
          },
        );
      });

      template.push({
        label: 'View',
        submenu: [
          //{ role: 'reload' },
          //{ role: 'forceReload' },
          { role: 'toggleDevTools' },
          { type: 'separator' },
          { role: 'resetZoom' },
          { role: 'zoomIn' },
          { role: 'zoomOut' },
          { type: 'separator' },
          { role: 'togglefullscreen' }
        ]
      });

      this.translate.get([_('PAGES.MENU.ABOUT')]).subscribe((translations: { [key: string]: string }) => {
        template.push({
          label: translations['PAGES.MENU.ABOUT'],
          click: () => {
            const { shell } = window.require('electron');
            shell.openExternal('https://github.com/SMUnlimited/AMAI');
          }
        });
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
      this.translate.onDefaultLangChange.subscribe((event: LangChangeEvent) => {
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
