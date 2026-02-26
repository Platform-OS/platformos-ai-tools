# claude-pos-plugin

Claude Code plugin marketplace for platformOS development tools.

## Plugins

| Plugin | Description |
|--------|-------------|
| [platformos-lsp](./platformos-lsp) | platformOS Language Server — auto-diagnostics, hover, completions, definitions, references, and dead-code detection for `.liquid` and `.graphql` files |

## Installation

**1. Add this marketplace to Claude Code:**

```bash
claude plugin marketplace add <your-github-username>/claude-pos-plugin
```

**2. Install the plugin:**

```bash
claude plugin install platformos-lsp@claude-pos-plugin
```

**3. Prerequisites** — install [pos-cli](https://github.com/Platform-OS/pos-cli) globally:

```bash
npm install -g @platformos/pos-cli
```

## Usage

Start Claude Code from the root of a platformOS project. The plugin activates automatically — diagnostics run after every file edit, and LSP tools are available for the agent to call.

See the [platformos-lsp README](./platformos-lsp/README.md) for full documentation.
