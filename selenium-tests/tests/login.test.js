const { Builder, By, until } = require('selenium-webdriver');
const { expect } = require('chai');

describe('SheSecure Web Portal - Authentication Functional Tests', function () {
  let driver;
  const baseUrl = process.env.TEST_URL || 'http://localhost:3000';

  before(async function () {
    // Configure headless chrome for CI runs
    const chrome = require('selenium-webdriver/chrome');
    const options = new chrome.Options();
    options.addArguments('--headless', '--disable-gpu', '--no-sandbox', '--disable-dev-shm-usage');
    
    driver = await new Builder()
      .forBrowser('chrome')
      .setChromeOptions(options)
      .build();
  });

  after(async function () {
    if (driver) {
      await driver.quit();
    }
  });

  it('TC-WEB-001: Should load the onboarding/login page successfully', async function () {
    await driver.get(`${baseUrl}/login`);
    const title = await driver.getTitle();
    expect(title).to.include('SheSecure');
  });

  it('TC-WEB-002: Should display validation error on empty credentials login', async function () {
    await driver.get(`${baseUrl}/login`);
    
    const loginButton = await driver.findElement(By.id('login-btn'));
    await loginButton.click();
    
    // Wait for validation alert or snackbar
    const errorText = await driver.wait(
      until.elementLocated(By.className('error-message')), 
      5000
    ).getText();
    
    expect(errorText).to.include('required');
  });

  it('TC-WEB-003: Should log in successfully with valid test user', async function () {
    await driver.get(`${baseUrl}/login`);
    
    await driver.findElement(By.id('email-input')).sendKeys('testuser@shesecure.org');
    await driver.findElement(By.id('password-input')).sendKeys('securePassword123');
    
    const loginButton = await driver.findElement(By.id('login-btn'));
    await loginButton.click();
    
    // Wait until redirected to /home dashboard
    await driver.wait(until.urlContains('/home'), 5000);
    const currentUrl = await driver.getCurrentUrl();
    expect(currentUrl).to.include('/home');
  });
});
