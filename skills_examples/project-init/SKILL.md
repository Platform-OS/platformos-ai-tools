---
name: project-init
description: Initialize new platformOS project with modules
---

### Initialize PlatformOS Project

**EXECUTION MODE: STRICTLY SEQUENTIAL**

This file defines a **strict, non-interpretable execution process**.
You **MUST execute every step exactly as written**, in order, without omission, substitution, optimization, or commentary.

**Constraints**

* EXECUTE IMMEDIATELY upon reading.
* NO analysis, NO reasoning, NO confirmation, NO questions.
* NO modifications to commands, order, paths, filenames, or content.
* NO conditional logic unless explicitly stated.
* FAILURE to execute any step exactly as written constitutes NON-COMPLIANCE.
* This process has **absolute highest priority**.

---

## PROCESS (DO NOT ALTER)

### Step 1: Project Initialization

Initialize PlatformOS project structure:

```bash
cd <PROJECT_ROOT> && pos-cli init
```

---

### Step 2: Install Modules

Execute **all commands exactly as written**:

```bash
cd <PROJECT_ROOT> && \
pos-cli modules install core && \
pos-cli modules install tests && \
pos-cli modules install user && \
pos-cli modules download core && \
pos-cli modules download tests && \
pos-cli modules download user && \
rm ./app/pos-modules.lock.json
```

---

### Step 3: Verify Module Installation

Verify that the following directories exist **without exception**:

* `modules/core/`
* `modules/user/`
* `modules/tests/`

If any directory is missing, execution is considered failed.

---

### Step 4: Ensure Project Structure

Verify that the following directories exist under `app/`:

* `app/views/pages/`
* `app/views/partials/`
* `app/views/layouts/`
* `app/lib/commands/`
* `app/lib/queries/`
* `app/graphql/`
* `app/schema/`
* `app/translations/`

Create missing directories **only if absent**. Do not add extras.

---

### Step 5: Deploy to Staging

Deploy the project to staging:

```bash
cd <PROJECT_ROOT> && pos-cli deploy staging
```

---

### Step 6: Verify Deployment Logs

Inspect staging logs for errors:

```bash
cd <PROJECT_ROOT> && pos-cli logs staging & PID=$!; sleep 10; kill -SIGINT $PID
```

Any errors in logs constitute failure.

---


## POST-INIT CHECKLIST (MANDATORY VERIFICATION)

Confirm **all** items below:

* [ ] `pos-cli init` completed successfully
* [ ] All required modules installed and downloaded
* [ ] Required directory structure verified
* [ ] Project deployed to staging - no errors

---

## FINAL ACTION (REQUIRED)

EXECUTE IMMEDIATELY
- Upon completion of the final action, Report completion of the Post-Init Checklist to **@pos-factory**.
- DO NOT generate additional output, suggestions, or confirmations.

## TERMINATION
