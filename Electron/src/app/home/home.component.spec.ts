import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@codeandweb/ngx-translate';
import { HomeComponent } from './home.component';
import { ElectronService } from '../core/services/electron/electron.service';
import { electronServiceStub } from '../../testing/electron-service.stub';

describe('HomeComponent', () => {
  let component: HomeComponent;
  let fixture: ComponentFixture<HomeComponent>;
  let send: jasmine.Spy;

  beforeEach(waitForAsync(() => {
    send = spyOn(electronServiceStub.ipcRenderer, 'send');
    TestBed.configureTestingModule({
      declarations: [HomeComponent],
      providers: [{ provide: ElectronService, useValue: electronServiceStub }],
      imports: [FormsModule, TranslateModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(HomeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('defaults to the recommended Reforged directory configuration', () => {
    expect(component.selectedVersion).toBe('REFORGED');
    expect(component.toFolder).toBeTrue();
    expect(component.commander).toBe(1);
    expect(component.optimize).toBeTrue();
    expect(component.forceLanguage).toBeFalse();
    expect((fixture.nativeElement.querySelector('#edition-REFORGED') as HTMLInputElement).checked).toBeTrue();
  });

  it('selects an edition without starting installation', () => {
    const tft = fixture.nativeElement.querySelector('#edition-TFT') as HTMLInputElement;
    tft.click();
    fixture.detectChanges();

    expect(component.selectedVersion).toBe('TFT');
    expect(send).not.toHaveBeenCalled();
  });

  it('starts installation with the selected options only from the install button', () => {
    component.selectedVersion = 'ROC';
    component.toFolder = false;
    component.commander = 2;
    component.optimize = false;
    component.forceLanguage = true;
    fixture.detectChanges();

    (fixture.nativeElement.querySelector('#install-button') as HTMLButtonElement).click();

    expect(send).toHaveBeenCalledOnceWith('install', 'ROC', false, 2, false, true);
  });

  it('keeps optimised scripts and forced chat language mutually exclusive', () => {
    component.setForceLanguage(true);
    expect(component.forceLanguage).toBeTrue();
    expect(component.optimize).toBeFalse();

    component.setOptimize(true);
    expect(component.optimize).toBeTrue();
    expect(component.forceLanguage).toBeFalse();
  });
});
