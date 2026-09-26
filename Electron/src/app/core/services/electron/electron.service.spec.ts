import { ElectronService } from './electron.service';

describe('ElectronService', () => {
  it('should detect the Electron renderer', () => {
    const process = window.process;
    Object.defineProperty(window, 'process', { configurable: true, value: { ...process, type: 'renderer' } });
    const service = Object.create(ElectronService.prototype) as ElectronService;
    expect(service.isElectron).toBe(true);
    Object.defineProperty(window, 'process', { configurable: true, value: process });
  });
});
