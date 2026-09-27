import { NgClass } from '@angular/common';
import { A11yModule } from '@angular/cdk/a11y';
import { AfterViewChecked, ChangeDetectorRef, Component, ElementRef, ViewChild, ChangeDetectionStrategy } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { TranslateService, _ as t_ } from '@codeandweb/ngx-translate';
import type { LangChangeEvent } from '@codeandweb/ngx-translate';
import { TranslatePipe } from '@codeandweb/ngx-translate';
import { ElectronService } from './core/services';
import { APP_CONFIG } from '../environments/environment';
import { InstallModel } from '../../commons/models';
import packageJson from '../../package.json';

type InstallStatus = 'running' | 'success' | 'warning' | 'error';

interface LanguageOption {
  code: string;
  label: string;
}

interface InstallLogEvent {
  type: 'log';
  level: 'info' | 'warning' | 'error';
  key: string;
  params?: Record<string, unknown>;
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [A11yModule, NgClass, RouterOutlet, TranslatePipe]
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
  successfulCount = 0;
  problemMessageIndexes = new Set<number>();
  mapStartMessageIndexes = new Set<number>();
  currentLanguage = 'en';

  @ViewChild('logareawrapper') private logContainer?: ElementRef<HTMLElement>;
  @ViewChild('dialogPanel') private dialogPanel?: ElementRef<HTMLElement>;

  private installingTitle = '';
  private focusDialog = false;
  private previousFocus: HTMLElement | null = null;
  private currentMapActive = false;
  private currentMapFailed = false;

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
      this.finishCurrentMap();
      this.progressCurrent = progress.current;
      this.progressTotal = progress.total;
      this.currentMapActive = true;
      this.currentMapFailed = false;
      this.mapStartMessageIndexes.add(this.messages.length);
      this.title = `(${this.successfulCount}/${progress.total}) ${this.installingTitle}`;
      this.cdr.detectChanges();
    });

    this.electronService.ipcRenderer.on('on-install-init', (_, args: InstallModel) => {
      this.previousFocus = document.activeElement as HTMLElement;
      this.destination = args.response;
      this.active = true;
      this.couldClose = false;
      this.status = 'running';
      this.messages = [];
      this.problemMessageIndexes.clear();
      this.mapStartMessageIndexes.clear();
      this.progressCurrent = 0;
      this.progressTotal = 0;
      this.successfulCount = 0;
      this.currentMapActive = false;
      this.currentMapFailed = false;
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
      this.finishCurrentMap();
      this.translate.get(t_('PAGES.APP.INSTALL_DONE')).subscribe((result: string) => {
        this.title = this.progressTotal ? `(${this.successfulCount}/${this.progressTotal}) ${result}` : result;
      });
      this.status = this.successfulCount < this.progressTotal ? 'warning' : 'success';
      this.couldClose = true;
      this.cdr.detectChanges();
    });

    this.electronService.ipcRenderer.on('on-install-message', (_, message: unknown) => {
      if (this.isInstallLogEvent(message)) {
        this.translate.get(message.key, message.params).subscribe((text: string) => {
          this.appendLog(text, message.level !== 'info');
        });
      } else {
        const text = String(message);
        this.appendLog(text, /\b(?:warn(?:ing)?|error|fail(?:ed|ure)?)\b/i.test(text));
      }
    });

    this.electronService.ipcRenderer.on('on-install-error', (_, error: unknown) => {
      this.translate.get(t_('PAGES.APP.INSTALL_FAILED')).subscribe((result: string) => this.title = result);
      this.problemMessageIndexes.add(this.messages.length);
      this.messages.push(`ERROR: ${String(error)}`);
      this.currentMapFailed = true;
      this.status = 'error';
      this.couldClose = true;
      this.cdr.detectChanges();
    });
  }

  private finishCurrentMap(): void {
    if (this.currentMapActive && !this.currentMapFailed) this.successfulCount++;
    this.currentMapActive = false;
  }

  private appendLog(text: string, isProblem: boolean): void {
    if (isProblem) {
      this.problemMessageIndexes.add(this.messages.length);
      this.currentMapFailed = true;
    }
    this.messages.push(text);
    this.cdr.detectChanges();
  }

  private isInstallLogEvent(message: unknown): message is InstallLogEvent {
    if (!message || typeof message !== 'object') return false;
    const candidate = message as Partial<InstallLogEvent>;
    return candidate.type === 'log'
      && ['info', 'warning', 'error'].includes(candidate.level ?? '')
      && typeof candidate.key === 'string';
  }
}
