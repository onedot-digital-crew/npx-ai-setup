#!/bin/bash
# Plugin & extension installation: GSD, Claude-Mem, official plugins, Context7, Playwright
# Requires: $WITH_GSD, $WITH_CLAUDE_MEM, $WITH_PLUGINS, $WITH_CONTEXT7, $WITH_PLAYWRIGHT, $AI_CLI

PENDING_PLUGINS=""

# GSD (Get Shit Done) install
install_gsd() {
  if [ "$WITH_GSD" = "" ]; then
    echo ""
    echo "📦 GSD (Get Shit Done) is a workflow engine for structured AI development."
    echo "   It adds phase planning, codebase mapping, and session management."
    echo "   More info: https://github.com/get-shit-done-cc/get-shit-done-cc"
    echo ""
    read -p "   Install GSD? (y/N) " INSTALL_GSD
    [[ "$INSTALL_GSD" =~ ^[Yy]$ ]] && WITH_GSD="yes" || WITH_GSD="no"
  fi

  if [ "$WITH_GSD" = "yes" ]; then
    GSD_GLOBAL_DIR="${HOME}/.claude/commands/gsd"
    if [ -d "$GSD_GLOBAL_DIR" ] || [ -d ".claude/commands/gsd" ] || [ -d ".claude/get-shit-done" ]; then
      echo "🎯 GSD already installed, skipping."
    else
      echo "🎯 Installing GSD (Get Shit Done) globally..."

      # Run in background with progress spinner
      npx -y get-shit-done-cc@latest --claude --global >/dev/null 2>&1 &
      GSD_PID=$!

      # Simple spinner
      SPIN='-\|/'
      i=0
      while kill -0 $GSD_PID 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r  ${SPIN:$i:1} Installing... (may take 30-60 seconds)"
        sleep 0.2
      done

      GSD_EXIT=0
      wait $GSD_PID 2>/dev/null || GSD_EXIT=$?

      if [ $GSD_EXIT -eq 0 ]; then
        printf "\r  ✅ GSD installed successfully%*s\n" 40 ""
      else
        printf "\r  ⚠️  GSD installation failed. Manual: npx get-shit-done-cc@latest --claude --global\n"
      fi
    fi

    # GSD Companion Skill (global)
    GSD_SKILL_GLOBAL="${HOME}/.claude/skills/gsd"
    if [ -d "$GSD_SKILL_GLOBAL" ] || [ -d ".claude/skills/gsd" ]; then
      echo "  GSD Companion Skill already installed, skipping."
    else
      npx skills add https://github.com/ctsstc/get-shit-done-skills --skill gsd --agent claude-code --agent github-copilot -g -y 2>/dev/null || echo "  Skills CLI not available, skipping."
    fi

    # Append GSD workflow to CLAUDE.md
    if [ -f CLAUDE.md ] && ! grep -q "Workflow (GSD)" CLAUDE.md 2>/dev/null; then
      cat >> CLAUDE.md << 'GSDEOF'

## Workflow (GSD)
1. `/gsd:map-codebase` - Analyze existing code (brownfield)
2. `/gsd:new-project` - Initialize project planning
3. `/gsd:plan-phase N` - Plan next phase
4. `/gsd:execute-phase N` - Execute phase
5. `/gsd:verify-work N` - User acceptance testing
GSDEOF
    fi

    # Append GSD lines to copilot-instructions.md
    if [ -f .github/copilot-instructions.md ] && ! grep -q "planning/PROJECT" .github/copilot-instructions.md 2>/dev/null; then
      echo "- **MUST READ**: \`.planning/PROJECT.md\` for project identity and goals" >> .github/copilot-instructions.md
      echo "- GSD workflow in \`.planning/\` for task management" >> .github/copilot-instructions.md
    fi
  else
    echo "⏭️  GSD skipped."
  fi
}

