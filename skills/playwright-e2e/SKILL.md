---
name: playwright-e2e
description: Implement fully functional e2e test suite for platfrmOS web application
---

# Playwright E2E Testing Skill

> **AUTHORITY NOTICE**: This skill enforces mandatory testing discipline. Deviations result in unreliable tests and production failures. Follow every instruction precisely.

## Skill Activation

**MANDATORY ANNOUNCEMENT**: When invoking this skill, you MUST declare:
```
"I am using the Playwright E2E Testing Skill. I will follow the complete workflow: EXPLORE → PLAN → IMPLEMENT → EXECUTE → HEAL."
```

---

## Table of Contents

1. [Core Principles](#1-core-principles)
2. [Tool Setup](#2-tool-setup)
3. [Phase 1: Application Exploration](#3-phase-1-application-exploration)
4. [Phase 2: Test Planning](#4-phase-2-test-planning)
5. [Phase 3: Test Implementation](#5-phase-3-test-implementation)
6. [Phase 4: Test Execution](#6-phase-4-test-execution)
7. [Phase 5: Test Healing](#7-phase-5-test-healing)
8. [Selector Strategy](#8-selector-strategy)
9. [Anti-Patterns](#9-anti-patterns)
10. [Checklists](#10-checklists)

---

## 1. Core Principles

**YOU MUST INTERNALIZE THESE PRINCIPLES. VIOLATIONS CAUSE TEST FAILURES.**

### 1.1 The Testing Hierarchy

```
EXPLORATION before PLANNING
PLANNING before IMPLEMENTATION
IMPLEMENTATION before EXECUTION
EXECUTION before HEALING
```

**No skipping phases. No exceptions.**

### 1.2 Fundamental Laws

| Law | Requirement |
|-----|-------------|
| **Isolation** | Each test MUST be independent. No shared state between tests. |
| **Determinism** | Tests MUST produce identical results on every run. |
| **Atomicity** | One test = one scenario = one behavior verification. |
| **Readability** | Tests are documentation. Code MUST be self-explanatory. |
| **Resilience** | Tests MUST survive minor UI changes without breaking. |

### 1.3 Commitment Contract

Before writing ANY test code, you MUST have:
- [ ] Explored the application thoroughly
- [ ] Documented the test plan with explicit steps
- [ ] Identified all selectors using resilient strategies
- [ ] Defined expected outcomes for each scenario

**Skipped planning = failed tests. Every time.**

---

## 2. Tool Setup

### 2.1 Installation Verification

**FIRST ACTION - ALWAYS**: Verify playwright-cli is available.

```bash
# Check installation
playwright-cli --help

# If not installed:
npm install -g @playwright/cli@latest
```

### 2.2 Session Management

```bash
# List active sessions
playwright-cli session-list

# Create named session for test development
playwright-cli --session testing open <url>

# Stop sessions when done
playwright-cli session-stop-all
```

### 2.3 Configuration

Create `playwright-cli.json` in project root:

```json
{
  "browser": "chromium",
  "headless": true,
  "timeout": 30000,
  "viewport": { "width": 1280, "height": 720 },
  "outputDir": "./test-results"
}
```

---

## 3. Phase 1: Application Exploration

> **PURPOSE**: Understand the application completely before designing tests.

### 3.1 Mandatory Exploration Sequence

**EXECUTE THESE COMMANDS IN ORDER:**

```bash
# Step 1: Open application
playwright-cli open <application-url>

# Step 2: Capture initial state
playwright-cli screenshot --path exploration/initial-state.png

# Step 3: Get page structure
playwright-cli snapshot

# Step 4: Observe network behavior
playwright-cli network
```

### 3.2 Discovery Protocol

For EACH page/view in the application, you MUST:

1. **Capture Visual State**
   ```bash
   playwright-cli screenshot --path exploration/<page-name>.png
   ```

2. **Extract DOM Structure**
   ```bash
   playwright-cli snapshot
   ```

3. **Identify Interactive Elements**
   - Buttons, links, forms, inputs
   - Dropdowns, checkboxes, radio buttons
   - Modals, dialogs, tooltips
   - Navigation elements

4. **Map User Flows**
   - Entry points
   - Decision branches
   - Success paths
   - Error states
   - Exit points

### 3.3 Exploration Checklist

**DO NOT proceed to planning until ALL items are checked:**

- [ ] All pages/views visited and documented
- [ ] All interactive elements identified
- [ ] All forms and their validations understood
- [ ] All navigation paths mapped
- [ ] All error states identified
- [ ] All success states identified
- [ ] Network requests observed for critical flows
- [ ] Authentication flow understood (if applicable)
- [ ] Data dependencies identified

### 3.4 Exploration Documentation Format

Create `test-plan/exploration-notes.md`:

```markdown
# Application Exploration Notes

## Application: [Name]
## URL: [Base URL]
## Date: [Exploration Date]

### Pages Discovered
1. [Page Name] - [URL Path] - [Purpose]
2. ...

### User Roles Identified
1. [Role] - [Capabilities]
2. ...

### Critical Flows
1. [Flow Name]: [Step 1] → [Step 2] → [Step 3] → [Outcome]
2. ...

### Form Elements
| Page | Form ID/Name | Fields | Validation Rules |
|------|--------------|--------|------------------|
| ... | ... | ... | ... |

### Error States
| Trigger | Expected Error | Recovery Path |
|---------|----------------|---------------|
| ... | ... | ... |

### External Dependencies
- [API endpoints]
- [Third-party services]
- [Database operations]
```

---

## 4. Phase 2: Test Planning

> **PURPOSE**: Design comprehensive test scenarios BEFORE writing code.

### 4.1 Mandatory Planning Sequence

**YOU MUST create a test plan document BEFORE writing any test code.**

### 4.2 Scenario Categories

Every application requires tests in ALL these categories:

| Category | Description | Priority |
|----------|-------------|----------|
| **Smoke** | Critical path verification | P0 - Block release |
| **Happy Path** | Normal user flows | P1 - Must pass |
| **Boundary** | Edge cases, limits | P1 - Must pass |
| **Negative** | Error handling, invalid inputs | P1 - Must pass |
| **Integration** | Cross-feature interactions | P2 - Should pass |
| **Accessibility** | a11y compliance | P2 - Should pass |

### 4.3 Test Scenario Template

**EVERY scenario MUST include ALL fields:**

```markdown
## Scenario: [Descriptive Name]

### Metadata
- **ID**: [UNIQUE-ID]
- **Category**: [Smoke|HappyPath|Boundary|Negative|Integration|Accessibility]
- **Priority**: [P0|P1|P2]
- **Preconditions**: [Required state before test]

### Steps
1. [Action]: [Specific instruction]
   - **Element**: [Selector or description]
   - **Data**: [Input value if applicable]

2. [Action]: [Specific instruction]
   - **Element**: [Selector or description]
   - **Data**: [Input value if applicable]

### Expected Results
- [ ] [Specific, verifiable outcome 1]
- [ ] [Specific, verifiable outcome 2]

### Success Criteria
[What constitutes a passing test]

### Failure Indicators
[What indicates test failure]
```

### 4.4 Test Plan Structure

Create `test-plan/TEST-PLAN.md`:

```markdown
# Test Plan: [Application Name]

## Overview
- **Application**: [Name]
- **Version**: [Version under test]
- **Environment**: [Test environment URL]
- **Author**: [Agent/Human]
- **Date**: [Creation date]

## Test Coverage Matrix

| Feature | Smoke | Happy | Boundary | Negative | Integration |
|---------|-------|-------|----------|----------|-------------|
| [Feature 1] | ✓ | ✓ | ✓ | ✓ | ✓ |
| [Feature 2] | ✓ | ✓ | ✓ | ✓ | - |

## Scenarios

### Feature: [Feature Name]

#### Scenario 1: [Name]
[Full scenario template]

#### Scenario 2: [Name]
[Full scenario template]

---

## Test Data Requirements

| Scenario | Data Type | Values | Source |
|----------|-----------|--------|--------|
| [Scenario] | [Type] | [Values] | [Generated/Fixed/API] |

## Environment Requirements

- Browser: [chromium|firefox|webkit]
- Viewport: [dimensions]
- Authentication: [requirements]
- Test accounts: [details]
```

### 4.5 Planning Validation

**DO NOT proceed to implementation until:**

- [ ] Every critical user flow has at least one test scenario
- [ ] Every form has validation tests (valid + invalid inputs)
- [ ] Every error state has a negative test
- [ ] Every scenario has explicit expected results
- [ ] Test data is defined for all scenarios
- [ ] Preconditions are clearly stated

---

## 5. Phase 3: Test Implementation

> **PURPOSE**: Transform test plans into reliable, maintainable Playwright tests.

### 5.1 Implementation Protocol

**MANDATORY SEQUENCE FOR EACH TEST:**

1. **Verify Plan Exists**: Confirm scenario is documented in test plan
2. **Setup Page**: Initialize browser state
3. **Execute Steps**: Perform each action from plan
4. **Verify Outcomes**: Assert expected results
5. **Capture Evidence**: Screenshots on failure

### 5.2 File Structure

```
tests/
├── e2e/
│   ├── smoke/
│   │   └── critical-path.spec.ts
│   ├── features/
│   │   ├── authentication.spec.ts
│   │   ├── [feature-name].spec.ts
│   ├── fixtures/
│   │   └── test-data.ts
│   └── utils/
│       └── helpers.ts
├── playwright.config.ts
└── test-plan/
    ├── exploration-notes.md
    └── TEST-PLAN.md
```

### 5.3 Test Code Standards

**EVERY test file MUST follow this structure:**

```typescript
/**
 * @file [feature-name].spec.ts
 * @description Tests for [Feature Name]
 * @testplan test-plan/TEST-PLAN.md#[section]
 */

import { test, expect } from '@playwright/test';

test.describe('[Feature Name]', () => {

  test.beforeEach(async ({ page }) => {
    // Setup: Navigate to starting point
    // Setup: Establish required state
  });

  test('[Scenario ID]: [Scenario Name]', async ({ page }) => {
    // Step 1: [Description from plan]
    await page.locator('[selector]').click();

    // Step 2: [Description from plan]
    await page.locator('[selector]').fill('value');

    // Verify: [Expected outcome from plan]
    await expect(page.locator('[selector]')).toBeVisible();
    await expect(page.locator('[selector]')).toHaveText('expected');
  });

});
```

### 5.4 Selector Priority

**USE SELECTORS IN THIS ORDER (highest to lowest priority):**

| Priority | Selector Type | Example | Resilience |
|----------|---------------|---------|------------|
| 1 | data-testid | `[data-testid="submit-btn"]` | Highest |
| 2 | Role + Name | `getByRole('button', { name: 'Submit' })` | High |
| 3 | Label text | `getByLabel('Email')` | High |
| 4 | Placeholder | `getByPlaceholder('Enter email')` | Medium |
| 5 | Text content | `getByText('Submit')` | Medium |
| 6 | CSS selector | `.submit-button` | Low |
| 7 | XPath | `//button[@type="submit"]` | Lowest |

**NEVER use:**
- Auto-generated IDs (e.g., `#ember123`, `#react-root-0`)
- Positional selectors (e.g., `nth-child(3)`) without stable parent
- Deeply nested selectors (more than 3 levels)

### 5.5 Assertion Patterns

**MANDATORY ASSERTION RULES:**

```typescript
// CORRECT: Use web-first assertions (auto-wait)
await expect(page.locator('[data-testid="result"]')).toBeVisible();
await expect(page.locator('[data-testid="result"]')).toHaveText('Success');
await expect(page.locator('[data-testid="count"]')).toHaveText(/\d+ items/);

// WRONG: Manual waits
await page.waitForTimeout(1000); // NEVER use fixed timeouts
const text = await page.locator('[data-testid="result"]').textContent();
expect(text).toBe('Success'); // No auto-retry

// CORRECT: Handle dynamic content with regex
await expect(page.locator('[data-testid="timestamp"]')).toHaveText(/\d{4}-\d{2}-\d{2}/);

// CORRECT: Verify element states
await expect(page.locator('button')).toBeEnabled();
await expect(page.locator('input')).toHaveValue('expected');
await expect(page.locator('[data-testid="list"]')).toHaveCount(5);
```

### 5.6 Page Object Pattern (For Complex Applications)

```typescript
// pages/LoginPage.ts
export class LoginPage {
  constructor(private page: Page) {}

  // Locators as methods
  private usernameInput = () => this.page.getByLabel('Username');
  private passwordInput = () => this.page.getByLabel('Password');
  private submitButton = () => this.page.getByRole('button', { name: 'Sign In' });
  private errorMessage = () => this.page.getByRole('alert');

  // Actions
  async login(username: string, password: string) {
    await this.usernameInput().fill(username);
    await this.passwordInput().fill(password);
    await this.submitButton().click();
  }

  // Assertions
  async expectError(message: string) {
    await expect(this.errorMessage()).toHaveText(message);
  }
}
```

### 5.7 Implementation Checklist

**FOR EACH TEST, verify:**

- [ ] Test has unique, descriptive name matching plan
- [ ] Test is independent (no dependencies on other tests)
- [ ] Selectors follow priority order
- [ ] All assertions use web-first pattern
- [ ] No hardcoded waits (`waitForTimeout`)
- [ ] Dynamic data handled with regex or functions
- [ ] Comments reference test plan steps
- [ ] Error scenarios include negative assertions

---

## 6. Phase 4: Test Execution

> **PURPOSE**: Run tests systematically and gather actionable results.

### 6.1 Execution Commands

```bash
# Run all tests
npx playwright test

# Run specific test file
npx playwright test tests/e2e/features/authentication.spec.ts

# Run tests with specific tag
npx playwright test --grep "@smoke"

# Run in headed mode (for debugging)
npx playwright test --headed

# Run with trace recording
npx playwright test --trace on

# Run specific project (browser)
npx playwright test --project=chromium
```

### 6.2 Execution Strategy

**MANDATORY EXECUTION ORDER:**

1. **Smoke Tests First**
   ```bash
   npx playwright test --grep "@smoke"
   ```
   - If smoke fails, STOP. Fix before proceeding.

2. **Feature Tests**
   ```bash
   npx playwright test tests/e2e/features/
   ```

3. **Full Suite**
   ```bash
   npx playwright test
   ```

### 6.3 Result Analysis Protocol

**AFTER EVERY EXECUTION:**

1. **Review Summary**
   ```
   Tests: X passed, Y failed, Z skipped
   ```

2. **For Each Failure:**
   - Identify failing test name
   - Review error message
   - Examine trace/screenshot
   - Determine failure category:
     - **Selector Issue**: Element not found
     - **Timing Issue**: Race condition
     - **Assertion Failure**: Wrong value
     - **Application Bug**: Actual defect

3. **Document Failures**
   ```markdown
   ## Failure Report: [Test Name]
   - **Error**: [Error message]
   - **Category**: [Selector|Timing|Assertion|Bug]
   - **Root Cause**: [Analysis]
   - **Resolution**: [Fix description]
   ```

### 6.4 Using playwright-cli for Investigation

```bash
# Open the failing page state
playwright-cli open <url>

# Verify selector exists
playwright-cli snapshot

# Test selector interactively
playwright-cli click "[data-testid='target']"

# Check for console errors
playwright-cli console

# Capture current state
playwright-cli screenshot --path debug-state.png
```

---

## 7. Phase 5: Test Healing

> **PURPOSE**: Systematically fix failing tests with permanent solutions.

### 7.1 Healing Protocol

**MANDATORY SEQUENCE FOR EACH FAILURE:**

```
1. REPRODUCE → Confirm failure is consistent
2. INVESTIGATE → Identify root cause
3. ANALYZE → Determine fix category
4. FIX → Implement correction
5. VERIFY → Confirm fix resolves issue
6. VALIDATE → Ensure no regression
```

### 7.2 Root Cause Categories

| Category | Symptoms | Solution |
|----------|----------|----------|
| **Selector Drift** | Element not found | Update selector, prefer data-testid |
| **Timing Race** | Intermittent failures | Add proper waits, use web-first assertions |
| **State Dependency** | Fails based on order | Add setup/cleanup, isolate test |
| **Data Mismatch** | Wrong values | Use regex, dynamic data handling |
| **Application Change** | New behavior | Update expected outcomes |
| **Actual Bug** | Valid failure | Report bug, mark test appropriately |

### 7.3 Selector Healing

**When selectors break:**

```bash
# Get current page structure
playwright-cli snapshot

# Identify new selector
# Priority: data-testid > role > label > text > css
```

```typescript
// BEFORE (broken)
await page.locator('.old-class-name').click();

// AFTER (healed)
await page.getByRole('button', { name: 'Submit' }).click();
// OR
await page.locator('[data-testid="submit-btn"]').click();
```

### 7.4 Timing Healing

**When timing causes failures:**

```typescript
// WRONG: Fixed wait
await page.waitForTimeout(2000);

// CORRECT: Wait for specific condition
await page.waitForLoadState('networkidle');
await expect(page.locator('[data-testid="loaded"]')).toBeVisible();

// CORRECT: Wait for network request
await page.waitForResponse(resp =>
  resp.url().includes('/api/data') && resp.status() === 200
);
```

### 7.5 Data Healing

**When dynamic data causes failures:**

```typescript
// WRONG: Exact match on dynamic data
await expect(page.locator('[data-testid="id"]')).toHaveText('12345');

// CORRECT: Pattern match
await expect(page.locator('[data-testid="id"]')).toHaveText(/^\d+$/);

// CORRECT: Partial match
await expect(page.locator('[data-testid="message"]')).toContainText('Success');
```

### 7.6 When Tests Cannot Be Fixed

**ONLY after exhausting all options:**

```typescript
test.fixme('[REASON]: Test cannot pass due to known issue', async ({ page }) => {
  // Document why this test is skipped
  // Link to issue tracker: [URL]
  // Expected resolution: [description]
});
```

**Requirements for using `test.fixme()`:**
- Document specific reason in test name
- Add comment with issue tracker link
- Describe expected resolution
- Set reminder to revisit

### 7.7 Healing Verification

**AFTER EVERY FIX:**

```bash
# Run fixed test 3 times minimum
npx playwright test [test-file] --repeat-each=3

# Run full suite to check for regressions
npx playwright test
```

---

## 8. Selector Strategy

### 8.1 Recommended Selectors

```typescript
// BEST: Test IDs (most stable)
page.locator('[data-testid="login-button"]')

// GOOD: Semantic roles with accessible names
page.getByRole('button', { name: 'Log in' })
page.getByRole('textbox', { name: 'Email' })
page.getByRole('link', { name: 'Home' })

// GOOD: Form labels
page.getByLabel('Password')

// ACCEPTABLE: Text content (for static text)
page.getByText('Welcome back')

// ACCEPTABLE: Placeholder (for inputs without labels)
page.getByPlaceholder('Search...')
```

### 8.2 Forbidden Selectors

```typescript
// FORBIDDEN: Auto-generated IDs
page.locator('#react-select-2-input') // Changes between renders

// FORBIDDEN: Deep structural selectors
page.locator('div > div > div > span.text') // Breaks with any DOM change

// FORBIDDEN: Index-based without context
page.locator('button').nth(3) // Position may change

// FORBIDDEN: Style-based selectors
page.locator('[style*="display: block"]') // Styles change
```

### 8.3 Selector Debugging

```bash
# Get current page accessibility tree
playwright-cli snapshot

# Verify element exists and is interactable
playwright-cli click "[data-testid='target']"

# Check element visibility
playwright-cli eval "document.querySelector('[data-testid=\"target\"]').getBoundingClientRect()"
```

---

## 9. Anti-Patterns

### 9.1 FORBIDDEN Practices

| Anti-Pattern | Problem | Correct Approach |
|--------------|---------|------------------|
| `waitForTimeout(n)` | Flaky, slow | Use web-first assertions |
| `waitForLoadState('networkidle')` | Deprecated, unreliable | Wait for specific elements |
| `page.evaluate()` for assertions | No auto-retry | Use `expect()` matchers |
| Shared state between tests | Order-dependent failures | Full isolation |
| Hardcoded test data | Environment-specific failures | Fixtures or generated data |
| Ignoring console errors | Misses application issues | Assert no errors |
| Comments instead of test names | Poor documentation | Descriptive test names |

### 9.2 Code Smells

**If you see these patterns, REFACTOR:**

```typescript
// SMELL: Multiple assertions without separation
test('everything', async ({ page }) => {
  // Tests login, dashboard, profile, settings...
  // 50+ lines of assertions
});
// FIX: Split into focused tests

// SMELL: Duplicated setup across tests
test('test1', async ({ page }) => {
  await page.goto('/');
  await login(page);
  // ...
});
test('test2', async ({ page }) => {
  await page.goto('/');
  await login(page);
  // ...
});
// FIX: Use beforeEach or fixtures

// SMELL: Try-catch hiding failures
try {
  await expect(element).toBeVisible();
} catch {
  console.log('Element not found, continuing...');
}
// FIX: Let assertions fail properly
```

---

## 10. Checklists

### 10.1 Pre-Implementation Checklist

**STOP if any item is unchecked:**

- [ ] Application explored completely
- [ ] All user flows documented
- [ ] Test plan created with all scenarios
- [ ] Selectors identified for all elements
- [ ] Test data requirements defined
- [ ] Environment configured

### 10.2 Per-Test Checklist

- [ ] Unique, descriptive test name
- [ ] Matches scenario in test plan
- [ ] Independent (no shared state)
- [ ] Uses resilient selectors
- [ ] Web-first assertions only
- [ ] No hardcoded waits
- [ ] Comments reference plan steps
- [ ] Handles dynamic data properly

### 10.3 Pre-Commit Checklist

- [ ] All tests pass locally
- [ ] Tests run 3+ times without flakiness
- [ ] No skipped tests without documentation
- [ ] No console warnings/errors
- [ ] Test plan updated if scenarios changed
- [ ] Code reviewed for anti-patterns

### 10.4 Healing Checklist

- [ ] Failure reproduced consistently
- [ ] Root cause identified
- [ ] Fix category determined
- [ ] Minimal change implemented
- [ ] Fixed test passes 3+ times
- [ ] Full suite passes (no regression)
- [ ] Documentation updated

---

## Quick Reference Card

### Essential Commands

```bash
# Exploration
playwright-cli open <url>
playwright-cli snapshot
playwright-cli screenshot --path <file>
playwright-cli network

# Test Execution
npx playwright test
npx playwright test --headed
npx playwright test --trace on
npx playwright test --grep "@smoke"

# Debugging
npx playwright test --debug
npx playwright show-report

# Session Management
playwright-cli session-list
playwright-cli session-stop-all
```

### Essential Assertions

```typescript
await expect(locator).toBeVisible();
await expect(locator).toHaveText('exact');
await expect(locator).toHaveText(/pattern/);
await expect(locator).toContainText('partial');
await expect(locator).toHaveCount(n);
await expect(locator).toBeEnabled();
await expect(locator).toHaveValue('value');
await expect(page).toHaveURL(/pattern/);
await expect(page).toHaveTitle(/pattern/);
```

### Workflow Summary

```
EXPLORE → Document all pages, flows, elements
    ↓
PLAN → Create comprehensive test scenarios
    ↓
IMPLEMENT → Write tests following standards
    ↓
EXECUTE → Run tests, analyze results
    ↓
HEAL → Fix failures systematically
    ↓
VERIFY → Confirm stability, no regressions
```

---

## Compliance Declaration

**By using this skill, the agent commits to:**

1. Never skipping the exploration phase
2. Never implementing tests without a documented plan
3. Never using forbidden selectors or anti-patterns
4. Always following the healing protocol for failures
5. Always validating fixes with multiple runs
6. Never marking tests as fixme without full documentation

**Failure to comply results in unreliable test suites that provide false confidence and miss real defects.**

---

*This skill enforces professional testing discipline. Tests are the safety net for production. Treat them with the rigor they deserve.*
