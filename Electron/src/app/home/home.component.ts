import { Component, OnInit, ViewChild, ElementRef, HostListener, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { ElectronService } from '../core/services/electron/electron.service';

@Injectable({
  providedIn: 'root'
})

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

  Images_ROC_Shown: boolean = false;
  Images_TFT_Shown: boolean = false; 
  Images_REF_Shown: boolean = false; 
  ROCInstall: boolean = false; 
  TFTInstall: boolean = false; 
  REFInstall: boolean = false; 
  Mode_State: boolean = true;
  BJ_State: number = 1;
  isInteractive: boolean = true;
  modeState: string = '-folder';
  bjState: string = '';
  message: string = '';
  optimize: boolean = true;
  forcelang: boolean = false;
  installEvent: string = 'install'

  ngOnInit(): void {
    console.log('HomeComponent INIT');
  }

  @HostListener('mouseenter', ['$event', '$event.target.dataset.action'])
  onMouseEnter(event: MouseEvent, action: string) {
    if (this.isInteractive) {
      switch (action) {
        case 'Roc':
          if (!this.ROCInstall) {
            this.Images_ROC_Shown = true;
          }
          break;
        case 'Tft':
          if (!this.TFTInstall) {
            this.Images_TFT_Shown = true;
          }
          break;
        case 'Ref':
          if (!this.REFInstall) {
            this.Images_REF_Shown = true;
          }
          break;
      }
    };
  }


  @HostListener('mouseout', ['$event', '$event.target.dataset.action'])
  onMouseLeave(event: MouseEvent, action: string) {
    if (this.isInteractive) { 
      switch (action) {
        case 'Roc':
          if (!this.ROCInstall) {
            this.Images_ROC_Shown = false;
          }
          break;
        case 'Tft':
          if (!this.TFTInstall) {
            this.Images_TFT_Shown = false;
          }
          break;
        case 'Ref':
          if (!this.REFInstall) {
            this.Images_REF_Shown = false;
          }
          break;
      }
    };
  }
  


  @HostListener('click', ['$event', '$event.target.dataset.action'])
  onClick(event: MouseEvent, action: string) {
    if (this.isInteractive) {
      switch (action) {
        case 'Roc':
          if (!this.ROCInstall) {
            this.message = `install${this.modeState}${this.bjState}-ROC`;
            this.TFTInstall = false;
            this.REFInstall = false;
            this.ROCInstall = !this.ROCInstall;
            this.electronService.ipcRenderer.send(this.installEvent, 'ROC', this.Mode_State, this.BJ_State, this.optimize, this.forcelang);
            console.log('message',this.message);
          }
          break;
        case 'Tft':
          if (!this.TFTInstall) {
            this.message = `install${this.modeState}${this.bjState}-TFT`;
            this.ROCInstall = false;
            this.REFInstall = false;
            this.TFTInstall = !this.TFTInstall;
            this.electronService.ipcRenderer.send(this.installEvent, 'TFT', this.Mode_State, this.BJ_State, this.optimize, this.forcelang);
            console.log('message',this.message);
          }
          break;
        case 'Ref':
          if (!this.REFInstall) {
            this.message = `install${this.modeState}${this.bjState}`;
            this.ROCInstall = false;
            this.TFTInstall = false;
            this.REFInstall = !this.REFInstall;
            this.electronService.ipcRenderer.send(this.installEvent, 'REFORGED', this.Mode_State, this.BJ_State, this.optimize, this.forcelang);
            console.log('message',this.message);
          }
          break;
      }
    };
    this.Images_ROC_Shown = false;
    this.Images_TFT_Shown = false;
    this.Images_REF_Shown = false;
    this.ROCInstall = false;
    this.TFTInstall = false;
    this.REFInstall = false;
  }

  onInputChange(inputId: string) {
    if (this.isInteractive) { 
      switch (inputId) {
        case 'ModeSwitch':
          this.Mode_State = !this.Mode_State;
          this.modeState = this.Mode_State ? '-folder' : '-map';
          console.log('mode',this.modeState,this.Mode_State);
          break;
        case 'BJoptionOn':
            this.bjState = '';
            this.BJ_State = 1;
            console.log('BJ',this.bjState);
            break;
        case 'BJoptionVsAI':
            this.bjState = '-vai';
            this.BJ_State = 2;
            console.log('BJ',this.bjState);
            break;
        case 'BJoptionOff':
            this.bjState = '-noc';
            this.BJ_State = 0;
            console.log('BJ',this.bjState);
            break;
        case 'Optimise':
          this.optimize = !this.optimize;
          if (this.optimize) {
            this.forcelang = false;
          }
          break;
        case 'ForceLang':
          this.forcelang = !this.forcelang;
          if (this.forcelang) {
            this.optimize = false;
          }
          break;      
      }
    };
  }

  constructor(
    private router: Router,
    private electronService: ElectronService,
  ) { }
}
