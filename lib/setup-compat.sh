#!/bin/bash
# Compatibility layers and config file installation
# Handles: OpenCode, Copilot, claudeignore, repomix, statusline
# Requires: core.sh ($TPL, $SYSTEM), setup.sh (_install_or_update_file)

# Install all GitHub templates (copilot instructions + workflows)
install_copilot() {
  mkdir -p .github
  while IFS= read -r -d '' _gh_path; do
    local _rel="${_gh_path#$TPL/github/}"
    local _target=".github/$_rel"
    _install_or_update_file "$_gh_path" "$_target"
  done < <(find "$TPL/github" -type f -print0 | sort -z)
}

# Map Claude Code model shorthand to OpenCode provider/model format
_oc_model() {
  case "$1" in
    haiku)  echo "anthropic/claude-haiku-4-5" ;;
    opus)   echo "anthropic/claude-opus-4-6" ;;
    *)      echo "anthropic/claude-sonnet-4-6" ;;
  esac
}

# Generate opencode.json for OpenCode compatibility
# Translates agents, commands, MCP servers from Claude Code format
generate_opencode_config() {
  if [ -f opencode.json ]; then
    echo "  opencode.json already exists, skipping."
    return 0
  fi

  command -v jq &>/dev/null || return 0

  # MCP servers from .mcp.json
  local mcp_block="{}"
  if [ -f .mcp.json ]; then
    mcp_block=$(jq '.mcpServers // {}' .mcp.json 2>/dev/null || echo "{}")
  fi

  # Agents from .claude/agents/*.md
  local agents_json="{}"
  if [ -d .claude/agents ]; then
    for agent_file in .claude/agents/*.md; do
      [ -f "$agent_file" ] || continue
      local aname amodel adesc atools
      aname=$(basename "$agent_file" .md)
      # Extract frontmatter fields (awk for macOS/BSD compat)
      adesc=$(awk '/^---$/{n++; next} n==1 && /^description:/{sub(/^description: */, ""); print}' "$agent_file" | head -1)
      amodel=$(awk '/^---$/{n++; next} n==1 && /^model:/{sub(/^model: */, ""); print}' "$agent_file" | head -1)
      atools=$(awk '/^---$/{n++; next} n==1 && /^tools:/{sub(/^tools: */, ""); print}' "$agent_file" | head -1)

      [ -z "$adesc" ] && adesc="$aname agent"

      # Map tools to OpenCode permissions
      local t_read=false t_write=false t_bash=false
      case "$atools" in *Read*|*Glob*|*Grep*) t_read=true ;; esac
      case "$atools" in *Write*|*Edit*) t_write=true ;; esac
      case "$atools" in *Bash*) t_bash=true ;; esac

      agents_json=$(printf '%s' "$agents_json" | jq -c \
        --arg name "$aname" \
        --arg desc "$adesc" \
        --arg model "$(_oc_model "$amodel")" \
        --arg file "$agent_file" \
        --argjson r "$t_read" --argjson w "$t_write" --argjson b "$t_bash" \
        '.[$name] = {
          "description": $desc,
          "mode": "subagent",
          "model": $model,
          "prompt": ("{file:" + $file + "}"),
          "tools": {"read": $r, "write": $w, "edit": $w, "bash": $b}
        }')
    done
  fi

  # Commands from .claude/commands/*.md
  local commands_json="{}"
  if [ -d .claude/commands ]; then
    for cmd_file in .claude/commands/*.md; do
      [ -f "$cmd_file" ] || continue
      local cname cmodel
      cname=$(basename "$cmd_file" .md)
      cmodel=$(awk '/^---$/{n++; next} n==1 && /^model:/{sub(/^model: */, ""); print}' "$cmd_file" | head -1)

      # Derive description from filename (kebab-case to words)
      local cdesc
      cdesc=$(echo "$cname" | tr '-' ' ')

      commands_json=$(printf '%s' "$commands_json" | jq -c \
        --arg name "$cname" \
        --arg desc "$cdesc" \
        --arg file "$cmd_file" \
        '.[$name] = {"description": $desc, "template": ("{file:" + $file + "}\\n\\n$ARGUMENTS")}')
    done
  fi

  # Assemble final config
  jq -n \
    --arg schema "https://opencode.ai/config.json" \
    --arg model "anthropic/claude-sonnet-4-6" \
    --arg small "anthropic/claude-haiku-4-5" \
    --argjson mcp "$mcp_block" \
    --argjson agents "$agents_json" \
    --argjson commands "$commands_json" \
    '{
      "$schema": $schema,
      "model": $model,
      "small_model": $small,
      "instructions": ["CLAUDE.md"],
      "mcp": $mcp,
      "agent": $agents,
      "command": $commands
    }' > opencode.json 2>/dev/null

  if [ -f opencode.json ]; then
    local ac=0 cc=0
    ac=$(echo "$agents_json" | jq 'keys | length' 2>/dev/null || echo 0)
    cc=$(echo "$commands_json" | jq 'keys | length' 2>/dev/null || echo 0)
    echo "  opencode.json created ($ac agents, $cc commands, OpenCode compatibility)"
  fi
}

