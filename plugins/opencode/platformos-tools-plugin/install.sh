#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="platformos-tools"
PLUGIN_FILE="plugin.js"
GITHUB_RAW="https://raw.githubusercontent.com/Platform-OS/platformos-ai-tools/refs/heads/master/plugins/opencode/platformos-tools-plugin/plugin.js"
OPENCODE_DIR="${HOME}/.config/opencode"
PLUGINS_DIR="${OPENCODE_DIR}/plugins"
CONFIG_FILE="${OPENCODE_DIR}/opencode.json"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${BOLD}  →${NC} $*"; }
success() { echo -e "${GREEN}  ✓${NC} $*"; }
warn()    { echo -e "${YELLOW}  ⚠${NC} $*"; }
error()   { echo -e "${RED}  ✗${NC} $*" >&2; exit 1; }

echo -e "\n${BOLD}platformos-tools for OpenCode${NC}\n"

info "Checking prerequisites..."

MISSING=()
command -v pos-cli     &>/dev/null || MISSING+=("pos-cli")
command -v pos-cli-lsp &>/dev/null || MISSING+=("pos-cli-lsp")
command -v pos-cli-mcp &>/dev/null || MISSING+=("pos-cli-mcp")

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo -e "${RED}  ✗  Missing required binaries: ${MISSING[*]}${NC}" >&2
  echo -e "" >&2
  echo -e "  Install pos-cli (v6.0.0-beta.10 or later) which includes all three:" >&2
  echo -e "" >&2
  echo -e "      npm install -g @platformos/pos-cli@6.0.0-beta.10" >&2
  echo -e "" >&2
  exit 1
fi

success "pos-cli     found at $(command -v pos-cli)"
success "pos-cli-lsp found at $(command -v pos-cli-lsp)"
success "pos-cli-mcp found at $(command -v pos-cli-mcp)"

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

info "Installing plugin..."

mkdir -p "${PLUGINS_DIR}"

DEST="${PLUGINS_DIR}/${PLUGIN_NAME}.js"

if [[ -f "${DEST}" ]]; then
  warn "Overwriting existing plugin at ${DEST}"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || true)"
LOCAL_FILE="${SCRIPT_DIR}/${PLUGIN_FILE}"

if [[ -f "${LOCAL_FILE}" ]]; then
  cp "${LOCAL_FILE}" "${DEST}"
  success "Plugin copied from local file to ${DEST}"
else
  if ! command -v curl &>/dev/null; then
    error "curl not found. Install curl or run this script from the repository directory."
  fi
  info "Downloading plugin from GitHub..."
  curl -fsSL "${GITHUB_RAW}" -o "${DEST}"
  success "Plugin downloaded to ${DEST}"
fi

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
      "command": ["pos-cli-mcp"]
    }
JSON
fi

echo ""
echo -e "${GREEN}${BOLD}Installation complete.${NC}"
echo ""
echo "  Plugin file : ${DEST}"
echo "  Config      : ${CONFIG_FILE}"
echo ""
echo "  Restart OpenCode for changes to take effect."
echo ""
