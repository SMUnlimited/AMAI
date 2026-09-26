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
      declarations: [AppComponent],
      providers: [{ provide: ElectronService, useValue: electronService }],
      imports: [A11yModule, RouterTestingModule, TranslateModule.forRoot()]
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
    callbacks['on-install-progress']({}, { current: 2, total: 4 });
    callbacks['on-install-message']({}, 'Installing map');
    fixture.detectChanges();

    expect(component.active).toBe(true);
    expect(component.couldClose).toBe(false);
    expect(component.destination).toBe('C:\\Maps');
    expect(component.progressPercent).toBe(50);
    expect(component.messages).toContain('Installing map');

    callbacks['on-install-exit']();
    fixture.detectChanges();
    expect(component.status).toBe('success');
    expect(component.couldClose).toBe(true);

    component.closeInstall();
    expect(component.active).toBe(false);
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
