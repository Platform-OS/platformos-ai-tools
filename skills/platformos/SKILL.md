---
name: pos-meta-skill
description: This skill equips an AI agent to reliably design, scaffold, configure, and operate applications on the **platformOS** platform. It standardizes how the agent reads documentation, models platform concepts, generates project structure, writes configuration, implements server logic, and performs deployments using platformOS conventions and tooling.
---

The skill emphasizes:
- Correct use of platformOS file structure
- Deterministic project scaffolding
- Safe data modeling and migrations
- Liquid templating accuracy
- Server-side logic (GraphQL, workflows, policies)
- Repeatable deployment procedures
- Minimal hallucination of unsupported features
---

# platformOS – Quick Decision Trees (Reference Selection)

These Quick Decision Trees are designed to deterministically map any developer request to the correct platformOS reference domain(s). They use ASCII tree visualizations for clarity and are exhaustive for all core tasks an agent would perform.

The agent MUST consult these trees before generating any code.

---

## Rendering or UI request

```
Rendering/UI request?
├─ Full URL / navigable page → /reference/pages/*
│  └─ Also render in Liquid → /reference/liquid/*
├─ Shared UI snippet / reusable component → /reference/liquid/*
├─ Styling / static resources → /reference/assets/*
└─ Localized text → also /reference/translations/*
```

---

## Data persistence or schema request

```
Data persistence / schema?
├─ Persistent data → /reference/models/*
├─ User-submitted input with validation → also /reference/forms/*
└─ Schema changes or migrations → /reference/models/*
```

---

##  Data retrieval or display request

```
Data retrieval / display?
├─ Read-only → /reference/graphql/* (queries)
├─ Filtering / sorting / pagination → /reference/graphql/*
└─ Rendered in HTML → also /reference/liquid/*
```

---

## Create / Update / Delete request

```
CRUD request?
├─ Write operation → /reference/graphql/* (mutations)
├─ User input involved → also /reference/forms/*
├─ Permissions required → also /reference/policies/*
└─ Post-write side effects / automation → also /reference/workflows/*
```

---

## Automation or background behavior request

```
Automation / background job?
├─ Event-based / async → /reference/workflows/*
├─ Scheduled / time-based → /reference/workflows/* (scheduled triggers)
├─ External call required → also /reference/integrations/*
└─ Reusable helper logic → also /reference/modules/*
```

---

## Security or access control request

```
Security / access control?
├─ Route protection → /reference/policies/* (page policies)
├─ Record ownership rules → /reference/policies/* (record policies)
├─ Mutation restrictions → /reference/policies/* (mutation policies)
└─ Authentication / identity context → /reference/policies/*
```

---

## External system or integration request

```
External system / integration?
├─ Inbound callback → /reference/integrations/* (webhooks)
│   └─ Often paired with workflows → /reference/workflows/*
├─ Outbound API call → /reference/integrations/* (HTTP requests)
│   └─ Usually paired with workflows → /reference/workflows/*
└─ Secrets / credentials → also /reference/environment/*
```

---

## Client-side interactivity request

```
Client-side interactivity?
├─ Simple behavior → /reference/assets/* (JavaScript)
├─ Server interaction required → also /reference/graphql/*
└─ Shared UI structure → also /reference/liquid/*
```

---

## Shared logic or utilities request

```
Shared logic / utilities?
├─ Pure reusable logic → /reference/modules/*
├─ Used inside workflows → also /reference/workflows/*
└─ Used in forms / mutations → also /reference/forms/* or /reference/graphql/*
```

---

## Deployment or operational request

```
Deployment / operational request?
├─ Release / sync → /reference/cli/*
├─ Environment variables / secrets → also /reference/environment/*
└─ Runtime troubleshooting → /reference/cli/* (logs / status)
```

---

## Localization or multi-language request

```
Localization / i18n?
├─ Text / content → /reference/translations/*
└─ Rendered in templates → also /reference/liquid/*
```

---

## Cross-Mapping Matrix (Decision → References)

```
Page/UI → pages + liquid
Component reuse → liquid
Styling / static → assets
Persisted data → models
Read data → graphql
Write data → graphql + policies
Forms → forms + graphql
Automation → workflows
External integration → integrations + workflows
Authorization → policies
Shared helpers → modules
Config / secrets → environment
Deployment → cli
Localization → translations + liquid
```

---

## Mandatory Rule

For every request:

1. Run the relevant decision tree(s)
2. Identify all referenced domains
3. Consult those reference directories
4. Only then generate code

No primitive outside these references is allowed.


# platformOS – Reference Index Catalog

This document intentionally contains ONLY a structured reference catalog.

It mirrors the Cloudflare skill’s "reference-first" approach: before generating any code, the agent must identify the correct domain and consult the corresponding reference set.

No architecture, tutorials, or narrative guidance belong here — only deterministic mappings from task → platform primitive → documentation surface.

The agent MUST treat these domains as the canonical source of truth and MUST NOT invent behavior outside them.

---

# Master Domain Map (Top-Level Routing)

Use this table first to classify the request.

