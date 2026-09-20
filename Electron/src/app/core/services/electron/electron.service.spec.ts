import { ElectronService } from './electron.service';

describe('ElectronService', () => {
  it('should detect the Electron renderer', () => {
    const service = Object.create(ElectronService.prototype) as ElectronService;
    expect(service.isElectron).toBeTrue();
  });
});
