const { Builder, By } = require('selenium-webdriver');
const { expect } = require('chai');

describe('SheSecure Web Portal - Accessibility Auditing Tests', function () {
  let driver;
  const baseUrl = process.env.TEST_URL || 'http://localhost:3000';

  before(async function () {
    const chrome = require('selenium-webdriver/chrome');
    const options = new chrome.Options();
    options.addArguments('--headless', '--disable-gpu', '--no-sandbox');
    driver = await new Builder().forBrowser('chrome').setChromeOptions(options).build();
  });

  after(async function () {
    if (driver) await driver.quit();
  });

  it('TC-WEB-008: Verify DOM inputs have associated label/aria elements', async function () {
    await driver.get(`${baseUrl}/login`);
    const emailInput = await driver.findElement(By.id('email-input'));
    const ariaLabel = await emailInput.getAttribute('aria-label');
    expect(ariaLabel).to.not.be.null;
    expect(ariaLabel).to.include('email');
  });

  it('TC-WEB-009: Verify focus management of elements on key tab press', async function () {
    await driver.get(`${baseUrl}/login`);
    const body = await driver.findElement(By.css('body'));
    await body.sendKeys('\t'); // Tab key
    const activeElement = await driver.switchTo().activeElement();
    const activeId = await activeElement.getAttribute('id');
    expect(activeId).to.equal('email-input');
  });
});
