# platformos-tools — Claude Code Plugin

Claude Code plugin providing platformOS Language Server integration for `.liquid` and `.graphql` files.

## Installation

**Step 1** — Add the marketplace registry (one-time, per machine):

```sh
claude plugin marketplace add Platform-OS/platformos-ai-tools
```

**Step 2** — Install the plugin:

```sh
claude plugin install platformos-tools@platformos-ai-tools
```

## Prerequisites

`pos-cli` v6.0.0-beta.10 or later (includes `pos-cli-lsp` and `pos-cli-mcp`):

```sh
npm install -g @platformos/pos-cli@6.0.0-beta.10
```

## What it does

**Auto-diagnostics** — after every Read, Write, or Edit on a `.liquid` or `.graphql` file, `pos-cli check` output is automatically appended to the tool result. The agent is instructed to fix all errors before proceeding.

**Available tools**

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

## Contents

- [`platformos-tools/`](platformos-tools/) — Plugin source (installed by `claude plugin install`)
