import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { A11yModule } from '@angular/cdk/a11y';
import { RouterTestingModule } from '@angular/router/testing';
import { TranslateModule, TranslateService } from '@codeandweb/ngx-translate';
import { AppComponent } from './app.component';
import { ElectronService } from './core/services';
import { Mock, vi } from 'vitest';

describe('AppComponent', () => {
  let fixture: ComponentFixture<AppComponent>;
  let component: AppComponent;
  let callbacks: Record<string, (...args: unknown[]) => void>;
  let openExternal: Mock;
  let send: Mock;

  beforeEach(waitForAsync(() => {
    callbacks = {};
    openExternal = vi.fn();
    send = vi.fn();
    const electronService = {
      isElectron: true,
      openExternal,
      ipcRenderer: {
        send,
        on: (channel: string, callback: (...args: unknown[]) => void) => callbacks[channel] = callback
      }
    };

    TestBed.configureTestingModule({
      providers: [{ provide: ElectronService, useValue: electronService }],
      imports: [AppComponent, A11yModule, RouterTestingModule, TranslateModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AppComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('creates the app shell', () => {
    expect(component).toBeTruthy();
  });

  it('switches language and opens About in the external browser', () => {
    const translate = TestBed.inject(TranslateService);
    component.changeLanguage({ target: { value: 'fr' } } as unknown as Event);
    component.openAbout();

    expect(translate.currentLang).toBe('fr');
    expect(send).toHaveBeenCalledWith('Trans', 'fr', expect.any(Object));
    expect(openExternal).toHaveBeenCalledExactlyOnceWith('https://github.com/SMUnlimited/AMAI');
  });

  it('shows the installer version and website in the About dropdown', () => {
    const dropdown = fixture.nativeElement.querySelector('.about-dropdown') as HTMLElement;

    expect(dropdown.textContent).toContain(`v${component.installerVersion}`);
    expect(dropdown.textContent).toContain('github.com/SMUnlimited/AMAI');
  });

  it('shows progress, messages, success, and restores the close action', () => {
    callbacks['on-install-init']({}, { response: 'C:\\Maps', commander: 1, isMap: false });
    callbacks['on-install-progress']({}, { current: 1, total: 4 });
    callbacks['on-install-progress']({}, { current: 2, total: 4 });
    callbacks['on-install-message']({}, 'Installing map');
    fixture.detectChanges();

    expect(component.active).toBe(true);
    expect(component.couldClose).toBe(false);
    expect(component.destination).toBe('C:\\Maps');
    expect(component.progressPercent).toBe(50);
    expect(component.messages).toContain('Installing map');

    callbacks['on-install-progress']({}, { current: 3, total: 4 });
    callbacks['on-install-progress']({}, { current: 4, total: 4 });
    callbacks['on-install-exit']();
    fixture.detectChanges();
    expect(component.status).toBe('success');
    expect(component.couldClose).toBe(true);

    component.closeInstall();
    expect(component.active).toBe(false);
  });

  it('marks warning and error logs red and counts only successful maps', () => {
    callbacks['on-install-init']({}, { response: 'C:\\Maps', commander: 1, isMap: false });
    callbacks['on-install-progress']({}, { current: 1, total: 2 });
    callbacks['on-install-message']({}, 'WARN: first map failed');
    callbacks['on-install-message']({}, 'Error flushing first map');
    callbacks['on-install-progress']({}, { current: 2, total: 2 });
    callbacks['on-install-message']({}, 'Second map installed');
    callbacks['on-install-exit']();
    fixture.detectChanges();

    const rows = fixture.nativeElement.querySelectorAll('.log-row') as NodeListOf<HTMLElement>;
    expect(rows[1].classList).toContain('map-start');
    expect(rows[1].classList).toContain('problem');
    expect(rows[2].classList).toContain('problem');
    expect(rows[3].classList).toContain('map-start');
    expect(rows[3].classList).not.toContain('problem');
    expect(component.successfulCount).toBe(1);
    expect(component.title).toContain('(1/2)');
    expect(component.status).toBe('warning');
    expect(fixture.nativeElement.querySelector('.modal-status.warning .status-icon').textContent).toContain('warning');
  });

  it('shows installation errors and ignores a cancelled picker', () => {
    callbacks['on-install-init']({}, { response: 'map.w3x', commander: 0, isMap: true });
    callbacks['on-install-error']({}, 'MPQ failed');
    fixture.detectChanges();

    expect(component.status).toBe('error');
    expect(component.messages).toContain('ERROR: MPQ failed');
    expect(component.couldClose).toBe(true);

    callbacks['on-install-empty']();
    expect(component.active).toBe(false);
  });
});
