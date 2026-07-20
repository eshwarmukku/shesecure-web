const { Builder, By, until } = require('selenium-webdriver');
const { expect } = require('chai');

describe('SheSecure Web Portal - Dashboard & SOS Functional Tests', function () {
  let driver;
  const baseUrl = process.env.TEST_URL || 'http://localhost:3000';

  before(async function () {
    const chrome = require('selenium-webdriver/chrome');
    const options = new chrome.Options();
    options.addArguments('--headless', '--disable-gpu', '--no-sandbox');
    driver = await new Builder().forBrowser('chrome').setChromeOptions(options).build();
    
    // Login to access dashboard
    await driver.get(`${baseUrl}/login`);
    await driver.findElement(By.id('email-input')).sendKeys('testuser@shesecure.org');
    await driver.findElement(By.id('password-input')).sendKeys('securePassword123');
    await driver.findElement(By.id('login-btn')).click();
    await driver.wait(until.urlContains('/home'), 5000);
  });

  after(async function () {
    if (driver) await driver.quit();
  });

  it('TC-WEB-004: Should display active risk level indicator on home screen', async function () {
    const riskLevelElement = await driver.wait(
      until.elementLocated(By.id('risk-level-indicator')), 
      5000
    );
    const text = await riskLevelElement.getText();
    expect(text.toLowerCase()).to.include('low');
  });

  it('TC-WEB-005: Should trigger emergency alert when SOS button is clicked', async function () {
    const sosButton = await driver.findElement(By.id('emergency-sos-btn'));
    await sosButton.click();
    
    // Check if redirect or dialog shows emergency status
    await driver.wait(until.urlContains('/emergency-alert'), 5000);
    const activeAlertHeader = await driver.findElement(By.id('emergency-header')).getText();
    expect(activeAlertHeader).to.include('Active Alert');
  });
});
