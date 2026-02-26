# platformos-tools for OpenCode

OpenCode plugin that integrates the [platformOS Language Server](https://github.com/Platform-OS/platformos-language-server) into agent sessions. Provides real-time diagnostics, hover documentation, completions, go-to-definition, and theme graph analysis for `.liquid` and `.graphql` files.

## Prerequisites

Requires `pos-cli` v6.0.0-beta.10 or later, which includes `pos-cli-lsp` and `pos-cli-mcp`:

```sh
npm install -g @platformos/pos-cli@6.0.0-beta.10
```

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/Platform-OS/platformos-ai-tools/refs/heads/master/plugins/opencode/platformos-tools-plugin/install.sh | bash
```

The installer:
- Verifies `pos-cli`, `pos-cli-lsp`, and `pos-cli-mcp` are available
- Copies `plugin.js` to `~/.config/opencode/plugins/platformos-tools.js`
- Adds the `pos-cli` MCP server entry to `~/.config/opencode/opencode.json`

Restart OpenCode after installation.

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

**pos-cli MCP server** — the installer registers `pos-cli-mcp` in `opencode.json`, giving the agent access to deploy, sync, run queries, and manage the platformOS instance directly.

## Manual installation

1. Copy `plugin.js` to `~/.config/opencode/plugins/platformos-tools.js`
2. Add to the `mcp` section of `~/.config/opencode/opencode.json`:

```json
"pos-cli": {
  "type": "local",
  "command": ["pos-cli-mcp"]
}
```

3. Restart OpenCode.