# Claude-Mem (Marketplace Plugin — persistent memory)
install_claude_mem() {
  CLAUDE_MEM_DIR="${HOME}/.claude/plugins/cache/thedotmack/claude-mem"

  if [ "$WITH_CLAUDE_MEM" = "" ]; then
    echo ""
    echo "🧠 Claude-Mem adds persistent memory across Claude Code sessions."
    echo "   Every decision, bug fix, and architectural choice — remembered automatically."
    echo "   More info: https://claude-mem.ai"
    echo ""
    read -p "   Install Claude-Mem? (y/N) " INSTALL_CMEM
    [[ "$INSTALL_CMEM" =~ ^[Yy]$ ]] && WITH_CLAUDE_MEM="yes" || WITH_CLAUDE_MEM="no"
  fi

  if [ "$WITH_CLAUDE_MEM" = "yes" ]; then
    if [ -d "$CLAUDE_MEM_DIR" ]; then
      echo "  🧠 Claude-Mem already installed, skipping."
    else
      # Merge extraKnownMarketplaces + enabledPlugins into .claude/settings.json
      if command -v jq &>/dev/null && [ -f .claude/settings.json ]; then
        CLAUDE_MEM_MERGE='{
          "extraKnownMarketplaces": {
            "thedotmack": {
              "source": { "source": "github", "repo": "thedotmack/claude-mem" }
            }
          },
          "enabledPlugins": {
            "claude-mem@thedotmack": true
          }
        }'
        TMP_SETTINGS=$(mktemp)
        jq --argjson merge "$CLAUDE_MEM_MERGE" '. * $merge' .claude/settings.json > "$TMP_SETTINGS" && mv "$TMP_SETTINGS" .claude/settings.json
        echo "  🧠 Claude-Mem marketplace registered in .claude/settings.json"
      fi

      # Try CLI install (works if claude is available)
      if command -v claude &>/dev/null; then
        echo "  🧠 Attempting Claude-Mem install via CLI..."
        if claude plugin install claude-mem@thedotmack --scope project 2>/dev/null; then
          echo "  ✅ Claude-Mem installed via CLI"
        else
          PENDING_PLUGINS="${PENDING_PLUGINS}claude-mem "
          echo "  📋 Claude-Mem registered — will be prompted on next Claude Code session"
        fi
      else
        PENDING_PLUGINS="${PENDING_PLUGINS}claude-mem "
        echo "  📋 Claude-Mem registered — teammates will be prompted to install when they trust this project"
      fi
    fi
  else
    echo "⏭️  Claude-Mem skipped."
  fi
}

