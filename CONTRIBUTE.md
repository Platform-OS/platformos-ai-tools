## 🛠️ How to Create a Skill

Each skill must be a folder containing a `SKILL.md` file. It starts with a YAML frontmatter block that tells the agent when to trigger the skill.

### `SKILL.md` Template

```markdown
---
name: git-expert
description: Guidelines for writing professional git commits and managing branches.
---

# Git Expert Skill
When this skill is active, you must follow these rules:
1. Always use conventional commit prefixes (feat, fix, docs).
2. Limit the first line to 50 characters.
3. Use the imperative mood in the subject line.

## Examples
- `feat: add user authentication`
- `fix: resolve memory leak in worker`

```

