# SheSecure Web Repository

This repository contains the end-to-end automated testing suite for the SheSecure Web platform. It uses **Selenium WebDriver** and the **Mocha/Chai** test runners to perform functional, UI/UX, accessibility, security, and regression tests.

## Repository Structure

- `.github/workflows/web-tests.yml`: Automated CI/CD pipeline.
- `selenium-tests/`: Node.js code containing the automated test scripts.
  - `tests/`: Individual spec files.
    - `login.test.js`: Sign-in validation and form testing.
    - `home.test.js`: Dashboard indicators and SOS triggers.
    - `accessibility.test.js`: Contrast and WCAG compliance tests.
  - `package.json`: Project dependencies configuration.
- `reports/`: Folder holding the generated Excel sheet.
  - `web_test_cases_report.xlsx`: Beautifully formatted document outlining 100 test cases with pass/fail execution results.

## Prerequisites

- **Node.js** (v18 or higher)
- **Google Chrome** browser and **ChromeDriver** installed (ensure matching versions)

## Setup Instructions

1. Navigate to the tests directory:
   ```bash
   cd selenium-tests
   ```
2. Install npm dependencies:
   ```bash
   npm install
   ```
3. Run the automated tests:
   ```bash
   npm test
   ```

*Note: You can pass custom target test URLs using env variables:*
```bash
TEST_URL=https://your-deployment.org npm test
```
