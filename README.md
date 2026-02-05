# AI Tooling & Agent Infrastructure

This repository centralizes shared AI tooling, agent configurations, automation workflows and knowledge hub used across the organization.

It acts as a common foundation for building, operating, and standardizing AI-assisted development practices.

# OpenCode

## Installation

```
# YOLO
curl -fsSL https://opencode.ai/install | bash

# Package managers
npm i -g opencode-ai@latest          # or bun/pnpm/yarn
scoop install opencode               # Windows
choco install opencode               # Windows
brew install anomalyco/tap/opencode  # macOS and Linux (recommended, always up to date)
brew install opencode                # macOS and Linux (official brew formula, updated less)
paru -S opencode-bin                 # Arch Linux
mise use -g opencode                 # Any OS
nix run nixpkgs#opencode             # or github:anomalyco/opencode for latest dev branch
```

## Running OpenCode

Start the TUI from your terminal:

```bash
opencode
```

## Default Agents

OpenCode includes two built-in agents you can switch between with the `Tab` key.

    Build - Default, full-access agent for development work
    Plan - Read-only agent for analysis and code exploration
        Denies file edits by default
        Asks permission before running bash commands
        Ideal for exploring unfamiliar codebases or planning changes

Also included is a general subagent for complex searches and multistep tasks. This is used internally and can be invoked using @general in messages.

## Directory structure

### Project scope
```
your-project/                         # cwd, from where `openncode` command is run
├─ opencode.json			          # per project config overrides global
└─.opencode/                          # Project-scoped OpenCode configuration (local overrides)
   ├─ agents/                         # Custom Agents definitions (personas + behavior bundles)
   │  ├─ reviewer.md                  # e.g., code review agent profile
   │  └─ security.md                  # e.g., security auditing agent
   │
   ├─ commands/                       # Reusable command specs the agents can invoke
   │  ├─ deploy.md                    # deployment workflow
   │  └─ lint.md                      # static analysis / formatting
   │
   ├─ skills/                         # Modular capabilities/tools agents compose at runtime
   │  ├─ liquid/                         
   │  │   └─ SKILL.md                 # Documentation for liquid skill
   │  └─ playwright/                    
   │      └─ SKILL.md                 # Workflow to write e2e tests in playwright
   │
   ├─ plugins/                        # Extensions / third-party integrations
   └─ tools/                          # External tool adapters
```
### Global scope
As per project but all the fies including `opencode.json` in:
```
~/.config/opencode/
```

## MCP Server
Configure in `opencode.json`

```
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "docs": {
      "type": "remote",
      "url": "https://librarian.platformos.dev",
      "headers": {
        "CF-Access-Client-Id": "***",
        "CF-Access-Client-Secret": "***"
      },
      "enabled": true
    },
    "chrome-devtools": {
      "type": "local",
      "command": [
        "npx",
        "-y",
        "chrome-devtools-mcp@latest",
        "--channel=stable",
        "--isolated=true",
        "--viewport=1920x1080",
        "--headless=true"
      ]
    }
  }
}
```
## READ MORE: [OpenCode Documentation](https://opencode.ai/docs)
---
# AI Agent Skills for OpenCode & Claude

This repository includes collection of reusable workflows and "on-demand" instructions for OpenCode and Claude Code. These skills help reduce context bloat by loading specific instructions only when the agent determines they are necessary.

## List of skills

| Skill Name | Description |
|------------|-------------|
| pos-unit-tests | Planning, writing, running, and fixing platformOS unit tests using pos module tests |
| code-review | Comprehensive code review for platformOS applications with focus on quality, security, and architecture compliance |
| project-init | Initialize new platformOS project with modules |
| pos-crud-generator | Generate CRUD resources and scaffolds using pos module core generators |
| pos-auth | Protocols for implementing user authentication in platformOS using the pos module user |
| pos-styling | Strict protocols for implementing consistent, professional UI using the platformOS pos module common-styling |
| pos-auth-expansion | Expansion module for implementing roles, permissions, and authorization in platformOS |
| pos-check | Run platformos-check linter with detailed error reporting |
| pos-sync | Sync files to platformOS staging instance with automatic validation |
| pos-logs | Fetch and analyze platformOS logs for errors and debugging |

## How to use

For these skills to be discovered automatically, place them in one of the following locations:

| Scope | Path (OpenCode/Claude compatible) | 
| ----- | ----- | 
| **Project-local** | `.claude/skills/<skill-name>/SKILL.md` | 
| **Global (User)** | `~/.claude/skills/<skill-name>/SKILL.md` | 
| **OpenCode Specific** | `.opencode/skills/<skill-name>/SKILL.md` | 

### Example Layout

**CLAUDE**

```text
.claude/skills/
└── git-expert/
    ├── SKILL.md          # Main instructions & frontmatter
    ├── scripts/          # Optional helper scripts
    └── templates/        # Optional reference files

```

**OPENCODE**

```text
.opencode/skills/
└── git-expert/
    ├── SKILL.md          # Main instructions & frontmatter
    ├── scripts/          # Optional helper scripts
    └── templates/        # Optional reference files

```

## Usage

### Automatic Discovery

Both Claude Code and OpenCode will scan your configured directories. When your prompt matches the description in a skill's frontmatter, the agent will automatically load those instructions into its context.

### Manual Invocation

* **Claude Code**: Use `/skill-name` (e.g., `/git-expert`) to force-load the instructions.
* **OpenCode**: Use the `/skill` command in prompt and select from listed skills or simply ask the agent to "load the git-expert skill."

## Best Practices

1. **Keep Descriptions Concise**: The description field is what the LLM uses to decide if the skill is relevant. Keep it under 200 characters.
2. **Lazy Loading**: Use skills for heavy documentation (like API specs) instead of putting them in `CLAUDE.md` to save on token costs.
3. **Versioning**: Include a version or license field in your frontmatter if sharing publicly.

## Model Variability

- Outcomes may vary by LLM. Because different models (e.g., Claude 3.5 Sonnet vs. GPT-4o vs. Llama 3) have different training biases and reasoning capabilities, the same skill definition may yield different results.

- Instruction Adherence: Highly capable models (like Sonnet) follow strict rules better than smaller, faster models (like Haiku).

- Tone & Style: A skill asking for "professional" output may result in different styles depending on the base model's personality.

Constraint Handling: Some models may ignore negative constraints (e.g., "don't do X") if the prompt is too long.

## Model Sensitivity & Reliability

To ensure your skills work reliably across different environments, follow these reliability principles:

1. The "Reasoning Gap"

Large reasoning models can interpret vague heuristics, but smaller models require explicit "Step-by-Step" instructions. If your skill fails on smaller models, break the logic into an ordered list.

2. Anchor with Examples

Examples are the most effective way to normalize output across different LLMs. Providing 2-3 "Golden Examples" reduces the chance of a model hallucinating a different format.

3. Temperature Sensitivity

In OpenCode, ensure your opencode.json temperature is set appropriately.

Low Temp (0.0 - 0.2): Best for strict skills (code style, git commits).

High Temp (0.7+): Best for creative or brainstorming skills.

