#!/usr/bin/env node
'use strict';

const { appendFile } = require('node:fs/promises');
const { join } = require('node:path');

async function main() {
  const chunks = [];
  for await (const chunk of process.stdin) chunks.push(chunk);
  const hookData = JSON.parse(chunks.join(''));

  const { cwd } = hookData;

  const logFile = join(cwd, 'platformos-tools.log');
  const log = (msg) => appendFile(logFile, `[${new Date().toISOString()}] ${msg}\n`).catch(() => {});
  await log(`session started: cwd=${cwd}`);

  process.stdout.write(
    '## platformOS Tools\n\n' +
    'You are working in a platformOS project. The following applies to `.liquid` and `.graphql` files:\n\n' +
    '### Auto-diagnostics: Post-Read/Edit Linter Gate\n\n' +
    '**Triggered automatically after every Read, Write or Edit on a `.liquid` or `.graphql` file**\n\n' +
    '**Step 1 — STOP: Read linter output**\n' +
    'Any ERROR or WARNING items present in the linter check results?\n' +
    '- PASS (0 errors, 0 warnings): CONTINUE to Step 3\n' +
    '- FAIL (errors or warnings present): CONTINUE to Step 2\n\n' +
    '**Step 2 — Fix all errors and warnings - NO COMPLIANCE**\n' +
    'Fix every ERROR and WARNING in the reported output. Do not ask the user. Do not skip any item.\n' +
    '- After fixing, the next Write or Edit will re-run the linter automatically.\n' +
    '- GOTO Step 1.\n\n' +
    '**Step 3 — Gate passed**\n' +
    'STOP. Proceed to the next task.\n\n' +
    'INFO items are advisory — use judgement, but do not block on them.\n\n' +
    '### Available LSP tools\n\n' +
    '| Tool | When to use |\n' +
    '|------|-------------|\n' +
    '| `platformos_diagnostics` | Explicitly run pos-cli check on a file and see all errors/warnings/info |\n' +
    '| `platformos_hover` | Look up docs for a Liquid tag, filter, or object at a specific position |\n' +
    '| `platformos_completions` | List valid completions inside a Liquid expression at a position |\n' +
    '| `platformos_definition` | Jump to the definition of a translation key |\n' +
    '| `platformos_references` | Find every file that renders/includes a given partial |\n' +
    '| `platformos_dependencies` | Find every file a template renders/includes |\n' +
    '| `platformos_dead_code` | Find `.liquid` files that are never referenced |\n\n' +
    '### MCP tools (pos-cli)\n\n' +
    'The `pos-cli` MCP server is available with tools for deploying, syncing, and querying the platformOS project. ' +
    'Use these tools when you need to interact with the platformOS platform directly.\n\n' +
    '### Positioning rules for LSP features\n\n' +
    'Both `platformos_hover` and `platformos_completions` use **0-based** `line` and `character` coordinates (LSP convention).\n\n' +
    '**`platformos_hover`** — position must be on the first character of a Liquid element:\n' +
    '- ✅ Tag name: `render`, `graphql`, `include`, `if`, `for`, …\n' +
    '- ✅ Filter name after `|`: `downcase`, `upcase`, `size`, …\n' +
    '- ✅ Object or property name: `context`, `current_user`, …\n' +
    '- ❌ Delimiters `{`, `%`, `}`, spaces, HTML tags, string literals → returns nothing\n\n' +
    'Example — line: `{{ context.current_user.name | downcase }}`\n' +
    '- `context` starts at char 3 → hover(line, 3) ✅\n' +
    '- `downcase` starts at char 32 → hover(line, 32) ✅\n' +
    '- char 0 is `{` → hover(line, 0) returns nothing ❌\n\n' +
    '**`platformos_completions`** — position must be inside a Liquid expression at the point where you would be mid-typing:\n' +
    '- ✅ Right after `{{ ` (char 3) — lists variables and objects\n' +
    '- ✅ Right after `| ` inside a filter chain — lists filters\n' +
    '- ✅ Right after `.` on an object — lists properties\n' +
    '- ✅ Inside `{% … %}` — lists tag names\n' +
    '- ❌ Outside any `{{ }}` or `{% %}` block → returns nothing\n'
  );
}

main().catch((err) => {
  process.stderr.write(`[platformos-tools] session-start error: ${err.message}\n`);
  process.exit(1);
});