# Install .claudeignore with universal patterns and optional system-specific additions.
# Idempotent: merges new patterns into existing file, never removes user entries.
install_claudeignore() {
  if [ ! -f .claudeignore ]; then
    cp "$TPL/.claudeignore" .claudeignore
    echo "  📄 .claudeignore installed ($(wc -l < .claudeignore | tr -d ' ') patterns)"
  else
    # Merge: append template patterns not already present
    local added=0
    while IFS= read -r line; do
      # Skip comments and blank lines for dedup check
      [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
      if ! grep -qxF "$line" .claudeignore 2>/dev/null; then
        echo "$line" >> .claudeignore
        added=$((added + 1))
      fi
    done < "$TPL/.claudeignore"
    [ "$added" -gt 0 ] && echo "  📄 .claudeignore updated (+$added patterns)"
  fi

  # Append system-specific patterns
  case "${SYSTEM:-}" in
    shopware*)
      for p in "var/cache/" "public/bundles/" "var/log/"; do
        grep -qxF "$p" .claudeignore || echo "$p" >> .claudeignore
      done
      ;;
    nuxt*)
      for p in ".nuxt/" ".output/"; do
        grep -qxF "$p" .claudeignore || echo "$p" >> .claudeignore
      done
      ;;
    next*)
      grep -qxF ".next/" .claudeignore || echo ".next/" >> .claudeignore
      ;;
    laravel*)
      for p in "bootstrap/cache/" "storage/framework/"; do
        grep -qxF "$p" .claudeignore || echo "$p" >> .claudeignore
      done
      ;;
  esac
}

# Install repomix.config.json for codebase snapshot configuration
install_repomix_config() {
  if [ ! -f repomix.config.json ]; then
    cp "$TPL/repomix.config.json" repomix.config.json
  else
    echo "  repomix.config.json already exists, skipping."
  fi
}

# Install claude-statusline globally via npx.
install_statusline_project() {
  echo "  Installing statusline..."
  npx @kamranahmedse/claude-statusline
  echo "  Statusline installed -> @kamranahmedse/claude-statusline"
}

# Generate repomix codebase snapshot in background (once, if not already present)
# Generate .repomixignore with base patterns + SYSTEM-specific exclusions.
# Repomix reads .repomixignore natively (like .gitignore). Machine-local artifact.
install_repomixignore() {
  [ -f .repomixignore ] && return 0

  cat > .repomixignore << 'REPOMIX_IGNORE_EOF'
# Base patterns — always excluded from repomix snapshots
node_modules/
vendor/
dist/
build/
coverage/
.git/
*.lock
*.lockb
*.map
*.min.js
*.min.css
*.png
*.jpg
*.jpeg
*.gif
*.webp
*.woff
*.woff2
*.ttf
*.pdf
REPOMIX_IGNORE_EOF

  # Append system-specific patterns
  case "${SYSTEM:-}" in
    shopware*)
      printf '\n# Shopware\nvar/cache/\nvar/log/\npublic/bundles/\n' >> .repomixignore
      ;;
    nuxt*)
      printf '\n# Nuxt\n.nuxt/\n.output/\n' >> .repomixignore
      ;;
    next*)
      printf '\n# Next.js\n.next/\n' >> .repomixignore
      ;;
    laravel*)
      printf '\n# Laravel\nbootstrap/cache/\nstorage/framework/\nstorage/logs/\n' >> .repomixignore
      ;;
  esac
  echo "  📄 .repomixignore generated"
}

generate_repomix_snapshot() {
  if [ -f ".agents/repomix-snapshot.xml" ]; then
    return 0
  fi
  mkdir -p .agents
  echo "📸 Generating codebase snapshot (repomix)..."

  local _repomix_timeout=""
  command -v timeout &>/dev/null && _repomix_timeout="timeout 120"
  command -v gtimeout &>/dev/null && _repomix_timeout="gtimeout 120"

  # Use repomix.config.json if present (user-customizable), otherwise fall back to defaults
  if [ -f "repomix.config.json" ]; then
    $_repomix_timeout npx -y repomix >/dev/null 2>&1 &
  else
    $_repomix_timeout npx -y repomix --compress --style xml \
      --remove-comments --remove-empty-lines \
      --ignore "node_modules,dist,.git,.next,.nuxt,coverage,.turbo,*.lock,*.lockb" \
      --output .agents/repomix-snapshot.xml >/dev/null 2>&1 &
  fi
  REPOMIX_PID=$!

  SPIN='-\|/'
  i=0
  while kill -0 $REPOMIX_PID 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    printf "\r  ${SPIN:$i:1} Analyzing codebase..."
    sleep 0.2
  done

  REPOMIX_EXIT=0
  wait $REPOMIX_PID 2>/dev/null || REPOMIX_EXIT=$?

  if [ $REPOMIX_EXIT -eq 0 ] && [ -f ".agents/repomix-snapshot.xml" ]; then
    LINES=$(wc -l < .agents/repomix-snapshot.xml 2>/dev/null || echo "?")
    printf "\r  ✅ Snapshot written to .agents/repomix-snapshot.xml (%s lines)%*s\n" "$LINES" 10 ""
    # Write snapshot state for freshness detection
    if [ -f ".agents/context/.state" ]; then
      echo "SNAPSHOT_HASH=$(cksum .agents/repomix-snapshot.xml 2>/dev/null | cut -d' ' -f1,2)" >> .agents/context/.state
      echo "SNAPSHOT_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> .agents/context/.state
    fi
  else
    printf "\r  ⏭️  repomix unavailable, skipping snapshot%*s\n" 20 ""
    rm -f .agents/repomix-snapshot.xml
  fi
}
