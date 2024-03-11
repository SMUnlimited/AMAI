import { Injectable, EventEmitter } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class HomeService {
  private enableHomeInteractive = true;
  public  changeEnabledHomeStateEmitter = new EventEmitter<boolean>();

  constructor() {}

  changeEnabledHomeState(state: boolean) {
    this.enableHomeInteractive = state;
    this.changeEnabledHomeStateEmitter.emit(state);
  }

  get enableHomeState(): boolean {
    return this.enableHomeInteractive;
  }
}
