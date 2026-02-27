#!/bin/bash
# Fresh install steps: requirements, templates, hooks, commands, agents
# Requires: core.sh ($TPL, $TEMPLATE_MAP, $SHOPIFY_SKILLS_MAP)

# Check requirements: node >= 18, npm, jq, AI CLI detection
# Sets: $AI_CLI
check_requirements() {
  MISSING=()
  ! command -v node &>/dev/null && MISSING+=("node (>= 18)")
  ! command -v npm &>/dev/null && MISSING+=("npm")
  ! command -v jq &>/dev/null && MISSING+=("jq (brew install jq)")

  if [ ${#MISSING[@]} -gt 0 ]; then
    echo "❌ Missing requirements:"
    for m in "${MISSING[@]}"; do echo "   - $m"; done
    echo ""
    echo "Install the missing tools and try again."
    exit 1
  fi

  # Node.js version check (>= 18)
  NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//' | cut -d. -f1)
  if [ -n "$NODE_VERSION" ] && [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js >= 18 required (found v$NODE_VERSION)"
    exit 1
  fi

  # Template directory validation
  if [ ! -d "$TPL" ]; then
    echo "❌ Template directory not found: $TPL"
    echo "   The package may be corrupted. Try: npm cache clean --force && npx @onedot/ai-setup"
    exit 1
  fi

  # AI CLI detection (optional, for Auto-Init)
  AI_CLI=""
  if command -v claude &>/dev/null; then
    AI_CLI="claude"
  elif command -v gh &>/dev/null && gh copilot --version &>/dev/null 2>&1; then
    AI_CLI="copilot"
  fi
  echo "✅ Requirements OK (AI CLI: ${AI_CLI:-none detected})"
}

# Detect and remove legacy AI structures
cleanup_legacy() {
  FOUND=()
  [ -d ".ai" ] && FOUND+=(".ai/")
  [ -d ".claude/skills/create-spec" ] && FOUND+=(".claude/skills/create-spec/")
  [ -d ".claude/skills/spec-work" ] && FOUND+=(".claude/skills/spec-work/")
  [ -d ".claude/skills/template-skill" ] && FOUND+=(".claude/skills/template-skill/")
  [ -d ".claude/skills/learn" ] && FOUND+=(".claude/skills/learn/")
  [ -f ".claude/INIT.md" ] && FOUND+=(".claude/INIT.md")
  [ -d "skills/" ] && FOUND+=("skills/")
  [ -d ".skillkit/" ] && FOUND+=(".skillkit/")
  [ -f "skillkit.yaml" ] && FOUND+=("skillkit.yaml")

  if [ ${#FOUND[@]} -gt 0 ]; then
    echo "⚠️  Legacy AI structures found:"
    for f in "${FOUND[@]}"; do echo "   - $f"; done
    echo ""
    read -p "Delete? (Y/n) " CLEANUP
    if [[ ! "$CLEANUP" =~ ^[Nn]$ ]]; then
      for f in "${FOUND[@]}"; do rm -rf "$f"; done
      echo "✅ Cleanup done."
    else
      echo "⏭️  Cleanup skipped."
    fi
  else
    echo "✅ No legacy structures found."
  fi
}

# Copy CLAUDE.md template
install_claude_md() {
  echo "📝 Writing CLAUDE.md..."
  if [ ! -f CLAUDE.md ]; then
    cp "$TPL/CLAUDE.md" CLAUDE.md
    echo "  CLAUDE.md created (template — customize as needed)."
  else
    echo "  CLAUDE.md already exists, skipping."
  fi
}

# Create .claude/settings.json
install_settings() {
  echo "⚙️  Writing .claude/settings.json..."
  mkdir -p .claude
  if [ ! -f .claude/settings.json ]; then
    cp "$TPL/claude/settings.json" .claude/settings.json
  else
    echo "  .claude/settings.json already exists, skipping."
  fi
}

# Install hook scripts
install_hooks() {
  echo "🛡️  Creating hooks..."
  mkdir -p .claude/hooks

  while IFS= read -r -d '' _hook_path; do
    _hook_name="${_hook_path##*/}"
    if [ ! -f ".claude/hooks/$_hook_name" ]; then
      cp "$_hook_path" ".claude/hooks/$_hook_name"
      case "$_hook_name" in *.sh) chmod +x ".claude/hooks/$_hook_name" ;; esac
    else
      echo "  .claude/hooks/$_hook_name already exists, skipping."
    fi
  done < <(find "$TPL/claude/hooks" -maxdepth 1 -type f -print0 | sort -z)
}

# Install rule templates
install_rules() {
  echo "📐 Installing rules..."
  mkdir -p .claude/rules

  while IFS= read -r -d '' _rule_path; do
    _rule_name="${_rule_path##*/}"
    if [ ! -f ".claude/rules/$_rule_name" ]; then
      cp "$_rule_path" ".claude/rules/$_rule_name"
    else
      echo "  .claude/rules/$_rule_name already exists, skipping."
    fi
  done < <(find "$TPL/claude/rules" -maxdepth 1 -type f -print0 | sort -z)
}

# Copy .github/copilot-instructions.md
install_copilot() {
  mkdir -p .github
  if [ ! -f .github/copilot-instructions.md ]; then
    cp "$TPL/github/copilot-instructions.md" .github/copilot-instructions.md
  else
    echo "  .github/copilot-instructions.md already exists, skipping."
  fi
}

# Create specs/ directory structure
install_specs() {
  echo "📋 Setting up spec-driven workflow..."
  mkdir -p specs/completed
  if [ ! -f specs/TEMPLATE.md ]; then
    cp "$TPL/specs/TEMPLATE.md" specs/TEMPLATE.md
  else
    echo "  specs/TEMPLATE.md already exists, skipping."
  fi
  if [ ! -f specs/README.md ]; then
    cp "$TPL/specs/README.md" specs/README.md
  else
    echo "  specs/README.md already exists, skipping."
  fi
  if [ ! -f specs/completed/.gitkeep ]; then
    touch specs/completed/.gitkeep
  fi
}

# Install slash commands
install_commands() {
  echo "⚡ Installing slash commands..."
  mkdir -p .claude/commands
  while IFS= read -r -d '' _cmd_path; do
    _cmd_name="${_cmd_path##*/}"
    if [ ! -f ".claude/commands/$_cmd_name" ]; then
      cp "$_cmd_path" ".claude/commands/$_cmd_name"
    else
      echo "  .claude/commands/$_cmd_name already exists, skipping."
    fi
  done < <(find "$TPL/commands" -maxdepth 1 -type f -print0 | sort -z)
}

# Install Shopify-specific template skills (when system includes shopify)
install_shopify_skills() {
  if [[ "${SYSTEM:-}" == *shopify* ]]; then
    echo "  🛍️  Installing Shopify skills..."
    for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
      local local_tpl="${mapping%%:*}"
      local local_target="${mapping#*:}"
      local skill_dir
      skill_dir="$(dirname "$local_target")"
      mkdir -p "$skill_dir"
      # Backwards-compat: rename legacy prompt.md to SKILL.md if present
      if [ -f "$skill_dir/prompt.md" ] && [ ! -f "$skill_dir/SKILL.md" ]; then
        mv "$skill_dir/prompt.md" "$skill_dir/SKILL.md"
      fi
      if [ ! -f "$local_target" ]; then
        cp "$TPL/${local_tpl#templates/}" "$local_target"
      else
        echo "  $local_target already exists, skipping."
      fi
    done
  fi
}

# Install subagent templates
install_agents() {
  echo "🤖 Installing subagent templates..."
  mkdir -p .claude/agents
  while IFS= read -r -d '' _agent_path; do
    _agent_name="${_agent_path##*/}"
    if [ ! -f ".claude/agents/$_agent_name" ]; then
      cp "$_agent_path" ".claude/agents/$_agent_name"
    else
      echo "  .claude/agents/$_agent_name already exists, skipping."
    fi
  done < <(find "$TPL/agents" -maxdepth 1 -type f -print0 | sort -z)
}

# Update .gitignore with AI setup entries
update_gitignore() {
  echo "🚫 Updating .gitignore..."
  if [ -f .gitignore ]; then
    if ! grep -q "claude/settings.local" .gitignore 2>/dev/null; then
      echo "" >> .gitignore
      echo "# Claude Code / AI Setup" >> .gitignore
      echo ".claude/settings.local.json" >> .gitignore
      echo ".ai-setup.json" >> .gitignore
      echo ".ai-setup-backup/" >> .gitignore
      echo ".agents/context/.state" >> .gitignore
      echo ".agents/repomix-snapshot.md" >> .gitignore
    else
      # Add new entries if missing from existing block
      grep -q "\.ai-setup\.json" .gitignore 2>/dev/null || echo ".ai-setup.json" >> .gitignore
      grep -q "\.ai-setup-backup" .gitignore 2>/dev/null || echo ".ai-setup-backup/" >> .gitignore
      grep -q "\.agents/context/\.state" .gitignore 2>/dev/null || echo ".agents/context/.state" >> .gitignore
      grep -q "repomix-snapshot" .gitignore 2>/dev/null || echo ".agents/repomix-snapshot.md" >> .gitignore
    fi
  else
    echo "# Claude Code / AI Setup" > .gitignore
    echo ".claude/settings.local.json" >> .gitignore
    echo ".ai-setup.json" >> .gitignore
    echo ".ai-setup-backup/" >> .gitignore
    echo ".agents/context/.state" >> .gitignore
    echo ".agents/repomix-snapshot.md" >> .gitignore
  fi
}

# Install repomix.config.json for codebase snapshot configuration
install_repomix_config() {
  if [ ! -f repomix.config.json ]; then
    cp "$TPL/repomix.config.json" repomix.config.json
  else
    echo "  repomix.config.json already exists, skipping."
  fi
}

# Install statusline script to ~/.claude/statusline.sh and configure ~/.claude/settings.json
install_statusline_global() {
  # Idempotency: skip if statusLine is already configured
  if [ -f "$HOME/.claude/settings.json" ] && jq -e '.statusLine' "$HOME/.claude/settings.json" >/dev/null 2>&1; then
    return 0
  fi
  mkdir -p "$HOME/.claude"
  cp "$SCRIPT_DIR/templates/statusline.sh" "$HOME/.claude/statusline.sh"
  chmod +x "$HOME/.claude/statusline.sh"
  # Merge statusLine into ~/.claude/settings.json
  if [ -f "$HOME/.claude/settings.json" ]; then
    local TMP
    TMP=$(mktemp)
    jq --arg cmd "$HOME/.claude/statusline.sh" '.statusLine = {"command": $cmd}' "$HOME/.claude/settings.json" > "$TMP" && mv "$TMP" "$HOME/.claude/settings.json"
  else
    printf '{"statusLine":{"command":"%s"}}\n' "$HOME/.claude/statusline.sh" > "$HOME/.claude/settings.json"
  fi
  echo "  Statusline installed -> ~/.claude/statusline.sh"
}

# Generate repomix codebase snapshot in background (once, if not already present)
generate_repomix_snapshot() {
  if [ -f ".agents/repomix-snapshot.md" ]; then
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
    $_repomix_timeout npx -y repomix --compress --style markdown \
      --ignore "node_modules,dist,.git,.next,.nuxt,coverage,.turbo,*.lock,*.lockb" \
      --output .agents/repomix-snapshot.md >/dev/null 2>&1 &
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

  if [ $REPOMIX_EXIT -eq 0 ] && [ -f ".agents/repomix-snapshot.md" ]; then
    LINES=$(wc -l < .agents/repomix-snapshot.md 2>/dev/null || echo "?")
    printf "\r  ✅ Snapshot written to .agents/repomix-snapshot.md (%s lines)%*s\n" "$LINES" 10 ""
  else
    printf "\r  ⏭️  repomix unavailable, skipping snapshot%*s\n" 20 ""
    rm -f .agents/repomix-snapshot.md
  fi
}
