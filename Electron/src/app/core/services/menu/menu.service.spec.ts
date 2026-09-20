/* tslint:disable:no-unused-variable */

import { TestBed, inject } from '@angular/core/testing';
import { MenuService } from './menu.service';
import { TranslateModule } from '@codeandweb/ngx-translate';
import { ElectronService } from '../electron/electron.service';
import { electronServiceStub } from '../../../../testing/electron-service.stub';

describe('Service: Menu', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [TranslateModule.forRoot()],
      providers: [MenuService, { provide: ElectronService, useValue: electronServiceStub }]
    });
  });

  it('should ...', inject([MenuService], (service: MenuService) => {
    expect(service).toBeTruthy();
  }));
});
