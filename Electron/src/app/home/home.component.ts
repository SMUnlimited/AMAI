import { Component, ChangeDetectionStrategy } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { TranslatePipe } from '@codeandweb/ngx-translate';
import { ElectronService } from '../core/services/electron/electron.service';

export type GameVersion = 'REFORGED' | 'TFT' | 'ROC';

interface GameEdition {
  id: GameVersion;
  asset: 'REF' | 'TFT' | 'ROC';
  version: string;
  optimal: string;
  alt: string;
}

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [FormsModule, TranslatePipe]
})
export class HomeComponent {
  readonly editions: readonly GameEdition[] = [
    { id: 'REFORGED', asset: 'REF', version: '3.0.0+', optimal: '3.0.0', alt: 'Warcraft III Reforged' },
    { id: 'TFT', asset: 'TFT', version: '1.24+', optimal: '1.24–1.28', alt: 'Warcraft III The Frozen Throne' },
    { id: 'ROC', asset: 'ROC', version: '1.24–1.31', optimal: '1.24–1.28', alt: 'Warcraft III Reign of Chaos' }
  ];

  selectedVersion: GameVersion = 'REFORGED';
  toFolder = true;
  commander = 1;
  optimize = true;
  forceLanguage = false;
  disableChat = false;

  constructor(private readonly electronService: ElectronService) {}

  install(): void {
    this.electronService.ipcRenderer.send(
      'install',
      this.selectedVersion,
      this.toFolder,
      this.commander,
      this.optimize,
      this.forceLanguage,
      this.disableChat
    );
  }

  uninstall(operation: 'commander' | 'all'): void {
    this.electronService.ipcRenderer.send('uninstall', this.toFolder, operation);
  }
}