# Official Claude Code Plugins (code-review, feature-dev, etc.)
install_official_plugins() {
  OFFICIAL_PLUGINS=(
    "code-review:Automated PR review with 4 parallel agents + confidence scoring"
    "feature-dev:7-phase feature workflow (discovery → architecture → review)"
    "frontend-design:Anti-generic design guidance for frontend projects"
  )

  if [ "$WITH_PLUGINS" = "" ]; then
    echo ""
    echo "🔌 Official Claude Code Plugins (from Anthropic):"
    echo ""
    for i in "${!OFFICIAL_PLUGINS[@]}"; do
      IFS=':' read -r pname pdesc <<< "${OFFICIAL_PLUGINS[$i]}"
      printf "   [%d] %-18s %s\n" "$((i+1))" "$pname" "$pdesc"
    done
    echo ""
    echo "   [a] All plugins    [n] None"
    echo ""
    read -p "   Select plugins (comma-separated numbers, a=all, n=none): " PLUGIN_CHOICE
    case "$PLUGIN_CHOICE" in
      [Nn]) WITH_PLUGINS="no" ;;
      [Aa]) WITH_PLUGINS="yes"; SELECTED_PLUGINS="1,2,3,4" ;;
      *)    WITH_PLUGINS="yes"; SELECTED_PLUGINS="$PLUGIN_CHOICE" ;;
    esac
  fi

  if [ "$WITH_PLUGINS" = "yes" ]; then
    # Default to all if flag used without interactive selection
    [ -z "$SELECTED_PLUGINS" ] && SELECTED_PLUGINS="1,2,3,4"

    INSTALLED_PLUGINS=""
    for idx in $(echo "$SELECTED_PLUGINS" | tr ',' ' '); do
      idx=$(echo "$idx" | tr -d ' ')
      [ -z "$idx" ] && continue
      PIDX=$((idx - 1))
      [ $PIDX -lt 0 ] || [ $PIDX -ge ${#OFFICIAL_PLUGINS[@]} ] && continue

      IFS=':' read -r PNAME PDESC <<< "${OFFICIAL_PLUGINS[$PIDX]}"

      # Check if already installed (plugin cache or .claude/settings.json)
      if [ -d "${HOME}/.claude/plugins/cache/anthropics/${PNAME}" ] 2>/dev/null; then
        echo "  🔌 ${PNAME} already installed, skipping."
        continue
      fi

      # Try CLI install
      if command -v claude &>/dev/null; then
        echo "  🔌 Installing ${PNAME}..."
        if claude plugin install "${PNAME}" --scope project 2>/dev/null; then
          INSTALLED_PLUGINS="${INSTALLED_PLUGINS}${PNAME} "
          echo "  ✅ ${PNAME} installed"
        else
          PENDING_PLUGINS="${PENDING_PLUGINS}${PNAME} "
          echo "  📋 ${PNAME} — install manually: /plugin install ${PNAME}"
        fi
      else
        PENDING_PLUGINS="${PENDING_PLUGINS}${PNAME} "
        echo "  📋 ${PNAME} — install manually: /plugin install ${PNAME}"
      fi
    done
  elif [ "$WITH_PLUGINS" = "no" ]; then
    echo "⏭️  Official plugins skipped."
  fi
}

# Context7 MCP Server (up-to-date library docs)
install_context7() {
  if [ "$WITH_CONTEXT7" = "" ]; then
    echo ""
    echo "📚 Context7 fetches up-to-date library docs directly into Claude's context."
    echo "   No more hallucinated APIs or outdated code examples. 45k+ ⭐ on GitHub."
    echo "   Works via MCP Server — add \"use context7\" to any prompt."
    echo ""
    read -p "   Install Context7? (y/N) " INSTALL_CTX7
    [[ "$INSTALL_CTX7" =~ ^[Yy]$ ]] && WITH_CONTEXT7="yes" || WITH_CONTEXT7="no"
  fi

  if [ "$WITH_CONTEXT7" = "yes" ]; then
    # Create or merge .mcp.json
    CTX7_CONFIG='{"mcpServers":{"context7":{"command":"npx","args":["-y","@upstash/context7-mcp"]}}}'

    if [ -f .mcp.json ]; then
      if grep -q '"context7"' .mcp.json 2>/dev/null; then
        echo "  📚 Context7 already configured in .mcp.json, skipping."
      elif command -v jq &>/dev/null; then
        TMP_MCP=$(mktemp)
        jq --argjson ctx "$CTX7_CONFIG" '.mcpServers += $ctx.mcpServers' .mcp.json > "$TMP_MCP" && mv "$TMP_MCP" .mcp.json
        echo "  📚 Context7 MCP server added to .mcp.json"
      else
        echo "  ⚠️  .mcp.json exists but jq not available to merge. Add manually."
      fi
    else
      echo "$CTX7_CONFIG" | jq '.' > .mcp.json 2>/dev/null || echo "$CTX7_CONFIG" > .mcp.json
      echo "  📚 Context7 MCP server configured in .mcp.json"
    fi

    # Add Context7 rule to CLAUDE.md
    if [ -f CLAUDE.md ] && ! grep -q "context7" CLAUDE.md 2>/dev/null; then
      cat >> CLAUDE.md << 'CTX7EOF'

## Documentation Lookup
Always use Context7 MCP when you need library/API documentation, code generation,
setup or configuration steps. Add "use context7" to prompts or it will be auto-invoked.
CTX7EOF
      echo "  📚 Context7 rule added to CLAUDE.md"
    fi
  else
    echo "⏭️  Context7 skipped."
  fi
}

# Playwright MCP Server (UI verification via browser automation)
install_playwright() {
  if [ "$WITH_PLAYWRIGHT" = "" ]; then
    echo ""
    echo "🎭 Playwright MCP enables Claude to interact with web browsers for UI verification."
    echo "   Useful for testing UI changes, taking screenshots, and validating frontend behavior."
    echo ""
    read -p "   Install Playwright MCP? (y/N) " INSTALL_PW
    [[ "$INSTALL_PW" =~ ^[Yy]$ ]] && WITH_PLAYWRIGHT="yes" || WITH_PLAYWRIGHT="no"
  fi

  if [ "$WITH_PLAYWRIGHT" = "yes" ]; then
    PW_CONFIG='{"mcpServers":{"playwright":{"command":"npx","args":["-y","@anthropic-ai/mcp-playwright"]}}}'

    if [ -f .mcp.json ]; then
      if grep -q '"playwright"' .mcp.json 2>/dev/null; then
        echo "  🎭 Playwright already configured in .mcp.json, skipping."
      elif command -v jq &>/dev/null; then
        TMP_MCP=$(mktemp)
        jq --argjson pw "$PW_CONFIG" '.mcpServers += $pw.mcpServers' .mcp.json > "$TMP_MCP" && mv "$TMP_MCP" .mcp.json
        echo "  🎭 Playwright MCP server added to .mcp.json"
      else
        echo "  ⚠️  .mcp.json exists but jq not available to merge. Add manually."
      fi
    else
      echo "$PW_CONFIG" | jq '.' > .mcp.json 2>/dev/null || echo "$PW_CONFIG" > .mcp.json
      echo "  🎭 Playwright MCP server configured in .mcp.json"
    fi
  else
    echo "⏭️  Playwright MCP skipped."
  fi
}

# Show pending plugin install instructions
show_plugin_summary() {
  if [ -n "$PENDING_PLUGINS" ]; then
    echo ""
    echo "  ⚡ Pending plugin installations (run in a Claude Code session):"
    for PP in $PENDING_PLUGINS; do
      case "$PP" in
        claude-mem)
          echo "     /plugin marketplace add thedotmack/claude-mem"
          echo "     /plugin install claude-mem"
          ;;
        *)
          echo "     /plugin install ${PP}"
          ;;
      esac
    done
    echo ""
    echo "  Then restart Claude Code."
  fi
}

