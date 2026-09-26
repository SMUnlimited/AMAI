import { AfterViewChecked, ChangeDetectorRef, Component, ElementRef, ViewChild, ChangeDetectionStrategy } from '@angular/core';
import { TranslateService, _ as t_ } from '@codeandweb/ngx-translate';
import type { LangChangeEvent } from '@codeandweb/ngx-translate';
import { ElectronService } from './core/services';
import { APP_CONFIG } from '../environments/environment';
import { InstallModel } from '../../commons/models';
import packageJson from '../../package.json';

type InstallStatus = 'running' | 'success' | 'error';

interface LanguageOption {
  code: string;
  label: string;
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  changeDetection: ChangeDetectionStrategy.Eager,
  standalone: false
})
export class AppComponent implements AfterViewChecked {
  readonly installerVersion = packageJson.version;
  readonly languages: readonly LanguageOption[] = [
    { code: 'en', label: 'PAGES.MENU.ENGLISH' },
    { code: 'zh', label: 'PAGES.MENU.CHINESE' },
    { code: 'fr', label: 'PAGES.MENU.FRENCH' },
    { code: 'de', label: 'PAGES.MENU.GERMAN' },
    { code: 'no', label: 'PAGES.MENU.NORWEGIAN' },
    { code: 'pt', label: 'PAGES.MENU.PORTUGUESE' },
    { code: 'ro', label: 'PAGES.MENU.ROMANIAN' },
    { code: 'ru', label: 'PAGES.MENU.RUSSIAN' },
    { code: 'es', label: 'PAGES.MENU.SPANISH' },
    { code: 'sv', label: 'PAGES.MENU.SWEDISH' }
  ];

  title = '';
  destination = '';
  active = false;
  couldClose = false;
  messages: string[] = [];
  status: InstallStatus = 'running';
  progressCurrent = 0;
  progressTotal = 0;
  currentLanguage = 'en';

  @ViewChild('logareawrapper') private logContainer?: ElementRef<HTMLElement>;
  @ViewChild('dialogPanel') private dialogPanel?: ElementRef<HTMLElement>;

  private installingTitle = '';
  private focusDialog = false;
  private previousFocus: HTMLElement | null = null;

  constructor(
    private readonly electronService: ElectronService,
    private readonly translate: TranslateService,
    private readonly cdr: ChangeDetectorRef
  ) {
    const browserLanguage = this.translate.getBrowserLang();
    this.currentLanguage = this.languages.some(language => language.code === browserLanguage) ? browserLanguage : 'en';
    this.translate.onDefaultLangChange.subscribe(event => this.syncLanguage(event));
    this.translate.onLangChange.subscribe(event => this.syncLanguage(event));
    this.translate.use(this.currentLanguage);
    console.log('APP_CONFIG', APP_CONFIG);

    if (electronService.isElectron) this.registerInstallerEvents();
  }

  get progressPercent(): number {
    if (!this.progressTotal) return 0;
    return Math.min(100, Math.round((this.progressCurrent / this.progressTotal) * 100));
  }

  ngAfterViewChecked(): void {
    if (this.logContainer) {
      const element = this.logContainer.nativeElement;
      element.scrollTop = element.scrollHeight;
    }

    if (this.focusDialog && this.dialogPanel) {
      this.focusDialog = false;
      this.dialogPanel.nativeElement.focus();
    }
  }

  changeLanguage(event: Event): void {
    this.translate.use((event.target as HTMLSelectElement).value);
  }

  openAbout(): void {
    this.electronService.openExternal('https://github.com/SMUnlimited/AMAI');
  }

  closeInstall(): void {
    if (!this.couldClose) return;
    this.active = false;
    this.cdr.detectChanges();
    this.previousFocus?.focus();
    this.previousFocus = null;
  }

  private syncLanguage(event: LangChangeEvent): void {
    this.currentLanguage = event.lang;
    this.translate.get([
      t_('PAGES.HOME.TITLE'),
      t_('PAGES.ELECTRON.OPEN_MAP'),
      t_('PAGES.ELECTRON.OPEN_DIR'),
      t_('PAGES.ELECTRON.MAPFILE')
    ]).subscribe((translations: { [key: string]: string }) => {
      if (this.electronService.isElectron) {
        this.electronService.ipcRenderer.send('Trans', event.lang, translations);
      }
    });
  }

  private registerInstallerEvents(): void {
    this.electronService.ipcRenderer.on('on-install-progress', (_, progress: { current: number; total: number }) => {
      this.progressCurrent = progress.current;
      this.progressTotal = progress.total;
      this.title = `(${progress.current}/${progress.total}) ${this.installingTitle}`;
      this.cdr.detectChanges();
    });

    this.electronService.ipcRenderer.on('on-install-init', (_, args: InstallModel) => {
      this.previousFocus = document.activeElement as HTMLElement;
      this.destination = args.response;
      this.active = true;
      this.couldClose = false;
      this.status = 'running';
      this.messages = [];
      this.progressCurrent = 0;
      this.progressTotal = 0;
      this.focusDialog = true;

      this.translate.get(t_('PAGES.APP.INSTALLING'), { path: args.response }).subscribe((result: string) => {
        this.installingTitle = result;
        this.title = result;
      });
      this.translate.get(t_('PAGES.APP.INSTALLING_DIR'), { path: args.response }).subscribe((result: string) => {
        if (!args.isMap) this.messages.push(result);
      });
      this.cdr.detectChanges();
    });

    this.electronService.ipcRenderer.on('on-install-empty', () => {
      this.active = false;
      this.couldClose = true;
      this.cdr.detectChanges();
    });

    this.electronService.ipcRenderer.on('on-install-exit', () => {
      this.translate.get(t_('PAGES.APP.INSTALL_DONE')).subscribe((result: string) => this.title = result);
      this.status = 'success';
      this.couldClose = true;
      this.cdr.detectChanges();
    });

    this.electronService.ipcRenderer.on('on-install-message', (_, message: unknown) => {
      this.messages.push(String(message));
      this.cdr.detectChanges();
    });

    this.electronService.ipcRenderer.on('on-install-error', (_, error: unknown) => {
      this.translate.get(t_('PAGES.APP.INSTALL_FAILED')).subscribe((result: string) => this.title = result);
      this.messages.push(`ERROR: ${String(error)}`);
      this.status = 'error';
      this.couldClose = true;
      this.cdr.detectChanges();
    });
  }
}
