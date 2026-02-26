# platformos-tools for Claude Code

Claude Code plugin that integrates the [platformOS Language Server](https://github.com/Platform-OS/platformos-language-server) into agent sessions. Provides real-time diagnostics, hover documentation, completions, go-to-definition, and theme graph analysis for `.liquid` and `.graphql` files.

## Prerequisites

Requires `pos-cli` v6.0.0-beta.10 or later, which includes `pos-cli-lsp` and `pos-cli-mcp`:

```sh
npm install -g @platformos/pos-cli@6.0.0-beta.10
```

## Installation

```sh
claude plugin marketplace add Platform-OS/platformos-ai-tools
claude plugin install platformos-tools@platformos-ai-tools
```

## What it does

**Auto-diagnostics** — after every Read, Write, or Edit on a `.liquid` or `.graphql` file, `pos-cli check` runs automatically and results are injected into the agent context. The agent is instructed to fix all errors before proceeding.

**LSP tools (via MCP)** — a private MCP server wraps the platformOS LSP to provide:

| Tool | Description |
|------|-------------|
| `platformos_diagnostics` | Run `pos-cli check` on a file and return all errors, warnings, and info |
| `platformos_hover` | Get LSP hover documentation for a Liquid tag, filter, or object |
| `platformos_completions` | List valid completions inside a Liquid expression |
| `platformos_definition` | Jump to the definition of a translation key |
| `platformos_references` | Find every file that renders/includes a given partial |
| `platformos_dependencies` | Find every file a template renders/includes |
| `platformos_dead_code` | Find `.liquid` files that are never referenced |

**pos-cli MCP server** — `pos-cli-mcp` is registered as a second MCP server, giving the agent access to deploy, sync, run queries, and manage the platformOS instance directly.

**Native LSP** — `.lsp.json` registers `pos-cli-lsp` with Claude Code's built-in LSP client for `.liquid` and `.graphql` files.

## Plugin structure

```
platformos-tools/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── hooks/
│   └── hooks.json           # PostToolUse + SessionStart hooks
├── scripts/
│   ├── post-tool-use.js     # Auto-diagnostics after file operations
│   ├── session-start.js     # System prompt injection
│   └── lsp-mcp-server.js    # MCP server wrapping pos-cli lsp
├── .mcp.json                # MCP server registrations
└── .lsp.json                # Native LSP registration
```