| If the user needs…            | Use this platformOS primitive | Consult this reference directory |
| ----------------------------- | ----------------------------- | -------------------------------- |
| A URL or page                 | Page + Layout                 | `/reference/pages/*`             |
| Reusable UI piece             | Partial                       | `/reference/liquid/*`            |
| HTML rendering logic          | Liquid                        | `/reference/liquid/*`            |
| Static files (JS/CSS/images)  | Assets                        | `/reference/assets/*`            |
| Persistent data               | Model                         | `/reference/models/*`            |
| Data retrieval                | GraphQL Query                 | `/reference/graphql/*`           |
| Data creation/update/delete   | GraphQL Mutation              | `/reference/graphql/*`           |
| Validated user input          | Form                          | `/reference/forms/*`             |
| Business rules/automation     | Workflow                      | `/reference/workflows/*`         |
| Access control                | Policy                        | `/reference/policies/*`          |
| Third‑party integration       | Webhook/HTTP/Workflow         | `/reference/integrations/*`      |
| Environment config/secrets    | Environment variables         | `/reference/environment/*`       |
| Deploy or manage environments | CLI                           | `/reference/cli/*`               |
| Shared server helpers         | Lib modules                   | `/reference/modules/*`           |
| Translations/i18n/date format | Translations                  | `/reference/translations/*`      |

If more than one row applies, consult all corresponding references before implementation.

---

# Liquid (Rendering Layer) Reference Index

Reference path: `/reference/liquid/*`

Scope: presentation only. No persistence or side effects.

| Topic                      | Responsibility        | Typical Use             |
| -------------------------- | --------------------- | ----------------------- |
| Layouts                    | page wrappers         | headers/footers/shell   |
| Pages                      | routable templates    | full views              |
| Partials/includes          | reusable components   | cards/forms/snippets    |
| Filters                    | formatting            | dates, numbers, strings |
| Tags/control flow          | branching/loops       | display logic           |
| Variables (assign/capture) | local state           | temporary values        |
| Rendering GraphQL results  | template data binding | lists/details           |
| Pagination helpers         | large lists           | cursor/limit rendering  |
| Snippets/macros            | reuse                 | DRY templates           |
| Asset linking              | JS/CSS                | script/style tags       |

Rules:

* No business logic
* No writes/mutations
* No authorization logic

---

# Pages & Routing Reference Index

Reference path: `/reference/pages/*`

Scope: request → response mapping.

| Topic          | Responsibility   | Typical Use            |
| -------------- | ---------------- | ---------------------- |
| Routes         | URL mapping      | `/posts`, `/dashboard` |
| Page files     | main entry views | route targets          |
| Layout binding | wrappers         | shared chrome          |
| Meta/SEO       | head config      | titles/meta            |
| Error pages    | 404/500          | fallback rendering     |
| Redirects      | navigation rules | legacy URLs            |

Rules:

* One responsibility per route
* Rendering only (no data mutation)

---

# GraphQL Reference Index

Reference path: `/reference/graphql/*`

Scope: ALL server-side data access.

| Topic             | Responsibility     | Typical Use           |
| ----------------- | ------------------ | --------------------- |
| Queries           | read-only fetch    | lists/details         |
| Mutations         | writes             | create/update/delete  |
| Variables         | dynamic input      | safe parameterization |
| Fragments         | reuse fields       | DRY schemas           |
| Filtering         | search             | user queries          |
| Sorting           | ordering           | lists                 |
| Pagination        | large datasets     | limit/cursor          |
| Validation errors | safe handling      | forms                 |
| Auth integration  | policy enforcement | secure fields         |
| Batch operations  | efficiency         | bulk updates          |

Rules:

* No direct DB
* No side effects in queries
* Keep operations minimal

---

# Models (Data Schema) Reference Index

Reference path: `/reference/models/*`

Scope: persistent structured data.

| Topic             | Responsibility    | Typical Use               |
| ----------------- | ----------------- | ------------------------- |
| Field types       | schema definition | strings/numbers/relations |
| Required fields   | integrity         | mandatory data            |
| Defaults          | initial values    | deterministic records     |
| Validations       | constraints       | formats/ranges            |
| Relations         | associations      | one-to-many/many-to-many  |
| Indexes           | performance       | frequent filters          |
| Slugs/identifiers | routing           | SEO-friendly URLs         |
| Soft delete       | lifecycle         | archiving                 |
| Seeds             | initial content   | bootstrapping             |
| Migrations        | schema changes    | evolution                 |

Rules:

* Define models before queries/mutations
* Avoid untyped/free-form data unless necessary

---

# Forms Reference Index

Reference path: `/reference/forms/*`

Scope: validated user submissions.

| Topic              | Responsibility  | Typical Use         |
| ------------------ | --------------- | ------------------- |
| Field definitions  | input structure | forms               |
| Validation rules   | correctness     | required/format     |
| Sanitization       | safety          | user text           |
| Submission mapping | mutation input  | data writes         |
| Error handling     | UX              | validation messages |
| CSRF protection    | security        | safe posts          |
| File uploads       | attachments     | media               |

