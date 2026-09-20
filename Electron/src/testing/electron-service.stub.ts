export const electronServiceStub = {
  isElectron: false,
  ipcRenderer: {
    on: () => undefined,
    send: () => undefined
  }
};
