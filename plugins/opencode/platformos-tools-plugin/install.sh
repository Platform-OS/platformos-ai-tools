#!/usr/bin/env bash
# install.sh — opencode-platformos-lsp installer
set -euo pipefail

PLUGIN_NAME="platformos-lsp"
PLUGIN_FILE="plugin.js"
OPENCODE_DIR="${HOME}/.config/opencode"
PLUGINS_DIR="${OPENCODE_DIR}/plugins"
CONFIG_FILE="${OPENCODE_DIR}/opencode.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${BOLD}  →${NC} $*"; }
success() { echo -e "${GREEN}  ✓${NC} $*"; }
warn()    { echo -e "${YELLOW}  ⚠${NC} $*"; }
error()   { echo -e "${RED}  ✗${NC} $*" >&2; exit 1; }

echo -e "\n${BOLD}opencode-platformos-lsp installer${NC}\n"

# ── 1. Check prerequisites ─────────────────────────────────────────────────────

info "Checking prerequisites..."

if ! command -v pos-cli &>/dev/null; then
  error "pos-cli not found. Install it first:\n\n      npm install -g @platformos/pos-cli\n"
fi
success "pos-cli found at $(command -v pos-cli)"

if ! command -v pos-cli-mcp &>/dev/null; then
  warn "pos-cli-mcp not found — MCP server entry will still be added to opencode.json, but install pos-cli-mcp before using it"
else
  success "pos-cli-mcp found at $(command -v pos-cli-mcp)"
fi

# Determine JSON runtime: prefer bun (shipped with OpenCode), fall back to node
if command -v bun &>/dev/null; then
  JSON_RUNTIME="bun"
elif command -v node &>/dev/null; then
  JSON_RUNTIME="node"
else
  error "Neither bun nor node found. One of them is required to update opencode.json."
fi
success "JSON runtime: ${JSON_RUNTIME}"

if [[ ! -d "${OPENCODE_DIR}" ]]; then
  error "OpenCode config directory not found: ${OPENCODE_DIR}\n  Make sure OpenCode is installed and has been run at least once."
fi
success "OpenCode config dir: ${OPENCODE_DIR}"

# ── 2. Install plugin file ─────────────────────────────────────────────────────

info "Installing plugin..."

mkdir -p "${PLUGINS_DIR}"

DEST="${PLUGINS_DIR}/${PLUGIN_NAME}.js"

if [[ -f "${DEST}" ]]; then
  warn "Overwriting existing plugin at ${DEST}"
fi

cp "${SCRIPT_DIR}/${PLUGIN_FILE}" "${DEST}"
success "Plugin copied to ${DEST}"

# ── 3. Add pos-cli-mcp entry to opencode.json ─────────────────────────────────

info "Updating ${CONFIG_FILE}..."

if [[ ! -f "${CONFIG_FILE}" ]]; then
  warn "opencode.json not found — creating a minimal one"
  echo '{}' > "${CONFIG_FILE}"
fi

MCP_UPDATER=$(cat <<'EOF'
import { readFileSync, writeFileSync } from "node:fs";
const path = process.argv[2];

let config;
try {
  config = JSON.parse(readFileSync(path, "utf8"));
} catch (e) {
  console.error("Failed to parse", path, ":", e.message);
  process.exit(1);
}

config.mcp ??= {};

const desired = {
  type: "local",
  command: ["pos-cli-mcp"],
  environment: {
    MCP_MIN_DEBUG: "1",
    DEBUG: "1",
    PARTNER_PORTAL_URL: "https://portal.ps-01-platformos.com",
  },
};

if (JSON.stringify(config.mcp["pos-cli"]) === JSON.stringify(desired)) {
  console.log("already-set");
  process.exit(0);
}

config.mcp["pos-cli"] = desired;
writeFileSync(path, JSON.stringify(config, null, 2) + "\n");
console.log("updated");
EOF
)

TMPSCRIPT=$(mktemp /tmp/opencode-mcp-install-XXXXXX.mjs)
echo "${MCP_UPDATER}" > "${TMPSCRIPT}"
RESULT=$("${JSON_RUNTIME}" "${TMPSCRIPT}" "${CONFIG_FILE}" 2>&1 || true)
rm -f "${TMPSCRIPT}"

if echo "${RESULT}" | grep -q "already-set"; then
  success "pos-cli MCP entry already present in opencode.json (no changes needed)"
elif echo "${RESULT}" | grep -q "updated"; then
  success "Added pos-cli MCP entry to opencode.json"
else
  warn "Could not update opencode.json automatically."
  warn "Please add the following to the \"mcp\" section of ${CONFIG_FILE} manually:\n"
  cat <<'JSON'
    "pos-cli": {
      "type": "local",
      "command": ["pos-cli-mcp"],
      "environment": {
        "MCP_MIN_DEBUG": "1",
        "DEBUG": "1",
        "PARTNER_PORTAL_URL": "https://portal.ps-01-platformos.com"
      }
    }
JSON
fi

# ── 4. Done ────────────────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}${BOLD}Installation complete.${NC}"
echo ""
echo "  Plugin file : ${DEST}"
echo "  Config      : ${CONFIG_FILE}"
echo ""
echo "  Restart OpenCode for changes to take effect."
echo ""
