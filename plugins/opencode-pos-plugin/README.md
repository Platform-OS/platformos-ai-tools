# opencode-platformos-lsp

An [OpenCode](https://opencode.ai) plugin that integrates the [platformOS Language Server](https://github.com/Platform-OS/platformos-tools) (`pos-cli lsp`) into AI agent sessions.

When you ask OpenCode to work on `.liquid` or `.graphql` files, this plugin gives the agent real-time diagnostics from `pos-cli check`, plus on-demand hover docs, completions, go-to-definition, reference tracking, and dead-code detection from the LSP.

---

## How it works

The plugin is a JavaScript ESM module that OpenCode loads at startup. It spawns a private `pos-cli lsp` subprocess, registers custom agent tools backed by that connection, and hooks into the write/edit lifecycle to surface diagnostics automatically.

```
OpenCode starts
  └─ loads ~/.config/opencode/plugins/platformos-lsp.js
       └─ calls PlatformOSLSPPlugin({ directory, $, ... })
            └─ resolves pos-cli path (via `which pos-cli`)
            └─ spawns pos-cli lsp (private JSON-RPC connection)
            └─ returns hooks: tools, auto-lint, system prompt, cleanup
```

No changes to `opencode.json` are required or needed.

---

## Agent tools

### `platformos_diagnostics`

Runs `pos-cli check run -f json` on the whole project and returns all offenses for a specific file.

```
agent → platformos_diagnostics("app/views/pages/index.liquid")
      → pos-cli check run -f json (project root)
      ← "platformOS pos-cli check — index.liquid (2 error(s), 1 warning(s)):
           ERROR 12:5 [UnusedVariable]: Variable `foo` is assigned but never used
           ERROR 23:1 [MissingTemplate]: Can't find template 'partials/missing'
           WARNING 5:3 [ImgLazyLoading]: img tag should use loading='lazy'"
```

### `platformos_hover`

Returns LSP documentation for a Liquid tag, filter, or object at a given position.

```
agent → platformos_hover("app/views/pages/index.liquid", line=5, character=8)
      → textDocument/hover { uri, position }
      ← "### render\nRenders a partial template..."
```

### `platformos_completions`

Lists valid completions at a position inside a Liquid expression.

```
agent → platformos_completions("app/views/pages/index.liquid", line=3, character=3)
      → textDocument/completion { uri, position }
      ← "Completions (42): context — platformOS context object, current_user — ..."
```

### `platformos_definition`

Finds where a translation key or schema translation is defined.

### `platformos_references`

Finds all files that `render` a given partial.

### `platformos_dependencies`

Finds all files a template renders or includes (direct and transitive).

### `platformos_dead_code`

Lists all `.liquid` files in the project that are never referenced by any other template.

---

## Positioning rules for hover and completions

Both `platformos_hover` and `platformos_completions` use **0-based** `line` and `character` coordinates (same convention as LSP / VS Code).

### `platformos_hover`

The cursor must land on the **first character of a Liquid element**:

| Target | Example line | Character |
|--------|-------------|-----------|
| Tag name | `{% render 'hero' %}` | char of `r` in `render` |
| Filter name | `{{ name \| downcase }}` | char of `d` in `downcase` |
| Object name | `{{ context.current_user.name }}` | char of `c` in `context` |

**Returns nothing** if positioned on `{`, `%`, `}`, spaces, HTML tags, or string literals.

Example — line: `{{ context.current_user.name | downcase }}`

```
char:  0123456789...
text:  {{ context.current_user.name | downcase }}
           ^                          ^
           char 3 → hover on context  char 32 → hover on downcase
```

### `platformos_completions`

The cursor must be **inside a Liquid expression at the point where you'd be mid-typing**:

| Trigger | Position | What you get |
|---------|----------|-------------|
| After `{{ ` | char 3 | variables and objects |
| After `\| ` in a filter chain | char after `\| ` | filter names |
| After `.` on an object | char after `.` | object properties |
| Inside `{% … %}` after opening space | char of first keyword | tag names |

**Returns nothing** if positioned outside `{{ }}` or `{% %}` blocks.

**Tip:** read the file first, identify the target token, then count characters from 0 at the start of that line.

---

## Auto-diagnostics

After every Write or Edit on a `.liquid` or `.graphql` file, `pos-cli check` results are **automatically appended** to the tool output. The agent sees them immediately and can self-correct without a separate prompt.

```
agent writes app/views/pages/index.liquid
  → tool.execute.after fires
    → pos-cli check run -f json (project root)
    → result appended to Write tool output
agent sees: "File written.\n\n---\nplatformOS pos-cli check — 1 error(s):
              ERROR 5:1 [LiquidHTMLSyntaxError]: Unexpected token..."
```

### Mandatory error fixing

The plugin injects the following rule into the agent's system prompt:

> **MANDATORY: you MUST fix every ERROR reported by the linter before proceeding to the next task.** Do not ignore errors, do not ask the user whether to fix them — just fix them. After fixing, the next Write or Edit will re-run the linter automatically; confirm the errors are gone. Warnings and INFO items are advisory — use your judgement, but errors are never acceptable.

This means the agent will automatically attempt to fix any `ERROR`-level offense before moving on. Warnings are surfaced but left to the agent's judgement.

### TUI notification

When errors or warnings are found, a toast notification appears in the OpenCode TUI:

- **Title**: `platformOS — <filename>`
- **Message**: `N error(s), M warning(s)`
- **Colour**: red for errors, yellow for warnings only
- **Duration**: 8 seconds

---

## Logging

The plugin writes a log file to `<project-root>/platformos-lsp.log`. It records:

- Plugin startup (resolved `pos-cli` and `node` paths)
- LSP initialization success or failure
- Every `pos-cli check` invocation and its result
- Auto-diagnostics trigger (which write tool fired, which file, full diagnostic text)
- Each tool invocation and its result summary
- Session shutdown

Tail it while working to observe plugin activity in real time:

```bash
tail -f platformos-lsp.log
```

---

## Prerequisites

- [OpenCode](https://opencode.ai) installed and configured
- [pos-cli](https://github.com/Platform-OS/pos-cli) installed globally:

  ```bash
  npm install -g @platformos/pos-cli
  ```

---

## Installation

```bash
./install.sh
```

Then restart OpenCode.

### What the installer does

1. Checks that `pos-cli` (and optionally `pos-cli-mcp`) are available in `$PATH`
2. Creates `~/.config/opencode/plugins/` if it doesn't exist
3. Copies `plugin.js` to `~/.config/opencode/plugins/platformos-lsp.js`
4. Adds the `pos-cli` MCP server entry to `~/.config/opencode/opencode.json`:

```json
"mcp": {
  "pos-cli": {
    "type": "local",
    "command": ["pos-cli-mcp"],
    "environment": {
      "MCP_MIN_DEBUG": "1",
      "DEBUG": "1",
      "PARTNER_PORTAL_URL": "https://portal.ps-01-platformos.com"
    }
  }
}
```

### Manual install

```bash
cp plugin.js ~/.config/opencode/plugins/platformos-lsp.js
```

## Uninstall

```bash
rm ~/.config/opencode/plugins/platformos-lsp.js
```

Restart OpenCode.

---

## Usage

No configuration needed after installation. When you open an OpenCode session in a platformOS project:

- The agent has all 7 tools available from the first message
- Diagnostics are automatically appended after any Write or Edit to `.liquid`/`.graphql` files
- The system prompt explains all tools, positioning rules, and the mandatory error-fix policy to the agent

### Example prompts

```
Create a page at app/views/pages/about.liquid that renders the header partial
```

```
Fix the Liquid errors in app/views/partials/product-card.liquid
```

```
What does the `graphql` tag accept as arguments? Check line 3 in app/views/pages/index.liquid
```

```
Which files render the header partial?
```

```
Are there any unused .liquid files in this project?
```

---

## platformOS LSP capabilities

`pos-cli lsp` provides the following for `.liquid`, `.graphql`, and `.json` files:

| Feature | Description |
|---------|-------------|
| Diagnostics | `pos-cli check`: ~50 built-in checks for correctness, performance, and best practices |
| Completions | Liquid tags, filters, objects, partials, translations, GraphQL variables |
| Hover | Documentation for tags, filters, objects, metafields |
| Go to definition | Jump to partial files, translation keys |
| Document links | Clickable links to referenced files |
| Code actions | Quick fixes for auto-correctable offenses |
| Rename | Rename partials and assets across the project |
| Theme graph | Dependency and reference tracking, dead code detection |

---

## File structure

```
opencode-platformos-lsp/
├── plugin.js     # The OpenCode plugin (ESM module)
├── install.sh    # Installer script
├── package.json  # npm manifest
└── README.md
```