# Show installation summary
show_installation_summary() {
  echo ""
  echo "🎉 AI Setup complete! Your project is ready for AI-assisted development."
  echo ""
  echo "================================================================"
  echo "INSTALLATION SUMMARY"
  echo "================================================================"
  echo ""
  echo "✅ Files created:"
  [ -f CLAUDE.md ] && echo "   - CLAUDE.md (project rules)"
  [ -f .claude/settings.json ] && echo "   - .claude/settings.json (permissions)"
  [ -f .github/copilot-instructions.md ] && echo "   - .github/copilot-instructions.md"
  echo "   - .claude/hooks/ (protect-files, post-edit-lint, circuit-breaker, context-freshness, update-check)"
  [ -f .mcp.json ] && echo "   - .mcp.json (MCP server config)"
  [ -d specs ] && echo "   - specs/ (spec-driven workflow)"
  [ -d .claude/commands ] && echo "   - .claude/commands/ (spec, spec-work, commit, pr, review, test, techdebt, bug, grill)"
  [ -d .claude/agents ] && echo "   - .claude/agents/ (verify-app, build-validator, staff-reviewer, context-refresher)"

  if [ "$WITH_GSD" = "yes" ] || [ "$WITH_CLAUDE_MEM" = "yes" ] || [ "$WITH_PLUGINS" = "yes" ] || [ "$WITH_CONTEXT7" = "yes" ] || [ "$WITH_PLAYWRIGHT" = "yes" ]; then
    echo ""
    echo "✅ Tools & Plugins:"
    [ "$WITH_GSD" = "yes" ] && [ -d "${HOME}/.claude/commands/gsd" ] && echo "   - GSD (Get Shit Done) - globally in ~/.claude/"
    [ "$WITH_GSD" = "yes" ] && [ -d "${HOME}/.claude/skills/gsd" ] && echo "   - GSD Companion Skill"
    if [ "$WITH_CLAUDE_MEM" = "yes" ]; then
      CLAUDE_MEM_DIR="${HOME}/.claude/plugins/cache/thedotmack/claude-mem"
      if [ -d "$CLAUDE_MEM_DIR" ]; then
        echo "   - Claude-Mem (persistent memory) ✅"
      else
        echo "   - Claude-Mem (pending — run install commands in Claude Code)"
      fi
    fi
    [ -n "${INSTALLED_PLUGINS:-}" ] && echo "   - Plugins: ${INSTALLED_PLUGINS}"
    [ "$WITH_CONTEXT7" = "yes" ] && [ -f .mcp.json ] && echo "   - Context7 MCP server (.mcp.json)"
    [ "$WITH_PLAYWRIGHT" = "yes" ] && [ -f .mcp.json ] && echo "   - Playwright MCP server (.mcp.json)"
    if [ -n "$PENDING_PLUGINS" ]; then
      echo "   - ⚠️  Pending plugins: ${PENDING_PLUGINS}(see install commands above)"
    fi
  fi

  if [ "$AI_CLI" = "claude" ] && [[ ! "${RUN_INIT:-N}" =~ ^[Nn]$ ]]; then
    echo ""
    echo "✅ Auto-Init completed (System: ${SYSTEM:-not set}):"
    echo "   - CLAUDE.md extended with Commands & Critical Rules"
    [ -d .agents/context ] && echo "   - .agents/context/ (STACK.md, ARCHITECTURE.md, CONVENTIONS.md)"
    if [ ${INSTALLED:-0} -gt 0 ]; then
      echo "   - ${INSTALLED} skills installed"
    fi
  fi

  echo ""
  echo "📂 Project structure ready for AI development"
}