Rules:

* Always validate server-side
* Forms must map to mutations

---

# Workflows (Automation) Reference Index

Reference path: `/reference/workflows/*`

Scope: asynchronous or multi-step logic.

| Topic              | Responsibility   | Typical Use          |
| ------------------ | ---------------- | -------------------- |
| Event triggers     | record lifecycle | create/update/delete |
| Scheduled triggers | time-based       | cron tasks           |
| Webhook triggers   | external events  | integrations         |
| Steps              | logic units      | transforms/actions   |
| Conditions         | branching        | rules                |
| HTTP steps         | external APIs    | integrations         |
| Retries            | reliability      | failures             |
| Idempotency        | safety           | duplicate events     |
| Logging            | debugging        | observability        |
| Notifications      | emails/messages  | alerts               |

Rules:

* Prefer workflows for background logic
* Keep idempotent

---

# Policies (Authorization) Reference Index

Reference path: `/reference/policies/*`

Scope: security and access control.

| Topic                  | Responsibility     | Typical Use         |
| ---------------------- | ------------------ | ------------------- |
| Page policies          | route protection   | auth-required pages |
| Record policies        | row-level access   | ownership rules     |
| Mutation policies      | write protection   | admin-only actions  |
| Role definitions       | permission groups  | admin/editor/user   |
| Guards                 | conditional checks | business rules      |
| Field restrictions     | sensitive data     | PII control         |
| Guest vs authenticated | visibility         | public/private      |

Rules:

* Enforce server-side only
* Never rely on hidden UI

---

# Integrations Reference Index

Reference path: `/reference/integrations/*`

Scope: external systems.

| Topic                  | Responsibility | Typical Use        |
| ---------------------- | -------------- | ------------------ |
| Webhooks               | inbound events | Stripe/GitHub      |
| HTTP requests          | outbound calls | REST APIs          |
| Auth tokens            | credentials    | API keys/OAuth     |
| Secrets storage        | protection     | env vars           |
| Payload transforms     | mapping        | format conversion  |
| Rate limiting          | safety         | API limits         |
| Retry/backoff          | reliability    | network issues     |
| Signature verification | security       | webhook validation |

Rules:

* Never hardcode secrets
* Use workflows for network logic

---

# Assets (Static/Client) Reference Index

Reference path: `/reference/assets/*`

Scope: client-side resources.

| Topic                 | Responsibility | Typical Use        |
| --------------------- | -------------- | ------------------ |
| JavaScript            | interactivity  | UI behavior        |
| CSS                   | styling        | layout/design      |
| Images/fonts          | media          | static delivery    |
| Bundling/minification | optimization   | performance        |
| Caching               | speed          | headers/versioning |

Rules:

* No server logic
* Keep lightweight

---

# Modules / Lib Reference Index

Reference path: `/reference/modules/*`

Scope: shared reusable backend helpers.

| Topic                 | Responsibility | Typical Use          |
| --------------------- | -------------- | -------------------- |
| Utility functions     | reuse          | formatting/helpers   |
| Shared business logic | DRY code       | cross-workflow logic |
| Validation helpers    | input rules    | forms/mutations      |
| Service wrappers      | integrations   | API clients          |

Rules:

* Pure functions preferred
* No hidden side effects

---

# Environment & Configuration Reference Index

Reference path: `/reference/environment/*`

Scope: operational configuration.

| Topic                  | Responsibility   | Typical Use     |
| ---------------------- | ---------------- | --------------- |
| Environment variables  | secrets/config   | keys/URLs       |
| Environment separation | dev/staging/prod | isolation       |
| Feature flags          | toggles          | gradual rollout |
| Domain settings        | routing          | host config     |
| Build settings         | optimization     | assets          |

Rules:

* Never commit secrets
* Environment-specific behavior only here

---

# CLI & Deployment Reference Index

Reference path: `/reference/cli/*`

Scope: operational control and releases.

| Topic                  | Responsibility  | Typical Use    |
| ---------------------- | --------------- | -------------- |
| Deploy                 | publish changes | releases       |
| Pull/sync              | local parity    | collaboration  |
| Logs                   | debugging       | runtime issues |
| Rollback               | recovery        | failures       |
| Environment management | staging/prod    | lifecycle      |
| Status checks          | health          | verification   |

Rules:

* All changes reproducible via CLI
* No manual production edits

---

# Translations (i18n) Reference Index

Reference path: `/reference/translations/*`

Scope: localization.

| Topic                  | Responsibility   | Typical Use |
| ---------------------- | ---------------- | ----------- |
| Locale files           | language strings | UI copy     |
| Variable interpolation | dynamic text     | templates   |
| Fallbacks              | missing keys     | resilience  |
| Pluralization          | grammar          | counts      |

Rules:

* No hardcoded user-facing text when localization is required

---

# Reference Selection Rule (Mandatory)

Before writing code:

1. Identify the domain from the Master Domain Map
2. Consult that reference directory
3. Use only documented primitives from that domain
4. Do not invent new constructs

This catalog is exhaustive and defines the complete set of valid platformOS surfaces.

