# platformos-lsp

A [Claude Code](https://claude.ai/code) plugin that integrates the [platformOS Language Server](https://github.com/Platform-OS/platformos-tools) into agent sessions.

---

## Features

| Component | What it does |
|-----------|-------------|
| **PostToolUse hook** | Runs `pos-cli check` after every Write/Edit on `.liquid`/`.graphql` files; injects diagnostics directly into Claude's context |
| **SessionStart hook** | Injects platformOS context and the mandatory error-fix rule into the system prompt |
| **LSP server** (`.lsp.json`) | Registers `pos-cli lsp` for real-time code intelligence in Claude Code's editor |
| **MCP tools** | 7 agent-callable tools: diagnostics, hover, completions, definition, references, dependencies, dead code |

---

## Prerequisites

- [Claude Code](https://claude.ai/code) 1.0.33 or later
- [pos-cli](https://github.com/Platform-OS/pos-cli) installed globally:

  ```bash
  npm install -g @platformos/pos-cli
  ```

- `pos-cli-mcp` in `$PATH` (ships with pos-cli)

---

## Installation

```bash
claude plugin marketplace add <your-github-username>/claude-pos-plugin
claude plugin install platformos-lsp@claude-pos-plugin
```

---

## Auto-diagnostics

After every Write or Edit on a `.liquid` or `.graphql` file, `pos-cli check run -f json` runs automatically and results are injected into Claude's context.

```
Claude writes app/views/pages/index.liquid
  → PostToolUse hook fires
    → pos-cli check run -f json (project root)
    → result injected as additionalContext
Claude sees: "platformOS pos-cli check — index.liquid (1 error):
               ERROR 5:1 [LiquidHTMLSyntaxError]: Unexpected token..."
```

Claude is instructed to fix every ERROR before proceeding — no ignoring, no asking.

---

## Available tools

| Tool | When to use |
|------|-------------|
| `platformos_diagnostics` | Explicitly run pos-cli check on a file |
| `platformos_hover` | Look up docs for a Liquid tag, filter, or object at a position |
| `platformos_completions` | List valid completions inside a Liquid expression |
| `platformos_definition` | Jump to definition of a translation key |
| `platformos_references` | Find every file that renders/includes a given partial |
| `platformos_dependencies` | Find every file a template renders/includes |
| `platformos_dead_code` | Find `.liquid` files that are never referenced |

---

## Logging

The plugin writes a log to `<project-root>/platformos-lsp.log`:

```bash
tail -f platformos-lsp.log
```

---

## File structure

```
platformos-lsp/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── hooks/
│   └── hooks.json           # PostToolUse + SessionStart hooks
├── scripts/
│   ├── post-tool-use.js     # Auto-diagnostics after file edits
│   ├── session-start.js     # System prompt: platformOS context
│   └── lsp-mcp-server.js   # MCP server: LSP agent tools
├── .mcp.json                # MCP server registrations
├── .lsp.json                # LSP server config
└── README.md
```
