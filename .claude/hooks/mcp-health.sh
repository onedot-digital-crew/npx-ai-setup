#!/bin/bash
# mcp-health.sh — SessionStart hook
# Validates .mcp.json on session start: JSON syntax, required fields per server type,
# and existence of base commands for stdio servers.
# Silent on success. Outputs warnings to stderr (shown as system messages in Claude's turn).
# Max runtime: 5s. Exits 0 always — warnings are informational only.

MCP_FILE="${CLAUDE_PROJECT_DIR:-.}/.mcp.json"
[ ! -f "$MCP_FILE" ] && exit 0

# Require jq
if ! command -v jq > /dev/null 2>&1; then
  echo "[MCP HEALTH] jq not found — skipping .mcp.json validation" >&2
  exit 0
fi

# Validate JSON syntax
if ! jq empty "$MCP_FILE" 2>/dev/null; then
  echo "[MCP HEALTH] .mcp.json has invalid JSON syntax — fix before MCP servers will load" >&2
  exit 0
fi

# Iterate over servers
WARNINGS=""

while IFS= read -r server_name; do
  [ -z "$server_name" ] && continue

  TYPE=$(jq -r --arg s "$server_name" '.mcpServers[$s].type // "stdio"' "$MCP_FILE" 2>/dev/null)

  case "$TYPE" in
    http|sse)
      URL=$(jq -r --arg s "$server_name" '.mcpServers[$s].url // empty' "$MCP_FILE" 2>/dev/null)
      if [ -z "$URL" ]; then
        WARNINGS="${WARNINGS}  - $server_name (${TYPE}): missing required field 'url'\n"
      fi
      ;;
    stdio|*)
      CMD=$(jq -r --arg s "$server_name" '.mcpServers[$s].command // empty' "$MCP_FILE" 2>/dev/null)
      if [ -z "$CMD" ]; then
        WARNINGS="${WARNINGS}  - $server_name (stdio): missing required field 'command'\n"
      else
        # Check that the base executable exists
        BASE_CMD=$(echo "$CMD" | awk '{print $1}')
        if ! command -v "$BASE_CMD" > /dev/null 2>&1; then
          WARNINGS="${WARNINGS}  - $server_name (stdio): command not found: $BASE_CMD\n"
        fi
      fi
      ;;
  esac
done < <(jq -r '.mcpServers | keys[]' "$MCP_FILE" 2>/dev/null)

if [ -n "$WARNINGS" ]; then
  printf "[MCP HEALTH] .mcp.json issues detected:\n%b" "$WARNINGS" >&2
fi

exit 0
