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

## Contents

- [`platformos-tools/`](platformos-tools/) — Plugin source (installed by `claude plugin install`)
