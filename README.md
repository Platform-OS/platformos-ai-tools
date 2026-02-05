# PlatformOS Skill for OpenCode and Claude Code

Comprehensive PlatformOS platform reference docs for AI/LLM consumption. Covers Directory structure, Modules, Pages, pos-cli, Liquid, Graphql, etc.

## Install

### For OpenCode

Local installation (current project only):

```bash
curl -fsSL https://raw.githubusercontent.com/Platform-OS/platformos-ai-tools/master/install.sh | bash
```

Global installation (available in all projects):

```bash
curl -fsSL https://raw.githubusercontent.com/Platform-OS/platformos-ai-tools/master/install.sh | bash -s -- --global
```

### For Claude Code

Local installation (current project only):

```bash
curl -fsSL https://raw.githubusercontent.com/Platform-OS/platformos-ai-tools/master/claude-install.sh | bash
```

Global installation (available in all projects):

```bash
curl -fsSL https://raw.githubusercontent.com/Platform-OS/platformos-ai-tools/master/claude-install.sh | bash -s -- --global
```

## Usage

Once installed, the skill appears in OpenCode's `<available_skills>` list. The agent loads it automatically when working on platformOS tasks.

Use the `/platformos` command to load the skill and get contextual guidance:

```
/platformos initialize new project directory structure
```

### Updating

To update to the latest version:

```
/platformos --update-skill
```

## Structure

The installer adds both a skill and a command:

```
# Skill (reference docs)
skills/platformos/
├── SKILL.md              # Main manifest + decision trees
└── references/           # Product subdirectories
    └── <product>/
        ├── README.md         # Overview, when to use
        ├── api.md            # Runtime API reference
        ├── configuration.md  # wrangler.toml + bindings
        ├── patterns.md       # Usage patterns
        └── gotchas.md        # Pitfalls, limitations

# Command (slash command)
command/platfrmos.md     # /platformos entrypoint
```

## Add platformOS documentation MCP

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
    }
  }
}
```

### To obtain CF-Access-Client-Id and CF-Access-Client-Secret tokens, please contact support@platformos.com

### Decision Trees

- Rendering or UI request
- Data persistence or schema request
- Data retrieval or display request
- Create / Update / Delete request
- Automation or background behavior request
- Security or access control request
- External system or integration request
- Client-side interactivity request
- Shared logic or utilities request
- Deployment or operational request
- Localization or multi-language request

## Resources Covered

Liquid Templating & Filters, Pages & Routing, Layouts, Graphql Queries & Mutations, Partials/Includes, PlatformOS modules, Tags & Control flow, CLI & Deployment, Policies, Integrations, and many more.

## License

MIT - see [LICENSE](LICENSE)