# Show next steps and cheat sheet
show_next_steps() {
  echo ""
  echo "================================================================"
  echo "NEXT STEPS"
  echo "================================================================"
  echo ""
  if [ "$WITH_GSD" = "yes" ]; then
    if [ "$AI_CLI" = "claude" ]; then
      echo "Run this in a Claude Code session to complete the setup:"
      echo ""
      echo "  /gsd:map-codebase        Deep codebase analysis (enhances .agents/context/)"
      echo ""
      echo "When you're ready to start building:"
      echo ""
      echo "  /gsd:new-project         Define project, requirements & roadmap"
    else
      echo "  1. /gsd:map-codebase     Deep codebase analysis"
      echo ""
      echo "  When ready to start building:"
      echo "  2. /gsd:new-project      Define project, requirements & roadmap"
    fi
  else
    echo "Start a Claude Code session and begin working."
    echo "Your project context and CLAUDE.md are ready."
    echo ""
    echo "Spec-driven workflow:"
    echo "  /spec \"task description\"    Create a structured spec before coding"
    echo "  /spec-work 001              Execute a spec step by step"
    echo ""
    echo "To regenerate context files later:"
    echo "  npx @onedot/ai-setup --regenerate"
    echo ""
    echo "Optional: Install GSD later for structured workflow management:"
    echo "  npx get-shit-done-cc@latest --claude --global"
  fi

  if [ "$WITH_GSD" = "yes" ]; then
    echo ""
    echo "================================================================"
    echo "GSD WORKFLOW CHEAT SHEET"
    echo "================================================================"
    echo ""
    echo "  Core Loop:"
    echo "  /gsd:discuss-phase N      Clarify requirements before planning"
    echo "  /gsd:plan-phase N         Create step-by-step plan"
    echo "  /gsd:execute-phase N      Write code & commit atomically"
    echo "  /gsd:verify-work N        User acceptance testing"
    echo ""
    echo "  Quick Tasks:"
    echo "  /gsd:quick \"task\"          Fast fix (typos, CSS, config)"
    echo "  /gsd:debug                Systematic debugging"
    echo ""
    echo "  Session Management:"
    echo "  /gsd:pause-work           Save context for later"
    echo "  /gsd:resume-work          Restore previous session"
    echo "  /gsd:progress             Status & next action"
    echo ""
    echo "  Roadmap:"
    echo "  /gsd:add-phase            Add phase to roadmap"
    echo "  /gsd:insert-phase         Insert urgent work (e.g. 3.1)"
    echo "  /gsd:add-todo             Capture idea as todo"
    echo "  /gsd:check-todos          Show open todos"
  fi

  echo ""
  echo "================================================================"
  echo "LINKS"
  echo "================================================================"
  echo ""
  echo "  Skills:   https://skills.sh/"
  [ "$WITH_GSD" = "yes" ] && echo "  GSD:      https://github.com/get-shit-done-cc/get-shit-done-cc"
  [ "$WITH_CLAUDE_MEM" = "yes" ] && echo "  Memory:   https://claude-mem.ai"
  echo "  Claude:   https://docs.anthropic.com/en/docs/claude-code"
  echo "  Hooks:    https://docs.anthropic.com/en/docs/claude-code/hooks"
  echo ""
  echo "================================================================"
}
