import { BrowserContext, ElectronApplication, Page, _electron as electron } from 'playwright';
import { test, expect } from '@playwright/test';
import * as path from 'path';

delete process.env.ELECTRON_RUN_AS_NODE;
process.env.AMAI_E2E = 'true';

test.describe('Check Home Page', async () => {
  let app: ElectronApplication;
  let firstWindow: Page;
  let context: BrowserContext;

  test.beforeAll( async () => {
    app = await electron.launch({
      args: ['--no-sandbox', path.join(__dirname, '../app/main.js'), path.join(__dirname, '../app/package.json')]
    });
    context = app.context();
    await context.tracing.start({ screenshots: true, snapshots: true });
    firstWindow = await app.firstWindow();
    await firstWindow.waitForLoadState('domcontentloaded');
  });

  test('Launch electron app', async () => {

    const windowState: { isVisible: boolean; isDevToolsOpened: boolean; isCrashed: boolean } = await app.evaluate(async (process) => {
      const mainWindow = process.BrowserWindow.getAllWindows()[0];

      const getState = () => ({
        isVisible: mainWindow.isVisible(),
        isDevToolsOpened: mainWindow.webContents.isDevToolsOpened(),
        isCrashed: mainWindow.webContents.isCrashed(),
      });

      return new Promise((resolve) => {
        if (mainWindow.isVisible()) {
          resolve(getState());
        } else {
          mainWindow.once('ready-to-show', () => setTimeout(() => resolve(getState()), 0));
        }
      });
    });

    expect(windowState.isVisible).toBeTruthy();
    expect(windowState.isDevToolsOpened).toBeFalsy();
    expect(windowState.isCrashed).toBeFalsy();
  });

  // test('Check Home Page design', async ({ browserName}) => {
  //   // Uncomment if you change the design of Home Page in order to create a new screenshot
  //   const screenshot = await firstWindow.screenshot({ path: '/tmp/home.png' });
  //   expect(screenshot).toMatchSnapshot(`home-${browserName}.png`);
  // });

  test('Check title', async () => {
    const elem = await firstWindow.$('.app-header h1');
    const text = await elem.innerText();
    expect(text).toBe('AMAI Installer');
  });

  test('Show the modern installer defaults without a native menu', async () => {
    const state = await app.evaluate((process) => {
      const mainWindow = process.BrowserWindow.getAllWindows()[0];
      return {
        menu: process.Menu.getApplicationMenu(),
        size: mainWindow.getSize()
      };
    });

    await expect(firstWindow.locator('#edition-REFORGED')).toBeChecked();
    await expect(firstWindow.locator('#install-folder')).toBeChecked();
    await expect(firstWindow.locator('#commander-on')).toBeChecked();
    await expect(firstWindow.locator('#optimise')).toBeChecked();
    await expect(firstWindow.locator('#install-button')).toBeVisible();
    expect(state.menu).toBeNull();
    expect(state.size).toEqual([1200, 820]);
    expect((await firstWindow.screenshot()).length).toBeGreaterThan(1000);
  });

  test('Support keyboard edition selection and the minimum window size', async () => {
    await firstWindow.locator('#edition-REFORGED').focus();
    await firstWindow.keyboard.press('ArrowRight');
    await expect(firstWindow.locator('#edition-TFT')).toBeChecked();

    await app.evaluate((process) => process.BrowserWindow.getAllWindows()[0].setSize(900, 650));
    await firstWindow.waitForTimeout(150);
    const hasHorizontalOverflow = await firstWindow.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth);
    expect(hasHorizontalOverflow).toBeFalsy();
    expect((await firstWindow.screenshot()).length).toBeGreaterThan(1000);
    await app.evaluate((process) => process.BrowserWindow.getAllWindows()[0].setSize(1200, 820));
  });

  test('Show determinate installation progress and completion', async () => {
    await app.evaluate((process) => {
      const window = process.BrowserWindow.getAllWindows()[0];
      window.webContents.send('on-install-init', { response: 'C:\\Maps', commander: 1, isMap: false });
      window.webContents.send('on-install-progress', { current: 2, total: 4 });
      window.webContents.send('on-install-message', 'Installing test map');
    });

    await expect(firstWindow.locator('.install-modal')).toBeVisible();
    await expect(firstWindow.locator('.modal-status .status-icon')).toHaveText('sync');
    const statusTitle = await firstWindow.locator('#install-status-title').boundingBox();
    expect(statusTitle).not.toBeNull();
    if (!statusTitle) throw new Error('Installation status title has no layout box');
    expect(statusTitle.width).toBeGreaterThan(300);
    await expect(firstWindow.locator('[role="progressbar"]')).toHaveAttribute('aria-valuenow', '50');
    await expect(firstWindow.locator('.log-area')).toContainText('Installing test map');
    await expect(firstWindow.locator('.secondary-button')).toBeDisabled();

    await app.evaluate((process) => process.BrowserWindow.getAllWindows()[0].webContents.send('on-install-exit'));
    await expect(firstWindow.locator('.secondary-button')).toBeEnabled();
    await firstWindow.locator('.secondary-button').click();
    await expect(firstWindow.locator('.install-modal')).toBeHidden();
  });

  test.afterAll( async () => {
    await context.tracing.stop({ path: 'e2e/tracing/trace.zip' });
    await app.close();
  });
});
