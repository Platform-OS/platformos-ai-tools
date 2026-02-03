# GraphQL Schema Index Documentation

This document explains the design, implementation, and usage of the AGENTS.md index for the GraphQL schema.

---

## Table of Contents

1. [Overview](#overview)
2. [Why Index the Schema?](#why-index-the-schema)
3. [Design Principles](#design-principles)
4. [Index Structure](#index-structure)
5. [Format Specification](#format-specification)
6. [Sections Reference](#sections-reference)
7. [LLM Instructions](#llm-instructions)
8. [Verification Q&A](#verification-qa)
9. [Testing](#testing)
10. [Usage Guide](#usage-guide)
11. [Maintenance](#maintenance)

---

## Overview

The GraphQL schema (`schema.json`) contains **434 types** including:
- Object types (134)
- Input types (226)
- Enum types (40)
- Scalars (18)
- Interfaces (16)
- Unions (1)

This is too large for LLMs to process effectively. AGENTS.md provides a **compressed, pipe-delimited index** that enables efficient navigation and retrieval.

**Current Metrics:**
- AGENTS.md: 44KB, 72 sections
- schema.json: ~6000 lines
- Test coverage: 10/10 passing

---

## Why Index the Schema?

### Problem
- `schema.json` is ~6000 lines
- Full schema exceeds LLM context limits
- Searching for specific types requires parsing the entire file
- No organized overview of relationships and patterns

### Solution
AGENTS.md provides:
- **Compact representation** (~40KB vs ~600KB)
- **Organized structure** - types grouped by domain
- **Cross-references** - interface implementations, relationships
- **Pattern documentation** - common filters, pagination, property access

---

## Design Principles

### 1. Pipe-Delimited Format

Inspired by [Vercel's AGENTS.md specification](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals.md), we use pipe-delimited sections:

```
|HEADER:value|ANOTHER:value|
|SECTION:{subsections}
|Type{field1,field2}
```

**Benefits:**
- Compact - minimal whitespace
- Parsable - consistent delimiter structure
- Complete - one line contains all type information

### 2. Hierarchical Organization

Types are organized by domain:

| Section | Contents |
|---------|----------|
| `OBJECTS\|ADMIN` | Admin-facing types (Assets, Pages, Webhooks) |
| `OBJECTS\|CORE` | Core domain types (Listing, User, Customization) |
| `OBJECTS\|AUTH` | Authentication types (Session, Authentication) |
| `OBJECTS\|DATA` | Data types (Embedding, Export, Search) |
| `INPUTS\|FILTER` | Filter and sort input types |
| `INPUTS\|CREATE` | Create/update input types |

### 3. Complete Type Coverage

Every type from `schema.json` must appear in AGENTS.md:
- Object types with all fields
- Input types with all parameters
- Enum types with all values
- Scalars with descriptions
- Interfaces with implementations

### 4. Cross-Reference Links

Types reference each other:
- `Interface->Impl{...}` shows which types implement an interface
- `QUERY_SHORTCUTS` shows query field patterns
- `RELATION_PATTERNS` shows how to traverse relationships

---

## Index Structure

### Header Section

```
[GraphQL Schema Index]|root: schema.json|IMPORTANT: note
```

| Field | Meaning |
|-------|---------|
| `root` | Source file for the schema |
| `IMPORTANT` | Guidance for LLM usage |

### Root Types

```
|ROOT:{query:RootQuery,mutation:RootMutation}
```

The entry points for all operations.

### Query Fields

```
|QUERY_FIELDS|activities(ids,page,per_page,sort,uuids),admin_...
```

All 98 query operations from `RootQuery` with parameters.

### Mutations

```
|MUTATION:{api_call_send(input,options),assets_create_mutation(input)...}
```

All 53 mutations from `RootMutation` with parameters.

### Objects

```
|OBJECTS|ADMIN:{ApiCallNotification{...},Asset{...}...}|CORE:{Listing{...}...}
```

Types organized by domain, each with all fields.

### Inputs

```
|INPUTS|FILTER:{FilterInput{...},SortInput{...}...}|CREATE:{CreateInput{...}...}
```

Filter/sort inputs and create/update inputs.

### Enums

```
|ENUMS|ACCESS:{ACL{private,public}}|AUTH:{AuthenticationProvider{...}}
```

All enum types with their possible values.

### LLM Instructions

AGENTS.md includes a dedicated `|LLM_INSTRUCTIONS|` section that guides LLMs on how to use the index:

```
|LLM_INSTRUCTIONS|FOR_QUESTIONS:{...}|FOR_QUERIES:{...}|FOR_MUTATIONS:{...}|...
```

**Sub-sections:**

| Section | Purpose |
|---------|---------|
| `FOR_QUESTIONS` | How to answer schema type/field questions |
| `FOR_QUERIES` | How to find and describe queries |
| `FOR_MUTATIONS` | How to find and describe mutations |
| `FOR_FILTERS` | How to locate filter inputs |
| `FOR_TYPES` | How to describe types |
| `FOR_RELATIONSHIPS` | How to show type relationships |
| `FOR_IMPLEMENTATION` | When to reference schema.json |
| `EXAMPLE_QUERY` | Walkthrough: Filter users by email |
| `EXAMPLE_MUTATION` | Walkthrough: Create a user |
| `EXAMPLE_RELATION` | Walkthrough: Users and listings relationship |
| `IMPORTANT_NOTE` | AGENTS.md vs schema.json roles |
| `QUICK_LOOKUP` | Common type existence checks |
| `QUERY_HINTS` | Query operation shortcuts |
| `MUTATION_HINTS` | Mutation operation shortcuts |
| `COMMON_ERRORS` | What to verify to avoid errors |

**LLM Workflow (from header):**
```
1) Read AGENTS.md to understand structure
2) Find type/field names from index
3) Use index info to answer schema questions
4) For implementation details, consult schema.json
```

### Verification Q&A

A separate file `LLM_VERIFICATION_QA.md` contains **20 Q&A examples** to verify LLM navigation:

| Category | Examples |
|----------|----------|
| Type Discovery | Q1-Q3 |
| Query Operations | Q4-Q6 |
| Mutations | Q7-Q9 |
| Filters/Sorting | Q10-Q12 |
| Relationships | Q13-Q14 |
| Enums/Values | Q15-Q16 |
| Complex Operations | Q17-Q18 |
| Error Handling | Q19 |
| Quick Reference | Q20 |

Each Q&A demonstrates:
1. **Question** - What user asks
2. **LLM Workflow** - Steps from AGENTS.md
3. **Answer** - Response to user

### Interface Implementations

```
|INTERFACE_IMPLS|AdminSharedAttributesInterface->{Asset,ApiCallNotification...}
```

Which types implement each interface.

### Common Patterns

```
|COMMON_PATTERNS|PAGINATION:{...}|TIMESTAMPS:{...}|PROPERTY_ACCESS:{...}
```

Reusable patterns for common operations.

---

## Format Specification

### Type Definitions

**Object:**
```
TypeName{field1,field2,field3}
```

**Input:**
```
InputType{param1,param2}
```

**Enum:**
```
EnumName{value1,value2,value3}
```

**Scalar:**
```
ScalarName{description}
```

**Interface:**
```
InterfaceName{field1,field2}
```

### Field Notation

| Notation | Meaning |
|----------|---------|
| `field` | Regular field |
| `field@deprecated` | Deprecated field |
| `field!` | Non-null field (optional in index) |
| `field:Type` | Field with type (optional in index) |

### Relationship Markers

| Marker | Meaning |
|--------|---------|
| `->` | Implements (Interface->Type) |
| `~` | Has relation (Type~{related_type}) |

### Pagination Collection Suffix

All pagination types end with `Collection`:
- `UserCollection`
- `ListingCollection`
- `BackgroundJobCollection`

---

## Sections Reference

### QUERY_FIELDS

All queries available on `RootQuery`:

```
activities(ids, page, per_page, sort, uuids)
admin_api_call_notifications(filter, sort)
admin_assets(filter, sort)
// ... 98 total
```

**Usage:** Find query operations and their parameters.

### MUTATION

All mutations available on `RootMutation`:

```
api_call_send(input, options)
assets_create_mutation(input)
create_customization(input)
// ... 53 total
```

**Usage:** Find mutation operations and their parameters.

### OBJECTS\|ADMIN

Admin-facing types:
- `Asset` - File assets
- `ApiCallNotification` - API webhook notifications
- `AuthorizationPolicy` - Access control
- `EmailNotification` - Email templates
- `Form` - Form configurations
- `Page` - CMS pages
- `WebhookEndpoint` - Webhook configurations

### OBJECTS\|CORE

Core domain types:
- `Listing` - Marketplace listings
- `User` - User accounts
- `Profile` - User profiles
- `Customization` - Custom model instances
- `Model` / `Record` - Generic models/records
- `Transactable` - Transactional entities

### OBJECTS\|DATA

Data types:
- `Embedding` - Vector embeddings
- `DataExport` - Data export jobs
- `Document` - Search documents
- `Aggregations` - Search aggregations

### INPUTS\|FILTER

Filter and sort inputs:
- `UsersFilterInput` - Filter users
- `ListingsSortInput` - Sort listings
- `BooleanFilter` - Boolean comparisons
- `DateFilter` - Date comparisons
- `StringFilter` - String comparisons
- `GeoPropertyFilterInput` - Geo filters

### INPUTS\|CREATE

Create and update inputs:
- `UserInputType` - Create user
- `CustomizationInputType` - Create customization
- `PropertyUploadOptionsInput` - Configure uploads
- `ImagePresignUrlInput` - Presign image upload

### ENUMS

All enum types:
- `StatusEnum` - active, disabled, inactive, pending
- `UserStatus` - active, inactive
- `TransactionStatusEnum` - pending, processed, failed
- `AggregationTypeEnum` - avg, max, min, terms
- `AuthenticationProvider` - auth0, google, github, etc.

### INTERFACE_IMPLS

Maps interfaces to implementing types:
```
AdminSharedAttributesInterface->{Asset,ApiCallNotification,AuthorizationPolicy...}
HasModelsInterface->{Model,User}
PropertiesInterface->{Customization,Model,Profile}
```

### COMMON_PATTERNS

**Pagination:**
```
{current_page, has_next_page, has_previous_page, per_page, results, total_entries, total_pages}
```

**Timestamps:**
```
{created_at: JSONDate, updated_at: JSONDate, deleted_at: JSONDate}
```

**Property Access:**
```
{property(name): String, property_array(name): [String!], ...}
```

**Filter Operations:**
```
{eq, not_eq, in, not_in, gt, gte, lt, lte, contains, starts_with, ends_with, is_null, exists}
```

---

## Testing

### Test File: `test_index.sh`

The test suite verifies AGENTS.md completeness against `schema.json`.

### Running Tests

```bash
./test_index.sh
```

### Test Coverage

| Test | What It Checks |
|------|----------------|
| Object Type Completeness | All 134 object types exist in AGENTS.md |
| Input Type Completeness | All 226 input types exist in AGENTS.md |
| Enum Type Completeness | All 40 enum types exist in AGENTS.md |
| Key Object Types | Critical types (User, Listing, etc.) present |
| Key Input Types | Critical inputs present |
| Key Enum Types | Critical enums present |
| Index Structure | Required sections exist (72 sections) |
| File Size | File is substantial (>40KB) |
| Query Fields | Query coverage is substantial (~188 fields) |
| Interface Implementations | Interface mappings exist (14 entries) |

### Test Philosophy

Tests are **rigorous**, not written to pass:
- They compare actual type names from `schema.json` against AGENTS.md
- They will **FAIL** if any type is missing
- They catch gaps during development

### Adding New Types

When `schema.json` is updated:

1. Run tests: `./test_index.sh`
2. If tests fail, identify missing types
3. Add missing types to appropriate section in AGENTS.md
4. Re-run tests to verify

---

## Usage Guide

### For LLM Navigation

1. **Find a type:**
   - Search for the type name in AGENTS.md
   - Read its definition with all fields

2. **Find queries for a domain:**
   - Check `QUERY_FIELDS` section
   - Find relevant operations

3. **Find input types:**
   - Check `INPUTS|FILTER` for filters
   - Check `INPUTS|CREATE` for mutations

4. **Understand relationships:**
   - Check `INTERFACE_IMPLS` for type hierarchies
   - Check `RELATION_PATTERNS` for navigation

### Example: Query Users

1. Find in QUERY_FIELDS:
   ```
   users(filter, sort)
   ```

2. Find filter input in INPUTS|FILTER:
   ```
   UsersFilterInput{created_at, deleted_at, email, first_name, id, last_name, slug, updated_at}
   ```

3. Find sort input in INPUTS|FILTER:
   ```
   UsersSortInput{created_at, email, first_name, id, last_name, slug, updated_at}
   ```

4. Find result type in OBJECTS|USER:
   ```
   User{created_at, customizations, deleted_at, email, external_id, first_name, id, last_name, listings, phone_number, profile, slug, updated_at}
   ```

### Example: Create Customization

1. Find mutation in MUTATION:
   ```
   create_customization(input)
   ```

2. Find input in INPUTS|CREATE:
   ```
   CustomizationInputType{created_at, custom_attachments, custom_images, custom_model_type_id, custom_model_type_name, customizable_id, customizable_type, customizations, deleted_at, external_id, id, model_schema_name, models, properties, title, user_id}
   ```

3. Find result type in OBJECTS|USER:
   ```
   Customization{address, addresses, attachment, attachments, created_at, custom_address, custom_addresses, custom_attachment, custom_attachments, custom_image, custom_images, customizable, customizable_id, customizable_type, deleted_at, external_id, human_name, id, image, images, model, models, name, properties, property, property_array, property_boolean, property_float, property_int, property_json, property_object, property_upload, related_model, related_models, related_user, remote_model, sort_score, updated_at, user, user_id}
   ```

---

## Maintenance

### Regular Tasks

1. **After schema updates:**
   ```bash
   ./test_index.sh
   # Fix any failures
   ```

2. **Verify file size:**
   ```bash
   du -h AGENTS.md  # Should be ~40KB
   ```

3. **Check section count:**
   ```bash
   grep -oE "\|[A-Z][A-Za-z_]+:" AGENTS.md | wc -l  # Should be ~57
   ```

### Adding New Types

1. Identify the type in `schema.json`
2. Find appropriate section in AGENTS.md
3. Add type with all fields
4. Run tests:
   ```bash
   ./test_index.sh
   ```

### Schema Update Process

When `schema.json` changes:

1. Read updated `schema.json`
2. Compare types against AGENTS.md
3. Add missing types
4. Update existing types if needed
5. Run tests to verify

### Troubleshooting

**Test fails - "Missing type":**
- The type exists in `schema.json` but not in AGENTS.md
- Add the type to the appropriate section

**Test fails - "Missing section":**
- A required section is missing
- Add the section with proper pipe delimiters

**File size too small:**
- AGENTS.md may be incomplete
- Verify against schema.json

---

## File Inventory

| File | Purpose | Size |
|------|---------|------|
| `schema.json` | Source GraphQL schema | ~6000 lines |
| `AGENTS.md` | Compressed index for LLM navigation | ~44KB |
| `test_index.sh` | Verification test suite | - |
| `INDEX_DOCUMENTATION.md` | This documentation file | - |
| `LLM_VERIFICATION_QA.md` | Q&A examples for LLM testing | - |

### Running Verification

To verify LLM can use the index:

```bash
# Run test suite
./test_index.sh

# Review Q&A examples
cat LLM_VERIFICATION_QA.md
```

**Expected test output:**
```
PASSED: 10/10
✓ All tests passed! AGENTS.md is comprehensive.
```

## Summary

AGENTS.md transforms an unusable 6000-line schema into a compact 44KB index that LLMs can effectively navigate. The pipe-delimited format enables:

- **Efficient lookup** - Find types by name
- **Complete coverage** - All 434 schema types indexed
- **Cross-references** - Understand relationships
- **Pattern documentation** - Common operations documented
- **LLM instructions** - Built-in guidance for navigation
- **Verification Q&A** - 20 examples to test LLM capability

**Key Components:**
- `AGENTS.md` - Index with 72 sections
- `test_index.sh` - 10 rigorous tests (all passing)
- `LLM_VERIFICATION_QA.md` - 20 Q&A examples

Tests ensure ongoing correctness. Run `./test_index.sh` anytime to verify completeness. Use `LLM_VERIFICATION_QA.md` to validate LLM navigation capability.
