export const electronServiceStub = {
  isElectron: false,
  openExternal: () => undefined,
  ipcRenderer: {
    on: () => undefined,
    send: () => undefined
  }
};
